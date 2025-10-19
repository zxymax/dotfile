-- 辅助函数模块
-- 提供统一的错误处理、延迟加载和其他工具函数
-- 用于减少代码重复并提高配置的可维护性

local M = {}

--- 安全地加载模块并处理错误
---@param module_name string 模块名称
---@param module_desc string 模块描述（用于错误提示）
---@param silent boolean 是否静默失败（不显示错误消息）
---@return boolean, any 加载成功状态和模块对象
function M.safe_require(module_name, module_desc, silent)
  silent = silent or false
  local ok, module = pcall(require, module_name)
  if not ok then
    if not silent then
      vim.schedule(function()
        local level = vim.log.levels.DEBUG -- 使用DEBUG级别避免干扰用户
        vim.notify(string.format("无法加载%s: %s", module_desc or module_name, tostring(module)), level)
      end)
    end
    return false, nil
  end
  return true, module
end

--- 创建安全的插件配置函数，自动处理错误
---@param module_name string 模块名称
---@param setup_fn function 配置函数
---@param module_desc string 模块描述
---@return function 包装后的配置函数
function M.create_safe_setup(module_name, setup_fn, module_desc)
  return function(opts)
    local ok, module = M.safe_require(module_name, module_desc, true)
    if ok and type(setup_fn) == "function" then
      local setup_ok, setup_err = pcall(setup_fn, module, opts)
      if not setup_ok then
        vim.schedule(function()
          vim.notify(string.format("%s配置失败: %s", module_desc or module_name, setup_err), vim.log.levels.DEBUG)
        end)
      end
    end
  end
end

--- 创建通用的安全配置函数（不需要特定模块）
---@param setup_fn function 配置函数
---@return function 安全的配置函数
function M.create_generic_safe_setup(setup_fn)
  return function(opts)
    local ok, err = pcall(setup_fn, opts)
    if not ok then
      vim.schedule(function()
        local plugin_name = debug.getinfo(setup_fn, 'S').source or '未知插件'
        plugin_name = plugin_name:match('([^/\\]+)%.lua$') or plugin_name
        vim.notify(string.format("插件 '%s' 配置失败: %s", plugin_name, err), vim.log.levels.DEBUG)
      end)
    end
  end
end

--- 检查当前平台
---@return table 平台信息表
function M.get_platform_info()
  local os = vim.loop.os_uname().sysname
  return {
    is_windows = os:find("Windows") or os:find("Win32") or os:find("Win64"),
    is_mac = os:find("Darwin"),
    is_linux = os:find("Linux"),
    os = os
  }
end

--- 根据平台条件执行
---@param windows_value any Windows平台的值
---@param other_value any 其他平台的值
---@return any 根据当前平台返回对应值
function M.platform_specific(windows_value, other_value)
  local platform = M.get_platform_info()
  return platform.is_windows and windows_value or other_value
end

--- 获取平台相关的构建命令
---@param plugin_name string 插件名称
---@return string 构建命令字符串
function M.get_platform_specific_build(plugin_name)
  local build_commands = {
    -- Windows平台特定的构建命令
    telescope_fzf_native = {
      windows = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      default = 'make'
    },
  }
  
  local plugin_info = build_commands[plugin_name]
  if not plugin_info then
    return nil
  end
  
  local platform = M.get_platform_info()
  return platform.is_windows and plugin_info.windows or plugin_info.default
end

--- 大文件检测函数
---@param buf number 缓冲区ID
---@param max_size_kb number 最大文件大小（KB）
---@return boolean 是否为大文件
function M.is_large_file(buf, max_size_kb)
  max_size_kb = max_size_kb or 100 -- 默认100KB
  local max_filesize = max_size_kb * 1024
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
  return false
end

--- 安全地添加按键映射
---@param mode string|table 模式
---@param lhs string 左侧按键
---@param rhs string|function 右侧命令或函数
---@param opts table 选项
function M.safe_keymap_set(mode, lhs, rhs, opts)
  opts = opts or {}
  -- 如果没有设置，默认添加描述
  if not opts.desc and type(rhs) == 'string' then
    opts.desc = rhs
  end
  
  local ok, err = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not ok then
    vim.schedule(function()
      vim.notify(string.format("按键映射失败 '%s': %s", lhs, err), vim.log.levels.DEBUG)
    end)
  end
end

--- 条件加载配置
---@param condition function 条件函数
---@param config_fn function 配置函数
function M.conditionally_configure(condition, config_fn)
  local ok, result = pcall(condition)
  if ok and result then
    pcall(config_fn)
  end
end

--- 大文本管理
M.texts = {
  header = {
    "",
    "  zzzzz    xxxxxx    yyyyy    mmmmmm    aaaaaa  ",
    "zzz  zzz  xxx  xxx  yyy  yyy  mm  mm    aa  aa  ",
    "zzz      xxx    xxx yyy      mm    mm  aa  aa  ",
    "zzz      xxx    xxx yyy      mm    mm  aaaaaa  ",
    "zzz  zzz  xxx  xxx  yyy  yyy  mm  mm    aa  aa  ",
    "  zzzzz    xxxxxx    yyyyy    mmmmmm    aa  aa  ",
    "",
  }
}

return M
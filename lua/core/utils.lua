-- 核心工具函数模块
-- 提供统一的错误处理、安全加载和日志记录功能

local M = {}

-- 已通知的错误缓存，避免重复弹窗
local notified_errors = {}

-- 安全加载模块的统一函数
-- @param module_name 要加载的模块名
-- @param friendly_name 用户友好的模块名称（用于错误消息）
-- @param silent 是否静默失败（不显示错误消息）
-- @param once 是否只通知一次
-- @return ok, module 返回加载状态和模块
M.safe_require = function(module_name, friendly_name, silent, once)
  local ok, module = pcall(require, module_name)
  
  if not ok then
    local error_msg = string.format("无法加载 %s (%s): %s", 
      friendly_name or module_name, 
      module_name, 
      module) -- module包含错误信息
    
    -- 检查是否需要通知用户
    if not silent then
      local key = module_name
      
      -- 如果设置了once且已经通知过，则跳过
      if not once or not notified_errors[key] then
        -- 使用vim.schedule确保在正确的上下文中执行
        vim.schedule(function()
          vim.notify(error_msg, vim.log.levels.ERROR)
          
          -- 记录到日志文件
          M.log_error(error_msg)
          
          -- 标记为已通知
          if once then
            notified_errors[key] = true
          end
        end)
      end
    end
    
    return false, nil
  end
  
  return true, module
end

-- 创建安全的配置设置函数
-- @param module_name 模块名称
-- @param setup_fn 设置函数
-- @param friendly_name 用户友好的名称
M.create_safe_setup = function(module_name, setup_fn, friendly_name)
  return function()
    local ok, module = M.safe_require(module_name, friendly_name, true)
    if ok then
      setup_fn(module)
    end
  end
end

-- 条件配置函数
-- @param condition 条件
-- @param if_true 条件为真时执行的函数
-- @param if_false 条件为假时执行的函数（可选）
M.conditionally_configure = function(condition, if_true, if_false)
  if condition then
    if if_true and type(if_true) == "function" then
      return if_true()
    end
    return condition
  else
    if if_false and type(if_false) == "function" then
      return if_false()
    end
    return nil
  end
end

-- 日志错误到文件
-- @param message 错误消息
M.log_error = function(message)
  local log_file = vim.fn.stdpath("data") .. "/nvim_error.log"
  local timestamp = os.date("[%Y-%m-%d %H:%M:%S]")
  local log_entry = string.format("%s %s\n", timestamp, message)
  
  -- 使用pcall安全写入日志
  pcall(function()
    local file = io.open(log_file, "a")
    if file then
      file:write(log_entry)
      file:close()
    end
  end)
end

-- 检测系统功能的工具函数
-- 检测是否有cmake
M.has_cmake = function()
  return vim.fn.executable("cmake") == 1
end

-- 检测是否有make
M.has_make = function()
  return vim.fn.executable("make") == 1
end

-- 检测是否有g++
M.has_gpp = function()
  return vim.fn.executable("g++") == 1
end

-- 检测是否有clang
M.has_clang = function()
  return vim.fn.executable("clang") == 1
end

-- 获取平台特定的适配器路径
-- @param adapter_name 适配器名称
M.get_platform_adapter_path = function(adapter_name)
  local paths = {}
  
  if adapter_name == "codelldb" then
    if vim.fn.has("win32") == 1 then
      -- Windows路径示例
      return vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe"
    elseif vim.fn.has("wsl") == 1 or vim.fn.has("unix") == 1 then
      -- WSL/Linux路径示例
      return "/usr/bin/lldb"
    end
  end
  
  return nil
end

return M
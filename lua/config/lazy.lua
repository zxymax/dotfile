-- 确保lazy.nvim正确安装
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 增强的lazy.nvim引导检查函数
local function ensure_lazy_nvim()
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print("🔄 正在安装lazy.nvim插件管理器...")
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    
    -- 尝试执行git clone命令
    local out = vim.fn.system({ 
      "git", 
      "clone", 
      "--filter=blob:none", 
      "--branch=stable", 
      lazyrepo, 
      lazypath 
    })
    
    if vim.v.shell_error ~= 0 then
      -- 安装失败，提供详细的错误信息和备选方案
      print("❌ 安装lazy.nvim失败!")
      print("错误详情:")
      print(out)
      print("")
      print("📋 请尝试以下手动安装步骤:")
      print("1. 打开终端")
      print("2. 执行命令: git clone --filter=blob:none --branch=stable " .. lazyrepo .. " " .. lazypath)
      print("3. 检查网络连接和GitHub访问权限")
      print("4. 确保git已正确安装")
      print("")
      print("🔄 备选方案: 如果你在受限环境中，可以:")
      print("- 从其他设备复制lazy.nvim文件夹到 " .. lazypath)
      print("- 检查防火墙或代理设置")
      return false
    else
      print("✅ lazy.nvim安装成功!")
      print("🔍 正在准备插件加载...")
      return true
    end
  end
  return true
end

-- 执行lazy.nvim安装检查
local lazy_installed = ensure_lazy_nvim()
if lazy_installed then
  vim.opt.rtp:prepend(lazypath)
else
  print("⚠️  无法加载插件，将使用基本配置启动")
  -- 设置基本的编辑器选项，确保即使在没有插件的情况下也能使用
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
end

-- 简化的插件配置
require("lazy").setup({
  spec = {
    -- 配置LazyVim
    { "LazyVim/LazyVim", 
      import = "lazyvim.plugins",
    },
      -- 使用新的mason包名，并彻底替换原始插件
    { 
      "mason-org/mason.nvim", 
      branch = "main",
      lazy = false,
      -- 替代原始的mason.nvim
      name = "mason.nvim",
      config = function()
        -- 使用pcall确保安全加载
        local ok, mason = pcall(require, "mason")
        if ok then
          mason.setup({
            ui = {
              check_outdated_packages_on_open = false, -- 关闭自动检查更新
            },
            -- 禁用自动安装以避免冲突
            ensure_installed = {},
          })
        end
      end,
      -- 优先级设置为最高，确保先于其他依赖它的插件加载
      priority = 1000,
    },
    -- 首先添加nvim-treesitter作为独立插件
    {
      "nvim-treesitter/nvim-treesitter",
      priority = 1000, -- 确保优先加载
      build = ":TSUpdate",
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = function()
        -- 添加更强健的错误处理
        local ok, treesitter = pcall(require, "nvim-treesitter")
        if not ok then
          -- 静默失败，不显示错误消息
          return
        end
        
        local ok_configs, treesitter_configs = pcall(require, "nvim-treesitter.configs")
        if ok_configs then
          treesitter_configs.setup({
            ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query"},
            highlight = { 
              enable = true,
              -- 禁用大型文件的语法高亮以提高性能
              disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                  return true
                end
              end,
            },
            indent = { enable = true },
            incremental_selection = { enable = true },
            textobjects = { enable = true },
          })
          vim.notify("✅ nvim-treesitter配置成功!", vim.log.levels.INFO)
        else
          print("❌ 无法加载nvim-treesitter配置")
        end
      end,
    },
    -- 已在上方配置
    -- 自定义插件
    { import = "plugins" },
  },
  defaults = {
    -- 设置默认懒加载，提高启动速度
    lazy = true,
    -- 不自动加载插件，除非明确指定
    auto = false,
    -- 使用最新版本，避免过时版本导致的问题
    version = false,
  },
  -- 安装和检查器设置
  install = { 
    colorscheme = { "gruvbox", "tokyonight", "habamax" },
    -- 自动处理插件重命名
    rename = { enabled = true },
  },
  checker = {
    enabled = true, -- 定期检查插件更新
    notify = false, -- 关闭更新通知
    frequency = 3600 * 24, -- 每24小时检查一次更新
  },
  -- 禁用luarocks支持以避免hererocks相关错误
  rocks = {
    enabled = false,
    hererocks = false,
  },
  performance = {
    rtp = {
      -- 禁用更多不需要的rtp插件以提高性能
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        -- "netrwPlugin", -- 保留netrw以避免与其他文件浏览器冲突
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "spellfile_plugin",
        "rplugin",
        "man",
        "shada_plugin",
        "health",
      },
    },
    -- 启用自动加载优化
    cache = {
      enabled = true,
    },
    -- 启用自动清理
    reset_packpath = true,
    -- 减少不必要的事件处理
    event = {
      -- 禁用一些不常用的事件
      "BufNewFile",
    },
    -- 限制lazy.nvim自身的日志级别
    log_level = vim.log.levels.ERROR,
  },
})

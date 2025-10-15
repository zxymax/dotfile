-- 确保lazy.nvim正确安装
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  print("正在安装lazy.nvim插件管理器...")
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    print("安装lazy.nvim失败:")
    print(out)
    print("请手动克隆仓库: git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git " .. lazypath)
  else
    print("✅ lazy.nvim安装成功!")
  end
end
vim.opt.rtp:prepend(lazypath)

-- 简化的插件配置
require("lazy").setup({
  spec = {
    -- 首先添加nvim-treesitter作为独立插件
    {
      "nvim-treesitter/nvim-treesitter",
      priority = 1000, -- 确保优先加载
      build = ":TSUpdate",
      config = function()
        local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
        if ok then
          treesitter_configs.setup({
            ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query"},
            highlight = { enable = true },
            indent = { enable = true },
          })
          print("✅ nvim-treesitter配置成功!")
        else
          print("❌ 无法加载nvim-treesitter配置")
        end
      end,
    },
    -- LazyVim核心插件
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 自定义插件
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- 定期检查插件更新
    notify = true, -- 通知更新
  },
  performance = {
    rtp = {
      -- 禁用一些不需要的rtp插件以提高性能
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin", -- 保留netrw以避免与其他文件浏览器冲突
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

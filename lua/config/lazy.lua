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

-- 强制安装nvim-treesitter
local function ensure_treesitter_installed()
  -- 检查nvim-treesitter是否已配置
  local treesitter_installed = pcall(require, "nvim-treesitter.configs")
  if not treesitter_installed then
    print("⚠️ nvim-treesitter未安装，正在尝试修复...")
    -- 手动添加nvim-treesitter配置
    return {
      spec = {
        -- 首先添加nvim-treesitter作为独立插件
        {
          "nvim-treesitter/nvim-treesitter",
          priority = 1000, -- 确保优先加载
          build = ":TSUpdate",
          config = function()
            require("nvim-treesitter.configs").setup({
              ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "rust", "typescript", "javascript", "tsx", "jsx", "html", "css", "json", "jsonc"},
              highlight = { enable = true },
              indent = { enable = true },
            })
            print("✅ nvim-treesitter配置成功!")
          end,
        },
        -- 然后添加其他所有插件
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { import = "plugins.lang" },
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
      enabled = true, -- check for plugin updates periodically
      notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }
  else
    -- 如果treesitter已安装，使用原始配置
    return {
      spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { import = "plugins.lang" },
        { import = "plugins" },
      },
      defaults = {
        lazy = false,
        version = false,
      },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = {
        enabled = true,
        notify = false,
      },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            -- "matchit",
            -- "matchparen",
            -- "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    }
  end
end

-- 调用函数并设置插件
require("lazy").setup(ensure_treesitter_installed())

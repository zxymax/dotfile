-- 主题相关配置模块
-- 包含所有与界面主题、颜色方案相关的设置

local helpers = require("helpers")

return {
  -- Gruvbox 主题配置 - 必须在启动时加载
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- 主题必须立即加载
    priority = 1000,
    config = function()
      local ok, gruvbox = pcall(require, "gruvbox")
      if ok then
        gruvbox.setup({
          terminal_colors = true,
          undercurl = true,
          underline = true,
          bold = true,
          italic = {
            strings = true,
            comments = true,
            operators = false,
            folds = true,
          },
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true,
          contrast = "hard",
          palette_overrides = {},
          overrides = {
            -- 自定义覆盖项
            Comment = { italic = true },
            -- 确保诊断消息在暗色背景下可读性良好
            DiagnosticError = { fg = "#fb4934" },
            DiagnosticWarn = { fg = "#fabd2f" },
            DiagnosticInfo = { fg = "#83a598" },
            DiagnosticHint = { fg = "#8ec07c" },
            -- 调整 LSP 相关高亮
            LspReferenceText = { bg = "#3c3836" },
            LspReferenceRead = { bg = "#3c3836" },
            LspReferenceWrite = { bg = "#3c3836" },
          },
          dim_inactive = false,
          transparent_mode = false,
        })
        
        -- 设置默认颜色方案
        vim.cmd.colorscheme("gruvbox")
      end
    end
  },
  
  -- 图标支持
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      local ok, web_devicons = pcall(require, "nvim-web-devicons")
      if ok then
        web_devicons.setup({
          color_icons = true,
          default = true,
        })
      end
    end
  },
}
-- 通知和命令行体验增强配置模块

local helpers = require("helpers")

return {
  -- 增强的通知和命令行体验
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      -- 使用helpers.safe_require安全加载模块
      local ok_noice = helpers.safe_require("noice", "增强通知")
      local ok_notify = helpers.safe_require("notify", "通知插件")
      
      if ok_noice then
        require("noice").setup({
          cmdline = {
            enabled = true,
            view = "cmdline_popup",
            opts = {},
            icons = {
              ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
              [":"] = { icon = " ", hl_group = "DiagnosticInfo" },
            },
          },
          popupmenu = {
            enabled = true,
            backend = "nui",
          },
          messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = "virtualtext",
          },
          notify = {
            enabled = true,
            view = "notify",
          },
          lsp = {
            progress = {
              enabled = true,
              format = "lsp_progress",
              format_done = "lsp_progress_done",
              throttle = 1000 / 30,
              view = "mini",
            },
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
          },
        })
      end
      
      if ok_notify then
        -- 配置通知插件
        require("notify").setup({
          stages = "fade_in_slide_out",
          timeout = 3000,
          max_width = 80,
          background_colour = "#000000",
        })
        
        -- 设置为默认通知器
        vim.notify = require("notify")
      end
    end,
  },
}
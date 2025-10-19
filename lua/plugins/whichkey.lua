-- Which Key 按键提示配置模块

local helpers = require("helpers")

return {
  -- 主要的Which-key配置
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = helpers.create_safe_setup("which-key", function(which_key)
      which_key.setup({})
    end, "按键提示"),
    opts = {
      spec = {
        {
          "<leader>g",
          name = "+git",
          {
            "c",
            name = "+conflict",
            o = { "<cmd>GitConflictChooseOurs<cr>", "选择我们的更改" },
            t = { "<cmd>GitConflictChooseTheirs<cr>", "选择他们的更改" },
            b = { "<cmd>GitConflictChooseBoth<cr>", "保留双方更改" },
            ["0"] = { "<cmd>GitConflictChooseNone<cr>", "不保留任何更改" },
            ["N"] = { "<cmd>GitConflictNextConflict<cr>", "下一个冲突" },
            ["P"] = { "<cmd>GitConflictPrevConflict<cr>", "上一个冲突" },
            c = { "<cmd>GitConflictListQf<cr>", "列出所有冲突" },
          }
        },
        {
          "<leader>h",
          name = "+hunk",
          s = { "<cmd>Gitsigns stage_hunk<cr>", "暂存当前块" },
          r = { "<cmd>Gitsigns reset_hunk<cr>", "重置当前块" },
          S = { "<cmd>Gitsigns stage_buffer<cr>", "暂存当前缓冲区" },
          u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "撤销暂存当前块" },
          R = { "<cmd>Gitsigns reset_buffer<cr>", "重置当前缓冲区" },
          p = { "<cmd>Gitsigns preview_hunk<cr>", "预览当前块" },
          b = { "<cmd>Gitsigns blame_line{full=true}<cr>", "显示行的完整注释" },
          d = { "<cmd>Gitsigns diffthis<cr>", "显示差异" },
          D = { "<cmd>Gitsigns diffthis('~')<cr>", "显示与上一次提交的差异" },
        },
        {
          "<leader>t",
          name = "+toggle",
          b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "切换行注释显示" },
          d = { "<cmd>Gitsigns toggle_deleted<cr>", "切换删除行显示" },
        },
      },
    },
  },
}
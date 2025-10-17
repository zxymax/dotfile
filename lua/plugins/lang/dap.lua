-- 调试器支持配置
return {
  -- 调试器核心
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- 安装调试器 - 使用可选依赖，避免重命名问题并增强错误处理
      {
        "mason-org/mason.nvim",
        optional = true,
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            -- 尝试安装调试器，但即使失败也不会阻止配置加载
            pcall(function()
              vim.list_extend(opts.ensure_installed, {
                "codelldb", -- 用于C/C++/Rust
                "js-debug-adapter", -- 用于JavaScript
                "debugpy", -- 用于Python
              })
            end)
          end
        end,
      },
    },
    keys = {
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "切换断点" },
      { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "条件断点" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "继续执行" },
      { "<leader>ds", "<cmd>lua require('dap').step_over()<cr>", desc = "单步跳过" },
      { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "单步进入" },
      { "<leader>do", "<cmd>lua require('dap').step_out()<cr>", desc = "单步退出" },
      { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "打开REPL" },
      { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "运行上次配置" },
      { "<leader>dq", "<cmd>lua require('dap').terminate()<cr>", desc = "终止调试" },
      { "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>", desc = "断开连接" },
      { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "悬停变量" },
      { "<leader>dp", "<cmd>lua require('dap.ui.widgets').preview()<cr>", desc = "预览变量" },
    },
    config = function()
      -- 自定义DAP UI，使用基本ASCII符号以确保兼容性
      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
    end,
  },

  -- 调试UI增强
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "切换调试UI" },
      { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "评估表达式" },
    },
    opts = {
      icons = {
        expanded = "▾",
        collapsed = "▸",
        current_frame = "▸",
      },
      mappings = {
        -- 为每个窗口定义键映射
        edit = "e",
        expand = { "o", "<2-LeftMouse>" },
        open = "O",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        { -- 左侧面板
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        { -- 底部面板
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = {
        indent = 1,
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      
      -- 自动打开/关闭DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- 调试器虚拟文本
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      display_callback = function(variable, _buf, _stackframe, _node) return variable.name .. " = " .. variable.value end,
      virt_text_pos = 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    },
  },

  -- 增强调试体验：通过主配置中的which-key.nvim统一管理快捷键
}
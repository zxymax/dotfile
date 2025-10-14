-- C++ 开发配置
return {
  -- 语法高亮和智能解析
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "cpp", "c", "objc", "objcpp", "cuda", "cmake" })
      end
    end,
  },

  -- clangd 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--enable-config",
          },
          init_options = {
            clangdFileStatus = true,
          },
        },
      },
    },
  },

  -- 增强clangd功能
  {
    "p00f/clangd_extensions.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { "c", "cpp", "objc", "objcpp", "cuda" },
    config = function()
      require("clangd_extensions").setup({
        server = {
          on_attach = function(_, bufnr)
            -- 快捷键设置
            vim.keymap.set("n", "<leader>ch", require("clangd_extensions").hover_actions.hover_actions, { buffer = bufnr, desc = "代码操作" })
            vim.keymap.set("n", "<leader>cm", require("clangd_extensions").memory_usage.toggle, { buffer = bufnr, desc = "内存使用" })
            vim.keymap.set("n", "<leader>cs", require("clangd_extensions").signature_help.signature_help, { buffer = bufnr, desc = "签名帮助" })
          end,
        },
        extensions = {
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          ast = {
            role_icons = {
              type = "",
              declaration = "",
              expression = "",
              specifier = "",
              statement = "",
              ["template argument"] = "",
            },
            kind_icons = {
              Compound = "",
              Recovery = "",
              TranslationUnit = "",
              PackExpansion = "",
              TemplateTypeParm = "",
              TemplateTemplateParm = "",
              TemplateParamObject = "",
            },
            highlights = {
              detail = "Comment",
            },
          },
        },
      })
    end,
  },

  -- DAP 调试支持
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode", -- 确保这个命令在你的PATH中
        name = "lldb",
      }
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- 调试快捷键
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "开始/继续调试" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "单步跳过" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "单步进入" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "单步退出" })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "切换断点" })
    end,
  },

  -- DAP 可视化界面
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { 
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
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
}
-- Rust 开发配置
return {
  -- 语法高亮和智能解析
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust" })
      end
    end,
  },

  -- rust-analyzer 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            rust = {
              analyzer = {
                cargo = {
                  buildScripts = { enable = true },
                },
                procMacro = { enable = true },
                diagnostics = {
                  enable = true,
                  experimental = { enable = true },
                },
              },
            },
          },
        },
      },
    },
  },

  -- 增强rust-analyzer功能
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    ft = "rust",
    config = function()
      local rust_tools = require("rust-tools")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      rust_tools.setup({
        server = {
          capabilities = capabilities,
          on_attach = function(_, bufnr)
            -- 快捷键设置
            vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions, { buffer = bufnr, desc = "代码操作" })
            vim.keymap.set("n", "<leader>ce", rust_tools.expand_macro.expand_macro, { buffer = bufnr, desc = "展开宏" })
            vim.keymap.set("n", "<leader>cr", rust_tools.runnables.runnables, { buffer = bufnr, desc = "运行测试" })
            vim.keymap.set("n", "<leader>cd", rust_tools.debuggables.debuggables, { buffer = bufnr, desc = "调试" })
          end,
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                features = "all",
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
      })
    end,
  },

  -- crates 管理
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      })

      -- 快捷键
      local map = vim.keymap.set
      map("n", "<leader>ct", require("crates").toggle, { desc = "切换crates.nvim" })
      map("n", "<leader>cr", require("crates").reload, { desc = "重载crates.nvim" })
      map("n", "<leader>cv", require("crates").show_versions_popup, { desc = "显示版本" })
      map("n", "<leader>cf", require("crates").show_features_popup, { desc = "显示特性" })
      map("n", "<leader>ci", require("crates").show_install_popup, { desc = "安装版本" })
      map("n", "<leader>cu", require("crates").update_crate, { desc = "更新单个crate" })
      map("n", "<leader>ca", require("crates").update_all_crates, { desc = "更新所有crate" })
    end,
  },
}
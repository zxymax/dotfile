-- Rust 语言支持配置
return {
  -- 语法高亮增强
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust" })
    end,
  },

  -- LSP 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            -- rust-analyzer 配置
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- 增强类型检查
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = { "async-trait", "async-recursion", "unionize" },
              },
            },
          },
        },
      },
    },
  },

  -- 调试支持
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        -- 使用可选依赖，更新为新的包名
        "mason-org/mason.nvim",
        optional = true,
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, { "codelldb" })
          end
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        require("dap").adapters["codelldb"] = {
          type = "server",
          port = "${port}",
          executable = {
            -- 使用 mason 安装的 codelldb
            command = "codelldb",
            args = {
              "--port",
              "${port}",
            },
          },
        }
      end
      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          name = "启动应用",
          program = function()
            return vim.fn.input("路径到可执行文件: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "附加到进程",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },

  -- Rust 增强插件
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = function()
      return {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        server = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },

  -- 代码补全增强
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources or {}, {
        { name = "crates" },
      }))
    end,
  },

  -- Crates.io 集成
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
      popup = {
        border = "rounded",
      },
    },
    keys = {
      { "<leader>ct", "<cmd>lua require('crates').toggle()<cr>", desc = "切换依赖显示" },
      { "<leader>cr", "<cmd>lua require('crates').reload()<cr>", desc = "重新加载依赖" },
      { "<leader>cv", "<cmd>lua require('crates').show_versions_popup()<cr>", desc = "显示版本" },
      { "<leader>cf", "<cmd>lua require('crates').show_features_popup()<cr>", desc = "显示特性" },
      { "<leader>cd", "<cmd>lua require('crates').show_dependencies_popup()<cr>", desc = "显示依赖" },
    },
  },
}
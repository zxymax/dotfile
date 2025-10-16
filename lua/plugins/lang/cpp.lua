-- C++ 语言支持配置
return {
  -- 语法高亮增强
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "cpp", "c" })
    end,
  },

  -- LSP 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>ci", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "切换源文件/头文件" },
          },
          settings = {
            -- 提高 clangd 的性能和功能
            clangd = {
              extraArgs = { "--background-index", "-std=c++20" },
              checkUpdates = false,
              semanticHighlighting = true,
              completion = {
                detailedLabel = true,
              },
            },
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          -- 增强 clangd 体验
          local lspconfig = require("lspconfig")
          lspconfig.clangd.setup(opts)
        end,
      },
    },
  },

  -- 调试支持
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
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
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "codelldb",
            request = "launch",
            name = "启动可执行文件",
            program = function()
              return vim.fn.input("路径到可执行文件: ", vim.fn.getcwd() .. "/", "file")
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
      end
    end,
  },

  -- CMake 支持
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_command = "cmake",
      cmake_regenerate_on_save = true,
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_directory = ".build",
      cmake_build_options = {},
      cmake_soft_link_compile_commands = true,
      cmake_default_configuration = "Debug",
    },
    keys = {
      { "<leader>cm", "<cmd>CMakeGenerate<cr>", desc = "生成项目" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "构建项目" },
      { "<leader>cr", "<cmd>CMakeRun<cr>", desc = "运行项目" },
      { "<leader>cd", "<cmd>CMakeDebug<cr>", desc = "调试项目" },
      { "<leader>cs", "<cmd>CMakeSelectBuildType<cr>", desc = "选择构建类型" },
    },
  },
}
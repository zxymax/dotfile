-- LSP 配置模块
-- 包含语言服务器配置、诊断设置和性能优化

local helpers = require("helpers")
local is_windows = helpers.get_platform_info().is_windows

return {
  -- 增强 LSP 功能和诊断显示
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 确保诊断设置被正确配置
      opts.diagnostics = {
        underline = true,
        update_in_insert = false, -- 设置为false以提高性能
        virtual_text = true,
        signs = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }
      
      -- 配置所有语言服务器的默认客户端设置
      opts.setup = vim.tbl_deep_extend("force", opts.setup or {}, {
        -- 通用服务器设置
        _ = function(server, server_opts)
          -- 性能优化：大文件禁用部分LSP功能
          local is_large_file = helpers.is_large_file(0) -- 检查当前缓冲区
          if is_large_file then
            -- 对大文件禁用部分LSP功能以提高性能
            server_opts.on_attach = function(client, bufnr)
              -- 保留基础功能，但禁用一些会影响性能的功能
              client.server_capabilities.semanticTokensProvider = nil
              client.server_capabilities.documentHighlightProvider = nil
            end
          end
          
          -- 确保客户端功能包含诊断相关支持
          server_opts.capabilities = vim.tbl_deep_extend("force", 
            server_opts.capabilities or {}, 
            {
              textDocument = {
                publishDiagnostics = {
                  tagSupport = {
                    valueSet = { 1, 2 },
                  },
                },
              },
            }
          )
          
          -- 配置诊断处理器
          server_opts.handlers = vim.tbl_deep_extend("force",
            server_opts.handlers or {},
            {
              ['textDocument/publishDiagnostics'] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                  virtual_text = true,
                  signs = true,
                  underline = true,
                  update_in_insert = false, -- 禁用插入模式更新以提高性能
                  severity_sort = true,
                }
              ),
            }
          )
          
          -- 应用服务器设置
          helpers.conditionally_configure(
            server, 
            function() require("lspconfig")[server].setup(server_opts) end,
            "配置语言服务器: " .. server
          )
        end,
      })
      
      return opts
    end,
  },
  
  -- 增强诊断显示
  {
    "folke/lsp-colors.nvim",
    config = helpers.create_safe_setup("lsp-colors", function()
      -- 设置诊断符号颜色
      vim.cmd([[
        highlight DiagnosticError guifg=#ff5252
        highlight DiagnosticWarn guifg=#ffb74d
        highlight DiagnosticInfo guifg=#29b6f6
        highlight DiagnosticHint guifg=#66bb6a
        
        highlight DiagnosticVirtualTextError guifg=#ff5252
        highlight DiagnosticVirtualTextWarn guifg=#ffb74d
        highlight DiagnosticVirtualTextInfo guifg=#29b6f6
        highlight DiagnosticVirtualTextHint guifg=#66bb6a
        
        highlight DiagnosticUnderlineError gui=undercurl guisp=#ff5252
        highlight DiagnosticUnderlineWarn gui=undercurl guisp=#ffb74d
        highlight DiagnosticUnderlineInfo gui=undercurl guisp=#29b6f6
        highlight DiagnosticUnderlineHint gui=undercurl guisp=#66bb6a
      ]])
    end, "诊断颜色")
  },
  
  -- 确保安装必要的 LSP 服务器
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = helpers.conditionally_configure(
        true, 
        function()
          -- 平台特定的LSP服务器安装
          local servers = {
            "clangd",
            "clang-format",
            "cpplint",
          }
          
          -- 如果不是Windows，添加可能在Windows上构建失败的服务器
          if not is_windows then
            table.insert(servers, "rust-analyzer")
          end
          
          return servers
        end
      ),
      -- 性能优化：禁用自动安装以减少启动时间
      automatic_installation = false,
      -- 平台特定的构建选项
      registries = {
        "github:mason-org/mason-registry",
      },
    },
  },
  
  -- LSP进度指示器
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = helpers.create_safe_setup("fidget", function(fidget)
      fidget.setup({
        text = {
          spinner = "dots_pulse",
          done = "✓",
          commenced = "Started",
          completed = "Completed",
        },
        align = {
          bottom = true,
          right = true,
        },
        window = {
          relative = "win",
          blend = 0,
          zindex = nil,
          border = "none",
          winblend = 0,
        },
        fmt = {
          fidget = helpers.conditionally_configure(
            true,
            function()
              return function(fidget_name, spinner) return string.format("%s %s", spinner, fidget_name) end
            end
          ),
          task = function(task_name, message, percentage) return message end,
          -- 禁用自动更新以提高性能
          stack_upwards = false,
        },
        -- 性能优化
        debug = false,
        timer = {
          spinner_rate = 100,
          fidget_decay = 500,
          task_decay = 300,
          -- 减少更新频率以提高性能
          resolution = 100,
        },
      })
    end, "LSP进度指示器")
  },
  
  -- LSP自动格式化
  {
    "lukas-reineke/lsp-format.nvim",
    config = helpers.create_safe_setup("lsp-format", function(lsp_format)
      lsp_format.setup({
        -- 性能优化：只在保存时格式化
        sync = false,
        auto = false,
        timeout_ms = 5000,
      })
    end, "LSP格式化")
  },
}
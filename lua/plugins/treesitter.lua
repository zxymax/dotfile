-- Treesitter 语法高亮和增强相关配置模块
-- 优化配置以提高性能和稳定性

local helpers = require("helpers")
local platform_info = helpers.get_platform_info()
local is_windows = platform_info.is_windows

return {
  -- 增强的代码高亮和语法支持
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" }, -- 延迟到文件读取后再加载
    build = function()
      -- 直接使用nvim-treesitter的更新函数
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      -- 使用helpers.safe_require安全加载模块
      local ok, treesitter_configs = helpers.safe_require("nvim-treesitter.configs", "Treesitter配置", true)
      if not ok then
        return
      end
      
      -- 性能优化的禁用函数
      local function should_disable_treesitter(lang, buf)
        -- 统一的大文件判定阈值：1MB
        local max_filesize = 1024 * 1024 -- 1MB
        
        -- 检查文件大小
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        
        -- 平台和语言特定的禁用规则
        local disable_for_languages = {
          "python", -- Python缩进通常有问题
          "php", -- PHP在Windows上性能较差
        }
        
        -- Windows特定的额外禁用规则
        if is_windows then
          table.insert(disable_for_languages, "ruby") -- Ruby在Windows上构建问题较多
          table.insert(disable_for_languages, "rust") -- 大Rust文件在Windows上性能问题
        end
        
        return vim.tbl_contains(disable_for_languages, lang)
      end
      
      treesitter_configs.setup({
        -- 优化的语言安装策略
        ensure_installed = helpers.conditionally_configure(
          true,
          function()
            -- 基础语言（总是安装）
            local base_languages = {
              "c", "cpp", "lua", "vim", "vimdoc", "query",
              "javascript", "typescript", "tsx", "jsx",
              "html", "css", "json", "jsonc",
              "python", "go", "bash",
              "markdown", "markdown_inline"
            }
            
            -- 平台特定语言
            if not is_windows then
              -- 在非Windows平台上添加可能构建失败的语言
              table.insert(base_languages, "rust")
              table.insert(base_languages, "ruby")
            end
            
            return base_languages
          end
        ),
        
        -- 性能优化选项
        sync_install = false, -- 异步安装提高启动速度
        auto_install = true, -- 自动安装缺失的解析器
        ignore_install = {},
        modules = {},
        
        -- 高性能高亮配置
        highlight = {
          enable = true,
          -- 对大文件和特定语言禁用高亮
          disable = should_disable_treesitter,
          additional_vim_regex_highlighting = false, -- 禁用额外的vim正则高亮
          use_languagetree = false, -- 禁用增量高亮以提高性能
        },
        
        -- 缩进配置
        indent = {
          enable = true,
          disable = should_disable_treesitter, -- 复用禁用函数
        },
        
        -- 增量选择
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        
        -- 文本对象
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer", -- 修复了语法问题
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]}"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[{]" ] = "@class.outer",
            },
          },
        },
        
        -- 性能优化: 限制最大解析行数
        max_file_lines = 10000,
        
        -- 优化解析器选项
        parser_install_dir = nil, -- 使用默认位置
        -- 针对大文件的额外优化
        playground = {
          enable = false, -- 禁用playground以提高性能
        },
      })
    end,
    desc = "语法高亮和增强"
  },
  
  -- Treesitter 上下文 - 显示当前函数/类名称
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = helpers.create_safe_setup("treesitter-context", function(context)
      context.setup({
        enable = true, -- 启用上下文显示
        -- 性能优化
        max_lines = 3, -- 限制上下文行数
        min_window_height = 0, -- 不限制窗口高度
        line_numbers = true,
        multiline_threshold = 20, -- 多行上下文阈值
        trim_scope = "outer", -- 外部修剪
        mode = "cursor", -- 基于光标位置
        -- 样式优化
        separator = "─",
        -- 性能优化: 仅在大文件时禁用
        disable = function(lang, buf)
          return helpers.is_large_file(buf)
        end,
      })
    end, "Treesitter上下文")
  },
}
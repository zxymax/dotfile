-- 模糊查找相关配置模块
-- 包含Telescope及其扩展的优化配置

local helpers = require("helpers")
local utils = require("core.utils")
local ft_utils = require("core.ft")
local platform_info = helpers.get_platform_info()
local is_windows = platform_info.is_windows

return {
  -- 模糊查找
  {
    "nvim-telescope/telescope.nvim",
    lazy = true, -- 启用懒加载
    cmd = "Telescope", -- 仅在命令调用时加载
    dependencies = {
      "nvim-lua/plenary.nvim", -- 基础依赖
      {"nvim-telescope/telescope-fzf-native.nvim",
        build = function()
          -- 使用统一的utils模块进行平台检测
          if is_windows then
            -- 检查cmake是否可用
            if not utils.has_cmake() then
              vim.notify("❌ 构建telescope-fzf-native失败：Windows平台需要安装cmake", vim.log.levels.ERROR)
              return "echo 'CMake not found, build skipped'"
            end
            -- Windows平台使用更简单的构建命令
            return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
          else
            -- 检查是否有必要的构建工具
            if utils.has_cmake() then
              return "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release && cmake --install build --prefix build"
            elseif utils.has_make() then
              return "make"
            else
              vim.notify("❌ 构建telescope-fzf-native失败：需要cmake或make工具", vim.log.levels.ERROR)
              return "echo 'Build tools not found, build skipped'"
            end
          end
        end,
        -- 使用统一的utils模块进行条件检测
        cond = function() 
          -- 基于可用的构建工具决定是否加载该插件
          if is_windows then
            return utils.has_cmake()
          else
            return utils.has_cmake() or utils.has_make()
          end
        end,
        -- 提供更友好的用户消息
        init = function()
          -- 预先检查构建工具是否可用
          if is_windows and not utils.has_cmake() then
            vim.schedule(function()
              vim.notify("🔧 提示：telescope-fzf-native需要cmake才能在Windows上构建。\n请安装cmake后运行:Lazy install重新构建插件。", vim.log.levels.WARN)
            end)
          end
        end,
      },
    },
    config = function()
      -- 应用文件类型映射到treesitter解析器
      ft_utils.apply_to_treesitter()
      
      -- 使用统一的utils.safe_require安全加载telescope
      local ok, telescope = utils.safe_require("telescope", "Telescope模糊查找", true, true) -- 设置once=true避免重复通知
      if not ok then
        return
      end
      
      -- 尝试加载fzf扩展 - 使用统一的utils模块进行错误处理
      utils.conditionally_configure(
        true,
        function() 
          telescope.load_extension("fzf") 
        end
      )
      
      -- 设置Telescope配置
      telescope.setup({
        defaults = {
          -- 性能优化设置
          cache_picker = {
            num_pickers = 5, -- 减少缓存以节省内存
            limit_entries = 1000, -- 限制缓存条目数
          },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/',
            -- 性能优化：限制搜索深度
            '--maxdepth=10',
          },
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-n>"] = require("telescope.actions").cycle_history_next,
              ["<C-p>"] = require("telescope.actions").cycle_history_prev,
            },
          },
          preview = {
            treesitter = false, -- 禁用treesitter预览以提高性能
            timeout = 200, -- 限制预览加载时间
            filesize_limit = vim.g.PREVIEW_FILESIZE_LIMIT or 1, -- 使用配置的预览文件大小限制（MB）
            -- 对大文件禁用预览
            check_mime_type = true,
            skip_broken_symlinks = true,
          },
          -- 性能优化设置
          dynamic_preview_title = false,
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
            "__pycache__/",
            "build/",
            "dist/",
            ".DS_Store",
            "*.swp",
            "*.swo",
          },
          -- 性能优化：减少延迟
          cycle_layout_list = {
            "horizontal",
            "vertical",
          },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
        },
        pickers = {
          -- 文件选择器性能优化
          find_files = {
            disable_devicons = false,
            -- 对大目录禁用预览
            previewer = function(opts)
              return not helpers.is_large_directory(vim.fn.expand("%:p:h"))
            end,
          },
          -- grep性能优化
          live_grep = {
            disable_coordinates = false,
            only_sort_text = true,
            -- 对大目录限制搜索范围
            additional_args = function(opts)
              if helpers.is_large_directory(vim.fn.expand("%:p:h")) then
                return { "--max-depth=5" }
              end
              return {}
            end,
          },
          -- 缓冲区选择器
          buffers = {
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
              i = {
                ["<c-d>"] = require("telescope.actions").delete_buffer,
              },
              n = {
                ["d"] = require("telescope.actions").delete_buffer,
              },
            },
          },
        },
        extensions = {
          -- fzf扩展配置
          fzf = {
            fuzzy = true,                   -- 模糊匹配
            override_generic_sorter = true, -- 覆盖通用排序器
            override_file_sorter = true,    -- 覆盖文件排序器
            case_mode = "smart_case",       -- 智能大小写
          },
        },
      })
    end,
    desc = "模糊查找",
    keys = {
      {"<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files"},
      {"<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep"},
      {"<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers"},
      {"<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags"},
      {"<leader>fr", function() require("telescope.builtin").registers() end, desc = "Registers"},
      {"<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps"},
    },
  },
}
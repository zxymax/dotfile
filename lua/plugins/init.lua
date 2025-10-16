-- 通用插件配置
return {
  -- 主题配置
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- 文件浏览器 - 图标支持
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      local ok, web_devicons = pcall(require, "nvim-web-devicons")
      if ok then
        -- 启用真正的图标支持，使用已安装的Hack Nerd Font
        web_devicons.setup({
          strict = true,
          override_by_extension = {}
        })
        vim.notify("nvim-web-devicons已加载，使用Hack Nerd Font图标", vim.log.levels.INFO)
      else
        vim.notify("无法加载nvim-web-devicons", vim.log.levels.WARN)
      end
    end,
  },
  {    
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy", -- 添加事件触发，确保在启动时加载
    config = function()
      -- 添加错误处理
      local ok, nvim_tree = pcall(require, "nvim-tree")
      if not ok then
        vim.notify("无法加载nvim-tree.lua: " .. tostring(nvim_tree), vim.log.levels.ERROR)
        return
      end
      
      -- 确保全局命令存在
      _G.NvimTreeToggle = function()
        local api = require("nvim-tree.api")
        api.tree.toggle()
      end
      
      -- 配置选项 - 使用真正的图标
      local config = {
          view = {
            width = 30,
          },
          filters = {
            dotfiles = false,
          },
          git = {
            enable = true,
            ignore = false,
          },
          -- 使用nvim-web-devicons的图标
          renderer = {
            icons = {
              -- 启用所有图标显示
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
              },
              -- 使用默认图标配置
              glyphs = {
                folder = {
                  arrow_closed = "▶",
                  arrow_open = "▼",
                },
              },
              -- 启用webdev颜色
              webdev_colors = true,
            },
            -- 特殊文件标记
            special_files = {
              "Cargo.toml", "Makefile", "README.md", "readme.md"
            }
          },
          -- 添加自定义快捷键映射
          on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          
          -- 定义默认映射
          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end
          
          -- 基本导航映射
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
          vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        end
      }
      
      nvim_tree.setup(config)
      
      vim.notify("nvim-tree.lua加载成功，使用Hack Nerd Font图标", vim.log.levels.INFO)
    end,
  },

  -- 增强的状态栏配置
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "folke/noice.nvim", -- 可选：与noice集成以获得更好的体验
    },
    config = function()
      local function get_lsp_progress()
        local msg = ''
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return msg
        end
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            local status = client.status
            if status and status ~= '' then
              return status
            end
          end
        end
        return msg
      end

      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          ignore_focus = { "NvimTree" },
          always_divide_middle = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { 
            { 
              "mode",
              fmt = function(str)
                return str:sub(1, 1) -- 只显示模式的第一个字符
              end,
              padding = { left = 1, right = 1 },
            }
          },
          lualine_b = { 
            { "branch", icon = "" }, 
            { 
              "diff", 
              colored = true,
              symbols = { added = "", modified = "", removed = "" },
            }
          },
          lualine_c = { 
            { 
              "filename", 
              path = 1, -- 显示相对路径
              symbols = { 
                modified = "●",
                readonly = "",
                unnamed = "",
              },
              padding = { left = 0 },
            },
            { get_lsp_progress, padding = { left = 1 } }
          },
          lualine_x = { 
            { 
              "diagnostics",
              sources = { "nvim_lsp", "nvim_diagnostic" },
              symbols = { error = "", warn = "", info = "", hint = "" },
              colored = true,
              update_in_insert = true,
            },
            "encoding", 
            "fileformat", 
            { 
              "filetype",
              icon_only = true,
              padding = { left = 1, right = 0 },
            },
          },
          lualine_y = { 
            { 
              "progress",
              fmt = function(str)
                -- 只显示百分比，去掉前后括号
                return str:gsub("[()]", "")
              end,
            }
          },
          lualine_z = { 
            { 
              "location",
              padding = { left = 0, right = 1 },
            }
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { 
          "nvim-tree", 
          "toggleterm",
          "lazy",
          "man",
          "quickfix",
        },
      })
    end,
  },
  
  -- 增强的欢迎界面配置
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require("dashboard")
      
      -- 自定义标题图标
      local function get_footer()
        local datetime = os.date("%Y-%m-%d %H:%M:%S")
        return { datetime, "󰚥  效率提升，从现在开始" }
      end
      
      dashboard.setup({
        theme = "doom",
        config = {
          header = {
            "",
            "",
            "██████╗  █████╗ ███╗   ███╗███████╗██████╗ ",
            "██╔══██╗██╔══██╗████╗ ████║██╔════╝██╔══██╗",
            "██████╔╝███████║██╔████╔██║█████╗  ██║  ██║",
            "██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║  ██║",
            "██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██████╔╝",
            "╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═════╝ ",
            "",
            "        ╭──────────────────────────────────╮        ",
            "        │           zxymax 的配置           │        ",
            "        ╰──────────────────────────────────╯        ",
            "",
          },
          week_header = {
            enable = true,
            append = { "  让每一天都充满创造力  " },
          },
          shortcut = {
            { 
              desc = "🔄  更新插件", 
              group = { "@property", "Label" }, 
              action = "Lazy update", 
              key = "u",
              icon = "",
            },
            { 
              desc = "📁  查找文件", 
              group = { "@property", "Label" }, 
              action = "Telescope find_files", 
              key = "f",
              icon = "",
            },
            { 
              desc = "🔍  搜索文本", 
              group = { "@property", "Label" }, 
              action = "Telescope live_grep", 
              key = "g",
              icon = "🔎",
            },
            { 
              desc = "📝  新建文件", 
              group = { "@property", "Label" }, 
              action = "enew", 
              key = "n",
              icon = "",
            },
            { 
              desc = "📊  项目管理", 
              group = { "@property", "Label" }, 
              action = "Telescope projects", 
              key = "p",
              icon = "📁",
            },
            { 
              desc = "❌  退出", 
              group = { "@property", "Label" }, 
              action = "quit", 
              key = "q",
              icon = "✗",
            },
          },
          packages = {
            enable = true,
            limit = 3,
          },
          project = {
            enable = true,
            limit = 5,
            icon = "📁",
            label = "🎯  最近项目:",
            action = function(path) 
              vim.cmd.cd(path) 
              require("telescope.builtin").find_files()
            end,
            icon_hl = "DashboardProjectIcon",
            label_hl = "DashboardProjectTitle",
          },
          mru = {
            limit = 7,
            icon = "📝",
            label = "📋  最近文件:",
            cwd_only = false,
            icon_hl = "DashboardMruIcon",
            label_hl = "DashboardMruTitle",
          },
          footer = get_footer(),
        },
      })
      
      -- 自定义颜色
      vim.cmd("highlight DashboardHeader guifg=#7BCCB5")
      vim.cmd("highlight DashboardFooter guifg=#8FA2FF")
      vim.cmd("highlight DashboardProjectIcon guifg=#97C1A9")
      vim.cmd("highlight DashboardProjectTitle guifg=#6A8CAF")
      vim.cmd("highlight DashboardMruIcon guifg=#C8A2C8")
      vim.cmd("highlight DashboardMruTitle guifg=#6A8CAF")
      vim.cmd("highlight DashboardShortcut guifg=#8FA2FF")
    end,
    dependencies = { 
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-telescope/telescope.nvim" }, -- 为了项目和文件查找功能
    },
  },

  -- 自动补全增强
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- 使用pcall安全加载模块
      local ok, cmp = pcall(require, "cmp")
      if not ok then
        vim.notify("nvim-cmp plugin not found or has errors.", vim.log.levels.WARN)
        return opts
      end
      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
      })
      return opts
    end,
  },

  -- 代码注释
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "注释当前行" },
      { "gc", mode = "v", desc = "注释选中区域" },
    },
    config = function()
      -- 使用pcall安全加载模块
      local ok, comment = pcall(require, "Comment")
      if not ok then
        vim.notify("Comment.nvim plugin not found or has errors.", vim.log.levels.WARN)
        return
      end
      comment.setup()
    end,
  },

  -- 多光标编辑
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- 模糊查找
  {    "nvim-telescope/telescope.nvim",
    config = function()
      -- 首先添加全局修复：提供ft_to_lang函数
      local function setup_ft_to_lang_fix()
        -- 尝试加载nvim-treesitter.parsers
        local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
        if ok_parsers then
          -- 如果parsers存在但没有ft_to_lang函数，添加它
          if not parsers.ft_to_lang then
            parsers.ft_to_lang = function(filetype)
              -- 简单的文件类型映射
              local ft_map = {
                javascriptreact = "tsx",
                typescriptreact = "tsx",
                html = "html",
                css = "css",
                json = "json",
                jsonc = "jsonc",
                lua = "lua",
                vim = "vim",
                c = "c",
                cpp = "cpp",
                rust = "rust",
              }
              return ft_map[filetype] or filetype
            end
          end
        end
        
        -- 也在全局环境中创建这个函数，以防其他地方需要
        _G.ft_to_lang = _G.ft_to_lang or function(filetype)
          local ft_map = {
            javascriptreact = "tsx",
            typescriptreact = "tsx",
            html = "html",
            css = "css",
            json = "json",
            jsonc = "jsonc",
            lua = "lua",
            vim = "vim",
            c = "c",
            cpp = "cpp",
            rust = "rust",
          }
          return ft_map[filetype] or filetype
        end
      end
      
      -- 应用修复
      setup_ft_to_lang_fix()
      
      -- 尝试加载telescope
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.setup({
          defaults = {
            mappings = {
              i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
              },
            },
            preview = {
              treesitter = false, -- 禁用treesitter预览以避免错误
            },
          },
        })
        
        -- 扩展已通过配置自动加载
      else
        vim.notify("无法加载telescope", vim.log.levels.ERROR)
      end
    end,
    keys = {
      {"<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files"},
      {"<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep"},
      {"<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers"},
      {"<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags"},
    },
    lazy = false, -- 不懒加载，确保所有命令可用
    dependencies = {"nvim-lua/plenary.nvim"}, -- 只保留必要的依赖
  },
  
  -- 终端集成 - 改进的终端配置
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 1,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
  },
  
  -- 视觉增强 - 平滑滚动
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },
  
  -- 增强的通知和命令行体验
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
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
      
      -- 配置通知插件
      require("notify").setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        max_width = 80,
        background_colour = "#000000",
      })
      
      -- 设置为默认通知器
      vim.notify = require("notify")
    end,
  },
  
  -- 终端增强插件
  { "skywind3000/vim-terminal-help", lazy = true },
  
  -- 增强的代码高亮和语法支持
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      -- Use pcall to safely load the plugin and handle errors gracefully
      local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter plugin not found. Please run :Lazy install to install missing plugins.", vim.log.levels.WARN)
        return
      end
      
      treesitter_configs.setup({
        ensure_installed = {
          "c", "cpp", "lua", "vim", "vimdoc", "query",
          "javascript", "typescript", "tsx", "jsx",
          "html", "css", "json", "jsonc",
          "python", "rust", "go", "bash",
          "markdown", "markdown_inline"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
          disable = { "python" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
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
              ["]]" ] = "@class.outer",
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
              ["[{" ] = "@class.outer",
            },
          },
        },
      })
    end,
  },
}
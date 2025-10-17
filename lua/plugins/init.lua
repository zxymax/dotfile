-- 通用插件配置
  return {
   -- 语言支持插件 - 使用pcall包装以避免错误
   { import = "plugins.lang", 
     config = function()
       -- 静默加载语言插件，避免错误传播
     end
   },
  -- 主题配置
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
      header = {
        "",
        "  zzzzz    xxxxxx    yyyyy    mmmmmm    aaaaaa  ",
        "zzz  zzz  xxx  xxx  yyy  yyy  mm  mm    aa  aa  ",
        "zzz      xxx    xxx yyy      mm    mm  aa  aa  ",
        "zzz      xxx    xxx yyy      mm    mm  aaaaaa  ",
        "zzz  zzz  xxx  xxx  yyy  yyy  mm  mm    aa  aa  ",
        "  zzzzz    xxxxxx    yyyyy    mmmmmm    aa  aa  ",
        "",
      },
    },
  },
  
  -- Gruvbox主题插件
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local ok, gruvbox = pcall(require, "gruvbox")
      if ok then
        gruvbox.setup({
          terminal_colors = true,
          undercurl = true,
          underline = true,
          bold = true,
          italic = {
            strings = true,
            comments = true,
            operators = false,
            folds = true,
          },
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true,
          contrast = "hard",
          palette_overrides = {},
          overrides = {},
          dim_inactive = false,
          transparent_mode = false,
        })
      end
    end
  },

  -- 文件浏览器 - 图标支持
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true, -- 延迟加载以提高启动速度
    config = function()
      local ok, web_devicons = pcall(require, "nvim-web-devicons")
      if ok then
        -- 启用真正的图标支持，使用已安装的Hack Nerd Font
        web_devicons.setup({
          strict = true,
          override_by_extension = {}
        })
      end
    end,
  },
  {    
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy" }, -- 使用table形式更清晰
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "文件浏览器" },
    },
    config = function()
      -- 添加错误处理
      local ok, nvim_tree = pcall(require, "nvim-tree")
      if not ok then
        vim.notify("无法加载nvim-tree.lua: " .. tostring(nvim_tree), vim.log.levels.ERROR)
        return
      end
      
      -- 配置选项 - 使用真正的图标，优化性能
      local config = {
          -- 性能优化设置
          sync_root_with_cwd = true,
          respect_buf_cwd = true,
          update_focused_file = {
            enable = true,
            update_root = true,
          },
          -- 视图设置
          view = {
            width = 30,
            preserve_window_proportions = true,
          },
          -- 文件过滤
          filters = {
            dotfiles = false,
            git_ignored = false, -- 显示被git忽略的文件
          },
          -- Git集成
          git = {
            enable = true,
            ignore = false,
            timeout = 400, -- 减少git操作超时时间
          },
          -- 文件系统相关
          filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
          },
          -- 使用nvim-web-devicons的图标
          renderer = {
            icons = {
              -- 简化图标配置
              git_placement = "after",
              padding = "  ",
              symlink_arrow = " → ",
              glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                folder = {
                  arrow_closed = "▶",
                  arrow_open = "▼",
                  default = "",
                  open = "",
                  empty = "",
                  empty_open = "",
                  symlink = "",
                  symlink_open = "",
                },
              },
              -- 启用webdev颜色
              webdev_colors = true,
            },
            -- 特殊文件标记
            special_files = {
              "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json", "go.mod", "go.sum"
            },
            -- 性能优化：减少渲染
            indent_markers = {
              enable = false, -- 禁用缩进标记以提高性能
            },
          },
          -- 添加自定义快捷键映射
            on_attach = function(bufnr)
              -- 使用局部变量避免重复require
              local api = require("nvim-tree.api")
              
              -- 定义默认映射
              local function keymap(lhs, rhs, desc)
                vim.keymap.set('n', lhs, rhs, {
                  desc = "nvim-tree: " .. desc,
                  buffer = bufnr,
                  noremap = true,
                  silent = true,
                  nowait = true,
                })
              end
              
              -- 基本导航映射
              keymap('<CR>', api.node.open.edit, '打开文件')
              keymap('o', api.node.open.edit, '打开文件')
              keymap('h', api.node.navigate.parent_close, '关闭目录')
              keymap('l', api.node.open.edit, '打开文件/目录')
              keymap('q', api.tree.close, '关闭')
              keymap('<Esc>', api.tree.close, '关闭')
              -- 额外实用快捷键
              keymap('r', api.fs.rename, '重命名')
              keymap('d', api.fs.remove, '删除')
              keymap('a', api.fs.create, '创建文件')
              keymap('c', api.fs.copy.node, '复制')
              keymap('x', api.fs.cut, '剪切')
              keymap('p', api.fs.paste, '粘贴')
              keymap('gf', api.node.navigate.git.prev, '上一个git变更')
              keymap('gn', api.node.navigate.git.next, '下一个git变更')
              keymap('.', api.node.run.cmd, '运行命令')
            end
          }
          
          nvim_tree.setup(config)
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
          theme = "gruvbox",
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
  
  -- Git 增强插件 - 行内 git 更改标记
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ok, gitsigns = pcall(require, "gitsigns")
      if not ok then
        vim.notify("gitsigns.nvim plugin not found or has errors.", vim.log.levels.WARN)
        return
      end
      
      gitsigns.setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
        -- 快捷键
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          
          -- 导航
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })
          
          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })
          
          -- 操作
          map('n', '<leader>hs', gs.stage_hunk)
          map('n', '<leader>hr', gs.reset_hunk)
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)
          
          -- 文本对象
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  },
  
  -- Git 集成插件 - 全面的 Git 功能
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git", "G", "Ggrep", "Gread", "Gwrite", "Gdiffsplit",
      "GBrowse", "GDelete", "GMove", "GRename"
    },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git 状态" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git 提交" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git 推送" },
      { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git 拉取" },
      { "<leader>gb", "<cmd>Git branch<cr>", desc = "Git 分支" },
      { "<leader>gd", "<cmd>Git diff<cr>", desc = "Git 差异" },
    },
    config = function()
      -- 使用 fugitive 的默认配置
    end
  },
  
  -- Git 代码注释插件（类似GitLens）
  {  
    "APZelos/blamer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- 使用pcall安全加载模块
      local ok, blamer = pcall(require, "blamer")
      if not ok then
        vim.notify("blamer.nvim plugin not found or has errors.", vim.log.levels.WARN)
        return
      end
      
      -- 配置blamer
      vim.g.blamer_enabled = 1
      vim.g.blamer_delay = 300  -- 鼠标悬停延迟
      vim.g.blamer_relative_time = 1  -- 显示相对时间
      vim.g.blamer_date_format = '%Y-%m-%d'
      vim.g.blamer_template = '<author> • <committer-time> • <summary>'
      
      -- 集成到which-key
      if pcall(require, "which-key") then
        require("which-key").register({
          ["<leader>gb"] = { "<cmd>BlamerToggle<cr>", "切换GitLens注释显示" },
        })
      end
    end,
  },

  -- Git 冲突解决插件
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    keys = {
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", desc = "选择我们的更改" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "选择他们的更改" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "保留双方更改" },
      { "<leader>gc0", "<cmd>GitConflictChooseNone<cr>", desc = "不保留任何更改" },
      { "<leader>gcN", "<cmd>GitConflictNextConflict<cr>", desc = "下一个冲突" },
      { "<leader>gcP", "<cmd>GitConflictPrevConflict<cr>", desc = "上一个冲突" },
      { "<leader>gcc", "<cmd>GitConflictListQf<cr>", desc = "列出所有冲突" },
    },
    opts = {
      default_mappings = false,
      disable_diagnostics = false,
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffChange',
      },
    }
  },
  
  -- Which-key git 快捷键分组
  {
    "folke/which-key.nvim",
    optional = true,
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
  
  -- 内存使用优化插件
  {
    "chrisbra/Recover.vim",
    lazy = true,
    cmd = "Recover",
  },
  
  -- 性能优化插件
  {
    "lewis6991/impatient.nvim",
    lazy = false,
    priority = 10000,
    config = function()
      -- 使用pcall安全加载
      local ok = pcall(require, "impatient")
      if not ok then
        vim.notify("impatient.nvim加载失败，但不影响正常使用", vim.log.levels.WARN)
      end
    end,
  },

  -- 更快的文件类型检测
  {
    "nathom/filetype.nvim",
    lazy = false,
    config = function()
      require("filetype").setup({
        overrides = {
          extensions = {
            -- 添加自定义文件类型
            h = "cpp",
            hpp = "cpp",
          },
        },
      })
    end,
  },

  -- 多光标编辑
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- 模糊查找
  {    "nvim-telescope/telescope.nvim",
    lazy = true, -- 启用懒加载
    cmd = "Telescope", -- 仅在命令调用时加载
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
        -- 尝试加载fzf扩展
        local ok_fzf = pcall(require, "telescope")
        if ok_fzf then
          pcall(function() telescope.load_extension("fzf") end)
        end
        
        telescope.setup({
          defaults = {
            -- 性能优化设置
            cache_picker = {
              num_pickers = 10,
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
              filesize_limit = 1, -- 限制预览文件大小为1MB
            },
            -- 减少不必要的延迟
            dynamic_preview_title = false,
            file_ignore_patterns = {
              "node_modules/",
              ".git/",
              "__pycache__/",
              "build/",
              "dist/",
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
    dependencies = {
      "nvim-lua/plenary.nvim", -- 只保留必要的依赖
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release && cmake --install build --prefix build",
        -- 如果构建失败，仍然允许插件加载
        cond = function() return pcall(function() require("telescope") end) end,
        config = function()
          pcall(function() require("telescope").load_extension("fzf") end)
        end,
      },
    },
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
    event = { "BufReadPost", "BufNewFile" }, -- 延迟到文件读取后再加载
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      -- Use pcall to safely load the plugin and handle errors gracefully
      local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        -- 静默跳过，不显示警告消息
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
        -- 性能优化选项
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          -- 对大文件禁用高亮以提高性能
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
          -- 禁用增量高亮以提高性能
          use_languagetree = false,
        },
        indent = {
          enable = true,
          -- 对大文件禁用缩进
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
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
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

  -- 状态栏 - 借鉴craftzdog风格
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", { "diff", colored = true } },
          lualine_c = { 
            { 
              "filename", 
              path = 1, -- 显示相对路径
              symbols = { 
                modified = "●",
                readonly = "",
                unnamed = "",
              }
            }
          },
          lualine_x = { 
            { 
              "diagnostics",
              sources = { "nvim_lsp" },
              symbols = { error = "●", warn = "●", info = "●", hint = "●" },
            },
            "encoding", 
            "fileformat", 
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "toggleterm" },
      })
    end,
  },
  
  -- 欢迎界面 - 借鉴craftzdog风格
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        config = {
          header = {
            "",
            "",
            "",
            "███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
            "████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
            "██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
            "██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
            "██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
            "",
            "                   欢迎使用 Neovim                    ",
            "",
          },
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = "󰊳  更新", group = "Label", action = "Lazy update", key = "u" },
            { desc = "  文件", group = "Label", action = "Telescope find_files", key = "f" },
            { desc = "󰙅  退出", group = "Label", action = "quit", key = "q" },
          },
          packages = {
            enable = true,
          },
          project = {
            enable = true,
            limit = 8,
            icon = "",
            label = "最近项目:",
            action = function(path) vim.cmd.cd(path) end,
          },
          mru = {
            limit = 10,
            icon = "",
            label = "最近文件:",
          },
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },

  -- 自动补全增强
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
      })
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
      require("Comment").setup()
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
  
  -- 终端增强插件
  { "skywind3000/vim-terminal-help", lazy = true },
}
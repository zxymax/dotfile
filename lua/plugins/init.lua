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

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_b = { "branch", "diff" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
        },
      })
    end,
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
  
  -- 终端集成
  {
    "akinsho/toggleterm.nvim",
    version = "v2.*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<leader>\]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },
}
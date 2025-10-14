-- 通用插件配置
return {
  -- nvim-treesitter配置（如果能加载的话）
  {"nvim-treesitter/nvim-treesitter",
    version = false, -- 不固定版本，使用最新
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- 尝试加载nvim-treesitter
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if ok then
        treesitter.setup({
          ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "rust", "typescript", "javascript", "tsx", "jsx", "html", "css", "json", "jsonc"},
          highlight = {
            enable = true,
          },
          indent = {
            enable = true,
          },
        })
      else
        vim.notify("无法加载nvim-treesitter", vim.log.levels.ERROR)
      end
    end,
  },
  -- 主题配置
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- 文件浏览器
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "文件浏览器" },
    },
    config = function()
      require("nvim-tree").setup({
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
      })
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
        
        -- 加载扩展
        pcall(require, "telescope")
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
}
-- 前端开发配置 (TypeScript, JavaScript)
return {
  -- 语法高亮和智能解析
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "javascript", "tsx", "jsx", "html", "css", "json", "jsonc" })
      end
    end,
  },

  -- TypeScript 语言服务器配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        -- CSS/HTML 语言服务器
        cssls = {},
        html = {},
        -- JSON 语言服务器
        jsonls = {},
      },
    },
  },

  -- 增强 TypeScript 功能
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("typescript").setup({
        server = {
          on_attach = function(_, bufnr)
            -- 快捷键设置
            vim.keymap.set("n", "<leader>to", "<cmd>TypescriptOrganizeImports<cr>", { buffer = bufnr, desc = "组织导入" })
            vim.keymap.set("n", "<leader>tr", "<cmd>TypescriptRenameFile<cr>", { buffer = bufnr, desc = "重命名文件" })
            vim.keymap.set("n", "<leader>ta", "<cmd>TypescriptAddMissingImports<cr>", { buffer = bufnr, desc = "添加缺失导入" })
            vim.keymap.set("n", "<leader>tf", "<cmd>TypescriptFixAll<cr>", { buffer = bufnr, desc = "修复所有问题" })
            vim.keymap.set("n", "<leader>ti", "<cmd>TypescriptRemoveUnused<cr>", { buffer = bufnr, desc = "移除未使用代码" })
          end,
        },
      })
    end,
  },

  -- 使用LazyVim默认的conform.nvim进行Prettier格式化
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
      }
      opts.formatters = {
        prettier = {
          args = { "--single-quote", "--jsx-single-quote" },
        },
      }
    end,
  },

  -- 自动闭合标签
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "tsx", "jsx", "xml" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- CSS 颜色高亮
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "tsx", "jsx" },
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "tsx", "jsx" }, {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      })
    end,
  },
}
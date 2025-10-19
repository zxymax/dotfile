-- Git相关配置模块

local helpers = require("helpers")

return {
  -- Git 增强插件 - 行内 git 更改标记
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = helpers.create_safe_setup("gitsigns", function(gitsigns)
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
    end, "Git 增强插件")
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
}
-- 性能优化相关配置模块

local helpers = require("helpers")

return {
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
    priority = 10000, -- 最高优先级，确保最先加载
    config = function()
      -- 使用helpers.safe_require安全加载
      helpers.safe_require("impatient", "性能优化插件", false)
    end,
  },

  -- 更快的文件类型检测
  {
    "nathom/filetype.nvim",
    lazy = false,
    config = helpers.create_safe_setup("filetype", function(filetype)
      filetype.setup({
        overrides = {
          extensions = {
            -- 添加自定义文件类型
            h = "cpp",
            hpp = "cpp",
          },
        },
      })
    end, "文件类型检测")
  },

  -- 多光标编辑
  { "mg979/vim-visual-multi", branch = "master" },
  
  -- 视觉增强 - 平滑滚动
  {
    "karb94/neoscroll.nvim",
    config = helpers.create_safe_setup("neoscroll", function(neoscroll)
      neoscroll.setup({
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
    end, "平滑滚动")
  },
}
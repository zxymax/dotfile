-- 代码注释相关配置模块

local helpers = require("helpers")

return {
  -- 代码注释
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "注释当前行" },
      { "gc", mode = "v", desc = "注释选中区域" },
    },
    config = helpers.create_safe_setup("Comment", function(comment)
      comment.setup()
    end, "代码注释")
  },
}
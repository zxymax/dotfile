-- 欢迎界面相关配置模块

local helpers = require("helpers")
local header = require("assets.header")

return {
  -- 增强的欢迎界面配置
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = helpers.create_safe_setup("dashboard", function(dashboard)
      -- 使用从assets/header.lua导入的页脚
      local function get_footer()
        local datetime = os.date("%Y-%m-%d %H:%M:%S")
        return { datetime, header.footer }
      end
      
      -- 从assets/header.lua引用头部文本
      -- 这样可以保持主配置文件的简洁，也便于维护
      
      dashboard.setup({
        theme = "doom",
        config = {
          header = header.main_header,
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
          },
          footer = get_footer,
        },
      })
    end, "欢迎界面"),
  },
}
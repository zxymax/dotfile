-- 状态栏相关配置模块

local helpers = require("helpers")

return {
  -- 增强的状态栏配置
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 
      "nvim-tree/nvim-web-devicons",
      "folke/noice.nvim", -- 可选：与noice集成以获得更好的体验
    },
    config = helpers.create_safe_setup("lualine", function(lualine)
      -- 获取LSP进度信息的函数
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

      lualine.setup({
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
    end, "状态栏"),
  },
}
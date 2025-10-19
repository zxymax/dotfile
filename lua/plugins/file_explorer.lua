-- 文件浏览器相关配置模块
-- 包含nvim-tree和其他文件浏览功能的设置

local helpers = require("helpers")

return {
  -- nvim-tree文件浏览器
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "文件浏览器" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "聚焦文件浏览器" },
    },
    config = helpers.create_safe_setup("nvim-tree", function(nvim_tree)
      -- 使用配置表方式使配置更清晰
      local config = {
        -- 性能优化设置
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        -- 视图配置
        view = {
          width = 30,
          side = "left",
          preserve_window_proportions = true,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
        },
        -- 文件过滤配置
        filters = {
          dotfiles = false,
          git_ignored = false, -- 显示被git忽略的文件
          custom = { ".git", "node_modules", ".cache", "__pycache__" },
        },
        -- Git集成
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        -- 文件系统监控配置（优化性能）
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
        },
        -- 渲染器配置
        renderer = {
          highlight_git = true,
          highlight_opened_files = "name",
          root_folder_label = ":t",
          icons = {
            git_placement = "after",
            padding = "  ",
            symlink_arrow = " → ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
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
        -- 键盘映射配置
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          
          -- 定义按键映射函数
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
          helpers.safe_keymap_set('n', '<CR>', api.node.open.edit, opts('打开文件'))
          helpers.safe_keymap_set('n', 'o', api.node.open.edit, opts('打开文件'))
          helpers.safe_keymap_set('n', 'h', api.node.navigate.parent_close, opts('关闭目录'))
          helpers.safe_keymap_set('n', 'l', api.node.open.edit, opts('打开文件/目录'))
          helpers.safe_keymap_set('n', 'q', api.tree.close, opts('关闭'))
          helpers.safe_keymap_set('n', '<Esc>', api.tree.close, opts('关闭'))
          
          -- 额外实用快捷键
          helpers.safe_keymap_set('n', 'r', api.fs.rename, opts('重命名'))
          helpers.safe_keymap_set('n', 'd', api.fs.remove, opts('删除'))
          helpers.safe_keymap_set('n', 'a', api.fs.create, opts('创建文件'))
          helpers.safe_keymap_set('n', 'c', api.fs.copy.node, opts('复制'))
          helpers.safe_keymap_set('n', 'x', api.fs.cut, opts('剪切'))
          helpers.safe_keymap_set('n', 'p', api.fs.paste, opts('粘贴'))
          helpers.safe_keymap_set('n', 'gf', api.node.navigate.git.prev, opts('上一个git变更'))
          helpers.safe_keymap_set('n', 'gn', api.node.navigate.git.next, opts('下一个git变更'))
          helpers.safe_keymap_set('n', '.', api.node.run.cmd, opts('运行命令'))
          
          -- 高级操作快捷键
          helpers.safe_keymap_set('n', 'R', api.tree.reload, opts('刷新'))
          helpers.safe_keymap_set('n', 'H', api.tree.toggle_hidden_filter, opts('切换显示隐藏文件'))
          helpers.safe_keymap_set('n', 'I', api.tree.toggle_gitignore_filter, opts('切换显示git忽略文件'))
        end,
        -- 关闭时自动聚焦到最近的缓冲区
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
      }
      
      nvim_tree.setup(config)
    end, "文件浏览器")
  },
}
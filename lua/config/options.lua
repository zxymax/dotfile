-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- 基础编辑配置
vim.opt.number = true          -- 显示行号
vim.opt.relativenumber = true  -- 显示相对行号
vim.opt.cursorline = true      -- 高亮当前行
vim.opt.cursorcolumn = false   -- 不高亮当前列
vim.opt.signcolumn = "yes"     -- 始终显示符号列
vim.opt.wrap = false           -- 不自动换行

-- 缩进设置
vim.opt.tabstop = 4            -- Tab键宽度
vim.opt.softtabstop = 4        -- 退格键宽度
vim.opt.shiftwidth = 4         -- 自动缩进宽度
vim.opt.expandtab = true       -- 将Tab转换为空格
vim.opt.smartindent = true     -- 智能缩进

-- 搜索设置
vim.opt.hlsearch = true        -- 高亮搜索结果
vim.opt.incsearch = true       -- 增量搜索
vim.opt.ignorecase = true      -- 忽略大小写
vim.opt.smartcase = true       -- 智能大小写

-- 外观设置
vim.opt.termguicolors = true   -- 启用真彩色
vim.opt.background = "dark"    -- 暗色背景
vim.opt.scrolloff = 8          -- 滚动时保持光标周围有8行
vim.opt.sidescrolloff = 8      -- 水平滚动时保持光标周围有8列
vim.opt.showmode = false       -- 不显示模式

-- 文件设置
vim.opt.swapfile = false       -- 不创建交换文件
vim.opt.backup = false         -- 不创建备份文件
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- 撤销目录
vim.opt.undofile = true        -- 启用撤销文件
vim.opt.autoread = true        -- 自动读取外部修改的文件

-- 性能设置
vim.opt.updatetime = 250       -- 更新时间
vim.opt.timeoutlen = 300       -- 按键超时时间
vim.opt.lazyredraw = false     -- 不延迟重绘
vim.opt.ttyfast = true         -- 终端速度快

-- 完成设置
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- 自动完成选项

-- 分割窗口设置
vim.opt.splitbelow = true      -- 新窗口在下方
vim.opt.splitright = true      -- 新窗口在右侧

-- 编码设置
vim.opt.encoding = "utf-8"     -- 编码
vim.opt.fileencoding = "utf-8" -- 文件编码

-- 其他设置
vim.opt.mouse = "a"            -- 启用鼠标
vim.opt.list = false           -- 不显示不可见字符
vim.opt.showtabline = 2        -- 始终显示标签页栏
vim.opt.clipboard = "unnamedplus" -- 共享剪贴板
vim.opt.pumheight = 10         -- 弹出菜单高度
vim.opt.cmdheight = 1          -- 命令行高度

-- 特定于开发的设置
vim.opt.colorcolumn = "80"     -- 显示80列标记线 (便于代码风格控制)

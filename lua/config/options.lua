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

-- 字体设置 - 使用Hack Nerd Font
vim.cmd [[
  if has('gui_running')
    if has('win32')
      set guifont=Hack\ Nerd\ Font:h12  " Windows环境
    else
      set guifont=Hack\ Nerd\ Font\ 12  " Linux/macOS环境
    endif
  endif
]]

-- 确保正确的字符编码设置
vim.opt.fileencodings = { 'utf-8', 'gbk', 'gb2312', 'cp936' }

-- 更安全的设置，确保在保存文件时不会损坏中文字符
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

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

-- 保留一些必要的自动命令，避免与autocmds.lua冲突
-- 为文档类型启用自动换行（不在autocmds.lua中）
vim.api.nvim_create_autocmd({
  "FileType",
}, {
  desc = "为文档类型启用自动换行",
  pattern = {
    "markdown",
    "text",
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 0
  end,
})

-- 保存文件前自动删除尾随空格（不在autocmds.lua中）
vim.api.nvim_create_autocmd({
  "BufWritePre",
}, {
  desc = "保存文件前自动删除尾随空格",
  callback = function()
    -- 使用pcall确保安全执行
    pcall(function()
      vim.cmd("silent! %s/\\s\\+$//e")
      -- 保存光标位置
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd("silent! %s/\\r$//e")
      -- 恢复光标位置
      vim.api.nvim_win_set_cursor(0, pos)
    end)
  end,
})

-- 确保vim.notify可用
if not vim.notify then
  -- 简单的通知回退函数
  vim.notify = function(msg, level)
    level = level or vim.log.levels.INFO
    local level_str = "INFO"
    if level == vim.log.levels.WARN then
      level_str = "WARN"
    elseif level == vim.log.levels.ERROR then
      level_str = "ERROR"
    end
    vim.cmd(string.format("echom '[%s] %s'", level_str, msg))
  end
end

-- 定义全局函数，确保它们可以在整个配置中访问
_G.toggle_line_numbers = function()
  if vim.opt.relativenumber:get() then
    vim.opt.relativenumber = false
    vim.opt.number = true
  else
    vim.opt.relativenumber = true
  end
end

_G.toggle_transparency = function()
  if vim.opt.winblend:get() == 0 then
    vim.opt.winblend = 10
    vim.opt.pumblend = 10
    vim.notify("透明度已开启", vim.log.levels.INFO)
  else
    vim.opt.winblend = 0
    vim.opt.pumblend = 0
    vim.notify("透明度已关闭", vim.log.levels.INFO)
  end
end

_G.toggle_spell_check = function()
  if vim.opt.spell:get() then
    vim.opt.spell = false
    vim.notify("拼写检查已关闭", vim.log.levels.INFO)
  else
    vim.opt.spell = true
    vim.opt.spelllang = { "en_us", "cjk" }
    vim.notify("拼写检查已开启", vim.log.levels.INFO)
  end
end

_G.format_buffer = function()
  local filetype = vim.bo.filetype
  local supported_formats = {
    "lua",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "html",
    "css",
    "json",
    "python",
    "cpp",
    "c",
    "rust",
  }
  
  -- 检查文件类型是否支持格式化
  for _, ft in ipairs(supported_formats) do
    if filetype == ft then
      -- 尝试使用LSP格式化
      local success, err = pcall(function()
        vim.lsp.buf.format({ async = true })
        vim.notify("正在格式化文件...", vim.log.levels.INFO)
      end)
      if not success then
        -- 如果LSP格式化失败，尝试使用内置格式化
        vim.cmd("normal! gg=G")
        vim.notify("LSP格式化失败，使用内置格式化", vim.log.levels.WARN)
      end
      return
    end
  end
  
  -- 如果不支持LSP格式化，尝试使用内置格式化
  vim.cmd("normal! gg=G")
  vim.notify("使用内置格式化", vim.log.levels.INFO)
end

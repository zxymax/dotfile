-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- 创建自定义自动命令组
local augroup = vim.api.nvim_create_augroup("CustomAutoCmds", { clear = true })

-- 为不同语言设置特定的缩进
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp", "rust", "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- 为前端文件设置特定的缩进
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "json", "jsonc" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- 为配置文件设置特定的缩进
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "lua", "vim", "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- 自动保存
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup,
  pattern = { "*" },
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- 进入缓冲区时跳转到上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = { "*" },
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, "\"")
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 高亮选中区域
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

-- 自动关闭 NvimTree 当只剩 NvimTree 一个窗口时
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd("quit")
    end
  end,
})

-- 自动格式化 - 使用更安全的检查方式
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = { "*.c", "*.cpp", "*.rs", "*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.lua", "*.vim" },
  callback = function()
    -- 使用pcall来安全地尝试格式化，避免因LSP不可用而导致错误
    local success, err = pcall(function()
      local clients = vim.lsp.get_active_clients({ buffer = 0 })
      if #clients > 0 then
        vim.lsp.buf.format({ async = false })
      end
    end)
    if not success and err then
      -- 静默失败，不影响保存
    end
  end,
})

-- 为不同文件类型设置不同的注释字符串
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp", "rust", "go", "javascript", "typescript", "javascriptreact", "typescriptreact", "lua", "vim" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "shell", "python", "ruby", "perl", "php" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "html", "xml", "css", "scss" },
  callback = function()
    vim.bo.commentstring = "<!-- %s -->"
  end,
})

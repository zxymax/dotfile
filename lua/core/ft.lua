-- 文件类型映射模块
-- 提供文件类型到语言的映射功能，避免全局污染

local M = {}

-- 文件类型到语言的映射表
local ft_to_lang_map = {
  javascriptreact = "tsx",
  typescriptreact = "tsx",
  html = "html",
  css = "css",
  json = "json",
  jsonc = "jsonc",
  lua = "lua",
  vim = "vim",
  c = "c",
  cpp = "cpp",
  rust = "rust",
  -- 可以根据需要扩展更多映射
}

-- 获取文件类型对应的语言
-- @param filetype 文件类型
-- @return string 对应的语言名称，如果没有映射则返回原始文件类型
M.ft_to_lang = function(filetype)
  return ft_to_lang_map[filetype] or filetype
end

-- 注册新的文件类型映射
-- @param ft 文件类型
-- @param lang 对应的语言名称
M.register_mapping = function(ft, lang)
  ft_to_lang_map[ft] = lang
end

-- 获取所有当前的映射
-- @return table 当前的文件类型映射表
M.get_mappings = function()
  -- 返回副本避免修改原始表
  local result = {}
  for k, v in pairs(ft_to_lang_map) do
    result[k] = v
  end
  return result
end

-- 应用映射到treesitter解析器
-- 这将检查nvim-treesitter.parsers是否存在并设置其ft_to_lang函数
M.apply_to_treesitter = function()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok and parsers then
    -- 如果parsers没有ft_to_lang函数，设置它
    if not parsers.ft_to_lang then
      parsers.ft_to_lang = M.ft_to_lang
    end
  end
end

return M
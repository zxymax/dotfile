-- 测试脚本：逐个加载插件配置文件，查找问题源
local plugin_dir = "c:\\Users\\ADMIN\\AppData\\Local\\nvim\\lua\\plugins"

local function load_file(file_path)
  local status, result = pcall(dofile, file_path)
  if not status then
    print("错误加载 ", file_path, ": ", result)
    return false
  end
  if type(result) ~= "table" and result ~= nil then
    print("警告：", file_path, " 返回非表类型: ", type(result))
    if type(result) == "function" then
      print("  这是一个函数")
    elseif type(result) == "table" then
      print("  表内容:", vim.inspect(result))
    end
  end
  return true
end

-- 测试加载helpers模块
print("\n测试加载helpers模块:")
local helpers = require("plugins.helpers")
print("helpers模块类型:", type(helpers))
print("helpers.texts存在:", helpers.texts ~= nil)

-- 测试加载plugins目录下的所有.lua文件
print("\n测试加载plugins目录下的文件:")
local files = {"comment.lua", "completion.lua", "dashboard.lua", "file_explorer.lua", "git.lua", "init.lua", "lsp.lua", "noice.lua", "performance.lua", "statusline.lua", "telescope.lua", "terminal.lua", "theme.lua", "treesitter.lua", "whichkey.lua"}

for _, file in ipairs(files) do
  local file_path = plugin_dir .. "\\" .. file
  print("\n加载 ", file, "...")
  load_file(file_path)
end

-- 测试加载lang目录下的文件
print("\n测试加载lang目录下的文件:")
local lang_files = {"cpp.lua", "dap.lua", "init.lua", "rust.lua"}
local lang_dir = plugin_dir .. "\\lang"

for _, file in ipairs(lang_files) do
  local file_path = lang_dir .. "\\" .. file
  print("\n加载 ", file, "...")
  load_file(file_path)
end

print("\n测试完成")
-- 模块化插件配置管理
-- 此文件作为插件配置的主入口，通过import导入各个功能模块

return {
  -- 导入LazyVim插件
  { import = "lazyvim.plugins" },
  -- 导入/覆盖自定义插件
  { import = "plugins.theme" },
  { import = "plugins.comment" },
  { import = "plugins.treesitter" },
  { import = "plugins.whichkey" },
  { import = "plugins.noice" },
  { import = "plugins.lsp" },
  { import = "plugins.statusline" },
  { import = "plugins.performance" },
  { import = "plugins.terminal" },
  { import = "plugins.file_explorer" },
  { import = "plugins.completion" },
  { import = "plugins.git" },
  { import = "plugins.dashboard" },
  { import = "plugins.telescope" },
}
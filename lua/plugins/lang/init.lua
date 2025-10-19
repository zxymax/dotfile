-- 语言配置模块入口
-- 此文件确保正确导入lang目录下的所有配置文件

return {
  -- 导入C++语言支持
  { import = "plugins.lang.cpp" },
  
  -- 导入调试器支持
  { import = "plugins.lang.dap" },
  
  -- 导入Rust语言支持
  { import = "plugins.lang.rust" },
}
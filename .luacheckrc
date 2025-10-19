-- Luacheck 配置文件
-- 用于Neovim配置的静态代码检查

-- 忽略的文件和目录
exclude_files = {
  ".git/",
  "__pycache__/",
  "build/",
  "dist/",
  "node_modules/",
  ".DS_Store",
  "*.swp",
  "*.swo",
  "*.log",
  "*.tmp",
  "*.temp",
  "*.bak",
  ".env",
  ".venv",
  "lazy-lock.json",  -- 插件锁定文件
  "**/packer_compiled.lua",  -- Packer编译文件
  "**/plugin/packer_compiled.lua",  -- 插件目录中的编译文件
}

-- 全局变量定义
globals = {
  -- Neovim全局API
  "vim",
  "vim.cmd",
  "vim.fn",
  "vim.api",
  "vim.loop",
  "vim.lsp",
  "vim.diagnostic",
  "vim.keymap",
  "vim.g",
  "vim.o",
  "vim.bo",
  "vim.wo",
  "vim.opt",
  "vim.env",
  "jit",
  
  -- 插件管理器全局变量
  "use",
  "packer",
  "lazy",
  "packer_plugins",
  
  -- 自定义全局辅助函数
  "P",  -- 调试打印函数
  "R",  -- 重新加载模块函数
  
  -- 标准库已在Lua中预定义，无需在此列出
  "getmetatable",
  "rawset",
  "rawget",
  "rawequal",
  "select",
  "pcall",
  "xpcall",
  "tostring",
  "tonumber",
  "ttype",
  "unpack",
}

-- 读取全局变量
read_globals = {
  -- 允许读取的标准库全局变量
  "_G",
  "_VERSION",
  "_ENV",
}

-- 模块设置
module = true
new_global = false

-- 警告设置
allow_defined_top = true
allow_defined = true

-- 错误设置
errors = {
  "undefined-global", -- 未定义的全局变量
  "redefined",       -- 重复定义
  "unused-function", -- 未使用的函数
  "unused-label",    -- 未使用的标签
  "unused-vararg",   -- 未使用的可变参数
  "trailing-space",  -- 行尾空格
  "redefined-local", -- 重复定义的局部变量
  "accessing-nonexistent-field", -- 访问不存在的字段
}

-- 警告级别
warnings = {
  "unused-local",    -- 未使用的局部变量
  "unused-argument", -- 未使用的参数
  "unused-value",    -- 未使用的值
  "empty-block",     -- 空代码块
  "redefined-global", -- 重复定义的全局变量
  "self-assigned-global", -- 自赋值的全局变量
  "self-assigned-local", -- 自赋值的局部变量
  "unreachable-code", -- 不可达代码
  "no-early-return",  -- 无早期返回
  "duplicate-table-keys", -- 重复的表键
  "ambiguity",       -- 语法歧义
}

-- 忽略特定警告
ignore = {
  "111",  -- 未使用的局部变量
  "212",  -- 未使用的参数
}

-- 针对Neovim的特殊设置
-- 允许在插件配置中使用特定模式
max_line_length = 120
indentation = 2

-- 性能相关检查
enable_performance_warnings = true

-- 标准库版本
std = "lua51c"

-- 文件特定的配置覆盖
files = {
  ["**.lua"] = {
    -- 基本的Lua文件检查
    allow_defined_top = true,
    read_globals = {"vim"},
  },
  
  ["lua/plugins/**/*.lua"] = {
    -- 插件配置文件可以有更宽松的规则
    ignore = {
      "unused_args",
      "unused_local",
      "212",  -- 忽略未使用的标签
    },
  },
  
  ["lua/core/utils.lua"] = {
    -- 核心工具文件应该更加严格
    strict = true,
    ignore = {},
  },
}

-- 启用扩展检查
enable = {
  "strong",  -- 更严格的类型检查
  "unused",  -- 未使用的变量和参数检查
  "access",  -- 未定义变量访问检查
}
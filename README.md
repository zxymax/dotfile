# Neovim 配置说明

本配置专为 **Rust、C++ 和前端(TypeScript)** 开发者设计，基于 **LazyVim** 构建，采用模块化管理方式，具有良好的扩展性。当前配置已在 Windows 环境下测试通过，可以完美运行。

## 目录结构

```
nvim/
├── init.lua                  # 主入口文件
├── lua/
│   ├── config/               # 配置文件目录
│   │   ├── lazy.lua          # 插件管理器配置
│   │   ├── options.lua       # 编辑器选项配置
│   │   ├── keymaps.lua       # 快捷键导入
│   │   ├── keybindings.lua   # 快捷键定义
│   │   └── autocmds.lua      # 自动命令
│   └── plugins/              # 插件配置目录
│       ├── init.lua          # 通用插件配置
│       └── lang/             # 语言特定插件配置
│           ├── rust.lua      # Rust 插件配置
│           ├── cpp.lua       # C++ 插件配置
│           └── frontend.lua  # 前端插件配置
```

## 功能特点

- 🛠️ **完整的开发环境**：为前端、C++ 和 Rust 提供专业开发支持
- 🚀 **高效快捷键**：精心设计的快捷键系统，提升开发效率
- 📦 **插件管理**：使用 LazyVim 管理插件，自动加载和更新
- 🌈 **美观界面**：现代化的 UI 设计，支持多种主题
- 🔍 **智能搜索**：集成 Telescope，提供强大的搜索功能
- 🧩 **代码智能**：支持语法高亮、自动补全、代码跳转等功能

## 安装要求

- **Neovim**：版本 0.8 或更高
- **Windows**：当前仅在 Windows 环境下测试通过
- **Git**：用于插件安装和更新
- **Node.js**：用于部分前端开发功能
- **相关语言工具链**：Rust、C++ 和 TypeScript 的编译器和工具

## 安装方法

1. 确保已安装 Neovim 0.8+ 和 Git
2. 克隆此仓库到你的 Neovim 配置目录：

```bash
git clone https://github.com/zxymax/dotfile.git $env:LOCALAPPDATA\nvim
```

3. 启动 Neovim，插件将自动安装：

```bash
nvim
```

## 插件说明

### 通用插件

- **nvim-tree/nvim-tree.lua** - 文件浏览器
- **nvim-lualine/lualine.nvim** - 状态栏
- **hrsh7th/nvim-cmp** - 自动补全
- **numToStr/Comment.nvim** - 代码注释
- **mg979/vim-visual-multi** - 多光标编辑

### Rust 插件

- **simrat39/rust-tools.nvim** - Rust 增强工具
- **saecki/crates.nvim** - Cargo 依赖管理

### C++ 插件

- **p00f/clangd_extensions.nvim** - Clangd 增强功能
- **mfussenegger/nvim-dap** - 调试支持
- **rcarriga/nvim-dap-ui** - 调试可视化界面

### 前端插件

- **jose-elias-alvarez/typescript.nvim** - TypeScript 增强功能
- **conform.nvim** - 代码格式化工具
- **windwp/nvim-ts-autotag** - 自动闭合标签
- **norcalli/nvim-colorizer.lua** - CSS 颜色高亮

## 快捷键说明

### 通用快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>w` | 保存文件 |
| `<leader>q` | 退出 |
| `<leader>Q` | 强制退出 |
| `<leader>x` | 保存并退出 |
| `<leader>nh` | 清除搜索高亮 |
| `<leader>e` | 切换文件浏览器 |
| `<leader>sv` | 垂直分割窗口 |
| `<leader>sh` | 水平分割窗口 |
| `<leader>se` | 使窗口大小相等 |
| `<leader>sx` | 关闭当前窗口 |
| `<leader>sm` | 最大化窗口 |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全局搜索 |
| `<leader>fb` | 查找缓冲区 |
| `<leader>fh` | 查找帮助文档 |
| `<leader>\` | 切换终端 |
| `<leader>td` | 查看 Telescope 插件状态和可用命令 |
| `gcc` | 注释当前行 |
| `gc` (可视模式) | 注释选中区域 |

### LSP 相关快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>gD` | 跳转到声明 |
| `<leader>gd` | 跳转到定义 |
| `<leader>gi` | 跳转到实现 |
| `<leader>gr` | 查找引用 |
| `<leader>K` | 显示文档 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作 |
| `<leader>f` | 格式化代码 |
| `<leader>d` | 显示诊断 |
| `[d` | 上一个诊断 |
| `]d` | 下一个诊断 |

### Rust 特定快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>ca` | 代码操作 |
| `<leader>ce` | 展开宏 |
| `<leader>cr` | 运行测试 |
| `<leader>cd` | 调试 |
| `<leader>ct` | 切换crates.nvim |
| `<leader>cv` | 显示版本 |
| `<leader>cf` | 显示特性 |
| `<leader>ci` | 安装版本 |
| `<leader>cu` | 更新单个crate |
| `<leader>ca` | 更新所有crate |

### C++ 特定快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>ch` | 代码操作 |
| `<leader>cm` | 内存使用 |
| `<leader>cs` | 签名帮助 |
| `<F5>` | 开始/继续调试 |
| `<F10>` | 单步跳过 |
| `<F11>` | 单步进入 |
| `<F12>` | 单步退出 |
| `<leader>b` | 切换断点 |

### 前端特定快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>to` | 组织导入 |
| `<leader>tr` | 重命名文件 |
| `<leader>ta` | 添加缺失导入 |
| `<leader>tf` | 修复所有问题 |
| `<leader>ti` | 移除未使用代码 |

## 使用说明

1. 启动 Neovim，第一次启动会自动安装所有插件
2. 等待插件安装完成后，您可以开始使用配置好的开发环境
3. 根据您的需求，可以在 `lua/plugins/` 目录下添加或修改插件配置
4. 所有的快捷键都集中在 `lua/config/keybindings.lua` 中管理

## 自定义配置

### 添加新插件

要添加新的通用插件，请编辑 `lua/plugins/init.lua` 文件。

要添加特定语言的插件，请在 `lua/plugins/lang/` 目录下创建相应的配置文件。

### 修改快捷键

所有的快捷键都集中在 `lua/config/keybindings.lua` 文件中，您可以根据需要修改或添加新的快捷键。

### 修改编辑器选项

编辑器的基础选项配置在 `lua/config/options.lua` 文件中。

### 修改自动命令

自动命令配置在 `lua/config/autocmds.lua` 文件中，包括自动保存、自动格式化等功能。

## 注意事项

1. **系统兼容性**：当前配置仅在 Windows 环境下测试通过，其他操作系统可能需要调整
2. **插件安装**：首次启动时会自动安装所有插件，请确保网络连接正常
3. **Telescope 使用**：使用 Telescope 命令时，子命令必须使用小写（例如 `:Telescope buffers`）
4. **依赖管理**：确保您的系统上已安装 Rust、C++ 和 TypeScript 的相关工具链
5. **C++ 调试**：对于 C++ 调试功能，需要安装 lldb-vscode
6. **性能优化**：配置已针对性能进行了优化，但仍建议使用较新的硬件以获得最佳体验

## 常见问题解决

### Telescope 报错问题
如果遇到 "attempt to call field 'ft_to_lang' (a nil value)" 错误，配置中已包含修复方案，应该不会影响使用。

### 插件加载失败
如果某个插件加载失败，可以尝试手动执行 `:Lazy install 插件名称` 命令重新安装该插件。如果问题仍然存在，可以查看 `:Lazy log` 命令输出的日志信息。

### 键盘映射冲突
如果发现快捷键冲突，可以修改 `lua/config/keybindings.lua` 文件中的映射。

## 更新配置

要更新配置，请运行以下命令：

```bash
cd $env:LOCALAPPDATA\nvim
git pull
```

然后重启 Neovim 以应用更新。

## License

MIT License

---

如果您有任何问题或建议，欢迎在 GitHub 仓库提交 Issue 或 Pull Request！

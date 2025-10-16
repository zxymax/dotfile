# Neovim 配置文件

这是一个基于 LazyVim 的现代化 Neovim 配置，提供了优雅的界面、强大的代码编辑功能和完善的插件生态系统。

## 特性

- **现代化界面**：使用 Gruvbox 主题，搭配 Nerd Font 图标，提供优雅的视觉体验
- **增强的状态栏**：功能丰富的 lualine.nvim 配置，显示模式、分支、文件路径、LSP状态和诊断信息
- **终端集成**：使用 Windows Terminal 模拟 tmux 功能，提供标签页管理和窗格分割
- **智能通知系统**：通过 noice.nvim 和 nvim-notify 提供优雅的通知和命令行体验
- **高级语法高亮**：通过增强的 nvim-treesitter 配置，支持多种编程语言和文本对象操作
- **自定义欢迎界面**：功能丰富的 dashboard，提供快速访问最近文件、项目和常用操作
- **平滑滚动体验**：使用 neoscroll.nvim 提供流畅的滚动效果
- **C++ 开发支持**：集成 clangd、CMake 工具和 codelldb 调试器（已修复路径配置）
- **Rust 开发支持**：集成 rust-analyzer、rust-tools 和 Crates.io 依赖管理
- **强大的调试系统**：基于 nvim-dap、dap-ui 和虚拟文本的现代化调试体验
- **Git 集成**：集成 gitsigns.nvim、vim-fugitive 和 git-conflict.nvim，提供完整的 Git 工作流支持
- **模糊查找**：集成 Telescope.nvim 实现快速文件和内容搜索
- **自动补全**：增强的 nvim-cmp 配置提供智能代码补全
- **代码注释**：使用 Comment.nvim 实现快速代码注释
- **多光标编辑**：支持 vim-visual-multi 进行高效的多位置编辑
- **终端集成**：使用 toggleterm.nvim 在编辑器内运行终端

## 快捷键说明

### 基本快捷键

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>w` | 保存文件 |
| `<C-s>` | 保存当前文件 |
| `<leader>q` | 退出 |
| `<C-q>` | 关闭当前文件 |
| `<leader>Q` | 强制退出 |
| `<leader>x` | 保存并退出 |
| `<leader>nh` | 清除搜索高亮 |
| `<leader>e` | 打开文件浏览器(nvim-tree) |
| `<C-n>` | 打开/关闭文件树 |
| `<leader>/` | 切换注释 (normal/visual模式) |
| `L` | 移动到行尾 |
| `H` | 移动到行头 |
| `jk` (插入模式) | 退出插入模式 |

### 窗口管理

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>sv` | 垂直分割窗口 |
| `<leader>sh` | 水平分割窗口 |
| `<leader>se` | 使窗口大小相等 |
| `<leader>sx` | 关闭当前窗口 |
| `<leader>sm` | 最大化窗口 |
| `<leader>w` | 窗口分割 (垂直) |
| `<leader>W` | 窗口分割 (水平) |
| `<leader>` + `<方向键>` | 窗口导航 |
| `<C-h>` | 向左窗口移动 |
| `<C-j>` | 向下窗口移动 |
| `<C-k>` | 向上窗口移动 |
| `<C-l>` | 向右窗口移动 |

### 标签页管理

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>to` | 创建新标签页 |
| `<leader>tx` | 关闭当前标签页 |
| `<leader>tn` | 下一个标签页 |
| `<leader>tp` | 上一个标签页 |
| `<leader>1`-`<leader>5` | 快速切换到对应标签页 |
| `<leader>1` 到 `<leader>9` | 跳转到对应标签页 |
| `<A-1>` 到 `<A-9>` | 跳转到对应标签页 |

### 查找功能

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>ff` | 查找文件 |
| `<C-f>` | 打开搜索文件面板 |
| `<leader>fg` | 全局搜索 |
| `<leader>fb` | 查找缓冲区 |
| `<leader>fc` | 查找命令历史 |
| `<leader>ft` | 查找标签页 |
| `<leader>fr` | 查找最近文件 |
| `<leader>fh` | 查找帮助 |
| `<leader>td` | 查看telescope调试信息 |

### 代码导航

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>gD` | 跳转到声明 |
| `<leader>gd` | 跳转到定义 |
| `<leader>gi` | 跳转到实现 |
| `<leader>gr` | 查找引用 |
| `<leader>K` | 显示文档 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作 |
| `<leader>f` | 格式化代码 |

### 诊断功能

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>d` | 显示诊断 |
| `[d` | 上一个诊断 |
| `]d` | 下一个诊断 |
| `<leader>dl` | 设置诊断位置列表 |

### C++ 开发功能

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>ci` | 切换源文件/头文件 |
| `<leader>cm` | 生成 CMake 项目 |
| `<leader>cb` | 构建 CMake 项目 |
| `<leader>cr` | 运行 CMake 项目 |
| `<leader>cd` | 调试 CMake 项目 |
| `<leader>cs` | 选择构建类型 |

### Rust 开发功能

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>ct` | 切换依赖显示 |
| `<leader>cr` | 重新加载依赖 |
| `<leader>cv` | 显示版本信息 |
| `<leader>cf` | 显示特性列表 |
| `<leader>cd` | 显示依赖树 |

### 调试功能

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>db` | 切换断点 |
| `<leader>dB` | 设置条件断点 |
| `<leader>dc` | 继续执行 |
| `<leader>ds` | 单步跳过 |
| `<leader>di` | 单步进入 |
| `<leader>do` | 单步退出 |
| `<leader>dr` | 打开 REPL |
| `<leader>dl` | 运行上次配置 |
| `<leader>dq` | 终止调试 |
| `<leader>dd` | 断开连接 |
| `<leader>dh` | 悬停查看变量 |
| `<leader>dp` | 预览变量 |
| `<leader>du` | 切换调试 UI |
| `<leader>de` | 评估表达式 |

### 终端快捷键

| 快捷键 | 功能描述 |
|-------|--------|
| `<C-\>` | 切换终端 |
| `<C-t>` | 打开/关闭终端 |
| `<Esc>` (终端模式) | 退出终端模式 |
| `jk` (终端模式) | 退出终端模式 |
| `<A-j>` | 向下滚动终端 |
| `<A-k>` | 向上滚动终端 |
| `<C-h>` (终端模式) | 终端模式下向左窗口移动 |
| `<C-j>` (终端模式) | 终端模式下向下窗口移动 |
| `<C-k>` (终端模式) | 终端模式下向上窗口移动 |
| `<C-l>` (终端模式) | 终端模式下向右窗口移动 |

### Dashboard 欢迎界面

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>dd` | 显示欢迎界面 |
| `<leader>u` | 更新插件 |
| `<leader>di` | 新建文件 |
| `<leader>dr` | 查找最近文件 |
| `<leader>dp` | 查找项目 |
| `<leader>dh` | 查找历史 |
| `<leader>tn` | 切换行号显示模式 |
| `<leader>tt` | 切换背景透明度 |
| `<leader>ts` | 切换拼写检查 |

### 导航增强

| 快捷键 | 功能描述 |
|-------|--------|
| `<C-d>` | 向下滚动半屏并居中 |
| `<C-u>` | 向上滚动半屏并居中 |
| `n` | 搜索下一个并居中 |
| `N` | 搜索上一个并居中 |
| `<leader>f` | 格式化当前文件 |

## Windows Terminal 替代 tmux 功能

由于在Windows上安装tmux需要管理员权限（通过WSL），我们使用Windows Terminal来模拟tmux的核心功能：

### 核心功能对比

| 功能 | tmux | Windows Terminal |
|------|------|-----------------|
| 新建会话 | `tmux new` | `Ctrl + Shift + T` (标签页) |
| 分割窗格 | `Ctrl+b %` (垂直), `Ctrl+b "` (水平) | `Alt + Shift + +` (垂直), `Alt + Shift + -` (水平) |
| 切换窗格 | `Ctrl+b 方向键` | `Alt + 方向键` |
| 关闭窗格 | `Ctrl+b x` | `Ctrl + Shift + W` |

详细配置请查看项目中的 `WINDOWS_TERMINAL_CONFIG.md` 文件。

## 近期更新

### 2024 年更新内容
- 主题从 TokyoNight 切换到 Gruvbox，提供更好的视觉体验
- 添加 Git 插件集成，包括 gitsigns.nvim、vim-fugitive 和 git-conflict.nvim
- 修复 codelldb 调试器路径配置问题
- 禁用不必要的 luarocks 支持以避免配置错误
- 优化 which-key 配置，提供更好的快捷键提示

## 安装要求

- Neovim 0.9 或更高版本
- Git
- Node.js (用于某些 LSP 和插件)
- 安装 [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) 或其他 Nerd Font（确保终端配置了该字体）

## 安装方法

1. 备份您现有的 Neovim 配置（如果有）：

```bash
# Windows
bak %USERPROFILE%\AppData\Local\nvim %USERPROFILE%\AppData\Local\nvim.bak

# Linux/MacOS
mv ~/.config/nvim ~/.config/nvim.bak
```

2. 克隆本仓库：

```bash
# Windows
git clone https://github.com/zxymax/dotfile.git %USERPROFILE%\AppData\Local\nvim

# Linux/MacOS
git clone https://github.com/zxymax/dotfile.git ~/.config/nvim
```

3. 启动 Neovim，插件将自动安装：

```bash
nvim
```

首次启动时，Lazy.nvim 插件管理器会自动下载并安装所有配置的插件。这个过程可能需要几分钟时间，取决于您的网络连接速度。

4. 安装 treesitter 解析器：

在 Neovim 中执行：

```vim
:TSUpdate
```

## 主要配置文件说明

- `init.lua`：主入口文件
- `lua/config/`：核心配置目录
  - `lazy.lua`：Lazy.nvim 插件管理器配置
  - `options.lua`：基本设置（字体、缩进、搜索等）
  - `keybindings.lua`：快捷键配置
  - `autocmds.lua`：自动命令配置
- `lua/plugins/`：插件配置目录
  - `init.lua`：插件配置主文件

## 使用指南

### 基本快捷键

- `<Leader>e`：打开/关闭文件浏览器
- `<Leader>ff`：查找文件
- `<Leader>fg`：全局搜索
- `<Leader>b`：切换缓冲区
- `<Leader>/`：注释当前行或选中代码
- `Ctrl+\`：打开/关闭终端
- `Alt+j/k/l/h`：在窗口间导航
- `u`（在欢迎界面）：更新插件
- `f`（在欢迎界面）：查找文件

### 终端快捷键

- `Esc` 或 `jk`：从终端模式返回普通模式
- `Ctrl+h/j/k/l`：在终端和其他窗口之间导航

### 文件浏览器 (nvim-tree)

- `a`：新建文件/目录
- `d`：删除文件/目录
- `r`：重命名
- `x`：剪切
- `c`：复制
- `p`：粘贴
- `g?`：帮助

### Telescope 模糊查找

- `<Leader>ff`：查找文件
- `<Leader>fg`：全局搜索（grep）
- `<Leader>fb`：查找缓冲区
- `<Leader>fh`：查找帮助文档
- `<Leader>fr`：查找最近使用的文件

### 终端集成 (toggleterm)

- `Ctrl+\`：打开/关闭终端
- 在终端模式下，按 `Esc` 或 `Ctrl+\` 可以返回普通模式
- 在终端模式下，按 `Ctrl+h/j/k/l` 可以在窗口间导航

## 自定义配置

### 添加新插件

在 `lua/plugins/init.lua` 文件中添加新的插件配置：

```lua
return {
  -- 现有插件配置...
  
  -- 新插件
  {
    "author/plugin-name",
    config = function()
      -- 插件配置
    end,
  },
}
```

### 修改主题

当前使用的是 Gruvbox 主题，可在 `lua/plugins/init.lua` 中修改主题配置：

```lua
return {
  { 
    "ellisonleao/gruvbox.nvim", 
    lazy = false, 
    priority = 1000, 
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = { 
        strings = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "soft",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },
}
```

## 故障排除

### 插件安装失败

如果插件安装失败，可以尝试以下步骤：

1. 检查网络连接
2. 在 Neovim 中运行 `:Lazy clean` 清理失败的插件
3. 运行 `:Lazy install` 重新安装插件
4. 如果特定插件仍然失败，可以在 `lua/config/lazy.lua` 中临时禁用该插件进行测试

### Treesitter 解析器问题

如果语法高亮不工作，可以运行：

```vim
:TSUpdate
:TSInstall <language>
```

### 字体图标显示问题

确保：
1. 已安装 Nerd Font
2. 终端已配置使用 Nerd Font
3. 可以在 `lua/config/options.lua` 中修改字体设置

### C++ 调试问题

如果遇到 codelldb 调试器问题：
1. 确保已通过 mason 安装了 codelldb
2. 检查 `lua/plugins/lang/cpp.lua` 中的路径配置是否正确
3. 可以使用 `:checkhealth` 命令检查配置状态

## 更新配置

从 GitHub 拉取最新配置：

```bash
# Windows
cd %USERPROFILE%\AppData\Local\nvim
git pull

# Linux/MacOS
cd ~/.config/nvim
git pull
```

然后重启 Neovim，运行 `:Lazy update` 更新所有插件。

## Git 插件功能

本配置集成了三个主要的 Git 插件：

### gitsigns.nvim
- 提供行内 Git 标记，显示修改、添加和删除
- 支持代码块操作：暂存、重置、预览等
- 快捷键：`<leader>h` 系列命令

### blamer.nvim (类似GitLens功能)
- 在代码行旁边显示Git提交信息（作者、时间、提交信息）
- 支持鼠标悬停显示详细信息
- 快捷键：`<leader>gb` 切换GitLens注释显示

### vim-fugitive
- 全面的 Git 命令集成
- 可通过 `:Git` 命令访问所有 Git 功能

### git-conflict.nvim
- 可视化解决 Git 冲突
- 快捷键：`<leader>gc` 系列命令

## 调试功能

### C++ 调试配置
- 使用 codelldb 适配器进行调试
- 支持启动可执行文件和附加到进程两种模式
- 已修复路径配置问题，确保正常工作

## 许可证

[MIT License](LICENSE)

## 致谢

- 本配置基于 [LazyVim](https://github.com/LazyVim/LazyVim) 构建
- 感谢所有插件作者的出色工作
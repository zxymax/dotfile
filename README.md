# Neovim 配置文件

这是一个基于 LazyVim 的现代化 Neovim 配置，提供了优雅的界面、强大的代码编辑功能和完善的插件生态系统。

## 特性

- **现代化界面**：使用 TokyoNight 主题，搭配 Nerd Font 图标
- **漂亮的状态栏**：增强的 lualine.nvim 配置，借鉴 craftzdog 风格，显示更多信息和更好的视觉效果
- **终端集成**：使用 Windows Terminal 模拟 tmux 功能，提供标签页管理和窗格分割

## 快捷键说明

### 基本快捷键

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>w` | 保存文件 |
| `<leader>q` | 退出 |
| `<leader>Q` | 强制退出 |
| `<leader>x` | 保存并退出 |
| `<leader>nh` | 清除搜索高亮 |
| `<leader>e` | 打开文件浏览器(nvim-tree) |
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

### 查找功能

| 快捷键 | 功能描述 |
|-------|--------|
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全局搜索 |
| `<leader>fb` | 查找缓冲区 |
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

### 终端快捷键

| 快捷键 | 功能描述 |
|-------|--------|
| `<C-\>` | 切换终端 |
| `<Esc>` (终端模式) | 退出终端模式 |
| `jk` (终端模式) | 退出终端模式 |
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

### 导航增强

| 快捷键 | 功能描述 |
|-------|--------|
| `<C-d>` | 向下滚动半屏并居中 |
| `<C-u>` | 向上滚动半屏并居中 |
| `n` | 搜索下一个并居中 |
| `N` | 搜索上一个并居中 |

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
- **欢迎界面**：集成 dashboard-nvim，提供项目和最近文件快速访问
- **平滑滚动**：使用 neoscroll.nvim 提供流畅的页面滚动体验
- **增强的终端**：改进的 toggleterm.nvim 配置，支持更好的窗口导航和视觉效果
- **智能代码编辑**：基于 nvim-treesitter 的语法高亮和代码解析
- **文件浏览**：使用 nvim-tree.lua 提供直观的文件管理
- **模糊查找**：集成 Telescope.nvim 实现快速文件和内容搜索
- **自动补全**：增强的 nvim-cmp 配置提供智能代码补全
- **代码注释**：使用 Comment.nvim 实现快速代码注释
- **多光标编辑**：支持 vim-visual-multi 进行高效的多位置编辑
- **终端集成**：使用 toggleterm.nvim 在编辑器内运行终端

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

在 `lua/plugins/init.lua` 中修改主题配置：

```lua
return {
  { "folke/tokyonight.nvim", priority = 1000, opts = { style = "moon" } },
}
```

将 `style` 改为以下选项之一：`storm`, `moon`, `night`, `day`

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

## 更新配置

从 GitHub 拉取最新配置：

```bash
# 在配置目录中执行
git pull
```

然后重启 Neovim，运行 `:Lazy update` 更新所有插件。

## 许可证

[MIT License](LICENSE)

## 致谢

- 本配置基于 [LazyVim](https://github.com/LazyVim/LazyVim) 构建
- 感谢所有插件作者的出色工作
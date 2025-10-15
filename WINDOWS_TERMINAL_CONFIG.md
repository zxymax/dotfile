# Windows Terminal 模拟 tmux 配置指南

由于在Windows上安装tmux需要管理员权限（通过WSL），我们可以使用Windows Terminal来模拟tmux的核心功能，同时优化Neovim的终端体验。

## Windows Terminal 核心功能

### 1. 标签页管理（替代tmux会话）
- **新建标签页**: `Ctrl + Shift + T`
- **关闭标签页**: `Ctrl + Shift + W`
- **切换标签页**: `Ctrl + Tab` 或 `Ctrl + 数字键`

### 2. 分割窗格（替代tmux窗格）
- **垂直分割**: `Alt + Shift + +`
- **水平分割**: `Alt + Shift + -`
- **关闭窗格**: `Ctrl + Shift + W`
- **切换窗格**: `Alt + 方向键`

### 3. 滚动与复制
- **启用复制模式**: `Shift + F10` 或右键点击
- **选择文本**: 按住Shift键并用鼠标选择
- **复制选中内容**: `Ctrl + C`
- **粘贴**: `Ctrl + V`

## 增强Neovim与Windows Terminal的集成

在Neovim中，我们已经配置了toggleterm.nvim插件，可以提供更好的终端集成体验。

### ToggleTerm 使用指南

- **打开终端**: `:ToggleTerm`
- **关闭终端**: 在终端模式下按 `Esc` 或 `jk`
- **切换到终端**: `Ctrl+\`
- **在终端中导航窗口**: `Ctrl+h/j/k/l`

## 个性化设置

### 推荐的Windows Terminal设置

1. 打开Windows Terminal设置 (Ctrl+,)
2. 调整以下设置:

```json
{
  "profiles": {
    "defaults": {
      "fontFace": "Consolas",
      "fontSize": 14,
      "colorScheme": "One Half Dark",
      "useAcrylic": true,
      "acrylicOpacity": 0.8,
      "cursorShape": "bar",
      "cursorColor": "#56e39f",
      "historySize": 9001
    }
  }
}
```

### 自定义颜色主题

在Windows Terminal设置中，你可以添加类似tokyonight的配色方案：

```json
{
  "schemes": [
    {
      "name": "Tokyo Night",
      "background": "#1a1b26",
      "foreground": "#c0caf5",
      "black": "#15161e",
      "blue": "#7aa2f7",
      "cyan": "#7dcfff",
      "green": "#9ece6a",
      "purple": "#bb9af7",
      "red": "#f7768e",
      "white": "#a9b1d6",
      "yellow": "#e0af68",
      "brightBlack": "#414868",
      "brightBlue": "#7aa2f7",
      "brightCyan": "#7dcfff",
      "brightGreen": "#9ece6a",
      "brightPurple": "#bb9af7",
      "brightRed": "#f7768e",
      "brightWhite": "#c0caf5",
      "brightYellow": "#e0af68"
    }
  ]
}
```

## 最佳实践

1. 使用Windows Terminal作为主要终端
2. 利用内置的分割窗格功能管理多个终端会话
3. 使用Neovim中的toggleterm插件进行快速终端访问
4. 自定义颜色方案以匹配你的Neovim主题

这种配置可以提供接近tmux的核心功能，同时避免了在Windows上安装tmux的复杂性。
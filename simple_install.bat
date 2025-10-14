@echo off
REM 简单的批处理文件用于手动安装nvim-treesitter插件
REM 运行方法: 双击此文件或在命令提示符中执行

echo === Neovim插件安装脚本 ===
echo 此脚本将帮助您手动安装必要的插件

echo.
echo 1. 检查Git是否安装...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: Git未安装!
    echo 请先从 https://git-scm.com/download/win 下载并安装Git
    echo 安装完成后重新运行此脚本
    pause
    exit /b 1
) else (
    echo Git已安装 ✓
)

echo.
echo 2. 创建必要的目录结构...
mkdir "%LOCALAPPDATA%\nvim\data\lazy" 2>nul
if %errorlevel% equ 0 (
    echo 目录创建成功 ✓
) else (
    echo 目录已存在 ✓
)

echo.
echo 3. 安装lazy.nvim插件管理器...
if not exist "%LOCALAPPDATA%\nvim\data\lazy\lazy.nvim" (
    git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "%LOCALAPPDATA%\nvim\data\lazy\lazy.nvim"
    if %errorlevel% equ 0 (
        echo lazy.nvim安装成功 ✓
    ) else (
        echo lazy.nvim安装失败 ✗
        echo 请检查网络连接
        pause
        exit /b 1
    )
) else (
    echo lazy.nvim已安装 ✓
)

echo.
echo 4. 安装nvim-treesitter插件...
if not exist "%LOCALAPPDATA%\nvim\data\lazy\nvim-treesitter" (
    git clone https://github.com/nvim-treesitter/nvim-treesitter.git "%LOCALAPPDATA%\nvim\data\lazy\nvim-treesitter"
    if %errorlevel% equ 0 (
        echo nvim-treesitter安装成功 ✓
        mkdir "%LOCALAPPDATA%\nvim\data\lazy\nvim-treesitter\parser" 2>nul
    ) else (
        echo nvim-treesitter安装失败 ✗
        echo 请检查网络连接
        pause
        exit /b 1
    )
) else (
    echo nvim-treesitter已安装 ✓
)

echo.
echo 5. 创建修复后的配置文件...
( 
echo -- 简化的Neovim配置文件 - 修复后版本

echo -- 添加lazy.nvim到运行时路径

echo local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

echo vim.opt.rtp:prepend(lazypath)

echo -- 配置lazy.nvim

echo require("lazy").setup({

echo   {

echo     "nvim-treesitter/nvim-treesitter",

echo     build = function()

echo       pcall(vim.cmd, "TSUpdate")

echo     end,

echo     config = function()

echo       local ok, treesitter = pcall(require, "nvim-treesitter.configs")

echo       if ok then

echo         treesitter.setup({

echo           ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "rust", "typescript", "javascript", "tsx", "jsx", "html", "css", "json", "jsonc"},

echo           highlight = {

echo             enable = true,

echo           },

echo           indent = {

echo             enable = true,

echo           },

echo         })

echo         vim.notify("✅ nvim-treesitter配置成功!", vim.log.levels.INFO)

echo       else

echo         vim.notify("⚠️ 无法加载nvim-treesitter，请运行:TSUpdate", vim.log.levels.WARN)

echo       end

echo     end,

echo   },

echo })

echo -- 添加基本设置

echo vim.o.number = true

echo vim.o.relativenumber = true

echo vim.o.tabstop = 2

echo vim.o.shiftwidth = 2

echo vim.o.expandtab = true

echo vim.o.autoindent = true

echo vim.o.smartindent = true

echo vim.o.termguicolors = true

echo -- 添加一个测试命令来验证treesitter是否工作

echo vim.api.nvim_create_user_command("CheckTreesitter", function()

echo   local ok, treesitter = pcall(require, "nvim-treesitter.configs")

echo   if ok then

echo     local parsers = require("nvim-treesitter.parsers")

echo     local installed = parsers.get_installed_parsers()

echo     vim.notify("✅ nvim-treesitter加载成功!\n已安装的解析器数量: " .. #vim.tbl_keys(installed), vim.log.levels.INFO)

echo   else

echo     vim.notify("❌ nvim-treesitter加载失败: " .. tostring(treesitter), vim.log.levels.ERROR)

echo   end

echo end, {})

echo vim.notify("🎉 修复后的Neovim配置已加载!\n请运行 :CheckTreesitter 命令来验证nvim-treesitter是否工作", vim.log.levels.INFO)
) > "%LOCALAPPDATA%\nvim\init.fixed.lua"

if %errorlevel% equ 0 (
    echo 修复后的配置文件已创建 ✓
) else (
    echo 配置文件创建失败 ✗
    pause
    exit /b 1
)

echo.
echo === 安装完成! ===
echo.
echo 🎉 现在您可以使用以下方式启动Neovim:
echo   1. 使用修复后的配置: nvim -u init.fixed.lua
echo   2. 然后在Neovim中运行: :CheckTreesitter 来验证安装
echo   3. 如果成功，可以运行: :TSUpdate 来安装所有解析器

echo.
echo 📝 后续步骤:
echo   - 如果修复后的配置工作正常，您可以将其内容复制到init.lua中
echo   - 或者使用这个固定配置作为基础来重建您的原始配置
echo   - 记得删除临时文件

echo.
pause
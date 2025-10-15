-- 快捷键映射配置文件
-- 此文件用于集中管理所有快捷键映射
--
-- 快捷键前缀说明：
-- <leader> 通常映射为空格键
-- <C> 表示Ctrl键
-- <A> 表示Alt键
-- <S> 表示Shift键
--
-- 模块化管理快捷键，可以根据不同功能分组

local M = {}

-- 通用快捷键
function M.setup_general()
  local map = vim.keymap.set

  -- 基本编辑快捷键
  map("n", "<leader>w", "<cmd>w<cr>", { desc = "保存文件" })
  map("n", "<leader>q", "<cmd>q<cr>", { desc = "退出" })
  map("n", "<leader>Q", "<cmd>q!<cr>", { desc = "强制退出" })
  map("n", "<leader>x", "<cmd>x<cr>", { desc = "保存并退出" })
  map("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "清除搜索高亮" })
  map("n", "<leader>e", function()
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      api.tree.toggle()
    else
      vim.notify("nvim-tree未加载，无法打开文件浏览器", vim.log.levels.ERROR)
      -- 作为后备方案，尝试全局函数
      if _G.NvimTreeToggle then
        _G.NvimTreeToggle()
      end
    end
  end, { desc = "文件浏览器" })
  map("n", "L", "$", { desc = "移动到行尾"})
  map("n", "H", "^", { desc = "移动到行头"})
  map("i", "jk", "<ESC>", { desc = "退出插入模式"})

  -- 窗口管理
  map("n", "<leader>sv", "<C-w>v", { desc = "垂直分割窗口" })
  map("n", "<leader>sh", "<C-w>s", { desc = "水平分割窗口" })
  map("n", "<leader>se", "<C-w>=", { desc = "使窗口大小相等" })
  map("n", "<leader>sx", "<cmd>close<cr>", { desc = "关闭当前窗口" })
  map("n", "<leader>sm", "<cmd>MaximizerToggle<cr>", { desc = "最大化窗口" })

  -- 标签页管理
  map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "创建新标签页" })
  map("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "关闭当前标签页" })
  map("n", "<leader>tn", "<cmd>tabn<cr>", { desc = "下一个标签页" })
  map("n", "<leader>tp", "<cmd>tabp<cr>", { desc = "上一个标签页" })

  -- 查找 - 注意：Telescope命令中的子命令必须使用小写！
  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "查找文件" })
  map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "全局搜索" })
  map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "查找缓冲区" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "查找帮助" })
  
  -- 添加一个telescope调试命令，用于查看所有可用的telescope命令
  map("n", "<leader>td", function()
    local ok, telescope = pcall(require, "telescope")
    if ok then
      local builtin = require("telescope.builtin")
      vim.notify("✅ telescope.nvim加载正常！可用命令：find_files, buffers, live_grep, help_tags等\n注意：使用命令行时必须用小写！", vim.log.levels.INFO)
      print("\n可用的Telescope内置函数：")
      for k, v in pairs(builtin) do
        if type(v) == "function" and k ~= "builtin" then
          print("  - " .. k)
        end
      end
    else
      vim.notify("❌ telescope.nvim加载失败: " .. tostring(telescope), vim.log.levels.ERROR)
    end
  end, { desc = "查看telescope调试信息" })

  -- 代码导航
  map("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "跳转到声明" })
  map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "跳转到定义" })
  map("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "跳转到实现" })
  map("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "查找引用" })
  map("n", "<leader>K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "显示文档" })
  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "重命名" })
  map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "代码操作" })
  map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "格式化代码" })

  -- 诊断
  map("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "显示诊断" })
  map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "上一个诊断" })
  map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "下一个诊断" })
  map("n", "<leader>dl", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "设置诊断位置列表" })

  -- 终端
  map("n", [[<leader>\]], "<cmd>ToggleTerm<cr>", { desc = "切换终端" })
  map("t", "<esc>", [[<C-\><C-n>]], { desc = "退出终端模式" })

  -- 注释快捷键已在Comment.nvim插件配置中自动设置
  -- 如需自定义请参考plugins/init.lua文件
end

-- 语言特定快捷键
function M.setup_language_specific()
  -- 这些快捷键会在各语言配置文件中设置
  -- 此处仅作为示例和说明
  
  -- Rust 快捷键 (在 rust.lua 中设置)
  -- <leader>ca 代码操作
  -- <leader>ce 展开宏
  -- <leader>cr 运行测试
  -- <leader>cd 调试
  -- <leader>ct 切换crates.nvim
  -- <leader>cv 显示版本
  -- <leader>cf 显示特性
  
  -- C++ 快捷键 (在 cpp.lua 中设置)
  -- <leader>ch 代码操作
  -- <leader>cm 内存使用
  -- <leader>cs 签名帮助
  -- <F5> 开始/继续调试
  -- <F10> 单步跳过
  -- <F11> 单步进入
  -- <F12> 单步退出
  -- <leader>b 切换断点
  
  -- TypeScript 快捷键 (在 frontend.lua 中设置)
  -- <leader>to 组织导入
  -- <leader>tr 重命名文件
  -- <leader>ta 添加缺失导入
  -- <leader>tf 修复所有问题
  -- <leader>ti 移除未使用代码
end

-- 调试快捷键
function M.setup_debug()
  -- 这些快捷键在 cpp.lua 中的 DAP 配置中设置
  -- <F5> 开始/继续调试
  -- <F10> 单步跳过
  -- <F11> 单步进入
  -- <F12> 单步退出
  -- <leader>b 切换断点
end

-- 初始化所有快捷键
function M.setup()
  M.setup_general()
  -- 语言特定快捷键会在各自的配置文件中设置
  -- 调试快捷键会在 DAP 配置中设置
end

return M
-- 自动补全相关配置模块

local helpers = require("helpers")

return {
  -- 自动补全增强 - 延迟加载以提高启动速度
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- 仅在进入插入模式时加载
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function(_, opts)
      -- 使用helpers.safe_require安全加载模块
      local ok, cmp = helpers.safe_require("cmp", "自动补全")
      if not ok then
        return opts
      end
      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
      })
      return opts
    end,
  },
}
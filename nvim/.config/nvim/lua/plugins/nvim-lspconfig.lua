return {
  "neovim/nvim-lspconfig",
  -- #10: 去掉 version='*'，跟随 LazyVim 默认策略用最新 commit（nvim-lspconfig tag 更新滞后）
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      eslint = {
        -- ESLint 9.x 默认只认 flat config, 项目用的是旧格式 .eslintrc.js, 通过环境变量强制使用旧配置
        cmd = { "vscode-eslint-language-server", "--stdio" },
        cmd_env = {
          ESLINT_USE_FLAT_CONFIG = "false",
        },
        settings = {
          workingDirectories = { mode = "auto" },
          -- #2: 用 vim.fn.expand 替代硬编码的 /Users/liuguangqi
          -- 注意：Node 版本仍硬编码，因为公司 formula-cli 依赖特定版本，升级 Node 后需同步修改这里
          resolvePluginsRelativeTo = vim.fn.expand("~")
            .. "/.nvm/versions/node/v18.20.2/lib/node_modules/@xhs/formula-cli",
          experimental = {
            useFlatConfig = false,
          },
        },
      },
    },
  },
}

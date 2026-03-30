return {
  "neovim/nvim-lspconfig",
  version= '*',
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          resolvePluginsRelativeTo="/Users/liuguangqi/.nvm/versions/node/v18.20.2/lib/node_modules/@xhs/formula-cli"
        },
      },
    },
  },
}

return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", "/Users/liuguangqi/.config/nvim/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}

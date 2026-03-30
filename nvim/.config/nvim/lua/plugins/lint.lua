return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        -- #3: 用 vim.fn.stdpath 替代硬编码路径，跨机器可移植
        args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}

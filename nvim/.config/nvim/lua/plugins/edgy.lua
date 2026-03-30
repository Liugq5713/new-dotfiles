return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = {
    right = {},
    left = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = "Neo-Tree Buffers",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "buffers"
        end,
        pinned = true,
        size = { height = 0.2 },
        collapsed = false, -- show window as closed/collapsed on start
        open = "Neotree position=top buffers",
      },
      {
        title = "Neo-Tree",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        collapsed = false, -- show window as closed/collapsed on start
        size = { height = 0.5 },
      },
      {
        title = "Neo-Tree Git",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "git_status"
        end,
        pinned = true,
        collapsed = false, -- show window as closed/collapsed on start
        open = "Neotree position=right git_status",
      },
    },
  },
}

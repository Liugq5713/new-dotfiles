return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          -- '.git',
          ".DS_Store",
          "thumbs.db",
        },
        hide_by_pattern = {
          "*.embedding",
        },
        never_show = {},
      },
    },
    renderers = {
      file = {
        { "indent" },
        { "icon" },
        {
          "container",
          content = {
            {
              "name",
              zindex = 10,
            },
            {
              "symlink_target",
              zindex = 10,
              highlight = "NeoTreeSymbolicLinkTarget",
            },
            { "clipboard", zindex = 10 },
            { "bufnr", zindex = 10 },
            { "modified", zindex = 20, align = "right" },
            { "diagnostics", zindex = 20, align = "right" },
            { "git_status", zindex = 10, align = "right" },
          },
        },
      },
    },
    source_selector = {
      winbar = false,
      statusline = false,
    },
    window = {
      -- position = "right",
      auto_expand_width = false,
      mappings = {
        o = "open_with_window_picker",
        S = "split_with_window_picker",
        s = "vsplit_with_window_picker",
        H = "",
      },
    },
  },
}

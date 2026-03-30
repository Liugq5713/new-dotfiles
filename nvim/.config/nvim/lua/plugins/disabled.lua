-- #7: 集中管理所有禁用的插件（删除了无意义的 blink.cmp enabled=true）
return {
  { "bufferline.nvim", enabled = false },
  { "folke/edgy.nvim", enabled = false },
}

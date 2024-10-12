---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "javascript",
      "typescript",
      "python",
      "c",
      "dockerfile",
      -- add more arguments for adding more treesitter parsers
    },
  },
}

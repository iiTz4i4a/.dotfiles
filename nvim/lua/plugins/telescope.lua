return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- required by telescope
  config = function()
    require("telescope").setup({})
  end,
}

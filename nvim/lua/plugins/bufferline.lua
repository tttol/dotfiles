return {
  'akinsho/bufferline.nvim',
  version = "v4.9.1",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup{}
  end
}

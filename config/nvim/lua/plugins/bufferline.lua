return {
  'akinsho/bufferline.nvim',
  version = "v4.9.1",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup{
      options = {
        max_name_length = 60,
        max_prefix_length = 30,
        truncate_names = true,
      }
    }
  end
}

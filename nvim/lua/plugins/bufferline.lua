return {
  'akinsho/bufferline.nvim',
  version = "v4.9.1",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup{
      options = {
        max_name_length = 30, -- max charachter lengh of filename in each buffer
        max_prefix_length = 15, -- max character length of pathname in each buffer
        truncate_names = true,
        -- tab_size = 18,
      }
    }
  end
}

return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({
          defaults = {
            layout_config = {
              width = 0.95,
              height = 0.85,
              preview_cutoff = 120,
              horizontal = {
                width = { padding = 0.1 },
                height = { padding = 0.1 },
                preview_width = 0.3,
              },
              vertical = {
                width = { padding = 0.05 },
                height = { padding = 0.1 },
                preview_height = 0.5,
              }
            },
          }
        })
        
        local builtin = require('telescope.builtin')
        vim.keymap.set({'n', 'v'}, '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set({'n', 'v'}, '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set({'n', 'v'}, '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set({'n', 'v'}, '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set({'n', 'v'}, '<leader>fi', '<cmd>Telescope lsp_incoming_calls<cr>')
        vim.keymap.set({'n', 'v'}, '<leader>fo', '<cmd>Telescope lsp_outgoing_calls<cr>')
      end
    }

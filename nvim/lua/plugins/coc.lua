return {
  'neoclide/coc.nvim',
  branch = 'release',
  enabled = false, -- 無効化！！！！！
  config = function()
    -- Map cmd+y to coc completion confirm behavior
    vim.keymap.set('i', '<D-y>', function()
      if vim.fn['coc#pum#visible']() == 1 then
        return vim.fn['coc#pum#confirm']()
      else
        return vim.api.nvim_replace_termcodes('<C-y>', true, false, true)
      end
    end, { expr = true, noremap = true, silent = true })
    
    -- gd: Go to Definition(定義ジャンプ)
    vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
    -- gy: Go to Type Definition(型定義ジャンプ)
    vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
    -- gi: Go to jump to implementation(実装ジャンプ)
    vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
    -- gr: Go to Show References
    vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
    
    -- Map ctrl+[ to go back in jumplist
    vim.keymap.set('n', '<C-[>', '<C-o>', { silent = true })
    -- Map ctrl+] to go forward in jumplist
    vim.keymap.set('n', '<C-]>', '<C-i>', { silent = true })
  end
}

highlight LineNr  guifg=White

set fenc=utf-8
set nobackup
set noswapfile
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
set showcmd " 入力中のコマンドをステータスに表示する
set background=dark
set guifont=Menlo-Regular:h13 "フォント指定
set number " 行番号表示
set cursorline " 現在行強調表示
set laststatus=2 " ステータスラインを常に表示

" keybindings
nnoremap e $
vnoremap e $
if has("gui_macvim")
    " Commandキーを使用可能にする
    " for MacVim 
   set macmeta
else
    " for zsh
endif

set hlsearch " 検索時にマッチ箇所をハイライト
" set clipboard=unnamedplus " OSのクリップボードと同期

" モードに応じてステータスラインの色を変更
function! SetStatuslineColor()
  if mode() == 'n'
    highlight StatusLine ctermbg=blue ctermfg=white guibg=blue guifg=white
  elseif mode() == 'i'
    highlight StatusLine ctermbg=green ctermfg=black guibg=green guifg=black
  elseif mode() == 'v'
    highlight StatusLine ctermbg=magenta ctermfg=white guibg=magenta guifg=white
  elseif mode() == 'R'
    highlight StatusLine ctermbg=red ctermfg=white guibg=red guifg=white
  elseif mode() == 'c'
    highlight StatusLine ctermbg=yellow ctermfg=black guibg=yellow guifg=black
  else
    highlight StatusLine ctermbg=darkgray ctermfg=white guibg=darkgray guifg=white
  endif
endfunction

" カーソル移動やモード変更時に色を適用
autocmd InsertEnter,InsertLeave,WinEnter,WinLeave,CursorHold,CursorMoved * call SetStatuslineColor()

set termguicolors
set history=100
set ruler
set showcmd
" generals
let maplocalleader = ","

" netrw etc
let g:netrw_banner = 0
let g:netrw_winsize = 75
let g:netrw_liststyle = 3
let g:netrw_altv = 1
" 1 - open files in a new horizontal split
" 2 - open files in a new vertical split
" 3 - open files in a new tab
" 4 - open in previous window
let g:netrw_browse_split = 4

" on nordic layout C-\ is impossible , map move from TERMINAL -> NORMAL mode
tnoremap <C-W>n <C-\><C-n>
" toggle displaying special chars
noremap <Leader><Tab><Tab> :set invlist<CR>

lua <<EOF

require("paq") {
  "savq/paq-nvim";
  "ojroques/nvim-hardline";
  "rmehri01/onenord.nvim";
  "gfanto/fzf-lsp.nvim";
  "Olical/conjure";
  "luochen1990/rainbow";
  "tpope/vim-surround";
  "tpope/vim-sexp-mappings-for-regular-people";
  "guns/vim-sexp";
}
require('hardline').setup {
        bufferline = true,  -- enable bufferline
}
require('onenord').setup({
        theme = "dark"
})

EOF

" use system fzf
set rtp+=~/.fzf


" clojure
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:conjure#client#clojure#nrepl#connection#auto_repl#hidden = "true"
let g:conjure#client#clojure#nrepl#eval#raw_out = "true"

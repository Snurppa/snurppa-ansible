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
-- From *paq-bootstrapping* docs

local function clone_paq()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
    return true
  end
end

local function bootstrap_paq(packages)
  local first_install = clone_paq()
  vim.cmd.packadd("paq-nvim")
  local paq = require("paq")
  if first_install then
    vim.notify("Installing plugins... If prompted, hit Enter to continue.")
  end

  -- Read and install packages
  paq(packages)
  paq.install()
end

bootstrap_paq {
  "savq/paq-nvim";
  "rmehri01/onenord.nvim";
  "gfanto/fzf-lsp.nvim";
-- clojure etc
  "Olical/conjure";
  "luochen1990/rainbow";
  "tpope/vim-surround";
  "tpope/vim-sexp-mappings-for-regular-people";
  "guns/vim-sexp";
-- statusline / bufferline
  "nvim-lua/plenary.nvim";
  "lewis6991/gitsigns.nvim";
  "crispgm/nvim-tabline";
--  "kyazdani42/nvim-web-devicons";
}
require('tabline').setup({})
require('onenord').setup({
        theme = "dark"
})
require('gitsigns').setup()
EOF

" use system fzf
set rtp+=~/.fzf


" clojure
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:conjure#client#clojure#nrepl#connection#auto_repl#hidden = "true"
let g:conjure#client#clojure#nrepl#eval#raw_out = "true"

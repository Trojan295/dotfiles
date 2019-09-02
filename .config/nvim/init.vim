" ----------------- Plugins -----------------
call plug#begin()

" Visual
Plug 'dracula/vim'
Plug 'Yggdroot/indentLine'
Plug 'bronson/vim-trailing-whitespace'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'Chiel92/vim-autoformat'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'liuchengxu/space-vim-dark'
Plug 'ycm-core/YouCompleteMe'

Plug 'hashivim/vim-terraform'

call plug#end()

" ----------------- Basic -------------------
set nocompatible
filetype plugin on

" Fuzzy file find
set path+=**
set wildmenu

" ----------------- NERDTree ----------------

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

noremap <F2> :NERDTreeFocus<CR>

" ----------------- Visual ------------------
syntax enable
set background=dark
colorscheme space-vim-dark

let g:space_vim_dark_background = 233
color space-vim-dark

let g:indentLine_conceallevel = 1
let g:ycm_min_num_of_chars_for_completion = 2

" ----------------- ALE ---------------------

let g:airline#extensions#ale#enabled = 1
let g:ale_open_list = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" ----------------- Other -------------------

hi MatchParen cterm=bold ctermbg=none ctermfg=white

let g:ycm_autoclose_preview_window_after_completion = 1

" Whitespace behaviour
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Autoformatting
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 1
au BufWrite * :Autoformat

" Enable line numbers
set number

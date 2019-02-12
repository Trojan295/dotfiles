
" ----------------- Plugins -----------------
call plug#begin()

" Visual
Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'Yggdroot/indentLine'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'Chiel92/vim-autoformat'
Plug 'vim-airline/vim-airline'

" Python
Plug 'Valloric/YouCompleteMe'

call plug#end()

" ----------------- NERDTree ----------------

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

noremap <F2> :NERDTreeFocus<CR>


" ----------------- Visual ------------------
syntax enable
set background=dark
colorscheme Atelier_LakesideDark
let g:airline_theme='Atelier_LakesideDark'

" ----------------- Other -------------------

" Whitespace behaviour
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Autoformatting
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
au BufWrite * :Autoformat

" Enable line numbers
set number

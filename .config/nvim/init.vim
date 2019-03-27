" ----------------- Plugins -----------------
call plug#begin()

" Visual
Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'Yggdroot/indentLine'
Plug 'bronson/vim-trailing-whitespace'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'Chiel92/vim-autoformat'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'

" Python
Plug 'Valloric/YouCompleteMe'

" Javascript
Plug 'posva/vim-vue'

" Go
Plug 'fatih/vim-go'

call plug#end()

" ----------------- NERDTree ----------------

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

noremap <F2> :NERDTreeFocus<CR>

" ----------------- Visual ------------------
syntax enable
set background=dark
colorscheme Atelier_ForestDark
let g:airline_theme='Atelier_ForestDark'

let g:indentLine_conceallevel = 1

" ----------------- ALE ---------------------

let g:ale_open_list = 1
let g:airline#extensions#ale#enabled = 1

" ----------------- Other -------------------

hi MatchParen cterm=bold ctermbg=none ctermfg=white

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
set conceallevel=0

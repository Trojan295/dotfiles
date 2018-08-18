
" ----------------- Plugins -----------------
call plug#begin()

" Visual
Plug 'reedes/vim-colors-pencil'
Plug 'Yggdroot/indentLine'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'Chiel92/vim-autoformat'

" Python
Plug 'nvie/vim-flake8'

" Typescript
Plug 'leafgarland/typescript-vim'

" Vue
Plug 'posva/vim-vue'

call plug#end()

" ----------------- NERDTree ----------------

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

noremap <F2> :NERDTreeFocus<CR>


" ----------------- Visual ------------------

colorscheme pencil
set background=dark

highlight LineNr ctermfg=darkgray ctermbg=black

let g:airline_theme = 'pencil'

" ----------------- Other -------------------

" Whitespace behaviour
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

au BufWrite * :Autoformat

" Enable line numbers
set number

let g:autoformat_autoindent=0


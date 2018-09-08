
" ----------------- Plugins -----------------
call plug#begin()

" Visual
Plug 'w0ng/vim-hybrid'
Plug 'Yggdroot/indentLine'

" Functional
Plug 'scrooloose/nerdtree'
Plug 'Chiel92/vim-autoformat'
Plug 'lifepillar/vim-mucomplete'

" Python
Plug 'nvie/vim-flake8'

" Typescript
Plug 'leafgarland/typescript-vim'

" Vue
Plug 'posva/vim-vue'

" Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Elixir
Plug 'elixir-editors/vim-elixir'

" RobotFramework
Plug 'mfukar/robotframework-vim'

call plug#end()

" ----------------- NERDTree ----------------

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

noremap <F2> :NERDTreeFocus<CR>


" ----------------- Visual ------------------

set background=dark
colorscheme hybrid

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

let g:go_metalinter_autosave=1



" ----------------- Plugins -----------------
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'jiangmiao/auto-pairs'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'reedes/vim-colors-pencil'

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
setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal autoindent
setlocal smartindent

" Enable line numbers
set number


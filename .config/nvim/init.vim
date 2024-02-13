" ----------------- Plugins -----------------
call plug#begin()

" Visual
Plug 'tomasr/molokai'

call plug#end()

" ----------------- Basic -------------------
set nocompatible
filetype plugin on

" Fuzzy file find
set path+=**
set wildmenu

" ----------------- Visual ------------------
syntax enable

set background=dark
colorscheme molokai

" ----------------- Other -------------------

"let g:airline_theme='Atelier_LakesideDark'

" Whitespace behaviour
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Enable line numbers
set number

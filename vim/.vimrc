set nocompatible
filetype off

" activates filetype detection
filetype plugin indent on

" activates syntax highlighting among other things
syntax on

" allows you to deal with multiple unsaved
" buffers simultaneously without resorting
" to misusing tabs
set hidden

" just hit backspace without this one and
" see for yourself
set backspace=indent,eol,start

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

"if (has("termguicolors"))
"    set termguicolors
"endif
"syntax enable

"colorscheme OceanicNext 
colorscheme solarized
set number

" this turns off physical line wrapping (automatic insertion of newlines)
set textwidth=0
set wrapmargin=0
set tw=0
set formatoptions-=t " do not automatically wrap text when typing

" this highlights text that exceeds 80 columns in length to evaluate breaking more text into new lines
highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80,".join(range(120,999),",")

set background=dark

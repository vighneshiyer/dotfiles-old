set shell=/bin/bash
call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'lervag/vimtex'

call plug#end()
" Use spacebar as leader key
let mapleader="\<SPACE>"
" Don't clear Ctrl-P cache between vim sessions (use F5 to refresh cache)
let g:ctrlp_clear_cache_on_exit = 0
" Ctrl-p should ignore files/folders specified in the repo's .gitignore
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
    \ 2: ['.rc18', 'find -O3 cmod vmod fpga vlib stand_sim/RC18_CHIP_TOP'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
" Use Latex indenting style
let g:tex_flavor='latex'
set nocompatible
set mouse=a

" activates filetype detection
"filetype plugin indent on

" activates syntax highlighting among other things
syntax on
syntax enable

" allows you to deal with multiple unsaved
" buffers simultaneously without resorting
" to misusing tabs
set hidden

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set showcmd         " Show command in statusline
set showmatch       " Show matching brackets
set showmode        " Show current mode
set splitbelow      " Hori split on bottom
set splitright      " Vert split on right

if !&scrolloff
  set scrolloff=3   " Show next 3 lines when scrolling
endif
if !&sidescrolloff
  set sidescrolloff=5 " Show next 5 columns when side-scrolling
endif
set nostartofline   " Don't jump to first character with page commands

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
set ignorecase      " Make searching case insensitive
set smartcase       " ... unless the query has capital letters
set gdefault        " use global flag by default when search/replace
set magic           " extended regex when searching

set laststatus=2
set ruler
set wildmenu

set termguicolors
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
colorscheme gruvbox
set number

" this turns off physical line wrapping (automatic insertion of newlines)
set textwidth=0
set wrapmargin=0
set tw=0
set formatoptions-=t " do not automatically wrap text when typing

" this highlights text that exceeds 100 columns in length to evaluate breaking more text into new lines
highlight ColorColumn ctermbg=0 guibg=#282828
let &colorcolumn="100,".join(range(130,999),",")

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

" Use relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

"""" Special commands/shortcuts
nmap <Leader>s :%s//<Left>
nnoremap <Leader>r :call NumberToggle()<cr>
nnoremap ; :
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :wq<CR>

vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

nmap <Leader>h <C-w>h
nmap <Leader>j <C-w>j
nmap <Leader>k <C-w>k
nmap <Leader>l <C-w>l

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPMRUFiles<CR>

nnoremap <Leader>n :NERDTreeToggle<CR>

nnoremap <Leader>m :make<CR>
autocmd BufRead,BufNewFile *.v set syntax=verilog
autocmd BufRead,BufNewFile *.vh set syntax=verilog
autocmd BufRead,BufNewFile *.sc set syntax=scala
autocmd BufRead,BufNewFile Makefrag set syntax=make

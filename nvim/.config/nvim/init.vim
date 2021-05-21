set shell=/bin/bash
call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'lervag/vimtex'
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/goyo.vim'
Plug 'mkitt/tabline.vim'
"Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install', 'for': ['vim', ], 'branch': 'release'}
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'bohlender/vim-smt2'
Plug 'easymotion/vim-easymotion'
autocmd FileType markdown let b:coc_suggest_disable = 1
autocmd FileType tex let b:coc_suggest_disable = 1
autocmd FileType tex setlocal indentexpr=

"autocmd BufNew,BufEnter *.vim execute "silent! CocEnable"
"autocmd BufLeave *.vim execute "silent! CocDisable"

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
nmap <Leader>c <C-w>c

"" tab switching
nmap <Leader>1 1gt
nmap <Leader>2 2gt
nmap <Leader>3 3gt
nmap <Leader>4 4gt
nmap <Leader>5 5gt
nmap <Leader>6 6gt
nmap <Leader>7 7gt
nmap <Leader>8 8gt
nmap <Leader>9 9gt
nmap <Leader>0 10gt

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
"nnoremap <Leader>f :CtrlPMRUFiles<CR>

nnoremap <Leader>n :NERDTreeToggle<CR>

nnoremap <Leader>m :make<CR>
autocmd BufRead,BufNewFile *.v set syntax=verilog
autocmd BufRead,BufNewFile *.vh set syntax=verilog
autocmd BufRead,BufNewFile Makefrag set syntax=make
autocmd BufRead,BufNewFile SConscript set syntax=python
autocmd BufRead,BufNewFile SConstruct set syntax=python
autocmd BufRead,BufNewFile *.lib set syntax=text
autocmd BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" folding
set foldmethod=syntax
set foldnestmax=10
set nofoldenable " don't enable folds after opening a file
set foldlevel=2
let g:markdown_folding = 1

" coc
" https://scalameta.org/metals/docs/editors/vim.html
"autocmd FileType json syntax match Comment +\/\/.\+$+
"
"" You will have a bad experience with diagnostic messages with the default 4000.
"set updatetime=300
"
"" Don't give |ins-completion-menu| messages.
"set shortmess+=c
"
"" Always show signcolumns
"set signcolumn=yes
"
"" Help Vim recognize *.sbt and *.sc as Scala files
"au BufRead,BufNewFile *.sbt,*.sc set filetype=scala
"
"" Use tab for trigger completion with characters ahead and navigate.
"" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"" Used in the tab autocompletion for coc
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"
"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
"" Coc only does snippet and additional edit on confirm.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"
"" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to either doHover or show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction
"
"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)
"
"" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
"
"augroup mygroup
"  autocmd!
"  " Setup formatexpr specified filetype(s).
"  autocmd FileType scala setl formatexpr=CocAction('formatSelected')
"  " Update signature help on jump placeholder
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end
"
"" Remap for do codeAction of current line
"xmap <leader>a  <Plug>(coc-codeaction-line)
"nmap <leader>a  <Plug>(coc-codeaction-line)
"
"" Fix autofix problem of current line
"nmap <leader>qf  <Plug>(coc-fix-current)
"
"" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')
"
"" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"" Trigger for code actions
"" Make sure `"codeLens.enable": true` is set in your coc config
"nnoremap <leader>cl :<C-u>call CocActionAsync('codeLensAction')<CR>
"
"" Show all diagnostics
"" NEED TO FIND new keys to map these to
""nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions
""nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
"" Show commands
""nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document
""nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols
""nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
""nnoremap <silent> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
""nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list
""nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
"
"" Notify coc.nvim that <enter> has been pressed.
"" Currently used for the formatOnType feature.
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"" Toggle panel with Tree Views
"nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
"" Toggle Tree View 'metalsPackages'
"nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
"" Toggle Tree View 'metalsCompile'
"nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
"" Toggle Tree View 'metalsBuild'
"nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
"" Reveal current current class (trait or object) in Tree View 'metalsPackages'
"nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>

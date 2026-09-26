set nocompatible

set background=dark

syntax on

set backspace=indent,eol,start
set history=50
set ruler
set showcmd
set incsearch
set nobackup
set noundofile
set timeoutlen=1000 ttimeoutlen=0

set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set smartindent

set mouse=a
set pastetoggle=+
set nonumber
set nolist
set listchars=tab:>-,space:·

autocmd BufEnter * silent! cd %:p:h
autocmd Filetype haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2

let g:nogx = "true"

set rulerformat=%38(%#TabLine#\ %-t\ %m\ %#MatchParen#\ %12(%l:%c%V%)\ %k\ %4p%%%)
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight LineNr guifg=#405460

let mapleader = "\\"

nnoremap <C-left>  <C-w><
nnoremap <C-down>  <C-w>+
nnoremap <C-up>    <C-w>-
nnoremap <C-right> <C-w>>

nnoremap <S-left>  5<C-w><
nnoremap <S-down>  5<C-w>+
nnoremap <S-up>    5<C-w>-
nnoremap <S-right> 5<C-w>>

nnoremap <A-left>  10<C-w><
nnoremap <A-down>  10<C-w>+
nnoremap <A-up>    10<C-w>-
nnoremap <A-right> 10<C-w>>

nnoremap <C-S-left>  <C-w>H
nnoremap <C-S-down>  <C-w>J
nnoremap <C-S-up>    <C-w>K
nnoremap <C-S-right> <C-w>L

nnoremap Q :marks<CR>
nnoremap _ <C-w>s
nnoremap \| <C-w>v

nnoremap <C-f> :e<space>
nnoremap <C-g> :jumps<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprev<CR>
nnoremap <C-q> :reg<CR>

nnoremap <leader>o :tabonly<CR>
nnoremap <leader>p :pwd<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>/ :set hlsearch!<CR>
nnoremap <leader>' :set list!<CR>
nnoremap <leader>; :set number!<CR>
nnoremap <leader>- :tabclose<CR>
nnoremap <leader>= :tabnew<CR>
nnoremap <leader>[ :tabprev<CR>
nnoremap <leader>] :tabnext<CR>

nnoremap <C-b><C-a> :badd<space>
nnoremap <C-b><C-b> :b<space>
nnoremap <C-b><C-d> :bdel<CR>
nnoremap <C-b><C-e> :blast<CR>
nnoremap <C-b><C-f> :bfirst<CR>
nnoremap <C-b><C-l> :buffers<CR>
nnoremap <C-b><C-n> :bnext<CR>
nnoremap <C-b><C-p> :bprev<CR>

cnoremap <C-x> <C-k>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

if filereadable("/etc/vimrc.local")
    source /etc/vimrc.local
endif
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

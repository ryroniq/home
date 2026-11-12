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
set scrolloff=5

set expandtab
set tabstop=4
set shiftwidth=0
set softtabstop=-1
set autoindent
set smartindent

set mouse=a
set pastetoggle=<F5>
set nonumber
set nolist
set listchars=tab:>-,space:·

" Vim doesn't know st or tmux support modifyOtherKeys
set keyprotocol^=st:mok2,tmux:mok2
" st's Shift-Tab isn't read from terminfo
if &term =~# '^st'
    execute "set t_kB=\<Esc>[Z"
endif

autocmd BufEnter * silent! cd %:p:h
autocmd Filetype haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufRead,BufNewFile *.journal setlocal expandtab shiftwidth=4 softtabstop=4 nosmartindent

let g:nogx = "true"

set rulerformat=%38(%#TabLine#\ %-t\ %m\ %#MatchParen#\ %12(%l:%c%V%)\ %k\ %4p%%%)
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
highlight LineNr guifg=#405460

command! -range=% Retab execute <line1> . ',' . <line2> . (&expandtab ? 'retab' : 'retab!')

augroup restore_cursor
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
augroup END

let s:keys = {
  \ 'y': 'h', 'h': 'j', 'a': 'k', 'e': 'l', 'j': 'q', 'l': 'z',
  \ 's': 'a', 'm': 'e', 'z': 'm', 'k': 'y', 'q': ':',
  \ 'Y': 'H', 'H': 'J', 'A': 'K', 'E': 'L', 'J': 'Q', 'L': 'Z',
  \ 'S': 'A', 'M': 'E', 'Z': 'M', 'K': 'Y', 'Q': ';',
  \ ';': ':', ':': ';',
  \ }
for [s:lhs, s:rhs] in items(s:keys)
  for s:mode in ['n', 'x', 'o']
    execute s:mode . 'noremap' s:lhs s:rhs
  endfor
endfor

for s:k in ['h', 'j', 'k', 'l', 'H', 'J', 'K', 'L', '<C-h>', '<C-j>', '<C-k>', '<C-l>']
  execute 'nnoremap <C-w>' . s:k . ' <Nop>'
endfor

nnoremap gh gj
nnoremap ga gk
xnoremap gh gj
xnoremap ga gk

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

nnoremap Q @@
nnoremap _ <C-w>s
nnoremap \| <C-w>v

nnoremap <C-j> @
nnoremap <C-q> :q<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-c> :shell<CR>
nnoremap <C-`> :marks<CR>
nnoremap <C-'> :marks<CR>
nnoremap <C-i> :jumps<CR>
nnoremap <C-/> :reg<CR>
nnoremap <C-f> <C-i>
nnoremap <C-m> <C-a>
nnoremap <C-y> <C-w>h
nnoremap <C-h> <C-w>j
nnoremap <C-a> <C-w>k
nnoremap <C-e> <C-w>l
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprev<CR>

nnoremap <C-b><C-a> :badd<space>
nnoremap <C-b><C-b> :b<space>
nnoremap <C-b><C-d> :bdel<CR>
nnoremap <C-b><C-e> :blast<CR>
nnoremap <C-b><C-f> :bfirst<CR>
nnoremap <C-b><C-l> :buffers<CR>
nnoremap <C-b><C-n> :bnext<CR>
nnoremap <C-b><C-p> :bprev<CR>

nnoremap <C-w><C-y> <C-w>H
nnoremap <C-w><C-h> <C-w>J
nnoremap <C-w><C-a> <C-w>K
nnoremap <C-w><C-e> <C-w>L

let mapleader = "\\"

nnoremap <leader><tab> :set expandtab!<CR>
nnoremap <leader>t :Retab<CR>
nnoremap <leader>o :tabonly<CR>
nnoremap <leader>p :pwd<CR>
nnoremap <leader>i :set number!<CR>
nnoremap <leader>' :set list!<CR>
nnoremap <leader>- :tabclose<CR>
nnoremap <leader>= :tabnew<CR>
nnoremap <leader>[ :tabprev<CR>
nnoremap <leader>] :tabnext<CR>
nnoremap <leader>/ :set hlsearch!<CR>

cnoremap <C-h> <Down>
cnoremap <C-a> <Up>

if filereadable("/etc/vimrc.local")
    source /etc/vimrc.local
endif
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

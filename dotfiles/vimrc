set nocompatible

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  let need_vim_plug_install = 1

  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

" General
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'gmist/vim-palette'

" Python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'dense-analysis/ale'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | q
endif

syntax on
set hidden
set number
set ruler
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch
set encoding=utf-8
set background=dark
set backspace=indent,eol,start
set scrolloff=5

set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=110
set expandtab

set backupdir=/tmp//
set directory=/tmp//

filetype plugin indent on

silent! colorscheme tigrana-256-dark

autocmd Filetype html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd Filetype scss setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd Filetype javascript setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier_eslint'],
\   'typescript': ['prettier_eslint'],
\   'css': ['prettier_eslint'],
\   'python': ['black'],
\}
let g:ale_python_auto_pipenv = 1
let g:ale_fix_on_save = 1

nnoremap j gj
nnoremap k gk

" Highlight/Clear trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

function! Trim()
  %s/\s*$//
  ''
endfunction
command! -nargs=0 Trim :call Trim()
nnoremap <silent> <Leader>cw :Trim<CR>

" NERDTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

" NERDCommenter
map <silent> <leader>c<space <plug>NERDCommenterComment
map <silent> <leader>cc <plug>NERDCommenterToggle

" fzf
map <silent> <leader>ff :Files<CR>
map <silent> <leader>fb :Buffers<CR>
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'  }

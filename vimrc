set nocompatible              " be iMproved, required
filetype off                  " required

filetype plugin indent on
set sw=4
set ts=4

syntax on

" gui / term setup
if !has('gui_running')
	set t_Co=256
endif

" colorscheme iceberg
colorscheme iceberg

" colorscheme alduin
" let g:alduin_Shout_Dragon_Aspect = 1
" colorscheme alduin

" status bar
set laststatus=2
set noshowmode
let g:lightline = { 'colorscheme': 'wombat' }

" fzf
set rtp+=/usr/local/opt/fzf
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
\   fzf#vim#with_preview(), <bang>0)

" layout & mouse/trackpad behavior
set mouse=a
set number

" Change how vim represents characters on the screen
set encoding=utf-8

" Set the encoding of files written
set fileencoding=utf-8

set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir

" go-vim plugin specific commands
" Also run `goimports` on your current file on every save
" Might be be slow on large codebases, if so, just comment it out
let g:go_fmt_command = "goimports"

" Ruby
:autocmd Filetype ruby set softtabstop=2
:autocmd Filetype ruby set sw=2
:autocmd Filetype ruby set ts=2

" NERDTree plugin specific commands
:nnoremap <C-g> :NERDTreeToggle<CR>


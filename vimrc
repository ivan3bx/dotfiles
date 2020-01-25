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
:autocmd Filetype ruby set tabstop=2
:autocmd Filetype ruby set softtabstop=2
:autocmd Filetype ruby set shiftwidth=2
:autocmd Filetype ruby set expandtab

" NERDTree plugin specific commands
:nnoremap <C-g> :NERDTreeToggle<CR>

" Set specific linters
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'ruby': ['rubocop'],
\}

" fzf config
if executable('fzf')
  " <C-p> or <C-t> to search files
  nnoremap <silent> <C-t> :FZF -m<cr>
  nnoremap <silent> <C-p> :FZF -m<cr>
  nnoremap <silent> <M-t> :History<cr>

  " Use fuzzy completion relative filepaths across directory
  imap <expr> <c-x><c-f> fzf#vim#complete#path('git ls-files $(git rev-parse --show-toplevel)')

  " Better command history with q:
  command! CmdHist call fzf#vim#command_history({'right': '40'})
  nnoremap q: :CmdHist<CR>

  " Better search history
  command! QHist call fzf#vim#search_history({'right': '40'})
  nnoremap q/ :QHist<CR>

  command! -bang -nargs=* Ack call fzf#vim#ag(<q-args>, {'down': '40%', 'options': '--no-color'})
end

" vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

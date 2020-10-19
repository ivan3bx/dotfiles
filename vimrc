set nocompatible
filetype off

filetype plugin indent on
let mapleader = ","    " leader to ','
set sw=4               " default shift width
set ts=4               " default tab stop
set encoding=utf-8     " default text encoding
set fileencoding=utf-8 " default file encoding
set clipboard=unnamed

syntax on

" gui / term setup
if !has('gui_running')
	set t_Co=256         " force 256-color mode
	colorscheme iceberg  " default colorscheme
	let g:alduin_Shout_Dragon_Aspect     = 1 " for alduin
	let g:alduin_Shout_Animal_Allegiance = 1 " for alduin
endif

" status bar
set laststatus=2         " play nice with tmux
set noshowmode           " play nice with tmux
let g:lightline = { 'colorscheme': 'wombat' }

" ctags locations
set tags=.git/tags,tags

" layout & mouse/trackpad behavior
set mouse=a
set number

" undo history cached between sessions
set undofile 
set undodir=~/.vim/undodir

" Go-specific configuration
let g:go_fmt_command = "goimports"

" Ruby-specific configuration
:autocmd Filetype ruby set tabstop=2
:autocmd Filetype ruby set softtabstop=2
:autocmd Filetype ruby set shiftwidth=2
:autocmd Filetype ruby set expandtab

" NERDTree
" :nnoremap <C-g> :NERDTreeToggle<CR> 

" language linters
let g:ale_enabled = 0
let g:ale_sign_column_always = 1
let g:ale_linters = { 'javascript': ['eslint'], 'ruby': ['rubocop'] }

" fzf config
set rtp+=/usr/local/opt/fzf
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
\   fzf#vim#with_preview(), <bang>0)

if executable('fzf')
  " search files and file history
  nnoremap <silent> <C-t> :FZF -m<cr>
  nnoremap <silent> <C-p> :History -m<cr>

  " search current word under cursor
  nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
  nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

  " fuzzy completion relative filepaths across directory
  imap <expr> <c-x><c-f> fzf#vim#complete#path('git ls-files $(git rev-parse --show-toplevel)')

  " search command history with q:
  command! CmdHist call fzf#vim#command_history({'right': '40'})
  nnoremap q: :CmdHist<CR>

  " search term history
  command! QHist call fzf#vim#search_history({'right': '40'})
  nnoremap q/ :QHist<CR>
end

" vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

" emacs-like bindings (because I'm an adult and I can handle it)
map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A
inoremap <M-f> <ESC><Space>Wi
inoremap <M-b> <Esc>Bi
inoremap <M-d> <ESC>cW

" -- BEGIN terminal paste hack
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" -- END terminal paste hack

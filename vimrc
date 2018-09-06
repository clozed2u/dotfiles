" github.com/clozed2u :: @clozed2u
" http://clozed2u.com

" Initial: {{{

if &compatible
  set nocompatible
endif

" }}}

" Plugins: {{{

if !isdirectory($HOME.'/.vim/bundle/repos/github.com/shougo/dein.vim')
  silent !git clone -q https://github.com/shougo/dein.vim.git $HOME/.vim/bundle/repos/github.com/shougo/dein.vim
endif

set runtimepath+=$HOMEBREW/opt/fzf
set runtimepath+=$HOME/.vim/bundle/repos/github.com/shougo/dein.vim
if dein#load_state(expand($HOME.'/.vim/bundle'))
  call dein#begin(expand($HOME.'/.vim/bundle'))
  call dein#add('shougo/dein.vim')
  call dein#add('wellle/targets.vim')
  call dein#add('tpope/vim-rsi')
  call dein#add('tpope/vim-eunuch')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-abolish')
  call dein#add('tpope/vim-dispatch')
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-markdown')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-commentary')
  call dein#add('justinmk/vim-dirvish')
  call dein#add('terryma/vim-expand-region')
  call dein#add('fatih/vim-go')
  call dein#add('janko-m/vim-test')
  call dein#add('sickill/vim-pasta')
  call dein#add('vim-ruby/vim-ruby')
  call dein#add('pangloss/vim-javascript')
  call dein#add('mxw/vim-jsx')
  call dein#add('christoomey/vim-tmux-navigator')
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

command PluginUpdate call dein#update()

filetype plugin indent on

" }}}

" Colors: {{{

set t_Co=256
syntax on
set background=dark
colorscheme grb

" Highlight extra whitespaces with red color
highlight SpecialKey guibg=NONE ctermbg=NONE
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" }}}

" Settings: {{{

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set nobomb
set shell=zsh\ -l

" Backup files and don't allow files with the same name to overwrite each other
set noswapfile
set writebackup
set backupdir=$HOME/.vim/backup
set undofile
set undodir=$HOME/.vim/undo
set directory=$HOME/.vim/tmp

" Enable tags
set tags=./tags

" Use spaces instead of tabs and auto indent
set backspace=2
set laststatus=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
" set shiftround
set expandtab
set smarttab
set autoindent
set smartindent
" set cinoptions=>4,l1,p0,)50,*50,t0

" Autoread and write files
set autoread
set autowrite
set autowriteall
set linespace=0

" Disalbe annoying prompt message
set shortmess=atToOI
set viewoptions+=unix,slash

" Autocomplete menu
set wildmenu
set wildmode=list:longest
set wildignore=
  \*.png,
  \*.jpg,
  \*.gif,
  \*.gem,
  \*.swp,
  \*.zip,
  \*.gz,
  \*/.DS_Store/*,
  \*/tmp/*,
  \*/node_modules/*,
  \*/bower_components/*,
  \*/vendor/*,
  \*/.gem/*,
  \*/.git/*,
  \*/.hg/*,
  \*/.svn/*
set wildignorecase

" Additional UI configs
set noshowmode
set showcmd
set showtabline=0
set hidden
set number
set norelativenumber
set ttyfast

" Search
set ignorecase
set smartcase
set infercase
set incsearch
set hlsearch
set noshowmatch
set matchtime=0

set nojoinspaces
set splitbelow
set splitright
set nowrap
set listchars=tab:\ \ ,eol:\ ,trail:•,nbsp:.
set list

" Timeout
set timeout
set timeoutlen=200
set ttimeout
set ttimeoutlen=0

" Folding
set foldenable
" set foldmethod=indent
set foldmethod=manual
set foldlevel=9999

" Line & column highlighting
set nocursorline
set nocursorcolumn

" Completion
set omnifunc=syntaxcomplete#Complete
set completefunc=syntaxcomplete#Complete
set completeopt=longest,menuone
" set complete=.,w,b,u,t,i
set complete-=i

set scrolloff=0
set synmaxcol=1000
set statusline=Path:\ %F\ %m\ %=\ %Y

" Use rg for grep if installed
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

" Enable clipboard
let s:kernel = system('echo -n "$(uname -s)"')
if s:kernel == 'Darwin'
  set clipboard=unnamed
elseif s:kernel == 'Linux'
  set clipboard=unnamedplus
endif

" }}}

" Explorer: {{{

" Nicer netrw
let g:netrw_altv=1
let g:netrw_banner=0
let g:netrw_preview=1
let g:netrw_winsize=25
let g:netrw_liststyle=3
let g:netrw_browse_split=0
let g:netrw_list_hide=&wildignore

" }}}

" Mappings: {{{

" Prefer spaces for leader
let mapleader = "\<space>"

  " Modes: {{{2

  nnoremap j gj
  nnoremap k gk
  nnoremap qq :q!<cr>
  nnoremap ; :
  nnoremap <cr> :nohlsearch<cr>

  vmap <  <gv
  vmap > >gv

  " }}}

  " Navigation: {{{2

  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l

  " }}}

  " Run: {{{2

  autocmd FileType go nnoremap <buffer> <leader>m :!go run %<cr>
  autocmd FileType php nnoremap <buffer> <leader>m :!php %<cr>
  autocmd FileType ruby nnoremap <buffer> <leader>m :!ruby %<cr>
  autocmd FileType python nnoremap <buffer> <leader>m :!python3 %<cr>
  autocmd FileType javascript nnoremap <buffer> <leader>m :!node %<cr>

  " }}}

  " Split: {{{2

  nnoremap <leader>- <c-w>_<cr>
  nnoremap <leader>= <c-w>=<cr>

  " }}}

" }}}

" Languages: {{{

" Focus on the line from last open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

augroup LanguageSpecific
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker foldlevel=0
  autocmd FileType zsh setlocal foldmethod=marker foldlevel=0
  autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4 foldmethod=syntax
  autocmd FileType ruby setlocal foldmethod=syntax
  autocmd FileType make setlocal noexpandtab tabstop=4 softtabstop=4
  autocmd FileType python setlocal nosmartindent tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType javascript,javascript.jsx setlocal foldmethod=syntax
augroup END

" }}}

" PluginSettings: {{{

  " Test: {{{2

  let g:test#strategy='basic'
  let g:test#preserve_screen=0

  nmap <silent> <leader>n :TestNearest<cr>
  nmap <silent> <leader>f :TestFile<cr>
  nmap <silent> <leader>l :TestLast<cr>

  " }}}

  " Go: {{{2

  let g:go_fmt_command="goimports"

  " Highlight
  " let g:go_highlight_functions=1
  " let g:go_highlight_methods=1
  " let g:go_highlight_structs=1
  " let g:go_highlight_operators=1
  " let g:go_highlight_build_constraints=1

  " }}}

  " JSX: {{{2

  let g:jsx_ext_required=0

  " }}}

  " NERDTree: {{{2

  nnoremap <leader>w :NERDTreeToggle<enter>
  nnoremap <silent> <leader>v :NERDTreeFind<cr>
  let NERDTreeQuitOnOpen=1
  let NERDTreeAutoDeleteBuffer=1
  let NERDTreeMinimalUI=1
  let NERDTreeDirArrows=1

  " }}}

" }}}

" Tab: {{{

function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

inoremap <expr> <silent> <tab> InsertTabWrapper()

" }}}

" Fuzzy: {{{

nnoremap <leader>p :call fzf#run({'source': 'fd -t f .', 'sink': 'e', 'up': '40%'})<cr>
nnoremap <leader>o :call fzf#run({'source': map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'), 'sink': 'e', 'down': '40%'})<cr>

" function! FuzzyCommand(choice_command, vim_command)
"   try
"     let selection = system(a:choice_command . " | fzy -l 18")
"   catch /Vim:Interrupt/
"     redraw!
"     return
"   endtry
"   redraw!
"   if v:shell_error == 0 && !empty(selection)
"     execute a:vim_command . " " . selection
"   endif
" endfunction

" nnoremap <leader>p :call FuzzyCommand("fd -t f .", ":e")<cr>

" function! FuzzyBuffer()
"   let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
"   let buffers = map(bufnrs, 'bufname(v:val)')
"   call FuzzyCommand('echo "' . join(buffers, "\n") . '"', ":b")
" endfunction

" nnoremap <leader>o :call FuzzyBuffer()<cr>

" }}}

" TrimTrailingWhitespace: {{{

if !&binary && &filetype != 'diff'
  autocmd bufwritepre * :%s/\s\+$//e
endif

" }}}

" Note: {{{

" ** Default vim key binding for autocomplete
" <c-x><c-f> for path completion
" <c-x><c-k> for dictionary conpletion
" <c-x><c-l> for whole line completion
" <c-x><c-o> for omnifunc completion
" <c-x><c-u> for completefunc completion
" <c-x><c-]> for tag conpletion
" <c-x><c-n> for keyword in current file
" <c-x><c-v> for vim command line
" <c-n> for completion for next match keyword
" <c-p> for completion for previous match keyword
" ** When stage is on option list
" <c-n> for next option
" <c-p> for previous option

" }}}

" github.com/clozed2u :: @clozed2u
" http://clozed2u.com

" Initialization: {{{

set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set nobomb

" }}}

" Plugin: {{{

let s:dein = 0

if !isdirectory($HOME.'/.vim/bundle/repos/github.com/shougo/dein.vim')
  silent !git clone https://github.com/shougo/dein.vim.git ~/.vim/bundle/repos/github.com/shougo/dein.vim
  let s:dein = 1
endif

set runtimepath+=$HOME/.vim/bundle/repos/github.com/shougo/dein.vim
call dein#begin(expand($HOME.'/.vim/bundle'))
call dein#add('shougo/dein.vim')
call dein#add('junegunn/fzf.vim')
call dein#add('wellle/targets.vim')
call dein#add('fatih/vim-go')
call dein#add('janko-m/vim-test')
call dein#add('sickill/vim-pasta')
call dein#add('vim-ruby/vim-ruby')
call dein#add('clozed2u/vim-noctu')
call dein#add('pangloss/vim-javascript')
call dein#add('strogonoff/vim-coffee-script')
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('tpope/vim-haml')
call dein#add('tpope/vim-rake')
call dein#add('tpope/vim-rails')
call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-bundler')
call dein#add('tpope/vim-markdown')
call dein#add('tpope/vim-dispatch')
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-commentary')

if s:dein == 1
  call dein#update()
endif

call dein#end()

filetype plugin indent on

" }}}

" Colors: {{{

set t_Co=256
set background=dark
syntax on

try
  colorscheme noctu
catch /:E185:/
  colorscheme default
endtry

" }}}

" Settings: {{{

set shell=$SHELL

" don't allow files with the same name to overwrite each other
set noswapfile
set writebackup
set backupdir=~/.vim/backup
set undofile
set undodir=~/.vim/undo
set directory=~/.vim/tmp
set tags=./tags;

set backspace=2
set laststatus=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent
set smartindent
set autoread
set autowrite
set autowriteall

set shortmess=atToOI
set viewoptions+=unix,slash

set wildmenu
set wildmode=list:longest
set wildignore=*.png,*.jpg,*gif,*.gem,*.so,*.swp,*.zip,*.gz,*DS_Store*,*sass-cache*,*/tmp/*,*node_modules*,*bower_components*,*vendor*,.composer/*,.gem/*,.git/*

set showmode
set showcmd
set showtabline=0
set hidden
set number
set ttyfast

set ignorecase
set smartcase
set infercase
set incsearch
set hlsearch
set noshowmatch
set matchtime=0

set splitbelow
set splitright
set nowrap
" set listchars=tab:▸\ ,eol:¬,trail:•,nbsp:.
set listchars=tab:▸\ ,eol:\ ,trail:•,nbsp:.
set list

set timeout
set timeoutlen=200
set ttimeout
set ttimeoutlen=0

set foldenable
set foldmethod=indent
set foldlevel=9999

set nocursorline
set nocursorcolumn

set omnifunc=syntaxcomplete#Complete
set completefunc=syntaxcomplete#Complete
set completeopt=longest,menuone

set scrolloff=5

set synmaxcol=0
set fillchars+=vert:\!

" }}}

" StatusLine: {{{

  " StatusFunction: {{{2

  function! Status(winnum)
    let active = a:winnum == winnr()
    let bufnum = winbufnr(a:winnum)

    let stat = ''

    " this function just outputs the content colored by the
    " supplied colorgroup number, e.g. num = 2 -> User2
    " it only colors the input if the window is the currently
    " focused one

    function! Color(active, group, content)
      if a:active
        return '%#' . a:group . '#' . a:content . '%*'
      else
        return a:content
      endif
    endfunction

    " this handles alternative statuslines
    let usealt = 0

    let type = getbufvar(bufnum, '&buftype')
    let name = bufname(bufnum)

    let altstat = ''

    if type ==# 'help'
      let altstat .= '%#SLHelp# HELP %* ' . fnamemodify(name, ':t:r')
      let usealt = 1
    endif

    if usealt
      return altstat
    endif

    " column
    "   this might seem a bit complicated but all it amounts to is
    "   a calculation to see how much padding should be used for the
    "   column number, so that it lines up nicely with the line numbers

    "   an expression is needed because expressions are evaluated within
    "   the context of the window for which the statusline is being prepared
    "   this is crucial because the line and virtcol functions otherwise
    "   operate on the currently focused window

    function! Column()
      let vc = virtcol('.')
      let ruler_width = max([strlen(line('$')), (&numberwidth - 1)]) + &l:foldcolumn
      let column_width = strlen(vc)
      let padding = ruler_width - column_width
      let column = ''

      if padding <= 0
        let column .= vc
      else
        let column .= repeat(' ', padding + 1) . vc
      endif

      return column . ' '
    endfunction

    let stat .= '%#SLColumn#'
    let stat .= '%{Column()}'
    let stat .= '%*'

    if getwinvar(a:winnum, 'statusline_progress', 0)
      let stat .= Color(active, 'SLProgress', ' %p ')
    endif

    " file name
    let stat .= Color(active, 'SLArrows', active ? '' : '')
    let stat .= ' %<'
    let stat .= '%f'
    let stat .= ' ' . Color(active, 'SLArrows', active ? '' : '')

    " file modified
    let modified = getbufvar(bufnum, '&modified')
    let stat .= Color(active, 'SLLineNr', modified ? ' +' : '')

    " read only
    let readonly = getbufvar(bufnum, '&readonly')
    let stat .= Color(active, 'SLLineNR', readonly ? ' ‼' : '')

    " paste
    if active
      if getwinvar(a:winnum, '&spell')
        let stat .= Color(active, 'SLLineNr', ' S')
      endif

      if getwinvar(a:winnum, '&paste')
        let stat .= Color(active, 'SLLineNr', ' P')
      endif
    endif

    " right side
    let stat .= '%='

    " git branch
    if exists('*fugitive#head')
      let head = fugitive#head()

      if empty(head) && exists('*fugitive#detect') && !exists('b:git_dir')
        call fugitive#detect(getcwd())
        let head = fugitive#head()
      endif
    endif

    if !empty(head)
      let stat .= Color(active, 'SLBranch', ' ← ') . head . ' '
    endif

    " syntax error
    if exists('*SyntasticStatuslineFlag')
      let stat .= '%#warningmsg#'
      let stat .= '%{SyntasticStatuslineFlag()}'
      let stat .= '%*'
    endif

    return stat
  endfunction

  " }}}

  " StatusAutocmd: {{{

  function! s:ToggleStatusProgress()
    if !exists('w:statusline_progress')
      let w:statusline_progress = 0
    endif

    let w:statusline_progress = !w:statusline_progress
  endfunction

  command! ToggleStatusProgress :call s:ToggleStatusProgress()

  function! s:IsDiff()
    let result = 0

    for nr in range(1, winnr('$'))
      let result = result || getwinvar(nr, '&diff')

      if result
        return result
      endif
    endfor

    return result
  endfunction

  function! s:RefreshStatus()
    for nr in range(1, winnr('$'))
      call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
    endfor
  endfunction

  command! RefreshStatus :call <SID>RefreshStatus()

  augroup status
    autocmd!
    autocmd VimEnter,VimLeave,WinEnter,WinLeave,BufWinEnter,BufWinLeave * :RefreshStatus
  augroup END

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

" Explorer: {{{

let g:netrw_liststyle=1
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_preview=1
let g:netrw_browse_split=0
let g:netrw_list_hide=&wildignore

" }}}

" OSSpecific: {{{

let s:kernel = system('echo -n "$(uname -s)"')

  " Mac: {{{2

  if s:kernel == 'Darwin'
    set clipboard=unnamed

  " }}}

  " Linux: {{{2

  elseif s:kernel == 'Linux'
    set clipboard=unnamedplus
  endif

  " }}}

" }}}

" Mappings: {{{

let mapleader = "\<space>"

  " Modes: {{{2

  nnoremap ; :
  nnoremap ! :!
  nnoremap <cr> :nohlsearch<cr>
  nnoremap <leader>; :ToggleStatusProgress<cr>
  inoremap <c-k> <c-w>

  vmap <  <gv
  vmap > >gv

  " }}}

  " Navigation: {{{2

  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l

  " }}}

" }}}

" File: {{{

augroup filetypespecific
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  autocmd filetype * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  autocmd filetype vim setlocal foldmethod=marker foldlevel=0
  autocmd filetype zsh setlocal foldmethod=marker foldlevel=0
  autocmd filetype php setlocal shiftwidth=4 tabstop=4 softtabstop=4 foldmethod=syntax
  autocmd filetype ruby setlocal foldmethod=syntax
  autocmd filetype make setlocal noexpandtab tabstop=4 softtabstop=4
  autocmd filetype python setlocal nosmartindent tabstop=4 softtabstop=4
  autocmd filetype javascript setlocal foldmethod=syntax
augroup END

" }}}

" PluginSettings: {{{

  " FZF: {{{2

  if executable('fzf')

    set runtimepath+=/usr/local/opt/fzf

    nnoremap <leader>p :Files<cr>
    nnoremap <leader>b :Buffers<cr>

  endif

  " }}}

  " Test: {{{2

  let g:test#strategy='neovim'
  let g:test#preserve_screen=1

  nmap <silent> <leader>t :TestNearest<cr>
  nmap <silent> <leader>f :TestFile<cr>
  nmap <silent> <leader>a :TestSuite<cr>
  nmap <silent> <leader>l :TestLast<cr>
  nmap <silent> <leader>g :TestVisit<cr>

  " }}}

" }}}

" Rename: {{{

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    execute ':saveas ' . new_name
    execute ':silent !rm ' . old_name
    redraw!
  endif
endfunction

map <leader>n :call RenameFile()<cr>

" }}}

" TrimTrailingWhitespace: {{{

if !&binary && &filetype != 'diff'
  autocmd BufWritePre * :%s/\s\+$//e
endif

" }}}

" Macvim: {{{

if has('gui_running')
  colorscheme xoria256
  set macligatures
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
  set guifont=Inconsolata-g:h14
endif

" }}}

" Note: {{{

"" Default vim key binding for autocomplete
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
"" When stage is on option list
" <c-n> for next option
" <c-p> for previous option

" }}}

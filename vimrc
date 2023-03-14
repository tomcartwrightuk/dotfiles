" Vundle setup
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'vim-scripts/c.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'keith/gist.vim'
Plugin 'nsf/gocode'
Plugin 'scrooloose/nerdtree'
Plugin 'rentalcustard/pbcopy.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'ervandew/supertab'
Plugin 'rking/ag.vim'
Plugin 'Chun-Yang/vim-action-ag'
Plugin 'alvan/vim-closetag'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'tpope/vim-rails'
Plugin 'thoughtbot/vim-rspec'
Plugin 'derekwyatt/vim-scala'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'elixir-lang/vim-elixir'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/webapi-vim'
Plugin 'sotte/presenting.vim'
Plugin 'vim-scripts/SyntaxRange'
Plugin 'elzr/vim-json'
Plugin 'tpope/vim-rhubarb'
Plugin 'janko-m/vim-test'
Plugin 'Lokaltog/vim-powerline'
Plugin 'godlygeek/tabular'
Plugin 'w0rp/ale'
Plugin 'gerrard00/vim-mocha-only'
if executable('scala')
  Plugin 'ensime/ensime-vim'
endif

call vundle#end()            " required
filetype plugin indent on    " required

" Basic setup
let mapleader=","
set t_Co=256 " Use 256 colors
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
set cursorline " highlight current line
set number " Show numbered lines
set ruler
set expandtab "turn tabs into whitespace
set visualbell " Turn off beeping
set synmaxcol=128 " set syntax highlighting up to 128 columns only

" Appearance
colorscheme solarized
set background=dark
set winheight=30
set winminheight=5
set winwidth=80
set winminwidth=30
let g:solarized_termcolors=256
let g:solarized_termtrans=1

let g:UltiSnipsSnippetsDir="~/.vim/bundle/ultisnips/UltiSnips"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="c-tab>"
filetype plugin indent on
" Formatting for rust
let g:rustfmt_autosave = 1

syntax on
filetype plugin indent on

" Movement around the program
nnoremap <C-m> :bnext<CR>
nnoremap <C-n> :bprev<CR>
:map <C-'> :sp<ENTER>
:map <C-\> :vs<ENTER>
map <C-t> :tabnew<return>
map <S-l> :tabnext<return>
map <S-h> :tabprevious<return>
map <C-c> gcc
map <C-x> gcu
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
noremap <leader>fw :FixWhitespace<CR>

" Moving around windows
nnoremap <S-C-h> <C-W>h
nnoremap <S-C-j> <C-W>j
nnoremap <S-C-k> <C-W>k
nnoremap <S-C-l> <C-W>l

" Yanking the text
noremap <leader>y "*y
noremap <leader>yy "*Y

" Run tests in quickfix
let g:rubytest_in_quickfix = 1

set showtabline=2

function! OpenWithSpecs(filename)
  let l:filename=a:filename
  let l:specname = substitute(filename, "^app/\\(.*\\).rb$", "spec/\\1_spec.rb", "")
  echo specname
endfunction

function! OpenVerticalSpec()
  let l:filename=bufname("%")
  let l:specname = substitute(filename, "app/\\(.*\\).rb$", "spec/\\1_spec.rb", "")
  exec 'vsplit '.specname
endfunction

command! -complete=file -nargs=1 SpecEdit call OpenWithSpecs("<args>")
cabbrev spe SpecEdit
command! Spev call OpenVerticalSpec()
cabbrev spev Spev

" set clipboard+=unnamed
map <C-y> :PBCopy<ENTER>
" Set block cursor on normal and visual modes
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

let s:os = system("uname")
if s:os =~ "Darwin"
  let g:Grep_Xargs_Options='-0'
endif
cabbrev rgrep Rgrep

" Add Quickfix window list to args list
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(values(buffer_numbers))
endfunction

" Syntastic setup
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Put this in vimrc or a plugin file of your own.
" " After this is configured, :ALEFix will try and fix your JS code with
" ESLint.
"
" " Set this setting in vimrc if you want to fix files automatically on save.
" " This is off by default.
let g:ale_fix_on_save = 1

" If in an ovo org use different linting
let j3tdir = matchstr(getcwd(), 'ovo')
if empty(j3tdir)
  set tabstop=2 "set tabs to two spaces
  set shiftwidth=2 "indent width for autoindent
  " Loading standardjs linter
  let g:ale_fixers = {'javascript': ['prettier_standard']}
  let g:ale_linters = {'javascript': ['']}
  let g:ale_fix_on_save = 1
else
  " Loading just3things linter
  let g:ale_javascript_eslint_use_global = 1
  let g:ale_linters = {
  \   'javascript': ['eslint'],
  \}

  let g:ale_fixers = {
  \   'javascript': ['eslint'],
  \}
  set tabstop=4 "set tabs to 4 spaces
  set shiftwidth=4 "indent width for autoindent
endif

" Testing and debugging
nnoremap <F6> :execute "Dispatch ".b:dispatch.":".line(".")<CR>
nnoremap <F7> :execute "Focus ".b:dispatch<CR>
nnoremap <F8> :Focus!<CR>
nnoremap <F9> :Dispatch<CR>
augroup dispatchsetup
  autocmd!
  autocmd BufNewFile,BufRead *_spec.rb let b:dispatch = 'rspec %'
  autocmd BufNewFile,BufRead *_test.rb let b:dispatch = 'testrb %'
  autocmd FileType cucumber let b:dispatch = 'cucumber %'
  autocmd BufNewFile,BufRead *_spec.js let b:dispatch = 'jasmine-node %'
augroup END

function! FilterSpec()
  let ln = line(".")
  execute ln . "s/ do/, focus: true do/g"
endfunction

function! UnfilterSpec()
  let ln = line(".")
  execute ln . "s/, focus: true / /g"
endfunction

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>fs :call FilterSpec()<CR>
map <Leader>us :call UnfilterSpec()<CR>
" Add .only to a mocha test
nnoremap <Leader>mo :MochaOnlyToggle<CR>

" pry
let @g = "Orequire \"pry\"; binding.pry"

" Moving lines up and down alt-j and alt-k
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" set and unset paste
nnoremap π :set paste<CR>
nnoremap ∏ :set nopaste<CR>
inoremap π <Esc>:set paste<CR>gi
inoremap ∏ <Esc>:set nopaste<CR>gi

" Handling backups
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set shortmess+=A "Don't warn about swap files

"Rgrep setup
set grepprg=grep\ -nrI\ --exclude-dir=target\ --exclude-dir=tmp\ --exclude-dir=log\ --exclude="*.min.js"\ --exclude="*.log"\ $*\ /dev/null

" Display settings
" Display 80 char line
set colorcolumn=80
set statusline+=%F

" File format handling
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
command! Jsonf %!python -m json.tool

"Vim go setup
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" ABC
let g:closetag_filenames = "*.html,*.xhtml,*.phtml"

" Ag
cabbrev ag Ag

" Ensime config
nnoremap <Leader>tc :EnTypeCheck<CR>
au FileType scala nnoremap <Leader>df :EnDeclaration<CR>
au FileType scala nnoremap <Leader>ti :EnInspectType<CR>
au FileType go nnoremap <Leader>df :GoDef<CR>

" Make ctrl p faster by delegating to ag
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'

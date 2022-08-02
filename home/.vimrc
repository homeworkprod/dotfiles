set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
"Plug 'altercation/vim-colors-solarized'
"Plug 'chriskempson/base16-vim'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'fholgado/minibufexpl.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'lepture/vim-jinja'
Plug 'morhetz/gruvbox'
Plug 'NoahTheDuke/vim-just'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

set wildmenu
set ruler           " Koordinatenanzeige in Statuszeile aktivieren
set cursorline
set showmode        " Editmodus-Anzeige in Statuszeile (rechts oder links unten)
set report=0        " Hinweis in Statuszeile ab N geänderte/gelöschte/eingefügte Zeilen
set showcmd         " Kommando-Wiederholungsfaktoren und Teilkommandos in Statuszeile anzeigen
set number          " Zeilennummern anzeigen
set nowrap
set showbreak=>     " Zeilenanfangmarkierung für zu lange Zeilen, die umgebrochen dargestellt werden
set wrapmargin=0    " Bildschirmrand, innerhalb dem während Texteingabe umgebrochen wird (0=aus)

" Bei Fehlern (z.B. 2x ESC) nicht piepsen, sondern visuelle Anzeige
set noerrorbells
set visualbell

set nobackup
set noswapfile

" Suche NICHT case-senitiv, außer ein Grossbuchstabe steht im Suchmuster
" SmartCase, SMARTcase, smartCASE, SmArTcAsE, sMaRtCaSe, smartcase
set ignorecase
set smartcase

" Remove toolbar.
set guioptions-=T

" Configure taglist.
let Tlist_Compact_Format=1
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=0
map <F8> :TlistToggle<CR>

" File Browser
let g:netrw_banner=0
let g:netrw_list_hide='.*\.py[co]'
let g:netrw_liststyle=1
map <F9> :Explore<CR>

" MiniBufExplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 

" Switch between buffers.
map <A-Left> :bprev!<CR>
map <A-Right> :bnext!<CR>

set clipboard=unnamedplus

" Programmieren
" -------------

set enc=utf-8

" Display certain whitespace characters (see `:help listchars` and `:dig`).
" Toggle with `:set list!`.
set listchars=eol:¶,tab:»·,trail:·,extends:»,precedes:«

setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
set showmatch   " zugehörige Klammer anzeigen
set smarttab
"set smartindent
set foldenable

filetype plugin indent on
syntax enable

set tabstop=4
set shiftwidth=4
set expandtab

" Search
" ------
set incsearch
set hlsearch

" Clear search highlights on <esc>.
nnoremap <esc> :noh<return><esc>

map <c-p> :Files<CR>
map <c-g> :Rg<CR>

let g:lightline = { 'colorscheme': 'seoul256' }

" colors
syntax on
"colorscheme darkblue
"colorscheme solarized
colorscheme gruvbox
set background=dark

" Disable cursor blinking.
set gcr=a:blinkon0

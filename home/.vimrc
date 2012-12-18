set nocompatible

call pathogen#infect()

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

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

" Programmieren
" -------------

set enc=utf-8

" Display certain whitespace characters (see `:help listchars` and `:dig`).
" Toggle with `:set list!`.
set listchars=eol:¶,tab:»·,trail:·,extends:»,precedes:«

setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
set showmatch   " zugehörige Klammer anzeigen
set smarttab
set smartindent
set foldenable

set tabstop=4
set shiftwidth=4
set expandtab

" colors
syntax on
"colorscheme darkblue
colorscheme solarized
set background=dark

" Disable cursor blinking.
set gcr=a:blinkon0

" Set local leader to ``,,`` (especially for Vim Outliner).
let maplocalleader = ",,"  " (should be set in /etc/vim/vimoutlinerrc)

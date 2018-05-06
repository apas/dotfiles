syntax enable                   " Enable syntax highlighting

" Enable all Pathogen plugins
execute pathogen#infect()

set encoding=utf8               " Set UTF-8 encoding
set autoread                    " Reload files changed outside vim
set nocompatible                " Use vim rather than vi settings
set backspace=indent,eol,start  " Allow backspace in insert mode
set number                      " Line numbers are good
set ttyfast                     " Faster term redrawing, scrolling; perhaps
set nobackup                    " Disable file backups when writing files
set nowritebackup               " Don't backup before overwriting files
set expandtab                   " Use the appropriate number of spaces to tab
set smarttab                    " A tab in front of a line inserts spaces
set shiftwidth=4                " # of spaces to use for autoindent
set tabstop=4                   " # of spaces that a tab counts for
set textwidth=80                " Make all lines 80 chars or less
set wrap                        " Wrap lines longer than 80 chars 
set linebreak                   " Wrap lines when convenient
set nojoinspaces                " Set 1 space btwn lines/periods to be joined
set scrolloff=999               " Working line will always be in the center
set title                       " Set title of the Vim window
set titleold=                   " Revert to original title when exiting
set hlsearch                    " Highlight searches by default
set noshowmode                  " Don't show current mode [bc Lightline]
set noshowcmd                   " Don't show incomplete cmds [bc Lightline]
set laststatus=2                " Always show status bar
set autoindent                  " Use existing indent depth starting a new line
set smartindent                 " Do smart indenting when starting a new line
set ttimeoutlen=1               " Exit insert/visual mode without ESC delay
set digraph                     " Support special characters, eg German umlaut
set background=light            " Set solarized background color
colorscheme solarized           " Set solarized colorscheme

" Set search results to white font, red background overriding solarized
autocmd ColorScheme * hi Search cterm=NONE ctermfg=white ctermbg=red

" Set Make tabs to tabs and not spaces
filetype on
autocmd FileType make set noexpandtab shiftwidth=4

" Expand textwidth char limit column
let &colorcolumn=join(range(81,335),",")
" Slightly change background color of expanded textwidth char column
highlight ColorColumn ctermbg=lightgrey

" Show current cursor line
set cursorline
" Color highlight current cursor line
highlight CursorLine ctermbg=lightgrey cterm=NONE

" Color highlight line numbers
highlight LineNr ctermfg=NONE
" Color highlight current cursor line number
highlight CursorLineNr ctermfg=brown

" Map yanking in visual mode to system's copy
map <C-c> "*y

" Map toggle automatic line comment (a la ST3)
map <C-/> gcc

" Map insert line above current line and exit insert mode (a la ST3)
nnoremap <S-o> O<ESC>

" Clear previous search highlights
" <C-l> would originally redraw the screen; now we first clear, then redraw
nnoremap <C-l> :nohl<CR><C-L>

" Customize Lightline with a minimal set of configs + current git branch
let g:lightline = {
\ 'colorscheme': 'solarized',
\ 'active': {
\   'left': [['mode', 'paste'], ['gitbranch'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent']]
\   },
\ 'component_function': {
\   'gitbranch': 'gitbranch#name'
\   },
\ }

" Persisent undo --- store all change information in an undodir
" Check if an undodir exists, otherwise create it w proper permissions
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "", 0700)
endif
set undodir=$HOME/.vim/undodir  " Set undodir path
set undofile                    " Write changes to the undofile
set undolevels=1000             " Max # of changes that can be undone
set undoreload=10000            " Max # of lines to save for undo on buf reload

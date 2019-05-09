" Enable all Pathogen plugins
execute pathogen#infect()
let iterm_profile = $ITERM_PROFILE

syntax on                      " Enable syntax highlighting
if iterm_profile == "Dark"
    set background=dark
else
    set background=light        " Set solarized background color
endif
colorscheme solarized           " Set solarized colorscheme
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
set undodir=$HOME/.vim/undodir  " Set persistent undodir path
set undofile                    " Write changes to the undofile
set undolevels=1000             " Max # of changes that can be undone
set undoreload=10000            " Max # of lines to save for undo on buf reload
set directory=$HOME/.vim/swp//  " Write swap files in one directory, unique nms
set splitright                  " Splitting will put the new window right
set splitbelow                  " Splitting will put the new window below

" Customise git gutter settings
set updatetime=10
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '━'
let g:gitgutter_sign_removed_first_line = '━'
let g:gitgutter_sign_modified_removed = '┳'

" Set search results to white font, red background overriding solarized
autocmd ColorScheme * hi Search cterm=NONE ctermfg=white ctermbg=red

" Set Make tabs to tabs and not spaces
filetype on
autocmd FileType make set noexpandtab shiftwidth=4

" Close open buffer without closing window split
command BD bp|bd #

" Efficient saving and closing with using leader key
nnoremap <leader>q :q!<cr>
nnoremap <leader>z :wq<cr>
nnoremap <leader>w :w<cr>

" Color highlight line numbers
highlight LineNr ctermfg=NONE
" Color highlight current cursor line number
highlight CursorLineNr ctermfg=brown

" Map yanking in visual mode to system's copy
vnoremap <C-c> "*y

" Map toggle automatic line comment (a la ST3)
nnoremap <C-/> gcc

" Map insert line above current line and exit insert mode (a la ST3)
nnoremap <S-o> O<ESC>

" Clear previous search highlights
" <C-l> would originally redraw the screen; now we first clear, then redraw
nnoremap <C-l> :nohl<CR><C-L>

" Provide my `pub` shell script as a Vim command
" Build LaTeX PDFs from Markdown with Pandoc
" No need for `Ctrl-z` and `fg` any more
command Pdf execute "w | silent !pub -d % &" | silent redraw!
command Tufte execute "w | silent !pub -t % &" | silent redraw!

" Custom status line mode dictionary
let g:cmode={
  \ 'n' : 'NORMAL',
  \ 'v' : 'VISUAL',
  \ 'V' : 'VISUAL',
  \ 'i' : 'INSERT'
  \ }

" Custom status line - current mode buffer path modified column lines
set statusline=%1*
set statusline+=%{(g:cmode[mode()])}
set statusline+=\ \[%n]
set statusline+=\ %<%F\ %m
set statusline+=%=
set statusline+=%c%10(%l/%L%)%10(%p%%\%)

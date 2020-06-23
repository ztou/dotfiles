" Gotta be first
set nocompatible
let mapleader = ","


filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')

Plugin 'gmarik/Vundle.vim'

" ----- Making Vim look good ------------------------------------------
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'scrooloose/syntastic'
"Plugin 'jistr/vim-nerdtree-tabs'
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'myusuf3/numbers.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'jiangmiao/auto-pairs'


call vundle#end()

if has('win32')
    source $VIMRUNTIME/mswin.vim
endif

filetype plugin indent on

" --- General settings ---
syntax on

if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
	set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
	set clipboard=unnamed
    endif
endif

"When included, Vim will use the clipboard register '*' for all yank, delete, change and put operations which
"set clipboard+=unnamed
nmap <C-c> :let @* = expand("%:p")<CR>

"Copy paste to/from clipboard
vnoremap <C-c> "*y
vnoremap <C-v> "*p


" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

if has('win32')
  set guifont=Fira\ Code:h15
else
  set guifont=Menlo\ Regular\ for\ Powerline:h11
  "set guifont=Source_Code_Pro_for_Powerline:h13
endif
set guifont=Fira\ Code\ Retina:h13

set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
"clear the search
nnoremap <silent> <leader>, :noh<cr> " Stop highlight after searching

set encoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936
set guioptions-=m
set guioptions-=T
set formatoptions=ntql
set cursorline
hi cursorline ctermbg=darkgrey
set complete=.,w,b,
set nofoldenable
set nospell
" disable swap file
set noswapfile
"set lines=30
"set columns=120


set wrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent

set mouse=a                 	" Automatically enable mouse usage
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)


set autoread                    " Reload files changed outside vim
" Trigger autoread when changing buffers or coming back to vim in terminal.
"au FocusGained,BufEnter * :silent! !

map <silent><Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>"
map <silent><Leader><S-p> :set paste<CR>O<esc>"*]p:set nopaste<cr>"
" ----- Plugin-Specific Settings --------------------------------------

" ----- altercation/vim-colors-solarized settings -----
" Toggle this to "light" for light colorscheme
set background=dark

" Set the colorscheme
if has('gui_running')
    colorscheme solarized
    let g:solarized_termtrans = 0
    let g:solarized_visibility =  "low"

    " Uncomment the next line if your terminal is not configured for solarized
    " let g:solarized_termcolors=256
endif

" autocmd BufEnter * silent! lcd %:p:h

" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2
let g:airline#extensions#tagbar#enable = 0

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
"nmap <silent> <leader>t :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
nmap <silent> <F2> :NERDTreeToggle<CR>
nmap <silent> <C-n> :NERDTree %<CR>

let NERDTreeChDirMode=2
let NERDTreeMouseMode=3

" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1


" ----- majutsushi/tagbar settings -----
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>
nmap <silent> <F3> :TagbarToggle<CR>
let g:tagbar_show_linenumbers = 1
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)


"-----ctrlp settings -------
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/Applications/*,*/\.git/*
let g:ctrlp_custom_ignore = { 'dir':  '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll)$' }
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=25
let g:ctrlp_mruf_max=250
let g:ctrlp_follow_symlinks=1
let g:ctrlp_clear_cache_on_exit=0
let g:ctrlp_cmd = 'CtrlPMRU'


" ----- syntastic -----
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0


" ----------YouCompleteMe----------------
"let g:ycm_global_ycm_extra_conf='D:/Dropbox/opt/Vim/ycm/.ycm_extra_conf.py'

"----- A.vim ------
let g:alternateNoDefaultAlternate = 1
nmap <tab> :A<CR>
"}
"
"
"
" =============key binding==============
"
" replace \ with /
map <Leader>/ :s#\\#\/#g<CR>

" replace / with \
map <Leader>\ :s#/#\\#g<CR>


"Json"{
map <Leader>j <Esc>:set filetype=json<CR>:%!python -m json.tool<CR>
"}

nmap <Leader>f =a{<CR>

nmap <C-q> :wq!<CR>
nmap <A-q> :q!<CR>

nmap <Leader>h :%! xxd<CR>
nmap <Leader>n :%! xxd -r<CR>
nmap <Leader>r :source ~\.vimrc<CR>
nmap <Leader>e :e ~\.vimrc<CR>

nmap <Leader>d :e ++ff=dos<CR>
nmap <Leader>u :e ++ff=unix<CR>

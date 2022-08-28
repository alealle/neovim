"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author:
"       Alessandro Alle
"
" Sections:
"    => Plugins
"      -> Installation with vim plug
"      -> Configuration and mapping
"    => Settings
"        -> NeoVIM user interface
"        -> Colors and Fonts
"        -> Files and backups
"        -> Text, tab and indent related
"    => Mappings
"       -> All
"           :> Buffers
"           :> Tabs
"           :> Windows
"       -> Insert mode
"       -> Visual mode
"       -> Command line
"       -> vimgrep searching and cope displaying
"       -> Spell checking
"    => Misc
"    => Status line
"    => Helper functions
"    => Compilation with F5
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
let mapleader = ","

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" -> Installation with vim plug
call plug#begin('~/.config/nvim/plugins')
" call plug#begin('~/.vim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
call plug#end()

" -> Configuration and mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"-> NeoVim user interface
" Sets how many lines of history has to remember
set history=500

" Always show current position
set ruler

" Set number
set relativenumber
set nu

" Ignore case when searching
" set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

"Enable incremental command: see live effects of substitutions in a split window
set icm=split

" Don't redraw while executing macros good performance config
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=700

" Command line height
set cmdheight=2

" Add a bit extra margin to the left
set foldcolumn=1

" Add a sign column to facilitate Lint signaling syntax errors etc
set signcolumn=yes

" Alert if editing goes further column 80
set colorcolumn=80

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Set to auto read when a file is changed from the outside
set autoread
augroup ChekTime
    autocmd!
    au FocusGained,BufEnter * checktime
augroup END

" A buffer becomes hidden when it is abandoned
set hidden

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" -> Colors and Fonts
"Syntax theme: use true color and winblend if available
if exists("&termguicolors") && exists("&winblend")
    " Enable syntax highlighting
    syntax enable
    set termguicolors
    set winblend=0
    set wildoptions=pum
    set pumblend=5
endif

" Use gruvbox colors
colorscheme gruvbox
set background=dark

"' Set cursor to bar in insert modee
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"

" Set highlight line when in insert mode
augroup InsertLine
    :autocmd!
    :autocmd InsertEnter * set cul
    :autocmd InsertLeave * set nocul
augroup END

" -> Files, backups and undo

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Turn persistent undo on means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.config/nvim/undo-dir
    set undofile
catch /Cannot open/
    echo "Unable to open undo-dir!!!"
endtry

" Writes buffer when new buffer opened and in other cases
" where some distration may result in data loss - seen help
set autowrite

" -> Text, tab and indent related
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set nowrap "nowrap lines

" Let scroll off when close to end of lines to keep view more centered
set scrolloff=8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" -> All modes
" Remap VIM 0 to first non-blank character
nnoremap 0 ^
" Disable highlight when <leader><cr> is pressed
nnoremap <silent> <leader><cr> :noh<cr>

" :> Buffers
" Close the current buffer
nnoremap <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
nnoremap <leader>ba :bufdo bd<cr>

noremap <leader>bn :bnext<cr>
noremap <leader>bp :bprevious<cr>
noremap <leader>B :buffers<cr>
noremap <leader>bm :buffer<space>

let i = 1
while i <= 9
    execute "nnoremap <leader>bg" . i . " :" . i . "buffer<cr>"
    let i = i + 1
endwhile

" Switch CWD to the directory of the open buffer
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" :> Tabs
" Useful mappings for managing tabs
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove
noremap <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
augroup LastTab
    au!
    au TabLeave * let g:lasttab = tabpagenr()
augroup end

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" :> Windows
" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Move around windows using numbers
let i =1
while i <= 9
    execute "nnoremap <C-W>" . i . " :" . i . "wincmd w<cr>"
    let i = i + 1
endwhile

" -> Normal mode
" Fast saving
nnoremap <leader>w :w!<cr>
nnoremap <leader>wa :wa!<cr>

"Always perform very magic search
nnoremap / /\v
nnoremap <leader>:s :%s /\v//g<left><left><left>

" Make sure that enter is never overriden in the quickfix window
autocmd! BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <leader>mj mz:m+<cr>`z
nmap <leader>mk mz:m-2<cr>`z
vmap <leader>mj :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>mk :m'<-2<cr>`>my`<mzgv`yo`z

" Or, simpler shortcuts:
nnoremap - ddp
nnoremap _ dd2kp

" Insert date
noremap <leader>D :put =strftime('%Y-%m-%d %H:%M:%S%z')

" Surround text with simbol
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel

" Edit init.vim
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source init.vim
nnoremap <leader>sv :source $MYVIMRC<cr>

" -> Insert mode
" Closing parenthesis. escape it using ctrl + v before typing the mapped char like ( { etc
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

" Bash like keys for the command line
inoremap <C-A>	<Home>
inoremap <C-E>	<End>

" Foward delete
inoremap <C-d>  <C-o>x

" Delete all line
inoremap <C-l> <C-o>dd

" Delete all line until the cursor: use CTRL-u that is the system default
" Replace current line
inoremap <C-e> <esc>ddO

" Windows CRTL-Z
inoremap <C-z> <C-o>u

"Re-map jk to go to normal mode
inoremap jk <esc>

" -> Visual mode related

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Move a line of text using ALT+[jk] or Command+[jk] on mac
vmap <leader>mj :m'>+<cr>`<my`>mzgv`yo`z
vmap <leader>mk :m'<-2<cr>`>my`<mzgv`yo`z

" vnoremap $1 <esc>`>a)<esc>`<i(<esc>
" vnoremap $2 <esc>`>a]<esc>`<i[<esc>
" vnoremap $3 <esc>`>a}<esc>`<i{<esc>
" vnoremap $$ <esc>`>a"<esc>`<i"<esc>
" vnoremap $q <esc>`>a'<esc>`<i'<esc>
" vnoremap $e <esc>`>a`<esc>`<i`<esc>

" -> Command mode
" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cnoremap $q <C-\>eDeleteTillSlash()<cr>


" Bash like keys for the command line
cnoremap <C-A>	<Home>
cnoremap <C-E>	<End>

"cnoremap <C-P> <Up>
"cnoremap <C-N> <Down>

" Smart mappings on the command line
cnoremap $h e ~/
cnoremap $d e ~/Desktop/
cnoremap $j e ./
cnoremap $c e <C-\>eCurrentFileDir("e")<cr>

" -> Grep and Vimgrep searching and cope displaying

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand('<cWORD>')) . " ."<cr>:copen<cr>
nnoremap <leader>gw :silent execute "grep! -R " . shellescape(expand('<cword>')) . " ."<cr>:copen<cr>

" -> Spell checking
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Command for all groups
augroup file_all
    autocmd!
    " Disable comment sign insertion in a new line after C-r in a comment line
    autocmd FileType * set formatoptions=jcql
    autocmd FileType * set foldlevelstart=0
augroup END

" Commands specific for .vim files
augroup filetype_vim
    au!
    au FileType vim setlocal foldmethod=marker
augroup END

" Delete trailing spaces for certain file types
if has("autocmd")
    autocmd! BufWritePre *.txt,*.js,*.py,*.c,*.cpp,*.cs,*.h,*.md,*.vim : call CleanExtraSpaces()
endif
" ,*.js,*.py,*.wiki,*.sh,*.coffee,*.vim,*.c,*.cpp,
"                \*.cs, *.dat,*.h, *.md
" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" Always show the status line
set laststatus=2

" status bar colors
augroup StatusBarCol
    au!
    au InsertEnter * hi statusline guibg=black guifg=#00d700 ctermfg=black ctermbg=green
    au InsertLeave * hi statusline guibg=black guifg=#8fbfdc ctermfg=black ctermbg=cyan
    au ModeChanged *:[vV\x16]* hi statusline guibg=black guifg=pink ctermfg=black ctermbg=magenta
    au ModeChanged [vV\x16]*:* hi statusline guibg=black guifg=#8fbfdc ctermfg=black ctermbg=cyan
augroup END

hi statusline guibg=black guifg=#8fbfdc ctermfg=black ctermbg=cyan

" Status Line Custom
let g:currentmode={
            \ 'n'  : 'Normal',
            \ 'no' : 'Normal·Operator Pending',
            \ 'v'  : 'Visual',
            \ 'V'  : 'V·Line',
            \ '^V' : 'V·Block',
            \ 's'  : 'Select',
            \ 'S'  : 'S·Line',
            \ '^S' : 'S·Block',
            \ 'i'  : 'Insert',
            \ 'R'  : 'Replace',
            \ 'Rv' : 'V·Replace',
            \ 'c'  : 'Command',
            \ 'cv' : 'Vim Ex',
            \ 'ce' : 'Ex',
            \ 'r'  : 'Prompt',
            \ 'rm' : 'More',
            \ 'r?' : 'Confirm',
            \ '!'  : 'Shell',
            \ 't'  : 'Terminal'
            \}
"
" Format the status line
set statusline=
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%1*%{StatuslineGit()}
set statusline+=%2*\%{HasPaste()}
set statusline+=%3*\%{expand('%:~:h')}/
set statusline+=%4*\%t\%m%r%h%w\          " File name, modified, readonly, helpfile, preview
set statusline+=%5*\ %y
set statusline+=\%<\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\%<\[%{&fileformat}\]
set statusline+=%= " Switch to the right side
set statusline+=%6*\ %<CWD>\ \%{expand('%:~:h')}\/
set statusline+=%7*\ %3p%%\       " % of file
set statusline+=%3*\ %4l:%2c\      " Current line
set statusline+=%8*\ %2n\         " Buffer number

hi User1 ctermfg=black ctermbg=green guibg=#444444 guifg=#d78700
hi User2 ctermfg=yellow ctermbg=black guibg=#ff8700 guifg=#444444
hi User3 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User4 ctermfg=black ctermbg=yellow guifg=#444444 guibg=#af8700
hi User5 ctermfg=yellow ctermbg=black guibg=#444444 guifg=#ffd700
hi User6 ctermfg=cyan ctermbg=black guibg=#d7ffff guifg=#444444
hi User7 ctermfg=007 ctermbg=236 guifg=#303030 guibg=#adadad
hi User8 ctermfg=007 ctermbg=yellow guibg=#af8700 guifg=#444444


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Grep mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    endif
    return ''
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! :%s/\s\+$//g
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':""
endfunction

func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

" Don't close window, when deleting a buffer
autocmd! BufDelete call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   => Compilation with F5
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
"
"   Following file contains the commands on how to run the currently open code.
"   The default mapping is set to F5 like most code editors.
"   Change it as you feel comfortable with, keeping in mind that it does not
"   clash with any other keymapping.
"
"   NOTE: Compilers for different systems may differ. For example, in the case
"   of C and C++, we have assumed it to be gcc and g++ respectively, but it may
"   not be the same. It is suggested to check first if the compilers are installed
"   before running the code, or maybe even switch to a different compiler.
"
"   NOTE: Adding support for more programming languages
"
"   Just add another elseif block before the 'endif' statement in the same
"   way it is done in each case. Take care to add tabbed spaces after each
"   elseif block (similar to python). For example:
"
"   elseif &filetype == '<your_file_extension>'
"       exec '!<your_compiler> %'
"
"   NOTE: The '%' sign indicates the name of the currently open file with extension.
"         The time command displays the time taken for execution. Remove the
"         time command if you dont want the system to display the time
"
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F5> :call CompileRun()<CR>
imap <F5> <Esc>:call CompileRun()<CR>
vmap <F5> <Esc>:call CompileRun()<CR>

func! CompileRun()
    exec "w"
    if &filetype == 'c'
        exec "!gcc % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %"
    elseif &filetype == 'sh'
        exec "!time bash %"
    elseif &filetype == 'python'
        exec "!time python3 %"
    elseif &filetype == 'html'
        exec "!google-chrome % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'matlab'
        exec "!time octave %"
    endif
endfunc

" -> Commenting
"  :autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
augroup CommentGroup
    autocmd! FileType
    autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>$
    autocmd FileType javascript nnoremap <buffer> <localleader>c I// <esc>$
    autocmd FileType vim nnoremap <buffer> <localleader>c I<C-O>" <esc>
    autocmd FileType c nnoremap <buffer> <localleader>c I/<esc>$
    autocmd FileType html nnoremap <buffer> <localleader>c 0i<!<esc>$a/><esc>$
augroup END

" Return to last edit position when opening files (You want this!)
augroup LastPosition
    au! BufReadPost
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

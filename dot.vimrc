
"
" VIM Configuration file
" Author: Vaibhav Gupta
" Email:  vaibhav.gupta@gmail.com
"

set nocompatible              " be iMproved, required
filetype off                  " required
set clipboard=exclude:.*

"
" Vundle Settings : Load Modules
"
"
" cd ~/.vim/bundle && \
" git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
"

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'kien/ctrlp.vim.git'
Plugin 'scrooloose/nerdtree.git'
Plugin 'scrooloose/nerdcommenter'
Plugin 'elixir-editors/vim-elixir.git'
Plugin 'vim-syntastic/syntastic.git'
Plugin 'rust-lang/rust.vim'
Plugin 'junegunn/seoul256.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/fzf'
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-erlang/vim-erlang-runtime'
Plugin 'jceb/vim-orgmode'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-fugitive.git'
Plugin 'racer-rust/vim-racer'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" TODO
:execute pathogen#infect()

"
" You Complete me
"
if filereadable("./.ycm_extra_conf.py")
        "let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
        let g:ycm_confirm_extra_conf = 0

        " Additional autocomplete settings
        let g:ycm_complete_in_comments = 0
        let g:ycm_complete_in_strings = 1
else
        let g:loaded_youcompleteme = 1
endif

"
" Basic settings and mappings
"
syntax on
filetype plugin indent on    " required
filetype plugin on
set runtimepath^=~/.vim/bundle/vim-erlang-compiler
set nocp
set autowrite
set hlsearch
set incsearch
set textwidth=80
set history=1000
set splitright
set ruler
set showcmd
set showmatch
"set cursorline
set smartcase
set hidden             " Hide buffers when they are abandoned
set report=0
set wildmode=list:longest
set wildmenu
set winheight=9999
set so=5
set cmdheight=2
set nu

set backspace=indent,eol,start
"set completeopt-=preview
"set autoindent

" TODO
" :autocmd FileType * set formatoptions=tcql
" \ nocindent comments&
" :autocmd FileType c,cpp set formatoptions=croql
" \ cindent comments=sr:/*,mb:*,ex:*/,://


" Open tag in new tab
"map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap <F2> :'<,'>s/^/\/\/ /g<CR>
nmap <F3> <ESC>:mkview<CR>
nmap <F4> <ESC>:loadview<CR>
nmap <F5> :TlistToggle<CR>
nmap <F6> /}<CR>zf%<ESC>:nohlsearch<CR>

command -nargs=* Make make <args> | cwindow 5
"map <F9> :w<CR>:Make %< <CR> <CR>
map <F9> :make <CR>
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

"nmap <buffer> <CR> 0ye<C-W>w:tag <C-R>"<CR>z<CR><C-W><C-W># " press enter on tag name
"nmap <buffer> <CR> 0ye:! showgraph.sh <C-R>"  1 >/dev/null & <CR><CR>
":set mouse=a           " Enable mouse usage (all modes) " NOT GOOD
imap <silent> ,, <ESC>"_yiw:s/\(\%#\w\+\)/<\1> <\/\1>/<cr><c-o><c-l>f>a<cr><cr><UP><tab>

nmap ll :cl<CR>
nmap l; :cn<CR>
nmap lk :cp<CR>

" For reindexing the tags for omni completion.

"
" My Helper functions
"

" VIM with .py files.
function Setup_python_opts()
        "set cinoptions=:0,l1,t0,g0,(0
        set cindent
        set shiftround
        set autoindent
        set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        "set equalprg=/home/tushar/python/Python-2.7.13/Tools/scripts/reindent.py
endfunction

" VIM with .note files.
function Setup_note_opts()
        set nu
        setlocal spell spelllang=en_us
        set complete+=s
        set textwidth=80
        setlocal wrap
        set noexpandtab
        "match ColourYellow /^[^\t].*$/
endfunction

" VIM with c files.
function Setup_c_opts()
        set cino+=(0            " align function call breaks
        set cinoptions+=:0      " align switch, case
        set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
        set smartindent
        set autoindent
        set cindent
endfunction

function FoldComments()
        set foldmarker=/*,*/
        set foldmethod=marker
        silent! zx
endfunction

function DateInsert()
        .!date
endfunction

function FoldFunction()
        set foldmarker={,}
        set foldmethod=marker
        silent! zx
endfunction

function ShowGraph()
        let l:word = expand(expand("<cword>"))
        let execmd = 'showgraph.sh ' . l:word
        execute '!'.execmd.' &'
endfunction

function FindCalling()
        let l:word = expand(expand("<cword>"))
        let gf_s = &grepformat
        let gp_s = &grepprg
        let &grepformat = '%f\ %m\ %l'
        let &grepprg = 'findcalling.sh ' . l:word
        write
        silent! grep %
        copen
        redraw!
        echo &grepprg
        let &grepformat = gf_s
        let &grepprg = gp_s
endfunction

function FindCalled()
        let l:word = expand(expand("<cword>"))
        let gf_s = &grepformat
        let gp_s = &grepprg
        let &grepformat = '%f\ %m\ %l'
        let &grepprg = 'findcalled.sh ' . l:word
        write
        silent! grep %
        copen
        redraw!
        echo &grepprg
        let &grepformat = gf_s
        let &grepprg = gp_s
endfunction

fun! DiffFile()
        let lnum = line(".")
        echohl ModeMsg
        let line = getline(lnum)
        echohl None
        execute "!diff.sh " . line
        ":    system(" diff.sh" . line)
endfun

function ShowFunc()
        let gf_s = &grepformat
        let gp_s = &grepprg
        let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
        let &grepprg = 'ctags -x --language-force=c --c-types=f --sort=no -o -'
        ":    let &grepprg = 'ctags -x  --c-types=f --sort=no -o -'
        write
        silent! grep %
        cwindow
        redraw!
        let &grepformat = gf_s
        let &grepprg = gp_s
endfunction

fun! ShowFuncName()
        let lnum = line(".")
        let col = col(".")
        echohl ModeMsg
        echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
        echohl None
        call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

function! Myfun()
        let gf_s = &grepformat
        let gp_s = &grepprg
        let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
        ":    let &grepformat = '||\s\k*\s*%l\s%f\s%m'
        let &grepprg = 'ctags -x --c-types=f --sort=no -o - --format=1'
        write
        silent! grep %
        copen
        redraw!
        let &grepformat = gf_s
        let &grepprg = gp_s
endfunction


function PreviewHTML_TextOnly()
        let l:fname = expand("%:p" )
        new
        set buftype=nofile nonumber
        exe "%!lynx " . l:fname . " -dump -nolist -underscore :    -width " . winwidth( 0 )
endfunction

function! Mosh_html2text()
        silent! %s/&lt;/</g
        silent! %s/&gt;/>/g
        silent! %s/&amp;/&/g
        silent! %s/&quot;/"/g
        silent! %s/&nbsp;/ /g
        silent! %s/&ntilde;/\~/g
        silent! %s/<P>//g
        silent! %s/<BR>/ /g
        silent! %s/</\?[BI]>/ /g
        set readonly
endfun

function! Test()
        cwindow
endfunction

function CleanComments ()
        g/^$/d
        g/^#/d
endfunction

function HelpVaibhav ()
        echo "Vim### nmap <buffer> <CR> :call DiffFile()  <CR><CR> ###Mapping command to current buffer."
        echo "Vim###vim -f +\":runtime! syntax/2html.vim | :wq | :q \" a.c ### Convert a file to html file with color."
        echo "Vim###:set tw=0 wrap linebreak noautoindent ### For copying text from gui to vim"
        " File is saved in ~/.vim/vimtips.txt (~/vimfiles/vimtips.txt under windows)
        echo  " <Leader>dt (or :call DisplayVimTips()) - display Best Vim Tips in separate buffer"
        echo  " <Leader>rt (or :call DisplayRandomTip()) - display random position in vimtips.txt (download if necessary) "
        echo  " <Leader>gt (or :call GetVimTips()) - download and parse Best Vim Tips.  "
        "NERD Comments
        echo " :help NERD_comments. ()  "
        echo  " <leader>cc Comments out the current line or text selected in visual mode.   "
        echo  " <leader>cn enforces nesting.                                                "
        echo  " <leader>ci Toggles the comment state of the selected line(s) individually.  "
        echo  " <leader>cs Comments out the selected lines ``sexually''                     "
        echo  " <leader>cu Uncomments the selected line(s).                                 "
        echo  " :set list [List Mode] :set nolist "
        " omni completion help
        echo  ":h omnicppcomplete "
        echo  ":h surround"
        echo   ":set list listchars=tab:»·,trail:·,extends:…  Show tabs, trailing whitespace"
endfunction


function ActiveSyn()
        if has("syntax") && (&t_Co > 2 || has("gui_running"))
                syntax on
                function! ActivateInvisibleCharIndicator()
                        syntax match TrailingSpace "[ \t]\+$" display containedin=ALL
                        highlight TrailingSpace ctermbg=Red
                endf
                autocmd BufNewFile,BufRead * call ActivateInvisibleCharIndicator()
        endif
endfunction


" Show tabs, trailing whitespace, and continued lines visually
":set list listchars=tab:»·,trail:·,extends:…

" highlight overly long lines same as TODOs.
highlight ColourYellow ctermbg=yellow ctermfg=red
highlight ColourLightYellow ctermbg=LightYellow
highlight ColourGreen ctermfg=green
highlight ColourBlue ctermfg=blue
highlight ColourBlack ctermfg=Black
highlight ColourRed ctermbg=red
highlight Directory ctermfg=DarkGreen
highlight Comment ctermfg=DarkCyan
highlight Search cterm=NONE ctermfg=black ctermbg=yellow

autocmd BufRead,BufNewFile *.note,*.rst call Setup_note_opts()
autocmd Filetype python call Setup_python_opts()
autocmd Filetype cpp,c,cxx,h,hpp call Setup_c_opts()

autocmd FileType cpp,c,cxx,h,hpp,python match ColourYellow /\%80v.\+\|,[^ ]\|\s\+$\|\n\{3,}/
autocmd FileType cpp,c,cxx,h,hpp,python call matchadd('ColourRed', '\n\{3,}')
autocmd FileType cpp,c,cxx,h,hpp,python call matchadd('ColourYellow', '|[^ =]')
autocmd FileType cpp,c,cxx,h,hpp,python call matchadd('ColourYellow', '[^ ]|')

autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'
autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'
autocmd BufRead,BufNewFile *.sh,*.py,*.xml,*pl,*.1 call matchadd('ColourRed', '\s\+$')
autocmd BufRead,BufNewFile *.sh,*.xml,*.1,*.py call matchadd('ColourYellow', '\%80v.\+')
autocmd BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main


let g:tex_flavor='latex'
set iskeyword+=:

set nowrap
":nmap <buffer> <CR> :call DiffFile()  <CR><CR>
map .f :call ShowFuncName() <CR>
map ..c :call FindCalling() <CR> <C-W> <C-W>
map ..v :call FindCalled() <CR>  <C-W> <C-W>
map <F7> :call ShowGraph() <CR>  <C-W> <C-W>

if has("cscope") && filereadable("/usr/bin/cscope")
        set csprg=/usr/bin/cscope
        set csto=1
        set cst
        set nocsverb
        " add any database in current directory
        if filereadable("cscope.out")
                cs add cscope.out
                " else add database pointed to by environment
        elseif $CSCOPE_DB != ""
                cs add $CSCOPE_DB
        endif
        set csverb

        map <C-_> :cstag <C-R>=expand("<cword>")<CR><CR>
        map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
        map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>

        nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

        nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
        set csqf=s-,g-,d-,c-,t-,e-,f-,i-
endif



" Statusline

let g:currentmode={
    \ 'n'  : 'N ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'V ',
    \ 'V'  : 'V·Line ',
    \ '' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'I ',
    \ 'R'  : 'R ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" Automatically change the statusline color depending on mode
function! ChangeStatuslineColor()
        if (mode() =~# '\v(n|no)')
                exe 'hi! StatusLine ctermfg=008'
        elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
                exe 'hi! StatusLine ctermfg=005'
        elseif (mode() ==# 'i')
                exe 'hi! StatusLine ctermfg=004'
        else
                exe 'hi! StatusLine ctermfg=006'
        endif
        return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
        let bytes = getfsize(expand('%:p'))
        if (bytes >= 1024)
                let kbytes = bytes / 1024
        endif
        if (exists('kbytes') && kbytes >= 1000)
                let mbytes = kbytes / 1000
        endif

        if bytes <= 0
                return '0'
        endif

        if (exists('mbytes'))
                return mbytes . 'MB '
        elseif (exists('kbytes'))
                return kbytes . 'KB '
        else
                return bytes . 'B '
        endif
endfunction

function! ReadOnly()
        if &readonly || !&modifiable
                return ''
        else
                return ''
endfunction

function! GitInfo()
	let git = fugitive#head()
	if git != ''
		return ' '.fugitive#head()
	else
		return ''
endfunction

" %{exists('g:loaded_fugitive')?fugitive#statusline():''}
set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=%1*\ [%n]                                " buffernr
set statusline+=%2*\ %<%F\ %{ReadOnly()}\ %m\ %w\        " File+path
"set statusline+=%3*\ %{GitInfo()}                        " Git Branch name
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}             " Syntastic errors
set statusline+=%*
set statusline+=%4*\ %=                                  " Space
set statusline+=%1*\ %y\                                 " FileType
"set statusline+=%2*\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\ " Encoding & Fileformat
"set statusline+=%3*\ %-3(%{FileSize()}%)                 " File size
set statusline+=%0*\ %3p%%\ \ %l:\ %3c\                 " Rownumber/total (%)

hi User0 ctermfg=White    ctermbg=LightRed
hi User1 ctermfg=White    ctermbg=LightRed
hi User2 ctermfg=White    ctermbg=LightBlue
hi User3 ctermfg=White    ctermbg=LightMagenta
hi User4 ctermbg=Red      ctermbg=White
hi User5 ctermfg=White    ctermbg=LightGreen

" https://github.com/vim-syntastic/syntastic
function SetupSyntastic()
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
        nmap ll :llist<CR>
        nmap l; :lnext<CR>
        nmap lk :lprevious<CR>
endfunction

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=1
  colo seoul256
  Limelight1
  nmap l; }<CR>zt
  nmap lk <UP>{<CR>zt
  syntax off
  set nospell
  " ...
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

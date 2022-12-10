
"
" VIM Configuration file
" Author: Vaibhav Gupta
" Email:  vaibhav.gupta@gmail.com
"

set shell=/usr/local/bin/bash " fish shell does not go along.
" let mapleader = "\<Space>"  " Only if you want to use Space as leader.

set nocompatible              " be iMproved, required
filetype off                  " required
set clipboard=exclude:.*
set path+=**
set rtp+=~/.vim/bundle/Vundle.vim

"
" Vundle Settings : Load Modules
"

" set the runtime path to include Vundle and initialize
call vundle#begin()
" VIM enhancements
Plugin 'ciaranm/securemodelines'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'justinmk/vim-sneak'

" GUI enhancements
Plugin 'itchyny/lightline.vim'
Plugin 'machakann/vim-highlightedyank'
Plugin 'andymass/vim-matchup' " TODO

" Syntactic Language Support
Plugin 'rust-lang/rust.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'martinda/Jenkinsfile-vim-syntax'
Plugin 'fatih/vim-go'
"Plugin 'vim-erlang/vim-erlang-runtime'
Plugin 'google/vim-jsonnet'

" Fuzzy Finder
Plugin 'airblade/vim-rooter'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" For completion
Plugin 'Valloric/YouCompleteMe'

" Themes and color
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'junegunn/seoul256.vim'
"Plugin 'junegunn/goyo.vim'
"Plugin 'junegunn/limelight.vim'

" Utilities
Plugin 'jceb/vim-orgmode'         " org
Plugin 'benmills/vimux'           " tmux
Plugin 'tpope/vim-fugitive'       " git
Plugin 'scrooloose/nerdtree'      " Nerd Tree
Plugin 'scrooloose/nerdcommenter' " Nerd Commenter
Plugin 'liuchengxu/vim-which-key' " Check via leader key
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-obsession'      " Saving vim session.
Plugin 'christoomey/vim-tmux-navigator' " vim tmux navigation

Plugin 'majutsushi/tagbar'

" Unsorted.
"Plugin 'VundleVim/Vundle.vim'

" TODO Check these.
"Plugin 'zxqfl/tabnine-vim'
Plugin 'scrooloose/syntastic'
Plugin 'dbeniamine/cheat.sh-vim'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Permanent undo
if !isdirectory($HOME."/.vimdid")
    call mkdir($HOME."/.vimdid", "", 0700)
endi
"set undodir=~/.vimdid
"set undofile
execute pathogen#infect()

" Plugin settings for 'dbeniamine/cheat.sh-vim'
let g:CheatSheetFrameworks = {
      \ 'python' :      ['python', 'django', ],
      \ 'javascript' :  ['javascript', 'node', 'angular', 'jquery'],
      \ 'php' :         ['php', 'symphony', 'yii', 'zend'],
      \}


" Plugin settings for securemodelines ('ciaranm/securemodelines')
" {{{
let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]
" }}}

" Plugin Setting for Lightline ('itchyny/lightline.vim')
" {{{
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ },
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction
" }}}

" Plugin Settings for godlygeek/tabular Help: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
" {{{
"if exists(':Tabularize') " TODO Bug: this is not working, hence commenting.
    nmap <Leader>t= :Tabularize /=<CR>
    vmap <Leader>t= :Tabularize /=<CR>
    nmap <Leader>t: :Tabularize /:\zs<CR>
    vmap <Leader>t: :Tabularize /:\zs<CR>
"endif

" call the :Tabularize command each time you insert a | character.
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
" }}}

" Plugin Settings for 'vim-airline/vim-airline'
" {{{
let g:airline_theme = 'dark'
" }}}

" Plugin Settings for 'benmills/vimux'
" {{{
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vm :VimuxPromptCommand("make ")<CR><CR>
" Run current line by VimuxRunCommand
map <Leader>x :VimuxRunCommand ''.getline('.')<CR>

function! VimuxSlime()
  call VimuxRunCommand(@v)
endfunction

" If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <LocalLeader>vs "vy :call VimuxSlime()<CR>

" Select current paragraph and send it to tmux
nmap <LocalLeader>vs vip<LocalLeader>vs<CR>


" Run the last command on a tmux window on write.
function! VGautoWrite()
        let g:VimuxRunnerType = "window"
        autocmd BufWritePost  * :call VimuxRunLastCommand()
endfunction
" }}}

" Plugin Settings for 'liuchengxu/vim-which-key'
" {{{
" By default timeoutlen is 1000 ms
set timeoutlen=500
let g:which_key_map = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5'  , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5'  , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ 'c' : ['Cheat'      , 'cheat']            ,
      \ }
nnoremap <silent> <leader> :WhichKey! which_key_map<CR>
" }}}

" Plugin Settings for 'majutsushi/tagbar'
" {{{
nmap <F8> :TagbarToggle<CR>
" }}}

" Plugin Settings for junegunn/goyo.vim
" {{{
"function! s:goyo_enter()
  "silent !tmux set status off
  "silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  "set noshowmode
  "set noshowcmd
  "set scrolloff=1
  "colo seoul256
  "Limelight1
  "nmap l; }<CR>zt
  "nmap lk <UP>{<CR>zt
  "syntax off
  "set nospell
  "" ...
"endfunction

"function! s:goyo_leave()
  "silent !tmux set status on
  "silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  "set showmode
  "set showcmd
  "set scrolloff=5
  "Limelight!
  "" ...
"endfunction

"autocmd! User GoyoEnter nested call <SID>goyo_enter()
"autocmd! User GoyoLeave nested call <SID>goyo_leave()
" }}}

" Plugin Settings for 'scrooloose/syntastic'
" {{{
" https://github.com/vim-syntastic/syntastic
let g:syntastic_javascript_checkers = [ 'jshint' ]
let g:syntastic_ocaml_checkers      = ['merlin']
let g:syntastic_python_checkers     = ['pylint']
let g:syntastic_shell_checkers      = ['shellcheck']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_checkers = ['python']

function SetupSyntastic()
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
        nmap ll :llist<CR>
        nmap l; :lnext<CR>
        nmap lk :lprevious<CR>
endfunction
" }}}

" Plugin Settings for 'Valloric/YouCompleteMe'
" {{{
let g:ycm_python_interpreter_path = '/usr/local/bin/python3'
let g:ycm_python_sys_path         = []
let g:ycm_extra_conf_vim_data     = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/.global_extra_conf.py'
let g:ycm_add_preview_to_completeopt = '1'
let g:ycm_autoclose_preview_window_after_completion = '1'
"set previewpopup=height:10,width:60
" }}}

" Plugin Settings for 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_auto_extension_ext = 'txt' " It seems this is not working.

" Basic settings and mappings
" {{{
syntax on
filetype plugin indent on    " required
filetype plugin on
set relativenumber
set runtimepath^=~/.vim/bundle/vim-erlang-compiler
set nowrap
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
" set cursorline
set laststatus=2
set smartcase
set hidden             " Hide buffers when they are abandoned
set report=0
"set winheight=9999
set so=5
set cmdheight=2
set nu
set noswapfile
setlocal colorcolumn=120
set foldmethod=marker
set wildmode=list:longest
set wildmenu
" Add a line in insert mode.
"autocmd InsertEnter,InsertLeave * set cul!

":set mouse=a           " Enable mouse usage (all modes) " NOT GOOD
" Match it setting
let g:loaded_matchit = 1

set backspace=indent,eol,start
"set completeopt-=preview
"set autoindent
" }}}

" automatically rebalance windows on vim resize
:autocmd VimResized * :wincmd =

"
" My Helper functions
"

" VIM with .py files.
function Setup_python_opts()
" {{{
        "set cinoptions=:0,l1,t0,g0,(0
        set cindent
        set shiftround
        set autoindent
        set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        "set equalprg=/home/tushar/python/Python-2.7.13/Tools/scripts/reindent.py
endfunction
" }}}

" VIM with .note files.
function Setup_note_opts()
" {{{
        set nu
        setlocal spell spelllang=en_us
        set complete+=s
        set textwidth=80
        setlocal wrap
        set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        set noautoindent
        "match ColourYellow /^[^\t].*$/
endfunction
" }}}

" VIM with c files.
function Setup_c_opts()
" {{{
        set cino+=(0            " align function call breaks
        set cinoptions+=:0      " align switch, case
        set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
        set smartindent
        set autoindent
        set cindent
endfunction
" }}}

" VIM with box
function Setup_box_opts()
" {{{
        set cino+=(0            " align function call breaks
        set cinoptions+=:0      " align switch, case
        set nu
        set complete+=s
        set textwidth=120
        set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        set smartindent
        set autoindent
        set cindent
endfunction
" }}}

function FoldComments()
" {{{
        set foldmarker=/*,*/
        set foldmethod=marker
        silent! zx
endfunction
" }}}

function DateInsert()
" {{{
        .!date
endfunction
" }}}

function FoldFunction()
" {{{
        set foldmarker={,}
        set foldmethod=marker
        silent! zx
endfunction
" }}}

function ShowGraph()
" {{{
        let l:word = expand(expand("<cword>"))
        let execmd = 'showgraph.sh ' . l:word
        execute '!'.execmd.' &'
endfunction
" }}}

function FindCalling()
" {{{
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
" }}}

function FindCalled()
" {{{
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
" }}}

fun! DiffFile()
" {{{
        let lnum = line(".")
        echohl ModeMsg
        let line = getline(lnum)
        echohl None
        execute "!diff.sh " . line
        ":    system(" diff.sh" . line)
endfun
" }}}

fun! ShowFuncName()
" {{{
        let lnum = line(".")
        let col = col(".")
        echohl ModeMsg
        echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
        echohl None
        call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
"}}}

function! Myfun()
" {{{
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
" }}}

function PreviewHTML_TextOnly()
" {{{
        let l:fname = expand("%:p" )
        new
        set buftype=nofile nonumber
        exe "%!lynx " . l:fname . " -dump -nolist -underscore :    -width " . winwidth( 0 )
endfunction
" }}}

function! Mosh_html2text()
" {{{
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
" }}}

function! Test()
" {{{
        cwindow
endfunction
" }}}

function CleanComments ()
" {{{
        g/^$/d
        g/^#/d
endfunction
" }}}

function HelpVaibhav ()
" {{{
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
        :CocInstall coc-json coc-tsserver
        :CocInstall coc-pyright
endfunction
" }}}

" This vim init function for initialize for the first time.
function VimInit()
" {{{
        :CocInstall coc-json coc-tsserver
        :CocInstall coc-pyright
        :CocConfig
                "{
                  ""languageserver": {
                        ""go": {
                          ""command": "gopls",
                          ""rootPatterns": ["go.mod"],
                          ""trace.server": "verbose",
                          ""filetypes": ["go"]
                        "}
                  "}
                "}
endfunction
" }}}

function ActiveSyn()
" {{{
        if has("syntax") && (&t_Co > 2 || has("gui_running"))
                syntax on
                function! ActivateInvisibleCharIndicator()
                        syntax match TrailingSpace "[ \t]\+$" display containedin=ALL
                        highlight TrailingSpace ctermbg=Red
                endf
                autocmd BufNewFile,BufRead * call ActivateInvisibleCharIndicator()
        endif
endfunction
" }}}

" OLD Mappings - TODO
" {{{
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
imap <silent> ,, <ESC>"_yiw:s/\(\%#\w\+\)/<\1> <\/\1>/<cr><c-o><c-l>f>a<cr><cr><UP><tab>
" }}}

" highlight overly long lines same as TODOs.
" {{{
"highlight ColourYellow ctermbg=yellow ctermfg=red
"highlight ColourLightYellow ctermbg=LightYellow
"highlight ColourGreen ctermfg=green
"highlight ColourBlue ctermfg=blue
"highlight ColourBlack ctermfg=Black
"highlight ColourRed ctermbg=red
"highlight Directory ctermfg=DarkGreen
"highlight Comment ctermfg=DarkCyan
"highlight Search cterm=NONE ctermfg=black ctermbg=yellow

"autocmd BufRead,BufNewFile *.note call Setup_note_opts()
"autocmd Filetype python call Setup_python_opts()
"autocmd Filetype rst call Setup_note_opts()
"autocmd Filetype cpp,c,cxx,h,hpp call Setup_c_opts()

"autocmd FileType cpp,c,cxx,h,hpp,python match ColourYellow /\%120v.\+\|,[^ ]\|\s\+$\|\n\{3,}/
"autocmd FileType cpp,c,cxx,h,hpp,python call matchadd('ColourRed', '\n\{3,}')
"autocmd FileType cpp,c,cxx,h,hpp,python call matchadd('ColourYellow', '|[^ =]')
"autocmd FileType cpp,c,cxx,h,hpp,python call matchadd('ColourYellow', '[^ ]|')

"autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'
"autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'
"autocmd BufRead,BufNewFile *.sh,*.py,*.xml,*pl,*.1 call matchadd('ColourRed', '\s\+$')
"autocmd BufRead,BufNewFile *.sh,*.xml,*.1,*.py call matchadd('ColourYellow', '\%120v.\+')
" }}}

let g:tex_flavor='latex'
set iskeyword+=:

" TOBE DEPERECATED
" {{{
map .f :call ShowFuncName() <CR>
map ..c :call FindCalling() <CR> <C-W> <C-W>
map ..v :call FindCalled() <CR>  <C-W> <C-W>
map <F7> :call ShowGraph() <CR>  <C-W> <C-W>
" }}}

" cscope setttings C-\ 
" {{{
if has("cscope")
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

        "map <C-_> :cstag <C-R>=expand("<cword>")<CR><CR>
        "map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
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

        "nmap ll :cl<CR>
        "nmap l; :cn<CR>
        "nmap lk :cp<CR>
endif
" }}}

function! CodeBrowse()
" {{{
  " export CODE_BROWSE=1
  set showmode
  set showcmd
  set ro
  call FoldFunction()
  let Tlist_Auto_Open=1
endfunction

let CODE_BROWSE = expand("$CODE_BROWSE")
if CODE_BROWSE
        call CodeBrowse()
endif

" }}}

" START FZF : More at https://github.com/junegunn/fzf.vim#fzf-heart-vim
" FZF Shell Mappings: https://junegunn.kr/2016/07/fzf-git
" {{{
fun! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GFiles
  endif
endfun

" FZF Command reconfiguration.
command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
     \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

command! -bang -nargs=? -complete=dir BLines
      \ call fzf#vim#buffer_lines(<q-args>, {'options': ['--no-preview']}, <bang>0)

command! -bang -nargs=? -complete=dir Commands
      \ call fzf#vim#commands({'options': ['--no-preview']}, <bang>0)

"command! -bang -nargs=? -complete=dir History
      "\ call fzf#vim#history(<q-args>, {'options': ['--no-preview']})

" FZF New command `GGrep` : git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0], 'options': ['--layout=reverse', '--info=inline'] }), <bang>0)

function! RipgrepFzf(query, fullscreen)
" {{{
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
" }}}

" FZF New command `RG` : delegate serach to rg
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" FZF Mappings
nnoremap <silent><C-p>          :call FzfOmniFiles()<CR>
nnoremap <leader><leader>       :BLines<CR>
nnoremap <leader>qq             :BLines <C-R><C-W><CR>
nnoremap <leader><Enter>        :Buffers<CR>
nnoremap <leader>]              :BCommit<CR>
nmap <Leader>[                  :Commands<CR>
nmap <Leader>;                  :History:<CR>
nmap <Leader>M                  :Maps<CR>
nnoremap <silent> <Leader>`     :Marks<CR>

" Should be deprecate in favour of rg
nnoremap <silent> <Leader>AG    :Ag <C-R><C-A><CR>
nnoremap <silent> <Leader>ag    :Ag <C-R><C-W><CR>
xnoremap <silent> <Leader>ag    y:Ag <C-R>"<CR>

" delegate serach to RG
nnoremap <silent> <Leader>RG    :RG <C-R><C-A><CR>
nnoremap <silent> <Leader>rg    :Rg <C-R><C-W><CR>
xnoremap <silent> <Leader>rg    y:Rg <C-R>"<CR>

nnoremap <silent> <Leader>gg    :GG <C-R><C-W><CR>
xnoremap <silent> <Leader>gg    y:GG <C-R>"<CR>

" See `man fzf-tmux` for available options
if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p95%,90%' }
else
    let g:fzf_layout = { 'down': '40%' }
endif
" }}}

" Start Here
call Setup_box_opts()

"
" You Complete me
" brew install cmake python mono go nodejs
" npm install -g npm-groovy-lint
"
" Show tabs, trailing whitespace, and continued lines visually
":set list listchars=tab:»·,trail:·,extends:…
"
" To disable jsonnet format on save.
let g:jsonnet_fmt_on_save = 0

" Change directory as we open a file.
let g:rooter_manual_only = 0


" Statusline
"hi User0 ctermfg=White    ctermbg=LightRed
"hi User1 ctermfg=White    ctermbg=LightRed
"hi User2 ctermfg=White    ctermbg=LightBlue
"hi User3 ctermfg=White    ctermbg=LightMagenta
"hi User4 ctermbg=Red      ctermbg=White
"hi User5 ctermfg=White    ctermbg=LightGreen

" TODO
":inoremap jk <ESC>

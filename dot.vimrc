:syntax on
:execute pathogen#infect()
:filetype plugin on
:set nocp
:autocmd FileType * set formatoptions=tcql
\ nocindent comments&
:autocmd FileType c,cpp set formatoptions=croql
\ cindent comments=sr:/*,mb:*,ex:*/,://
:set autoindent
:set autowrite
:ab #d #define
:ab #i #include
:ab #b /****************************************
:ab #e <Space>****************************************/
:ab #l /*-------------------------------------------- */
:ab #j Jack Benny Show
:set shiftwidth=4
:set tabstop=4
:set expandtab
:set hlsearch
:set rnu
:set incsearch
:set textwidth=80
" Open tag in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
:nmap <F6> /}<CR>zf%<ESC>:nohlsearch<CR>
":nmap <F5> zf%
:nmap <F4> <ESC>:loadview<CR>
:nmap <F3> <ESC>:mkview<CR>
" To toggle Function list
:nmap <F5> :TlistToggle<CR>
":map <F9> :!make <CR>
:command -nargs=* Make make <args> | cwindow 5
":map <F9> :w<CR>:Make %< <CR> <CR>
:map <F9> :make %< <CR>
:map <F8> :!./%< <CR>
:set cmdheight=2
"nmap <buffer> <CR> 0ye<C-W>w:tag <C-R>"<CR>z<CR><C-W><C-W># " press enter on tag name
"nmap <buffer> <CR> 0ye:! showgraph.sh <C-R>"  1 >/dev/null & <CR><CR>
:set showcmd
:set showmatch
:set smartcase
:set hidden             " Hide buffers when they are abandoned
":set mouse=a		" Enable mouse usage (all modes) " NOT GOOD
:set report=0
:set wildmode=list:longest
:set winheight=9999
:set so=5
:set laststatus=2
:set statusline=%<%F\ %h%m%r%w%=%-14.(%l,%c%)\ %P
:imap <silent> ,, <ESC>"_yiw:s/\(\%#\w\+\)/<\1> <\/\1>/<cr><c-o><c-l>f>a<cr><cr><UP><tab>

:nmap ll :cl<CR>
:nmap l; :cn<CR>
:nmap lk :cp<CR>
:nmap <F2> :'<,'>s/^/\/\/ /g<CR>

" For reindexing the tags for omni completion.
:map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

:function FoldComments()
:set foldmarker=/*,*/
:set foldmethod=marker
: silent! zx
:endfunction

:function DateInsert()
:.!date 
:endfunction

:function FoldFunction()
:set foldmarker={,}
:set foldmethod=marker
: silent! zx
:endfunction

:function ShowGraph()
:    let l:word = expand(expand("<cword>"))
:    let execmd = 'showgraph.sh ' . l:word
:    execute '!'.execmd.' &'
:endfunction

:function FindCalling()
:    let l:word = expand(expand("<cword>"))
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%f\ %m\ %l'
:    let &grepprg = 'findcalling.sh ' . l:word
:    write
:    silent! grep %
:    copen
:    redraw!
:    echo &grepprg 
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction

:function FindCalled()
:    let l:word = expand(expand("<cword>"))
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%f\ %m\ %l'
:    let &grepprg = 'findcalled.sh ' . l:word
:    write
:    silent! grep %
:    copen
:    redraw!
:    echo &grepprg 
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction
:fun! DiffFile()
:    let lnum = line(".")
:    echohl ModeMsg
:    let line = getline(lnum)
:    echohl None
:    execute "!diff.sh " . line
":    system(" diff.sh" . line)
:endfun
":nmap <buffer> <CR> :call DiffFile()  <CR><CR>
:nmap <F12> <ESC>:qa<CR>

:function ShowFunc()
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
:    let &grepprg = 'ctags -x --language-force=c --c-types=f --sort=no -o -'
":    let &grepprg = 'ctags -x  --c-types=f --sort=no -o -'
:    write
:    silent! grep %
:    cwindow
:    redraw!
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction
:fun! ShowFuncName()
:    let lnum = line(".")
:    let col = col(".")
:    echohl ModeMsg
:    echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
:    echohl None
:    call search("\\%" . lnum . "l" . "\\%" . col . "c")
:endfun
:map .f :call ShowFuncName() <CR>
:map ..c :call FindCalling() <CR> <C-W> <C-W>
:map ..v :call FindCalled() <CR>  <C-W> <C-W>
:map <F7> :call ShowGraph() <CR>  <C-W> <C-W>

:function! Myfun()
:    let gf_s = &grepformat
:    let gp_s = &grepprg
:    let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
":    let &grepformat = '||\s\k*\s*%l\s%f\s%m'
:    let &grepprg = 'ctags -x --c-types=f --sort=no -o - --format=1'
:    write
:    silent! grep %
:    copen
:    redraw!
:    let &grepformat = gf_s
:    let &grepprg = gp_s
:endfunction


:function PreviewHTML_TextOnly()
:    let l:fname = expand("%:p" )
:    new
:    set buftype=nofile nonumber
:    exe "%!lynx " . l:fname . " -dump -nolist -underscore :    -width " . winwidth( 0 )
: endfunction
:function! Mosh_html2text()
    :silent! %s/&lt;/</g
    :silent! %s/&gt;/>/g
    :silent! %s/&amp;/&/g
    :silent! %s/&quot;/"/g
    :silent! %s/&nbsp;/ /g
    :silent! %s/&ntilde;/\~/g
    :silent! %s/<P>//g
    :silent! %s/<BR>/ /g
    :silent! %s/</\?[BI]>/ /g
    :set readonly
:endfun
:function! Test()
:	cwindow
:endfunction

:function CleanComments ()
:	g/^$/d
:	g/^#/d
:endfunction 

:function HelpVaibhav ()
: echo "Vim### nmap <buffer> <CR> :call DiffFile()  <CR><CR> ###Mapping command to current buffer."
: echo "Vim###vim -f +\":runtime! syntax/2html.vim | :wq | :q \" a.c ### Convert a file to html file with color."
: echo "Vim###:set tw=0 wrap linebreak noautoindent ### For copying text from gui to vim"
" File is saved in ~/.vim/vimtips.txt (~/vimfiles/vimtips.txt under windows)
: echo  " <Leader>dt (or :call DisplayVimTips()) - display Best Vim Tips in separate buffer"
: echo  " <Leader>rt (or :call DisplayRandomTip()) - display random position in vimtips.txt (download if necessary) "
: echo  " <Leader>gt (or :call GetVimTips()) - download and parse Best Vim Tips.  "
"NERD Comments 
: echo " :help NERD_comments. ()  "
: echo  " <leader>cc Comments out the current line or text selected in visual mode.   "
: echo  " <leader>cn enforces nesting.                                                "
: echo  " <leader>ci Toggles the comment state of the selected line(s) individually.  "
: echo  " <leader>cs Comments out the selected lines ``sexually''                     "
: echo  " <leader>cu Uncomments the selected line(s).                                 "
: echo  " :set list [List Mode] :set nolist "
" omni completion help
: echo  ":h omnicppcomplete " 
: echo  ":h surround" 
:echo   ":set list listchars=tab:»·,trail:·,extends:…  Show tabs, trailing whitespace" 

:endfunction 

:let g:tex_flavor='latex'
:set iskeyword+=:

:set nowrap

:function ActiveSyn()
:if has("syntax") && (&t_Co > 2 || has("gui_running"))
:      syntax on
:      function! ActivateInvisibleCharIndicator()
:      	syntax match TrailingSpace "[ \t]\+$" display containedin=ALL
:      	highlight TrailingSpace ctermbg=Red
:      endf
:      autocmd BufNewFile,BufRead * call ActivateInvisibleCharIndicator()
:endif
:endfunction 
:" Show tabs, trailing whitespace, and continued lines visually
":set list listchars=tab:»·,trail:·,extends:…
:
:" highlight overly long lines same as TODOs.
:autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'


":if has("cscope")
":    set csprg=/usr/bin/cscope
":    set csto=0
":    set cst
":    set nocsverb
":    " add any database in current directory
":    if filereadable("cscope.out")
":	cs add cscope.out
":    " else add database pointed to by environment
":    elseif $CSCOPE_DB != ""
":	cs add $CSCOPE_DB
":    endif
":endif

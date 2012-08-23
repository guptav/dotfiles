" Vim syntax file
" Language:	gdb variables window syntax file
" Maintainer:	<XavierDeGaye at netscape dot net>
" Last Change:	Mar 14 2004

if exists("b:current_syntax")
    finish
endif

setlocal iskeyword=a-z,A-Z,48-57,-

syn match gdbStr display contained /""\|".\{-}[^\\]"/
syn match gdbChar display contained "'[^`']\+'"
syn match gdbIgnore display contained "{[*=-]}"

syn region gdbVarChged display contained matchgroup=gdbIgnore start="={\*}"ms=s+1 end="$"
syn region gdbDeScoped display contained matchgroup=gdbIgnore start="={-}"ms=s+1 end="$"
syn region gdbVarUnChged display contained matchgroup=gdbIgnore start="={=}"ms=s+1 end="$"
    \ contains=gdbChar,gdbStr,cNumbers

syn match gdbItem display transparent "^.*$"
    \ contains=gdbVarUnChged,gdbDeScoped,gdbVarChged,gdbVarNum,gdbChar,gdbStr,cNumbers

syn case ignore
syn match cNumbers display contained "\<\d\|\.\d\|[+-] *\d\|[+-] *\.\d" contains=cNumber,cFloat

syn match cNumber display contained "[ +-]*\x\+\>"

syn match cFloat display contained "[ +-]*\d\+f\>"
syn match cFloat display contained "[ +-]*\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match cFloat display contained "[ +-]*\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match cFloat display contained "[ +-]*\d\+e[-+]\=\d\+[fl]\=\>"
syn case match

syn match gdbVarNum display contained "^\s*\d\+:"he=e-1

high def link gdbVarChged   Special
high def link gdbDeScoped   Comment
high def link gdbVarNum	    Identifier
high def link gdbIgnore	    Ignore
high def link gdbStr	    String
high def link gdbChar	    Character
high def link cNumber	    Number
high def link cFloat	    Float

let b:current_syntax = "gdbvar"


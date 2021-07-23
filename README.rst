



Installation
============


Create links for dot files::

        ./install.sh link

Check links::

        ./install.sh check

Unlink dot files::

        ./install.sh unlink

If old files exists then backed up in ${HOME}/\*.bak


Install fisher for plugins::

    # https://github.com/jorgebucaran/fisher
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

    fisher install jethrokuan/z
    fisher install simnalamburt/shellder

    # https://github.com/ryanoasis/nerd-fonts
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font

TODO
====

VIM Plugins:
    - vundle
    - Nerdtree
    - ctrlp
    - fugitive
    - syntastic

Link to check
=============

    - [GOOD ONE] https://github.com/nicknisi/dotfiles


Quick Help
==========

::

    v_aw     N  aw        Select "a word"
    v_iw     N  iw        Select "inner word"
    v_aW     N  aW        Select "a WORD"
    v_iW     N  iW        Select "inner WORD"
    v_as     N  as        Select "a sentence"
    v_is     N  is        Select "inner sentence"
    v_ap     N  ap        Select "a paragraph"
    v_ip     N  ip        Select "inner paragraph"
    v_ab     N  ab        Select "a block" (from "[(" to "])")
    v_ib     N  ib        Select "inner block" (from "[(" to "])")
    v_aB     N  aB        Select "a Block" (from "[{" to "]}")
    v_iB     N  iB        Select "inner Block" (from "[{" to "]}")
    v_a>     N  a>        Select "a <> block"
    v_i>     N  i>        Select "inner <> block"
    v_at     N  at        Select "a tag block" (from <aaa> to </aaa>)
    v_it     N  it        Select "inner tag block" (from <aaa> to </aaa>)
    v_a'     N  a'        Select "a single quoted string"
    v_i'     N  i'        Select "inner single quoted string"
    v_aquote N  a"        Select "a double quoted string"
    v_iquote N  i"        Select "inner double quoted string"
    v_a`     N  a`        Select "a backward quoted string"
    v_i`     N  i`        Select "inner backward quoted string"

vimdiff::

	]c               - advance to the next block with differences
	[c               - reverse search for the previous block with differences
	do (diff obtain) - bring changes from the other file to the current file
	dp (diff put)    - send changes from the current file to the other file
	zo               - unfold/unhide text
	zc               - refold/rehide text
	zr               - unfold both files completely
	zm               - fold both files completely

Set global git ignore file::

    git config --global core.excludesfile '~/.gitignore'

Code Browsing
==============

Switch to Browse mode::

  export CODE_BROWSE=1

cscope::

    0 or s: Find this C symbol
    1 or g: Find this definition
    2 or d: Find functions called by this function
    3 or c: Find functions calling this function
    4 or t: Find this text string
    6 or e: Find this egrep pattern
    7 or f: Find this file
    8 or i: Find files #including this file

Jumps::

    CTRL-O          Go to [count] Older cursor position in jump list
    CTRL-I          Go to [count] newer cursor position in jump list
    *CTRL-<Tab>*    Go to [count] newer cursor position in jump list
    <F5>            Tag list toggle
    <CTRL-P>        finding files
    <Leader>m       Mark the word under the cursor
    <Leader>n       Clear the mark under the cursor

Quick Links
===========

Task warrior Examples: https://taskwarrior.org/docs/examples.html


Articles
========

#. [VIM] http://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim

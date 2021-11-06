# .bashrc

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

if [ -f ~/.linuxify ]; then
        . ~/.linuxify
fi

if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

# Some settings
set -o notify
set -o noclobber
set -o ignoreeof
#set -o vi
#set -o nounset

export HISTSIZE=100000
export HISTFILESIZE=100000

export GNATSDB=guptav

# Enable options:
#shopt -s autocd
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob      # Necessary for programmable completion
shopt -s hostcomplete # TO check how it works

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

source ~/.git-prompt.sh

green='\E[32;40m'
white='\E[37;40m'
yellow='\E[33;40m'
bold="\033[1m"
normal="\033[0m"
# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
BLACK='\e[0;30m'
GREEN='\e[0;32m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color


#SHELL PROMPT
if [[ "${DISPLAY#$HOSTNAME}" != ":0.0" &&  "${DISPLAY}" != ":0" ]]; then
    HILIT=${BROWN}   # remote machine: prompt will be partly red
else
    HILIT=${cyan}  # local machine: prompt will be partly cyan
fi

function fastprompt()
{
    case $TERM in
    *term* | rxvt | screen | screen-256color )
    #PS1="${HILIT}[\h]$NC \W > \[\033]0;\${TERM} [\u@\h] \w\007\]"
    #PS1="${HILIT}[\A - ]$NC -----${BLUE}\$(git branch --show-current)${NC}--- ${red}\${PWD}${NC}  \n[\h \#] > "
    #PS1="${HILIT}[\A - ]$NC -----${BLUE}\$(__git_ps1 '(%s)')${NC}--- ${red}\${PWD}${NC}  \n[\h \#] > "
    PROMPT_COMMAND='__git_ps1 "${HILIT}[\A - $(task_indicator)]$NC -----${BLUE}" "${NC}--- ${red}\${PWD}${NC}  \n[\h \#] > "'
    ;;
    linux )
    PS1="${HILIT}[\h]$NC \W > " ;;
    *)
    PS1="[\h] \W > " ;;
    esac
}

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color'
alias rmbk='/bin/rm -f .*~ *~ *aux *bak *log 2>/dev/null'
alias ..='cd ..'
alias which="type -path"
alias path='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -kTh'
alias grep='grep --color'
alias cs='cscope -d .'
alias less='less -R'
alias more='more -R'
alias ll='exa -l -g --icons --tree --git-ignore -ha --ignore-glob .git'
alias k=kubectl

source <(kubectl completion bash)
complete -F __start_kubectl k

# The 'ls' family (this assumes you use the GNU ls)
alias la='ls -Al'               # show hidden files
#alias ls='ls -hF --color'  # add colors for filetype recognition
alias lx='ls -lXB'              # sort by extension
alias lk='ls -lSr'              # sort by size
alias lc='ls -lcr'      # sort by change time
alias lu='ls -lur'      # sort by access time
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date
alias lm='ls -al |more'         # pipe through 'more'
alias tree='tree -Csu'      # nice alternative to 'ls'
alias x=startx
alias m="mplayer -ao alsa -vo x11 -zoom"
alias t="task"
complete -o nospace -F _task  t

# Initialize HISTIGNORE with commands we don't want going into the bash history.  Only exact matches are filtered.
export HISTIGNORE="&:bg:fg:ll:h"
#HISTIGNORE="l:ll:llt:cdb:b:r:exit:env:date:.:..:...:....:.....:pwd:cfg:rb:eb:!!:ls:fg:bg:cd ..:h:mc"

#FOR CVS
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/lib/perl
#export CVS_RSH=ssh
#export CVSROOT=nsl-08:/users/rs/karkare/public_html/CVS614
export CVSROOT=/home/guptav/cvsroot
export EDITOR=vim


#A few useful function

if [ "$TERM" = "xterm" ]; then
    #cal -m
    echo -n "Today is : "
    date
    echo "--------------------------------------------------"
    fortune >| ~/.signature
    cat ~/.signature
    echo "--------------------------------------------------"
#   Birthday=birthday\#\#\#`date +%m`
#   grep $Birthday /home/guptav/public_html/cgi-bin/conf/appointments.txt \
#       | cut -d"#" -f 10,16
#   echo "--------------------------------------------------"
fi
# ONLY Valid for ksh shell
function mark {
        Usage="Usage: mark word"
    case $# in
     1) export "$1=cd `pwd`" ;;
         *) echo "Incorrect Arguments count "
        echo $Usage ;;
        esac
}
# ONLY Valid for ksh shell
function mygoto {
    Usage="Usage: goto word"
    case $# in
     1)  if env | grep "^$1=cd " > /dev/null ;
         then
         eval \$"$1"
         echo "New current directory is `pwd`"
         else
         echo "ERROR : $1 is not marked."
         echo $Usage
         fi
         ;;
    *)  echo "Incorrect Argument count"
        echo $Usage
        ;;
    esac
}
function _history
{
history | awk '{print $2}' | awk 'BEGIN {FS="|"}{print $1}' | sort | uniq -c | sort -n | tail | sort -nr
}

function c
{
  cd $1 ; ls
}
function aldo
{
    echo "Check if process ID is running or not"
    while ps -ao pid | grep -q "${1}$"; do sleep 1 ; done;
    echo $'\a';
    echo "DONE ";
    echo $1;
}
function vimgrep
{
    vimgrep_temp_file=/tmp/vimgrep_$$.tmp
    find . \( -name "*.c"  -o -name "*.h" -o -name "*.i" -o -name "*.icc" \) -print -follow | grep -v "CVS/" | sed "s/ /\\\/g" | xargs egrep -H -n -e $* > $vimgrep_temp_file
    vim -q $vimgrep_temp_file -c copen
    rm -f $vimgrep_temp_file
}
function xtitle ()
{
    case "$TERM" in
        *term | rxvt)
            echo -e "${RED}$*${NC}"  ;;
            #echo -n -e "${RED}$*${NC}"  ;;
        *)
        ;;
    esac
}
function man ()
{
    for i ; do
    xtitle The $(basename $1|tr -d .[:digit:]) manual
    command man -a "$i"
    done
}
function l ()
{
ls -l "$@"| egrep "^d" ;
ls -lXB "$@" 2>&-| egrep -v "^d|total ";
}
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    local SMSO=$(tput smso)
    local RMSO=$(tput rmso)
    find . -type f -name "${2:-*}" -print0 |
    xargs -0 grep -sn ${case} "$1" 2>&- | \
    sed "s/$1/${SMSO}\0${RMSO}/gI" | more
}
function fe()
{
    SSS=$1;
    shift ;
    if [ -z $SSS ]; then
        echo "Usages: fe '*.cpp' ls -l"
        return ;
    elif [ -z "$*" ]; then
        echo "Usages: fe *.cpp ls -l"
        return ;
    fi

    echo "Executing $* on every file";
    find . -type f -iname '*'$SSS'*' -exec $* {} \;  ;
}
function my_ps()
{ ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp()
{ my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }
function my_ip() # get IP adresses
{
    MY_IP=`ifconfig  | grep "inet addr" | awk -F":" '{print $2;}' | cut -d" " -f 1`
    #MY_IP=$(/sbin/ifconfig eth0| awk '/inet/ { print $2 } ' |  sed -e s/addr://)
    #MY_ISP=$(/sbin/ifconfig eth0 | awk '/P-t-P/ { print $3 } ' | sed -e s/P-t-P://)
}
function ii()   # get current host related info
{
  echo -e "\nYou are logged on ${RED}$HOSTNAME"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Memory stats :$NC " ; free
  my_ip 2>&- ;
  echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
  echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
  echo
}

function move2 ()
{
    archive=$1
    if [ -z "$archive" ]; then
        echo "Usages: move2 <Directory Name>"
        return 0;
    fi
    [  ! -d "$archive" ] && echo "Error : $archive is not a directory." && return 1
    dirname=`date +%b%d`
    echo "Creating Directory : $archive/$dirname "
    mkdir $archive/$dirname
    echo "Moving files to    : $archive/$dirname "
    mv * $archive/$dirname
    echo "Done."
}

#Misc Function
function repeat()       # repeat n times command
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}
function ask()
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}
function my_help
{
echo "fastprompt    : Change to New Prompt   "
echo "c <dirname>   : cd and ls to directory "
echo "xtitle <Text> : Display text in color  "
echo "l             : List files. Dir first  "
echo "fe <*.c> <ls> : Execute command on each file"
echo "fstr <pat>    : Search pattern and highlight"
echo "ii            : Show info about your m/c"
echo "pp            : Show processess "
echo "repeat n <cmd>: Repeat command n times "
echo
echo "Other Commands: ask aldo my_ps vimgrep my_ip "
}
function mean ()
{
    echo "Form=Dict1&Query=$1&Strategy=*&Database=wn" | lynx -dump http://www.dict.org/bin/Dict -post_data -nolist | awk "NR>18"
}
function getlyrics ()
{
    songname=$1
    if [ -z "$songname" ]; then
        echo "Usages: getlyrics songname"
        echo "Usages: getlyrics -f <title> <artist>"
        return 0;
    fi
    if [ "$songname" = "-f" ]; then
        title=$2
        artist=$3
    else
        info=`mp3info2 -p "%F|%t|%a|%l|%y|%c" "$songname"`
        #artist=`echo $info | cut -d "|" -f 3 | perl -e "s/([^A-Za-z0-9])/sprintf(\"%%%02X\", ord($1))/seg" -p`
        #title=`echo $info | cut -d "|" -f 2  | perl -e "s/([^A-Za-z0-9])/sprintf(\"%%%02X\", ord($1))/seg" -p`
        #artist=`echo $info | cut -d "|" -f 3 | perl -e 'while (<>) {  $_ =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg; print $_;} '`
        #title=`echo $info | cut -d "|" -f 2  | perl -e 'while (<>) {  $_ =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg; print $_;} '`
        artist=`echo $info | cut -d "|" -f 3 `
        title=`echo $info | cut -d "|" -f 2  `
        url=`echo $info | cut -d "|" -f 6`
    fi
    echo "Title: $title Artist: $artist"
    echo "Url  : $url"
    if [ -z "$url" ] ; then
        echo "procesado2=1&artist=$artist&songname=$title" | lynx -dump http://lyrc.com.ar/en/tema1en.php -post_data
    else
        lynx -dump $url
    fi
    #echo "procesado2=1&artist=$artist&songname=$title" | lynx -dump http://www.autolyrics.com/tema1en.php -post_data
}
function define () # Define a word - USAGE: define dog
{
    if [ -z "$1" ]; then
        echo "Usages: define dog"
        return;
    fi
    lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | grep -m 3 -w "*"  | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
    if [[ -s  /tmp/templookup.txt ]] ;then
        until ! read response
        do
            echo "${response}"
            done < /tmp/templookup.txt
    else
        echo "Sorry $USER, I can't find the term \"${1} \""
        fi
        rm -f /tmp/templookup.txt
}

# Weather by City or location. weather :help  # For help
function weather ()
{
    local city=${1-Cupertino}
    local option=${2-0}
    curl wttr.in/${city}?${option}
}

# Stock prices - can be called two ways. # stock novl  (this shows stock pricing)  #stock "novell"  (this way shows stock symbol for novell)
function old_stock ()
{
    if [ -z "$1" ]; then
    echo "Usages: stock novl|novell";
        return;
    fi
    stockname=`lynx -dump http://finance.yahoo.com/q?s=${1} | grep -i ":${1})" | sed -e 's/Delayed.*$//'`
    stockadvise="${stockname} - delayed quote."
    declare -a STOCKINFO
    STOCKINFO=(` lynx -dump http://finance.yahoo.com/q?s=${1} | egrep -i "Last Trade:|Change:|52wk Range:"`)
    stockdata=`echo ${STOCKINFO[@]}`
    if [[ ${#stockname} != 0 ]] ;then
        echo "${stockadvise}"
        echo "${stockdata}"
    else
        stockname2=${1}
    lookupsymbol=`lynx -dump -nolist http://finance.yahoo.com/lookup?s="${1}" | grep -A 1 -m 1 "Portfolio" | grep -v "Portfolio" | sed 's/\(.*\)Add/\1 /'`
    if [[ ${#lookupsymbol} != 0 ]] ;then
        echo "${lookupsymbol}"
    else
        echo "Sorry $USER, I can not find ${1}."
        fi
        fi
}
function stock()
{
    # The following is one long line, it'll wrap on your display
    stock=`lynx -source "http://finance.yahoo.com/d/quotes.csv?s=${1}&f=sl1d1t1c1ohgvn&e=.csv"`
    # End of long line
    ARRAY=(`echo $stock | sed s/\ /_/g | sed s/[,\"]/\ /g `)
    #ARRAY=(`echo $stock | sed s/[,\"]/\ /g `)
    COMPANY=${ARRAY[0]}

    SIGN=${ARRAY[4]:0:1}
    if [ "$SIGN" = "+" ];
    then
    COLOR=$green
    else
    COLOR=$red
    fi
    echo -en $bold"Company" $yellow${ARRAY[9]}$normal
    echo -en $bold" Code" $yellow$COMPANY$normal
    echo -en $bold "Date" '\E[33;40m'${ARRAY[2]}$normal
    echo -e $bold "Time" $yellow${ARRAY[3]}$normal
    echo -en $bold"Current" $yellow${ARRAY[1]}$normal
    echo -en $bold "Change $COLOR "${ARRAY[4]}$normal
    echo -e $bold "Volume "$yellow ${ARRAY[8]}$normal
    echo -en $bold"Open   " $yellow${ARRAY[5]}$normal
    echo -en $bold "High" $yellow${ARRAY[6]}$normal
    echo -e $bold "Low" $yellow${ARRAY[7]}$normal

    tput sgr0
}
function translate ()#Translate a Word  - USAGE: translate house spanish  # See dictionary.com for available languages (there are many).
{
    if [ -z "$1" ]; then
        echo "Usages: translate house spanish"
        return;
    fi
    TRANSLATED=`lynx -dump "http://dictionary.reference.com/browse/${1}" | grep -i -m 1 -w "${2}:" | sed 's/^[ \t]*//;s/[ \t]*$//'`
    if [[ ${#TRANSLATED} != 0 ]] ;then
        echo "\"${1}\" in ${TRANSLATED}"
    else
        echo "Sorry, I can not translate \"${1}\" to ${2}"
        fi
}


#Completion of commands
shopt -s extglob        # necessary
set +o nounset          # otherwise some completions will fail

complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown
complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
# Postscript,pdf,dvi.....
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' acroread pdf2ps xpdf
complete -f -o default -X '!*.+(pdf|ps)' gv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
# Multimedia
complete -f -o default -X '!*.+(jp*g|gif|xpm|png|bmp)' xv gimp
complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' ogg123
complete -f -o default -X '!*.pl'  perl perl5

# This is a 'universal' completion function - it works when commands have
# a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'

_get_longopts ()
{
    $1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| \
grep ^"$2" |sort -u ;
}
_longopts_func ()
{
    case "${2:-*}" in
    -*) ;;
    *)  return ;;
    esac

    case "$1" in
    \~*)    eval cmd="$1" ;;
    *)  cmd="$1" ;;
    esac
    COMPREPLY=( $(_get_longopts ${1} ${2} ) )
}
complete  -o default -F _longopts_func configure bash
complete  -o default -F _longopts_func wget id info a2ps ls recode

_cvs ()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ] || [ "${prev:0:1}" = "-" ]; then
        COMPREPLY=( $( compgen -W 'add admin checkout commit diff \
        export history import log rdiff release remove rtag status \
        tag update' $cur ))
    else
        COMPREPLY=( $( compgen -f $cur ))
    fi
    return 0
}
complete -F _cvs cvs



################### Begin gpg functions ##################
function encrypt ()
{
    # Use ascii armor
    gpg -ac --no-options "$1"
}
function bencrypt ()
{
    # No ascii armor
    # Encrypt binary data. jpegs/gifs/vobs/etc.
    gpg -c --no-options "$1"
}
function decrypt ()
{
    gpg --no-options "$1"
}
function pe ()
{
# Passphrase encryption program
# Created by Dave Crouse 01-13-2006
# Reads input from text editor and encrypts to screen.
    echo "         Passphrase Encryption Program";
    echo "--------------------------------------------------"; echo "";
    which $EDITOR &>/dev/null;
    if [ $? != "0" ];
    then
    echo "It appears that you do not have a text editor set in your .bashrc file.";
        echo "What editor would you like to use ? " ;
    read EDITOR ; echo "";
    fi
    echo "Enter the name/comment for this message :"
    read comment
    $EDITOR passphraseencryption
    gpg --armor --comment "$comment" --no-options --output passphraseencryption.gpg --symmetric passphraseencryption
    shred -u passphraseencryption ; clear
    echo "Outputting passphrase encrypted message"; echo "" ; echo "" ;
    cat passphraseencryption.gpg ; echo "" ; echo "" ;
    shred -u passphraseencryption.gpg ;
    read -p "Hit enter to exit" temp; clear
}
function keys ()
{
    # Opens up kgpg keymanager
    kgpg -k
}
function encryptfile ()
{
    zenity --title="zcrypt: Select a file to encrypt" --file-selection > zcrypt
    encryptthisfile=`cat zcrypt`;rm zcrypt
    # Use ascii armor
    #  --no-options (for NO gui usage)
    gpg -acq --yes ${encryptthisfile}
    zenity --info --title "File Encrypted" --text "$encryptthisfile has been encrypted"
}
function decryptfile ()
{
    zenity --title="zcrypt: Select a file to decrypt" --file-selection > zcrypt
    decryptthisfile=`cat zcrypt`;rm zcrypt
    # NOTE: This will OVERWRITE existing files with the same name !!!
    gpg --yes -q ${decryptthisfile}
    zenity --info --title "File Decrypted" --text "$encryptthisfile has been decrypted"
}

################### End gpg functions ##################
################### Begin Gnats functions ##################
function _bugs_list ()
{
    local i_state=${1}
    query-pr --format summary --state=${i_state}
}
function _bugs_detail()
{
    local i_pr=${1}
    query-pr ${i_pr}
}
function bugs ()
{
    local option=$1
    case "$option" in
    list)   _bugs_list "$2";;
    detail) _bugs_detail "$2";;
    *)  _bugs_list "open";;
    esac
}
################### End   Gnats functions ##################
################### Document Converting functions ##################
function pdfmerge ()
{

    output=${1}
    shift
    [ -f "${output}" ] && echo "Error: Output file already exists : $output" && return 1;
    echo "Merging $@ to $output ... "
    gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=${output} -dBATCH $@

}
################### Document Converting functions ##################

function myupdate()
{
    filename='.filelist.txt'
    function_filename='.function.list'
    structure_filename='.structure.list'
    command=${1-regen}

    case "$command" in
    clean)
        rm -f ${filename} ${function_filename} ${structure_filename} cscope.out
        rm -f tags  cscope.in.out cscope.po.out
        return
        ;;
    gen)
        echo "Finding files ..."
        git ls-files  >| $filename
        ;;
    regen)
        echo "Regenrating ctags from filelist."
        ;;
    status)
        echo "Functions : "
        wc -l $function_filename
        echo "Structures : "
        wc -l $structure_filename
        return
        ;;
    help|*)
        echo "Unknown command: $command"
        echo "Usages: myupdate [gen|regen|clena]"
        return
        ;;
    esac

    if [ ! -f $filename ]; then
    echo "ERROR: File does not exists: $filename"
    myupdate help
    return
    fi


    echo "- Generating tag list - "
    ctags --extras=+f -L $filename
    echo "- Generating cscope.out -"
    cscope -q -b -i $filename
    echo "- Generating Function Names for Language C -"
    ctags --language-force=c --c-types=f --sort=no -L $filename -o - | cut -f 1 >| $function_filename
    echo "- Generating Structure List for Language C -"
    ctags --language-force=c --c-types=s --sort=no -L $filename -o - | cut -f 1 >| $structure_filename
    myupdate status
}

function my_sol ()
{
    #For vim to have colors.
    export TERM=xtermc
}

function c_r()
{
    cvs log $1 |   awk '/^Working/ {w = $3}/^head:/{print $2, w}'|  sort -r  -n  -k 2 -t .
}

function date_sync()
{
     sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
}

function tmw()
{
    tmux split-window -dh "$*"
}

function ts {
    args=$@
    tmux send-keys -t right "$args" C-m
}

function install_zsh()
{
    sh -c "$(wget --no-check-certificate https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function myinit()
{
    sudo apt install git vim ctags cscope tmux texlive-latex-base pylint3
    sudo apt install clang g++ gcc xterm make python3-pip
    sudo apt install latexmk xpdf
    sudo apt install timewarrior taskwarrior
    sudo pip3 install Sphinx
    # apt install texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function join_by { local IFS="$1"; shift; echo "$*"; }

function vhelp()
{
    topic=${1}
    shift
    query=`join_by - $*`
    echo "Running: curl cht.sh/${topic}/$query" >/dev/stderr
    curl cht.sh/${topic}/$query
}

TIPS_FILES=~/tips.txt
function __vg_history__()
{
    local line=`cat ${TIPS_FILES} | fzf --height 40% --layout reverse --info inline --border --no-hscroll --tiebreak=begin`
    local cmd=`echo $line | awk -F'#' '{print $1}'`
    echo "Running => $line"
    $cmd
}

bind -m emacs-standard -x '"\C-v\C-v":__vg_history__'

function progress_bar() {
    local w=30 p=$1;  shift
    local FILLC='\e[30;48;5;82m'
    local EMPTYC='\e[30;48;5;236m'
    local dot=' '
    # create a string of spaces, then change them to dots
    local _fillw=$(( $p*$w/100 ))
    local _emptyw=$(($w-$_fillw))
    printf -v dots "%*s" "$_fillw" ""; dots=${dots// /${dot}};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\e[K${FILLC}%-*s${NC}${EMPTYC}%-*s${NC} %3d %% %s" "$_fillw" "$dots" "$_emptyw" "" "$p" "$*";
}

# Task and GTD
function task_tag()
{
    printf "%20s %10s %10s %11s\n" "Tag" "Remaining" "Total" "Complete"
    printf "%20s %10s %10s %11s\n" "---" "---------" "-----" "--------"
    for tag in `task tags 2>/dev/null | awk 'NR>3{print $1}' | sort`; do
        _completed=`task +COMPLETED +$tag count`
        _total=`task +$tag count`
        _remaining=$(($_total - $_completed))
        _percentage=$((_completed * 100 / $_total))
        printf  "%20s %10d %10d %3s" $tag $_remaining $_total ""
        progress_bar $_percentage
        printf "\n"
    done
}

webpage_title (){
    wget -qO- "$*" |   gawk -v IGNORECASE=1 -v RS='</title' 'RT{gsub(/.*<title[^>]*>/,"");print;exit}'
}

read_and_review (){
    link="$1"
    title=$(webpage_title $link)
    echo $title
    descr="\"Read and review: $title\""
    id=$(task add project:rnr +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$link"
}

alias rnr=read_and_review

URGENT="❗"
OVERDUE="☠️"
DUETODAY="😱"
DUETOMORROW="📅"

function task_indicator {
    if [ `task +READY +OVERDUE count` -gt "0" ]; then
        echo "$OVERDUE"
    elif [ `task +READY +DUETODAY count` -gt "0" ]; then
        echo "$DUETODAY"
    elif [ `task +READY +DUETOMORROW count` -gt "0" ]; then
        echo "$DUETOMORROW"
    elif [ `task +READY urgency \> 10 count` -gt "0" ]; then
        echo "$URGENT"
    else
        echo '$'
    fi
}

# Search using rg from command line.
function rg()
{
    local search=${1}
    command rg  --line-number --no-heading  --smart-case ${search}| fzf -m --delimiter : --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' --preview-window +{2}-/2
}

function vim-quickstart()
{
    # Basic Pkgs
    brew install cmake python3 mono go nodejs
    brew install llvm

    # Install Vundle
    mkdir -p ~/.vim/bundle/
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    # Install pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    # open .vimrc
    vim ~/.vimrc

    # Post vim install
    cd ~/.vim/bundle/YouCompleteMe
    brew install gcc@10
    CC=gcc-10 CXX=g++-10 python3 ./install.py --clangd-completer
    CC=gcc-10 CXX=g++-10 python3 ./install.py --all
    python3 install.py --all
}

alias tt=task_tag

unset SSH_ASKPASS

# FZF Defaults
export FZF_DEFAULT_OPTS='--layout=reverse --border --layout=reverse --info=inline --preview "~/.vim/bundle/fzf.vim/bin/preview.sh {}"'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#START Executing
fastprompt

# Mac packages.
# brew install highlight bat rg ag

#Refrence
#http://www.novell.com/coolsolutions/tools/18639.html


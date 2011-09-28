#!/bin/bash 

function link_file ()
{
    source="${PWD}/$1"
    target="${HOME}/${1/dot/}"

    if [ -e "${target}" ]; then
	mv $target $target.bak
    fi

    ln -sf ${source} ${target}
}

function unlink_file ()
{
    target="${HOME}/${1/dot/}"
    unlink ${target}
}

function check_file ()
{
    target="${HOME}/${1/dot/}"
    ls --color -la ${target}
}

function help_file ()
{
    echo "Usages: $0 [check|link|unlink|help]"
    exit 0 
}

function main ()
{
    command=${1-check}

    # Check if the function exists or not. If not then exit.	
    declare -F ${command}_file >/dev/null 
    [ $? -ne 0 ] && echo "Command not found : $command" && help_file 

    for i in dot.*
    do
	eval ${command}_file $i
    done
}


main $@

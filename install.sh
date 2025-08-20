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

function mlink_file()
{
    ln -sf ${PWD}/config.fish ~/.config/fish/config.fish
}

function main ()
{
    command=${1-check}

    # Check if the function exists or not. If not then exit.
    declare -F ${command}_file >/dev/null
    [ $? -ne 0 ] && echo "Command not found : $command" && help_file

    # For each dot file
    for i in `find . -type f -name 'dot*'`
    do
      eval ${command}_file $i
    done

    # For each dot directory.
    for d in `find . -type d -name 'dot*'`
    do
      mkdir ~/${d/dot/} 2> /dev/null > /dev/null
      for i in `find ${d} -maxdepth 1 -type f `
      do
        eval ${command}_file $i
      done
      for i in `find ${d} -maxdepth 1 -mindepth 1 -type d`
      do
        eval ${command}_file $i
      done
    done
}


main $@

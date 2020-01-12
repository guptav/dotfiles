#!/usr/local/bin/bash

source=$PWD/dot.linuxify
target=~/.linuxify

brew install coreutils
brew install findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
ln -sf ${source} ${target}

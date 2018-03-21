#!/bin/bash

dest=${1}
host=${2}
source=`pwd`

echo "Install .dotfiles"
echo " "
echo -e "Source directory:\t"${source}
echo -e "Destination directory:\t"${dest}
echo -e "Hostname:\t"${host}

dotfiles() {
    ln -sf ${source}/bash_profile ${dest}/.bash_profile
    ln -sf ${source}/inputrc ${dest}/.inputrc
    ln -sf ${source}/git/gitconfig ${dest}/.gitconfig
    ln -sf ${source}/git/gitignore_global ${dest}/.gitignore_global
    ln -sf ${source}/vimrc ${dest}/.vimrc

    if [[ "$(uname -s)" == "Darwin" ]]; then
        ln -sf ${source}/hushlogin ${dest}/.hushlogin
        ln -sf ${source}/boom/boom ${dest}/.boom
    fi
}

directories() {
    ln -sfn ${source}/bin ${dest}/.bin
    ln -sfn ${source}/gap ${dest}/.gap
    ln -sfn ${source}/pip ${dest}/.pip
    ln -sfn ${source}/shell ${dest}/.shell
    ln -sfn ${source}/vim ${dest}/.vim

    if [[ "$(uname -s)" == "Darwin" ]]; then
        ln -sfn ${source}/pandoc ${dest}/.pandoc
    fi

    if [[ "$(uname -s)" == "Linux" ]]; then
        ln -sfn ${source}/remote ${dest}/.remote
    fi

    sed -i.bak s/ulysses/${host}/ ${source}/shell/utils.sh
    rm ${source}/shell/*.bak
}


if [[ "$(uname -s)" == "Darwin" ]]; then
    brew=`which brew`

    if [[ -z ${brew} ]]; then
        echo "brew not installed. Installing brew. . . "
        /usr/bin/ruby -e "$(curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "brew installed. Installing Brewfile. . . "
    brew bundle install --file=${source}/Brewfile
fi

dotfiles
directories

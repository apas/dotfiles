#!/bin/bash

dest=${1}
host=${2}
source=`pwd`

install_brew() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "== Brew"

        isbrew=`which brew`

        if [[ -z ${isbrew} ]]; then
            echo "Brew not installed. Installing brew. . . "
            /usr/bin/ruby -e "$(curl -fsSL \
            https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        echo "Brew installed. Installing Brewfile. . . "
        brew bundle install --file=${source}/Brewfile
    fi
}

dotfiles() {
    echo "== Dotfiles"

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
    echo "== Directories"

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

if [[ ! $# -eq 2 ]]; then
    echo "Pilgrim requires two parameters: destination path and hostname."
    echo "Please try again."
    echo " "
    echo "./pilgrim.sh path/to/install hostname"
    exit 0
fi

echo "Pilgrim will symlink dotfiles from/to the following directories:"
echo " "
echo -e "Source directory:\t\t"${source}
echo -e "Destination directory:\t\t"${dest}
echo -e "Hostname to use in PS1 prompt:\t"${host}
echo " "
read -p "Are you sure you want to continue? (yes/no) " answer

if [[ ${answer} == "yes" || ${answer} == "y" ]]; then
    dotfiles
    directories
    install_brew
else
    echo "Exiting."
    exit 0
fi

#!/bin/bash

dest=${1}
host=${2}
source=$(pwd)

install_brew() {
    echo "== Brew"
    isbrew=$(which brew)

    if [[ -z ${isbrew} ]]; then
        echo "Brew not installed. Installing brew. . ."
        if [[ "$(uname -s)" == "Darwin" ]]; then
            /usr/bin/ruby -e "$(curl -fsSL \
            https://raw.githubusercontent.com/Homebrew/install/master/install)"
        elif [[ "$(uname -s)" == "Linux" ]]; then
            sh -c "$(curl -fsSL \
            https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
        fi
    fi

    echo "Brew installed. Installing Brewfile. . ."
    if [[ "$(uname -s)" == "Darwin" ]]; then
        brew bundle install --file=${source}/Brewfile-darwin
    elif [[ "$(uname -s)" == "Linux" ]]; then
        brew bundle install --file=${source}/Brewfile-linux
    fi

    echo "Changing shell to brew's bash. . ."
    echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells > /dev/null
    chsh -s $(brew --prefix)/bin/bash
}

macos() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "== macOS defaults"

        ./macos/defaults.sh
    fi
}

xclt() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "== Xcode command line tools"

        xcode-select --install
    fi
}

dotfiles() {
    echo "== Dotfiles"

    ln -sf ${source}/bash_profile ${dest}/.bash_profile
    ln -sf ${source}/inputrc ${dest}/.inputrc
    ln -sf ${source}/git/gitconfig ${dest}/.gitconfig
    ln -sf ${source}/git/gitignore_global ${dest}/.gitignore_global
    ln -sf ${source}/vimrc ${dest}/.vimrc
    ln -sf ${source}/hushlogin ${dest}/.hushlogin
    ln -sf ${source}/tmux.conf ${dest}/.tmux.conf

    echo -e "\n[core]\n\texcludesfile = ${dest}/.gitignore_global" \
        >> ${dest}/.gitconfig

    gitconfig="\n[pager]\n\tlog = ${dest}/.bin/diff-highlight | less\n"
    gitconfig="${gitconfig}\tshow = ${dest}/.bin/diff-highlight | less\n"
    gitconfig="${gitconfig}\tdiff = ${dest}/.bin/diff-highlight | less"
    echo -e "${gitconfig}" >> ${dest}/.gitconfig

    isgit=$(which git)
    if [[ -z ${isgit} ]]; then
        git update-index \
            --assume-unchanged ${source}/git/gitconfig
        git update-index \
            --assume-unchanged ${source}/iterm/com.googlecode.iterm2.plist
    fi

    if [[ "$(uname -s)" == "Darwin" ]]; then
        ln -sf ${source}/xvimrc ${dest}/.xvimrc
    fi
}

directories() {
    echo "== Directories"

    ln -sfn ${source}/bin ${dest}/.bin
    ln -sfn ${source}/pip ${dest}/.pip
    ln -sfn ${source}/shell ${dest}/.shell
    ln -sfn ${source}/vim ${dest}/.vim
    ln -sfn ${source}/pandoc ${dest}/.pandoc

    mkdir -p ${dest}/.vim/{undodir,swp}
    chmod go-rwx ${dest}/.vim/{undodir,swp}

    mkdir -p ${dest}/.tmux_tmp

    if [[ "$(uname -s)" == "Linux" ]]; then
        ln -sfn ${source}/remote ${dest}/.remote
    fi

    sed -i.bak s/winston/${host}/ ${source}/shell/utils.sh
    rm ${source}/shell/*.bak
}

vim_plugins() {
    echo "== Vim plugins"

    declare -a plugins=("https://github.com/vim-scripts/delimitMate.vim.git" \
        "https://github.com/tomtom/tcomment_vim.git" \
        "https://github.com/altercation/vim-colors-solarized.git" \
        "https://github.com/airblade/vim-gitgutter.git" \
        "https://github.com/tpope/vim-unimpaired.git")

    mkdir -p ${source}/vim/bundle

    isgit=$(which git)

    if [[ -z ${isgit} ]]; then
        echo "Git not installed. Downloading Vim plugins with wget. . ."

        iswget=$(which wget)

        if [[ -z ${iswget} ]]; then
            echo "[Warning]: wget not installed."
            echo "Can't download GitHub repos with cURL because of cookies."
            echo "Please download Vim plugins manually."
        else
            for plugin in "${plugins[@]}"; do
                plugin=${plugin%????};
                plugin=${plugin}/archive/master.zip;
                wget -P ${source}/vim/bundle ${plugin};
                unzip -q ${source}/vim/bundle/master.zip \
                    -d ${source}/vim/bundle/temp;
                plugindir=$(ls ${source}/vim/bundle/temp);
                plugindir=${plugindir%???????};
                mv ${source}/vim/bundle/temp/* ${source}/vim/bundle/${plugindir};
                rm -rf ${source}/vim/bundle/temp \
                    ${source}/vim/bundle/master.zip;
            done
        fi
    else
        echo "Git installed. Cloning Vim plugins. . ."

        for plugin in "${plugins[@]}"; do
            git -C ${source}/vim/bundle clone ${plugin};
        done
    fi
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
    macos
    xclt
    install_brew
    vim_plugins
else
    echo "Exiting."
fi

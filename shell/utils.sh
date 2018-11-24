if [[ "$(uname -s)" == "Darwin" ]]; then
    sith() {
        val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
        val_ret=$?
        if [[ $val == "Dark" ]]; then
            i
        fi
    }

    i() {
        if [[ $ITERM_PROFILE == "Terminal" ]]; then
            echo -ne "\033]50;SetProfile=Dark\a"
            export ITERM_PROFILE="Dark"
        else
            echo -ne "\033]50;SetProfile=Terminal\a"
            export ITERM_PROFILE="Terminal"
        fi
    }

    sith
fi

red="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"
grn="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"
blu="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"
cyn="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"
rst="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

if [[ "$(uname -s)" == "Darwin" ]]; then
    export PS1="\[$blu\]\W\[$cyn\]\[$rst\] "
else
    m="\[$grn\][winston]\[$grn\]\[$rst\]"
    export PS1="$m \[$blu\]\w\[$cyn\]\[$rst\] "
fi

if [[ "$(uname -s)" == "Linux" ]]; then
    export PATH=$HOME/.remote:$PATH
fi

export PATH=$HOME/.bin:$PATH:$HOME/.go/bin:$HOME/.cargo/bin
export GOPATH=$HOME/.go
export EDITOR='vim'
export TMUX_TMPDIR=$HOME/.tmux_tmp

shopt -s no_empty_cmd_completion
shopt -s extglob

shopt -s cmdhist
shopt -s cdspell
shopt -s histappend
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

tk1=token1
tk2=token2
export SLACK_TOKEN=$tk1$tk2
export PYTHONDONTWRITEBYTECODE=1

# color modifications for brew grc
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

if [[ "$(uname -s)" == "Darwin" ]]; then
    export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

# point to and source z in order to track and build dir list
# assumes z installed via brew and current ver is 1.9
if [[ "$(uname -s)" == "Darwin" ]]; then
    . /usr/local/Cellar/z/1.9/etc/profile.d/z.sh
elif [[ "$(uname -s)" == "Linux" ]]; then
    . $HOME/.remote/z.sh
fi

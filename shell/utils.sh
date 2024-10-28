red="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"
grn="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"
blu="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"
cyn="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"
rst="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

if [[ "$(uname -s)" == "Darwin" ]]; then
    export PS1="\[$cyn\]λ \[$blu\]\w\[$blu\]\[$rst\] "
else
    m="\[$grn\][winston]\[$grn\]\[$rst\]"
    export PS1="$m \[$blu\]\w\[$cyn\]\[$rst\] "
fi

if [[ "$(uname -s)" == "Linux" ]]; then
    export PATH=$HOME/.remote:/home/linuxbrew/.linuxbrew/bin:$HOME/.cabal/bin:$PATH
fi

export PATH=$HOME/.bin:/opt/homebrew/bin:$PATH:$HOME/.go/bin:$HOME/.cargo/bin
export GOPATH=$HOME/.go
export EDITOR='vim'
export TMUX_TMPDIR=$HOME/.tmux_tmp
export BASH_SILENCE_DEPRECATION_WARNING=1

shopt -s no_empty_cmd_completion
shopt -s extglob

shopt -s cmdhist
shopt -s cdspell
shopt -s histappend
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a"

export PYTHONDONTWRITEBYTECODE=1

# color modifications for brew grc
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

if [[ "$(uname -s)" == "Darwin" ]]; then
    export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

# point to and source z in order to track and build dir list
. $HOME/.bin/z.sh

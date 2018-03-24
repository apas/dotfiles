source $HOME/.gap/prompt.sh

red="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"
grn="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"
blu="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"
cyn="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"
rst="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

m="\[$grn\][ulysses]\[$grn\]\[$rst\]"
export PS1="$m \[$blu\]\w\[$cyn\]\$gitb\[$red\]\$gitd\[$rst\] "

if [[ "$(uname -s)" == "Linux" ]]; then
    export PATH=$HOME/.remote:$PATH
fi

# /usr/local/texlive/2017basic/bin/x86_64-darwin
export PATH=$PATH:$HOME/.go/bin:$HOME/.cargo/bin
export GOPATH=$HOME/.go
export EDITOR='vim'

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
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

# point to and source z in order to track and build dir list
# assumes z installed via brew and current ver is 1.9
if [[ "$(uname -s)" == "Darwin" ]]; then
    . /usr/local/Cellar/z/1.9/etc/profile.d/z.sh
elif [[ "$(uname -s)" == "Linux" ]]; then
    . $HOME/.remote/z.sh
fi

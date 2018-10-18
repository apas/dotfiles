alias cl='clear'
alias path="pwd | pbcopy"
alias venv="virtualenv env"
alias venv2="virtualenv --python=/usr/local/bin/python2.7 env"
alias aenv="source env/bin/activate"
alias denv="deactivate"
alias code="cd $HOME/git"
alias finder="open -a Finder ."
alias giddy="source $HOME/.bash_profile"
alias ~="cd $HOME"
alias slack="node $HOME/git/terminal-slack/main.js"
alias gifs="boom gifs"
alias bu="brew update; brew upgrade; brew cleanup -s"
alias h="history | grep ${1}"

alias archey='archey -c'
alias server="python -m SimpleHTTPServer"
alias branch="git rev-parse --abbrev-ref HEAD"
alias shots="finder $HOME/Dropbox/Screenshots"
alias git-undo="git checkout HEAD $1"
alias chrome="open -a 'Google Chrome' $1"
alias j="jump"
alias v="vim"
alias s="subl"
alias cat="ccat -G String=green -G Comment=faint -G Decimal=darkyellow \
  -G Keyword=purple -G Tag=yellow -G Plaintext=white -G Type=darkred \
  -G Punctuation=white -G Literal=white -G HTMLTag=yellow \
  ${1}"
alias bat="bat -p --theme='Monokai Extended Light' ${@}"

alias broad="ssh broad"
alias hms="ssh hms"
alias harris="ssh harris"
alias mit="ssh mit"
alias almighty="ssh almighty"
alias cora="ssh cora"
alias csail="ssh csail"
alias partners="ssh partners"
alias clio="ssh clio"
alias afovia="ssh afovia"

if [[ "$(uname -s)" == "Linux" ]]; then
    alias grep="grep --color=auto"
    alias ls="ls --color=auto"
fi

alias ppath="echo $PATH | tr ':' '\n'"
alias hogs="ps wwaxr -o pid,stat,%cpu,time,name,comm | head -10"
alias gist='gist -R -Ppc -f ${1}'
alias llt="ls -lthUr"
alias llat="ls -althUr"
alias fuck='$(thefuck $(fc -ln -1))'
alias ping='grc -es --colour=auto ping'
alias traceroute='grc -es --colour=auto traceroute'
alias monitor_dns="sudo tcpdump -i en0 -s 5000 -n port 53"
alias status="echo -n 'Branch: ' \
    && git rev-parse --abbrev-ref HEAD && git status -s"
alias mlb="open -a Safari 'https://encrypted.google.com/search?hl=en&q=mlb'"

alias ip='curl ifconfig.co'
alias netcons='lsof -i'
alias flushdns='dscacheutil -flushcache'
alias lsock='sudo /usr/sbin/lsof -i -P'
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'
alias ipinfo0='ipconfig getpacket en0'
alias ipinfo1='ipconfig getpacket en1'
alias openports='sudo lsof -i | grep LISTEN'
alias showblocked='sudo ipfw list'

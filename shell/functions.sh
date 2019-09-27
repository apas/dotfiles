pdf() {
  convert -flatten ${1}[0] - 2>/dev/null | imgcat
}

peek() {
    tmux split-window -p 40 $EDITOR $@ || exit;
}

mergepdf() {
    if [[ $# -eq 0 ]]; then
        echo "Merge PDFs."
        echo -e "Use:\n\tmergepdf FILE1 FILE2 FILE3..."
    else
        gs -q \
            -dNOPAUSE \
            -dBATCH \
            -sDEVICE=pdfwrite \
            -sOutputFile=merged.pdf \
            ${@}
    fi
}

edit() {
  if [[ $# -eq 1 ]]; then
    if [[ $1 == "aliases" ]]; then
      $EDITOR $HOME/.shell/aliases.sh
    elif [[ $1 == "functions" ]]; then
      $EDITOR $HOME/.shell/functions.sh
    elif [[ $1 == "utils" ]]; then
      $EDITOR $HOME/.shell/utils.sh
    fi
  else
    echo "Missing parameter: dotfile"
  fi
}

ds() {
    if [[ $# -eq 1 ]]; then
        du -ah ${1}
    elif [[ $# -eq 2 ]]; then
        if [[ ${1} == "-s" ]]; then
            du -sh ${2%/}
        else
            echo "directory size: missing parameter or wrong syntax."
            echo "ds [-s] path/to/directory"
        fi
    else
        echo "directory size: missing parameter or wrong syntax."
        echo "ds [-s] path/to/directory"
    fi
}

t() {
    if [[ $# -eq 0 ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
            tmux -CC
        else
            tmux
        fi
    elif [[ ${1} == "-a" ]]; then
        if tmux has-session -t ${2} > /dev/null 2>&1; then
            if [[ "$(uname -s)" == "Darwin" ]]; then
                tmux -CC attach -t ${2}
            else
                tmux attach -t ${2}
            fi
        else
            if [[ "$(uname -s)" == "Darwin" ]]; then
                tmux -CC new -s ${2}
            else
                tmux new -s ${2}
            fi
        fi
    elif [[ ${1} == "-l" ]]; then
        tmux ls
    elif [[ ${1} == "-k" ]]; then
        tmux kill-session -t ${2}
    elif [[ $# -eq 3 ]]; then
        if [[ ${1} == "-r" ]]; then
            tmux rename-session -t ${2} ${3}
        fi
    else
        echo "tmux wrapper (plain tmux and iTerm integration)"
        echo "Use: t [-a | -l | -k | -r NAME NAME_NEW]"
        echo " "
        echo -e "Options:\n\t-a:\tattach to or create session"
        echo -e "\t-l:\tlist tmux sessions"
        echo -e "\t-k:\tkill tmux session"
        echo -e "\t-r:\trename tmux session"
    fi
}

encrypt() {
    file=$1

    filename=$(basename "$file")        # get filename without path
    ext="${filename##*.}"               # get file extension
    name="${filename%.*}"               # get filename
    directory=$(dirname "$file")        # get directory path
    payload=$directory/$name-e.$ext

    if [[ $# -eq 1 ]]; then
        read -s -p "Encryption password: " filepasswd
        qpdf --encrypt $filepasswd ' ' 256 -- "$file" "$payload"
        echo -e "\nEncryption successful!"
    else
        echo "Missing parameter or wrong syntax. Needs one file name."
        echo "encrypt file"
    fi
}

jump() {
  dirpath=`pwd`
  input=$1
  newdir="/"

  for i in $(echo $dirpath | tr "/" "\n"); do
      if [[ $input == $i ]]; then
          newdir+=$input/
          echo $newdir
          cd $newdir
      fi
      newdir+=$i/
  done
}

getshots() {
  numberOfFiles=${1}

  ls -lthUr1 -d -1 $HOME/Dropbox/Screenshots/{*,.*} \
    | tail -n ${numberOfFiles} \
    | while read line; do
    echo "${line}"; \
    cp "${line}" .; \
  done
}

loc() {
  find . \
    -name ${1} \
    -type f | \
    xargs wc -l
}

batt() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        remaining=`pmset -g batt | awk 'FNR==2 {print $5}'`
        pct=`ioreg -c AppleSmartBattery -r | \
            awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%";
            max=c["\"MaxCapacity\""]; if (max>0) { print
            100*c["\"CurrentCapacity\""]/max;} }'`

        echo "Remaining: ${remaining} hrs, ${pct}%"
    fi
}

vupd() {
    current_dir=$(pwd)
    cd $HOME/.vim/bundle
    for plugin in $(ls); do
        cd "${plugin}"
        echo "== Updating plugin: ${plugin}"
        git pull
        echo " "
        cd ..
    done
    cd ${current_dir}
}

move-here() {
  numberOfFiles=${1}

  ls -lthUr1 -d -1 $HOME/Downloads/{*,.*} \
    | tail -n ${numberOfFiles} \
    | while read line; do
    echo "${line}"; \
    mv "${line}" .; \
  done
}

tdir() {
  tar -zcvf ${1%?}.tar.gz ${1%?}
}

utdir() {
  if [[ $# -eq 1 ]]; then
    tar xvzf ${1}
  elif [[ $# -eq 2 ]]; then
    mkdir -p ${2}
    tar xvzf ${1} -C ${2}
  fi
}

list() {
  if [[ $# -eq 1 ]]; then
    ls -alh | grep ${1}
  elif [[ $1 == "-one" ]]; then
    ls -1 | grep ${2}
  elif [[ $# -eq 2 ]]; then
    ls -alh ${1} | grep ${2}
  else
    echo "Example: list [/path/to/dir] file-type"
  fi
}

# sp: search and preview
sp() {
  list -one *${1}*.pdf \
    | while read filels; do
        if [[ -z ${filels} ]]; then
          echo "sp: empty list output"
        else
          preview ${filels};
        fi
      done
}

dropbox() {
  local base_url="https://dl.dropboxusercontent.com/u/353609/"

  if [[ $# -eq 2 ]]; then
    cp ${1} $HOME/Dropbox/Public/
    local url=${base_url}${1}
    echo ${url} | pbcopy
    open -a Safari ${url}
  else
    cp ${1} $HOME/Dropbox/Public/
    local url=${base_url}${1}
    echo ${url} | pbcopy
  fi
}

sp2u() {
  for i in "$@"; do
    mv -iv "$i" "${i// /_}";
  done
}

gifcat() {
  boom gifs ${1} > /dev/null
  curl -s $(pbpaste) | imgcat
}

copy() {
  /bin/cat $1 | pbcopy
}

wi() {
    word_lookup=${2}

    if [[ ${1} == "-d" ]]; then
        open "http://de.wiktionary.org/wiki/"${word_lookup}
    elif [[ ${1} == "-e" ]]; then
        open "http://en.wiktionary.org/wiki/"${word_lookup}
    elif [[ ${1} == "-g" ]]; then
        open "http://el.wiktionary.org/wiki/"${word_lookup}
    else
        echo "Wiktionary wrapper"
        echo "Use: wi [-d | -e | -g] WORD"
    fi
}

twitter() {
    word_lookup=${1}
    open "https://twitter.com/search?q=from%3Aapas%20"${word_lookup}
}

wolfram() {
  query=${@}
  open "https://www.wolframalpha.com/input/?i=""${query}"
}

randomizemac() {
  openssl rand -hex 6 | \
  sed 's/\(..\)/\1:/g; s/.$//' | \
  xargs sudo ifconfig en0 ether
}

# alias ll='ls -lh'
ll() {
  current_dir=$(pwd)
  dls_dir="/Users/apas/Downloads"
  papers_dir="/Users/apas/Dropbox/Papers/to-read"
  if [[ ${current_dir} == ${dls_dir} || ${1} == ${dls_dir}'/' ]]; then
    llt ${1}
  elif [[ ${current_dir} == ${papers_dir} || ${1} == ${papers_dir}'/' ]]; then
    llt ${1}
  else
    ls -lh ${1}
  fi
}

# alias lla='ls -alh'
lla() {
  current_dir=$(pwd)
  dls_dir="/Users/apas/Downloads"
  if [[ ${current_dir} == ${dls_dir} || ${1} == ${dls_dir}'/' ]]; then
      llat ${1}
  else
    ls -alh ${1}
  fi
}

dash() {
  open dash://$1
}

facetime() {
  open facetime://${1}
}

call() {
  input_tel=${*}
  clean_tel=${input_tel//[[:blank:]]/}
  open tel://${clean_tel}
}

preview() {
  open -a Preview ${*}
}

count() {
  cat $1 | tr [:space:] '\n' | grep -v "^\s*$" | sort | uniq -c | sort -bnr
}

checkdiff() {
  comm -2 -3 $1 $2 > diff.txt && cat diff.txt
}

commit-latest() {
  if [[ -z "${1}" ]]; then
    echo "Please specify an integer to determine number of commits."
  else
    git log --format="%h - %s - %an" -n ${1}

    if [[ "$(uname -s)" == "Darwin" ]]; then
        git log --format="%h - %s - %an" -n ${1} | \
            awk 'END {print $1}' | \
            pbcopy
    fi
  fi
}

commit-files() {
  if [[ ${#} -eq 0 ]]; then
    echo "Need parameters."
    echo "commit-files <commit hash>"
  elif [[ ${#} -eq 1 ]]; then
    git diff-tree --no-commit-id --name-only -r ${1}
  else
    echo "Invalid parameters."
    echo "commit-files <commit hash>"
  fi
}

commit-diff() {
  if [[ ${#} -eq 0 ]]; then
    echo "Please specify a git commit by hash."
    echo -e "\t usage: commit-diff [-l, --less] d71b1c5"
    echo -e "\t\t -l, --less show the diff with less"
  elif [[ ${#} -eq 2 ]]; then
    if [[ ${1} == "-l" || ${1} == "--less" ]]; then
      git diff ${2}^! | less -R
    else
      echo "Invalid parameters."
      echo "Please specify a git commit by hash."
      echo -e "\t usage: commit-diff [-l, --less] d71b1c5"
      echo -e "\t\t -l, --less show the diff with less"
    fi
  else
    git diff ${1}^!
  fi
}

ck() {
  declare -a array=("‘I'm bored’ is a useless thing to say. You live in a great, big, vast world that you've seen none percent of." 
    "America's a family. We all yell at each other. It all works out." 
    "I don't stop eating when I'm full. The meal isn't over when I'm full. It's over when I hate myself." 
    "Life isn't something you possess. It's something you take part in, and you witness." 
    "It's more fun to experience things when you don't know what's going to happen." 
    "I think one reason TV has always done well is because there is something comforting where you kind of know what you're going to be taken through." 
    "Well, but maybe..." 
    )

  var=$[ 0 + $[ $RANDOM % 6 ]]
  echo ${array[$var]}
}

port() {
    if [[ $# -eq 0 ]]; then
        echo "List open files by process at PORT"
        echo -e "\nUsage:\n\tport [-k] PORT"
        echo -e "\n\t-k:\tkills process at PORT"
    elif [[ $# -eq 1 ]]; then
        lsof -i :${1}
    elif [[ $# -eq 2 && ${1} == "-k" ]]; then
        lsof -i :${2} | awk '{print $2}' | tail -n 1 | xargs kill
    fi
}

mcd() {
  mkdir $1 && cd $1
}

#needs brew install ttytter
tw() {
  input=$@ && echo $input | ttytter
}

graph() {
  git log \
    --graph \
    --abbrev-commit \
    --decorate \
    --date=relative \
    --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(bold normal)%s%C(reset) %C(dim yellow)- %an%C(reset)%C(bold cyan)%d%C(reset)' \
    --all
}

gh() {
  if [[ $# -eq 1 ]]; then
    giturl=$(git config --get remote.origin.url)
    if [ "$giturl" == "" ]
      then
       echo "Not a git repository or no remote.origin.url set"
       # exit 0;
    fi
   
    giturl=${giturl/git\@github\.com\:/https://github.com/}
    giturl=${giturl/\.git/\/tree}
    branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch="(unnamed branch)"     # detached HEAD
    branch=${branch##refs/heads/}
    giturl=$giturl/$branch/$1
    open $giturl
  fi

  if [[ $# -ne 1 ]]; then
    giturl=$(git config --get remote.origin.url)
    if [ "$giturl" == "" ]
      then
       echo "Not a git repository or no remote.origin.url set"
       # exit 0;
    fi
   
    giturl=${giturl/git\@github\.com\:/https://github.com/}
    giturl=${giturl/\.git/\/tree}
    branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch="(unnamed branch)"     # detached HEAD
    branch=${branch##refs/heads/}
    giturl=$giturl/$branch
    open $giturl
  fi
}

m3u8() {
    if [[ $# -eq 1 ]]; then
        ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto \
            -i "${1}" \
            -c copy video.mp4
    elif [[ $# -eq 2 ]]; then
        m3u8 ${2}
        gifify video.mp4
        rm video.mp4
    else
        echo "m3u8 [-g] <.m3u8 link>"
        echo -e "-g\t\tsaves m3u8 directly to gif"
    fi
}

gifify() {
  if [[ $# -eq 1 ]]; then
    ffmpeg -i ${1} -filter_complex "fps=10" out.gif
  elif [[ $# -eq 3 ]]; then
    ffmpeg -i ${3} -filter_complex "fps=10,scale=-1:${2}" out.gif
  else
    echo "proper usage: gifify [-r size-in-pix] <input_movie.mov>"
    echo -e "-r\t\tresizes gif to given pixel size keeping aspect ratio"
  fi
}

whereami() {
  echo -e "You are logged on: ${RED}$HOSTNAME"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date:$NC " ; date
  echo -e "\n${RED}Machine stats:$NC " ; uptime
  echo -e "\n${RED}Current network location:$NC " ; scselect
  echo -e "\n${RED}Public facing IP Address:$NC " ; ip
}

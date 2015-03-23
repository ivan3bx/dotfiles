if [ -e $HOME/.profile ]; then source `pwd`/.profile; fi

#
# Git command completions
#
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash

#
# Racket
#
if [ -e '/Applications/Racket\ v6.1.1/bin' ]
then
  export PATH=$PATH:/Applications/Racket\ v6.1.1/bin
fi

#
# RVM
#
#export CC=gcc-4.2

#
# Git
#
alias gs='git status'
alias gu='git pull'
alias gl='git log'

#
# Go
#
export GOPATH=/usr/local/Cellar/go/1.4.2/libexec/
export PATH=$PATH:${GOPATH//://bin:}/bin

#
# ls
#
alias ls='ls -Fc'
alias ll='ls -ltr'
alias la='ls -a'

#
# Services
#
alias postgres_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias postgres_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias redis_start='redis-server /usr/local/etc/redis.conf'
alias memcache_start='memcached -p 11211 &'
alias spec="bundle exec spec --color --format progress"

#
# Proxies
#
alias bundle_proxy="http_proxy=http://localhost:3132 bundle"

#
# Shell Defaults
#
export EDITOR="/usr/local/bin/mate -w"
export TERM=xterm-color
export CLICOLOR=1
export LSCOLORS=cxgxcxdxbxegedabagacad
export ARCHFLAGS='-arch x86_64'

#
# JDK defaults
#
export M2_HOME=/usr/local/Cellar/maven30/3.0.5/libexec
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home

#
# Scala / SBT
#
export SBT_OPTS=-XX:MaxPermSize=256M
export SCALA_HOME=/usr/local/Cellar/scala/2.9.1/libexec

#
# Python defaults
#
alias ipython='ipython --colors=Linux'

#
# Open man page in Preview, or TextMate
#
pman () {
    man -t "${1}" | open -f -a /Applications/Preview.app
}

tman () {
  MANWIDTH=160 MANPAGER='col -bx' man $@ | mate
}



##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
  # How many characters of the $PWD should be kept
  local pwdmaxlen=10
  # Indicate that there has been dir truncation
  local trunc_symbol=""
  local dir=${PWD##*/}
  pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
  NEW_PWD=${PWD/$HOME/~}
  local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
  if [ ${pwdoffset} -gt "0" ]
    then
    NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
    NEW_PWD=${NEW_PWD#*/}
  fi
}

parse_git_branch() {
  local DIRTY STATUS
  STATUS=$(git branch 2>/dev/null)
  [ $? -eq 128 -o $? -eq 127 ] && return
  # [[ "$STATUS" == *'working directory clean'* ]] || DIRTY=''
  echo " ($(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'))"         # Full path
}

bash_prompt() {
  local NONE='\[\033[0m\]'    # unsets color to term's fg color

  # regular colors
  local  K='\[\033[0;30m\]'   # black
  local  R='\[\033[0;31m\]'   # red
  local  G='\[\033[0;32m\]'   # green
  local BR='\[\033[0;33m\]'   # brown
  local  B='\[\033[0;34m\]'   # blue
  local  M='\[\033[0;35m\]'   # magenta
  local  C='\[\033[0;36m\]'   # cyan
  local LY='\[\033[0;37m\]'   # light gray

  local DG='\[\033[1;30m\]'   # dark gray
  local LR='\[\033[1;31m\]'   # light red
  local LG='\[\033[1;32m\]'   # light green
  local  Y='\[\033[1;33m\]'   # yellow
  local LB='\[\033[1;34m\]'   # light blue
  local LP='\[\033[1;35m\]'   # light purple
  local LC='\[\033[1;36m\]'   # light cyan
  local W='\[\033[1;37m\]'    # dark gray

  # background colors
  local BGK='\[\033[40m\]'  # black
  local BGR='\[\033[41m\]'  # red
  local BGG='\[\033[42m\]'  # green
  local BGBR='\[\033[43m\]' # brown
  local BGB='\[\033[44m\]'  # blue
  local BGM='\[\033[45m\]'  # purple
  local BGC='\[\033[46m\]'  # cyan
  local BGG='\[\033[47m\]'  # gray

  local UC=$C                 # user's color
  [ $UID -eq "0" ] && UC=$R   # root's color

  PS1="${NONE}${R}\u@\h${LY}:${BR}\${NEW_PWD}${LG}\$(parse_git_branch) ${LY}> ${NONE}"
}

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="/usr/local/sbin:$PATH"

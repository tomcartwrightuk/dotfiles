# Many props to the urbanautomaton (https://github.com/urbanautomaton/dotfiles)

####################
# Helper Functions #
####################

function command_exists() {
  type -t "$1" >/dev/null
}

function source_if_present() {
  # This warning complains about a non-constant source location, but that's
  # the point of this function, so. What're you gonna do eh?
  #
  # shellcheck disable=SC1090
  [[ -f "$1" ]] && source "$1"
}

function path_contains() {
  [[ ":$PATH:" == *":$1:"* ]]
}

function directory_exists() {
  [[ -d "$1" ]]
}

function append_path() {
  path_contains "$1" || export PATH="${PATH:+"$PATH:"}$1"
}

function append_path_if_present() {
  directory_exists "$1" && append_path "$1"
}

##################
# Les poubellles #
##################

append_path_if_present "$HOME/bin"
append_path_if_present /usr/local/sbin
append_path_if_present /opt/local/sbin
append_path_if_present /usr/local/bin
append_path_if_present "$HOME/code/go/bin"
append_path_if_present ~/Library/Python/2.7/bin
append_path_if_present /usr/local/go/bin/

###############
# Other paths #
###############

source_if_present bash_aliases
export GOPATH=$HOME/code/go
export GOROOT=/usr/local/go
export PGHOST=localhost
export MAGICK_HOME="$HOME/bin/ImageMagick-7.0.3"
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"

# Set colours to xterm-256 when using tmux
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Node setup
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Machine setup
export EDITOR="vi"
export PERL_MB_OPT="--install_base \"/Users/$USER/perl5\"";
export PERL_MM_OPT="INSTALL_BASE=/Users/$USER/perl5";
export NVM_DIR="/Users/$USER/.nvm"

# PROMPT SETUP
function parse_git_branch {
  if [ "$PATH/.git" ]; then
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/';
  fi;
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local     DEFAULT="\[\033[0m\]"
  PS1="\[\033[01;33m\]\u@\h$BLUE\$(parse_git_branch)$GREEN:\w\[\033[01;35m\]$ $DEFAULT"
}
proml

# BASH ALIASES
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# GIT ALIASES
alias gti="git"
alias gs="git status"
alias gl="git log"
alias gc="git checkout"
alias ga="git add"
alias gaa="git add --all"
alias gd="git diff --color"
alias gdc="git diff --cached --color"
alias gm="git commit -m"
alias gco="git commit"
alias gam="git add . && git commit"
alias gb="git branch"
alias gp="git pull"
alias gitp="git rev-parse --abbrev-ref HEAD | xargs git push --set-upstream origin"
alias gbgrep="git branch | grep"
alias gbsp="git stash && git pull"
alias gsp="git stash pop"
alias hubb="hub browse"
alias hubpr="hub pull-request"

# FILE ALIASES
alias ls="ls -G"
alias lsa='ls -la'
alias lart="ls -lart"
alias grepall="grep -r -i -n"

# COMMAND ALIASES
alias ghost="/usr/local/bin/gs"
alias cls='clear sc'
alias sudovim="sudo mvim -v"
alias vimdiff="mvim -v"
alias view="mvim -v"
alias hidden_files="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
alias hidden_files_off="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias weather="curl -4 http://wttr.in/Bristol"
alias h="heroku"

# Programming commands
alias be='bundle exec'
alias cf="cucumber features/"
alias rs="rspec spec/ --color"
alias psra="ps aux | grep rack"
alias grm="go run main.go"

# KUBERNETES
alias kubeps="kubectl get pod --all-namespaces"
alias kubep='kubectl --context=$PROD_CON'
alias kubeci='kubectl --context=$CI_CON'
alias kube='kubectl'

# MAC SPECIFIC
if [[ $(uname) == "Darwin" ]]; then
  alias vi="mvim -v"
  alias vim="mvim -v"


  if command_exists gcloud; then
    local dev_box_name = 'tom-dev-box'
    alias moshdev="mosh -p 60000 tecartwright@`gcloud compute instances list | grep $dev_box_name | awk '{print $5}'`"
    alias sshbox="ssh tecartwright@`gcloud compute instances list | grep $dev_box_name | awk '{print $5}'`"
  fi
fi

# Golang commands
symgo() {
  project=$1
}

# Function commands
# Grep git branch with a pattern and checkout to that branch if it matches
gbg() {
  b=$(git branch | grep $1)
  c=$(echo "$b" | wc -l)
  if [ $c -eq 1 ]
    then
    git checkout $b
  else
    echo "$c matching branches found. Be more specific:"
    echo "$b"
  fi
}

gots() {
  go test -test.run="^${1}$"
}

# Delete local and remote git branches
gbrm() {
  gb -D $2
  git push origin :$1
}

# Setup history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
export HISTTIMEFORMAT="%d/%m/%y %T "
shopt -s histappend                      # append to history, don't overwrite it

# Restart postgres after crash
pg_reboot() {
  rm /usr/local/var/postgres/postmaster.pid
  pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
}

# Grep for aws instances
awsin() {
  aws ec2 describe-instances --filters "Name=tag:Name,Values=*$1*" --query 'Reservations[].Instances[].[PrivateIpAddress,PublicDnsName,InstanceId,Tags[?Key==`Name`].Value[]]' --output text
}

if command_exists rbenv; then
  eval "$(rbenv init -)"
fi
alias sshbast="ssh -F /Users/$USER/.ssh/bastion_config"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

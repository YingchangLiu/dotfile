#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


export EDITOR='vim'

export DOTROOT="/home/kelen/dotfile"

export SHELLROOT="${DOTROOT}/shellrc"

## environment
[[ ! -f $SHELLROOT/history.sh ]] || source "$SHELLROOT/history.sh" #2>/dev/null
[[ ! -f $SHELLROOT/environment.sh ]] || source "$SHELLROOT/environment.sh" #2>/dev/null

## Load functions
[[ ! -f $SHELLROOT/bashfuns.sh ]] || source "$SHELLROOT/bashfuns.sh" #2>/dev/null
[[ ! -f $SHELLROOT/functions.sh ]] || source "$SHELLROOT/functions.sh" #2>/dev/null

[[ ! -f $SHELLROOT/commonplugin.sh ]] || source $SHELLROOT/commonplugin.sh #2>/dev/null
[[ ! -f $SHELLROOT/bashplugin.sh ]] || source "$SHELLROOT/bashplugin.sh" #2>/dev/null
[ -f "$SHELLROOT/alias.sh" ] && source "$SHELLROOT/alias.sh"
[ -f "$SHELLROOT/path.sh" ] && source "$SHELLROOT/path.sh"
[ -f "$SHELLROOT/language.sh" ] && source "$SHELLROOT/language.sh"

[ -f "$SHELLROOT/custom.sh" ] && source "$SHELLROOT/custom.sh"  #2>/dev/null

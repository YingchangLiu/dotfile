#!/bin/bash
# Useful functions


# ex - archive extractor
# usage: ex <file> [directory]
ex ()
{
    if [ -f $1 ] ; then
        FILENAME=$(basename $1)
        DIR=${2:-${FILENAME%%.*}}
        mkdir -p $DIR
        case $1 in
            *.tar.bz2)  tar xjf $1 -C $DIR      ;;
            *.tar.gz)   tar xzf $1 -C $DIR      ;;
            *.tar.xz)   tar xJf $1 -C $DIR      ;;
            *.tar.zst)  tar xf  $1 -C $DIR      ;;
            *.bz2)      bunzip2 $1 -C $DIR      ;;
            *.rar)      unrar x $1 $DIR      ;;
            *.gz)       gunzip $1 -C $DIR       ;;
            *.tar)      tar xf $1 -C $DIR       ;;
            *.tbz2)     tar xjf $1 -C $DIR      ;;
            *.tgz)      tar xzf $1 -C $DIR      ;;
            *.zip)      unzip $1 -d $DIR        ;;
            *.Z)        uncompress $1 -C $DIR   ;;
            *.7z)       7z x $1 -o$DIR         ;;
            *.xz)       unxz $1 -C $DIR         ;;
            *.exe)      cabextract $1 -d $DIR   ;;
            *.deb)      ar x $1 $DIR         ;;
            *.lzma)     unlzma $1 -C $DIR       ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


# cx - archive creator
# usage: cx <file_or_dir> [file]
cx ()
{
    if [ -e $1 ] ; then
        FILE=${2:-$(basename $1).tar.gz}
        case $FILE in
            *.tar.bz2)  tar cjf $FILE -C $(dirname $1) $(basename $1)      ;;
            *.tar.gz)   tar czf $FILE -C $(dirname $1) $(basename $1)      ;;
            *.tar.xz)   tar cJf $FILE -C $(dirname $1) $(basename $1)      ;;
            *.tar.zst)  tar cf  $FILE -C $(dirname $1) $(basename $1)      ;;
            *.bz2)      bzip2 -c $1 > $FILE ;;
            *.rar)      rar a $FILE $1        ;;
            *.gz)       gzip -c $1 > $FILE ;;
            *.tar)      tar cf $FILE -C $(dirname $1) $(basename $1)       ;;
            *.tbz2)     tar cjf $FILE -C $(dirname $1) $(basename $1)      ;;
            *.tgz)      tar czf $FILE -C $(dirname $1) $(basename $1)      ;;
            *.zip)      zip -r $FILE $1       ;;
            *.Z)        compress -c $1 > $FILE ;;
            *.7z)       7z a $FILE $1         ;;
            *.xz)       xz -c $1 > $FILE ;;
            *.exe)      echo "'$1' cannot be compressed to '$FILE' via cx()" ;;
            *.deb)      echo "'$1' cannot be compressed to '$FILE' via cx()" ;;
            *.lzma)     lzma -c $1 > $FILE ;;
            *)          echo "'$1' cannot be compressed to '$FILE' via cx()" ;;
        esac
    else
        echo "'$1' is not a valid file or directory"
    fi
}

# get_distro - get the name of the distribution
get_distro() {
    if command -v lsb_release > /dev/null; then
        DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        DISTRO="unknown"
    fi
    echo $DISTRO
}

# V2Ray control，rc-service or systemctl is optional
v2control() {
    if [ "$1" = "start" ] || [ "$1" = "stop" ]; then
        if [[ $(ps --no-headers -o comm 1) == "systemd" ]]; then
            sudo systemctl $1 v2ray v2raya
        elif [[ $(command -v openrc) ]]; then
            sudo rc-service v2ray $1
            sudo rc-service v2raya $1
        else
            echo "Neither systemd nor openrc is being used"
        fi
    else
        echo "Invalid argument. Use 'start' or 'stop'."
    fi
}


delete_branches_except() {
    cmd='git branch'
     for i in $*; do
       cmd=$cmd' | grep -v "'$i'"'
     done
     cmd=$cmd' | xargs git branch -D'
     eval $cmd
}


## set_path function is used to add directories to PATH.
set_path(){
    # Check if user id is 0 (root) or 1000 or higher
    [[ "$(id -u)" -eq 0 ]] || [[ "$(id -u)" -ge 1000 ]] || return

    # Split the iput into an array using ' ' and ':' as the delimiters
    IFS=': ' read -r -a paths <<< "$@"

    for i in "${PATHS[@]}";
    do
        # Check if the directory exists and is not empty
        [[ -d "$i" && -n "$i" ]] || continue

        # Convert to absolute path
        i=$(realpath "$i")

        # Check if it is not already in your $PATH.
        [[ ":$PATH:" == *":$i:"* ]] && continue

        # Then append it to $PATH and export it
        export PATH="$i:${PATH}"
    done
}

## set_ld_library_path function is used to add directories to LD_LIBRARY_PATH.
set_ld_library_path(){
    # Check if user id is 0 (root) or 1000 or higher
    [[ "$(id -u)" -eq 0 ]] || [[ "$(id -u)" -ge 1000 ]] || return

    # Split the iput into an array using ' ' and ':' as the delimiters
    IFS=': ' read -r -a paths <<< "$@"

    for i in "${PATHS[@]}";
    do
        # Check if the directory exists and is not empty
        [[ -d "$i" && -n "$i" ]] || continue

        # Convert to absolute path
        i=$(realpath "$i")

        # Check if it is not already in your $LD_LIBRARY_PATH.
        [[ ":$LD_LIBRARY_PATH:" == *":$i:"* ]] && continue

        # Then append it to $LD_LIBRARY_PATH and export it
        export LD_LIBRARY_PATH="$i:${LD_LIBRARY_PATH}"
    done
}

## set_library_path function is used to add directories to LIBRARY_PATH.
set_library_path(){
    # Check if user id is 0 (root) or 1000 or higher
    [[ "$(id -u)" -eq 0 ]] || [[ "$(id -u)" -ge 1000 ]] || return

    # Split the iput into an array using ' ' and ':' as the delimiters
    IFS=': ' read -r -a paths <<< "$@"

    for i in "${PATHS[@]}";
    do
        # Check if the directory exists and is not empty
        [[ -d "$i" && -n "$i" ]] || continue

        # Convert to absolute path
        i=$(realpath "$i")

        # Check if it is not already in your $LIBRARY_PATH.
        [[ ":$LIBRARY_PATH:" == *":$i:"* ]] && continue

        # Then append it to $LIBRARY_PATH and export it
        export LIBRARY_PATH="$i:${LIBRARY_PATH}"
    done
}

## set_cpath function is used to find include files.
set_cpath(){
    # Check if user id is 0 (root) or 1000 or higher
    [[ "$(id -u)" -eq 0 ]] || [[ "$(id -u)" -ge 1000 ]] || return

    # Split the iput into an array using ' ' and ':' as the delimiters
    IFS=': ' read -r -a paths <<< "$@"

    for i in "${PATHS[@]}";
    do
        # Check if the directory exists and is not empty
        [[ -d "$i" && -n "$i" ]] || continue

        # Convert to absolute path
        i=$(realpath "$i")

        # Check if it is not already in your $CPATH.
        [[ ":$CPATH:" == *":$i:"* ]] && continue

        # Then append it to $CPATH and export it
        export CPATH="$i:${CPATH}"
    done
}

__kitty_complete() {
    # load kitty completions if in kitty
    if test "$TERM" = "xterm-kitty"; then
        if (( $+commands[kitty] )); then
            eval "$(kitty + complete setup zsh)"
        fi
    fi
}

# mkcd - make directory and change to it
mkcd () {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# back - go back to the previous directory
back() {
    cd "$OLDPWD"
}

# Find a file in the current directory
f() {
    find . -name "$1" 2>/dev/null
}

# Find a file whose name contains the given string
ff() {
    grep -r "$1" 2>/dev/null
}

# check disk usage
duh() {
    du -sh * 2>/dev/null
}

# check network status
netstat() {
    sudo netstat -tuln
}

# check process status
psg() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# check system status
load() {
    echo "uptime:"
    uptime
    echo "-------------------------------------"
    echo "cpu info:"
    mpstat 1 3
}

# check memory status
mem() {
    echo "mem info:"
    free -h
}
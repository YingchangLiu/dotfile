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
DISTRO=$(get_distro)
case $DISTRO in
    *Arch*|*arch*)
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
    ;;
    *Debian*|*debian*)
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
    source ~/.config/powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
    . /etc/zsh_command_not_found 2>/dev/null  # need command-not-found
    ;;
# else
#     echo "This is not Arch Linux or Debian. You need fix the plugin path for your distrobution."
esac

# You should install "pkgfile" and exec 'sudo pkgfile -u' in archlinux or "command-not-found" in debian to use the script.
source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null

source /usr/share/autojump/autojump.zsh 2>/dev/null
autoload -Uz compinit
compinit -u
# kitty + complete setup zsh | source /dev/stdin 2>/dev/null

__kitty_complete() {
    # load kitty completions if in kitty
    if test "$TERM" = "xterm-kitty"; then
        if (( $+commands[kitty] )); then
            eval "$(kitty + complete setup zsh)"
        fi
    fi
}
autoload -Uz __kitty_complete


DISTRO=$(get_distro)
case $DISTRO in
    *Arch*|*arch*)
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
    source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh 2>/dev/null
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
    # You should install "pkgfile" and exec 'sudo pkgfile -u' in archlinux or "command-not-found" in debian to use the script.
    source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null
    ;;
    *Debian*|*debian*)
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
    source $HOME/.config/powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
    . /etc/zsh_command_not_found 2>/dev/null  # need command-not-found
    ;;
    *Gentoo*|*gentoo*)
    source /usr/share/zsh/site-functions/powerlevel10k/powerlevel10k.zsh-theme 2>/dev/null
    source /usr/share/zsh/site-functions/zsh-autocomplete/zsh-autocomplete.plugin.zsh 2>/dev/null
    source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh 2>/dev/null
    source /usr/share/zsh/site-functions/zsh-history-substring-search.zsh 2>/dev/null
    source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh 2>/dev/null
    ;;
# else
#     echo "This is not Arch Linux / Debian or Gentoo. You need fix the plugin path for your distrobution."
esac



source /usr/share/autojump/autojump.zsh 2>/dev/null

# kitty + complete setup zsh | source /dev/stdin 2>/dev/null


autoload -Uz __kitty_complete

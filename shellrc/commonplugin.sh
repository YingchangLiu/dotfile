# Enable nnn plugins
source $HOME/.config/nnn/plugin.sh 2>/dev/null
source /usr/share/nnn/quitcd/quitcd.bash_sh_zsh 2>/dev/null
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"
# Restart gnome-remote-desktop.service
# source ${DOTROOT}/script/grdp.sh 2>/dev/null

# Enable command-not-found, only for gentoo
DISTRO=$(get_distro)
case $DISTRO in
    *Gentoo*|*gentoo*)
    source /etc/bash/bashrc.d/command-not-found.sh 2>/dev/null
    ;;
esac

eval $(thefuck --alias)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export DOTROOT="/home/kelen/dotfile"
export SHELLROOT="${DOTROOT}/shellrc"

# environment
[[ ! -f $SHELLROOT/history.sh ]] || source "$SHELLROOT/history.sh" #2>/dev/null
[[ ! -f $SHELLROOT/environment.sh ]] || source "$SHELLROOT/environment.sh" #2>/dev/null

# Load functions
[[ ! -f $SHELLROOT/zshfuns.zsh ]] || source "$SHELLROOT/zshfuns.zsh" #2>/dev/null
[[ ! -f $SHELLROOT/functions.sh ]] || source "$SHELLROOT/functions.sh" #2>/dev/null

# Load common plugin
[[ ! -f $SHELLROOT/commonplugin.sh ]] || source "$SHELLROOT/commonplugin.sh" #2>/dev/null

# To customize prompt, run `p10k configure` or edit ~/dotfile/shellrc/p10k.zsh.
[[ ! -f $SHELLROOT/p10k.zsh ]] || source "$SHELLROOT/p10k.zsh" #2>/dev/null

# Enable some plugins of zsh installed by kelen
[[ ! -f $SHELLROOT/zshplugin.zsh ]] || source "$SHELLROOT/zshplugin.zsh" #2>/dev/null
[[ ! -f $SHELLROOT/zshsetting.zsh ]] || source "$SHELLROOT/zshsetting.zsh" #2>/dev/null

# Load other shellrc
[ -f "$SHELLROOT/alias.sh" ] && source "$SHELLROOT/alias.sh" #2>/dev/null
[ -f "$SHELLROOT/path.sh" ] && source "$SHELLROOT/path.sh" #2>/dev/null
[ -f "$SHELLROOT/language.sh" ] && source "$SHELLROOT/language.sh"  #2>/dev/null

[ -f "$SHELLROOT/custom.sh" ] && source "$SHELLROOT/custom.sh"  #2>/dev/null


# Change default editor to vim
export EDITOR='vim'


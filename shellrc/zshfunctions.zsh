autoload -Uz add-zsh-hook


# kitty + complete setup zsh | source /dev/stdin 2>/dev/null
_kitty_complete() {
    # load kitty completions if in kitty
    if test "$TERM" = "xterm-kitty"; then
        if (( $+commands[kitty] )); then
            eval "$(kitty + complete setup zsh)"
        fi
    fi
}
[ -z "$_LOADED_KITTY_COMPLETE" ] && autoload -Uz _kitty_complete && _LOADED_KITTY_COMPLETE=1

_termtitle()
{
    case "$TERM" in
        rxvt*|nxterm|screen-*|st|st-*|Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*)
            local prompt_host="${(%):-%m}"
            local prompt_user="${(%):-%n}"
            local prompt_char="${(%):-%~}"
            # local prompt_host="${HOSTNAME}"
            # local prompt_user="${USER}"
            # local prompt_char="${PWD/#$HOME/~}"  # Replace $HOME with ~
            case "$1" in
                precmd)
                    printf '\e]0;%s@%s: %s\a' "${prompt_user}" "${prompt_host}" "${prompt_char}"
                ;;
                preexec)
                    printf '\e]0;%s [%s@%s: %s]\a' "$2" "${prompt_user}" "${prompt_host}" "${prompt_char}"
                ;;
            esac
        ;;
    esac
}
_setup_git_prompt() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        unset _git_prompt
        return 0
    fi

    local git_status_dirty git_status_stash git_branch

    if [ "$(git --no-optional-locks status --untracked-files='no' --porcelain)" ]; then
        git_status_dirty='%F{green}*'
    else
        unset git_status_dirty
    fi

    if [ "$(git stash list)" ]; then
        git_status_stash="%F{yellow}▲"
    else
        unset git_status_stash
    fi

    git_branch="$(git symbolic-ref HEAD 2>/dev/null)"
    git_branch="${git_branch#refs/heads/}"

    if [ "${#git_branch}" -ge 24 ]; then
        git_branch="${git_branch:0:21}..."
    fi

    git_branch="${git_branch:-no branch}"

    _git_prompt=" %F{blue}[%F{253}${git_branch}${git_status_dirty}${git_status_stash}%F{blue}]"

}
# Fancy prompt.
_setup_ssh_prompt() {
    local over_ssh
    over_ssh=$(echo "$SSH_CLIENT" | awk '{print $1}')

    if [ -n "$over_ssh" ] && [ -z "${TMUX}" ]; then
        _prompt_is_ssh='%F{blue}[%F{red}SSH%F{blue}] '
    elif [ -n "$over_ssh" ]; then
        _prompt_is_ssh='%F{blue}[%F{253}SSH%F{blue}] '
    else
        unset _prompt_is_ssh
    fi
}

# xterm title
# function xterm_title_precmd () {
# 	print -Pn -- '\e]2;%n@%m %~\a'
# 	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
# }

# function xterm_title_preexec () {
# 	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
# 	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
# }

_xterm_title_precmd() {
    # Set terminal title.
    _termtitle precmd

    # Set optional git part of prompt.
    # update_prompt
    _setup_git_prompt
    _setup_ssh_prompt
}

_xterm_title_preexec() {
    # Set terminal title along with current executed command pass as second argument
    # if [ -n "$ZSH_VERSION" ]; then
        _termtitle preexec "${(V)1}"
    # elif [ -n "$BASH_VERSION" ]; then
    #     termtitle preexec "$BASH_COMMAND"
    # else
    #     termtitle preexec "$1"
    # fi    
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd _xterm_title_precmd
	add-zsh-hook -Uz preexec _xterm_title_preexec
fi

# Update the prompt for bash. Need 'PROMPT_COMMAND=update_prompt' in .bashrc
_update_prompt() {
    # local git_prompt ssh_prompt
    _setup_git_prompt
    _setup_ssh_prompt
    case $USER in
    root)
        PS1="%B%F{cyan}%m%k %(?..%F{blue}[%F{253}%?%F{blue}] )${_prompt_is_ssh}%B%F{blue}%1~${_git_prompt}%F{blue} %# %b%f%k"
    ;;
    *)  
        PS1="%B%F{blue}%n@%m%k %(?..%F{blue}[%F{253}%?%F{blue}] )${_prompt_is_ssh}%B%F{cyan}%1~${_git_prompt}%F{cyan} %# %b%f%k"
    ;;
esac
}
_update_prompt

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Ensure that / is added after tab complation to directories.
# without disabling it, $LBUFFER does not have the slash at the end
# and it's required for _append_path_to_buffer thing..
#setopt AUTO_PARAM_SLASH
#unsetopt AUTO_REMOVE_SLASH
_select_path_with_fzy() {
    (
        if [ "$1" != '.' ]; then
            if ! [ -d $~1 ]; then
                echo -e "${yellow}The $1 is not a directory.${NC}"  >&2
                return
            fi
            cd $~1
        fi

        find -L . \( -type d -printf "%p/\n" , -type f -print \) 2>/dev/null | cut -c 3- | sort | fzy
    )
}

_append_path_to_buffer() {
    local selected_path

    if ! command -v fzy >/dev/null 2>&1; then
        echo 'No fzy binary found in $PATH.'
        return 1
    fi
    echo
    print -nr "${zle_bracketed_paste[2]}" >/dev/tty
    {
        if [ "${LBUFFER[-1]}" = '/' ]; then
            search_in="${LBUFFER##*[$'\t' ]}"
        else
            search_in='.'
        fi

        selected_path="$(_select_path_with_fzy "${search_in}")"
    } always {
        print -nr "${zle_bracketed_paste[1]}" >/dev/tty
    }
    if [ "${selected_path}" ]; then
        if [[ "${LBUFFER[-1]}" =~ [[:alnum:]] ]]; then
            # if last character is a word character, insert space.
            # before inserting selected path. Useful when one's lazy 
            # and use 'vim^F', yet works okay with 'cmd foo=^F'.
            LBUFFER+=" "
        fi
        LBUFFER+="${(q)selected_path}"
    fi
    zle reset-prompt
}
zle -N _append_path_to_buffer

_history_search_with_fzy() {
    local selected_history_entry

    if ! command -v fzy >/dev/null 2>&1; then
        echo 'No fzy binary found in $PATH.'
        return 1
    fi

    if ! command -v awk >/dev/null 2>&1; then
        echo 'No awk binary found in $PATH.'
        return 1
    fi
    echo

    print -nr "${zle_bracketed_paste[2]}" >/dev/tty
    {
        # The awk is used to filter out duplicates, keeping the most 
        # recent entries, while not re-ordering the history list.
        selected_history_entry="$(fc -nrl 1 | awk '!v[$0]++' | fzy)"
    } always {
        print -nr "${zle_bracketed_paste[1]}" >/dev/tty
    }
    if [ "${selected_history_entry}" ]; then
        BUFFER="${selected_history_entry}"
        CURSOR="${#BUFFER}"
    fi
    zle reset-prompt
}
zle -N _history_search_with_fzy


# ^A to open new terminal in current working directory
# Check `logname` so we won't create new terminal as user after `su`.
_open_new_terminal_here(){
    if \
        [ "${XAUTHORITY}" ] && \
        [ "${DISPLAY}" ] && \
        [ "${LOGNAME}" = "$(logname)" ] && \
        command -v urxvt >/dev/null 2>&1
    then
        # Spawn terminal with clean login shell.
        env -i \
            XAUTHORITY="${XAUTHORITY}" \
            PATH="${PATH}" \
            HOME="${HOME}" \
            DISPLAY="${DISPLAY}" \
            LOGNAME="${LOGNAME}" \
            SHELL="${SHELL}" \
            LANG="${LANG}" \
            urxvt -e "${SHELL}" --login >/dev/null 2>&1 &!
    fi
}
zle -N _open_new_terminal_here

bindkey "^F" _append_path_to_buffer     # Ctrl+f to append path to buffer
bindkey "^T" _history_search_with_fzy   # Ctrl+t to search history with fzy
bindkey "^A" _open_new_terminal_here    # Ctrl+a to open new terminal in current working directory


# By default, Ctrl+d will not close your shell if the command line is filled, this fixes it:
_exit_zsh() { exit }
zle -N _exit_zsh
bindkey '^D' _exit_zsh                  # Ctrl+d to exit shell
# Clear the backbuffer using a key binding
function _clear-screen-and-scrollback() {
    printf '\x1Bc'
    zle clear-screen
}
zle -N _clear-screen-and-scrollback
bindkey '^L' _clear-screen-and-scrollback   # Ctrl+l to clear screen and scrollback

# Reset the terminal when it's broken
function _reset_broken_terminal () {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
# [ -z "$_LOADED_ZSH_RESET" ] && add-zsh-hook -Uz precmd _reset_broken_terminal && _LOADED_ZSH_RESET=1

# Always restore the working directory when the shell exits.
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
_chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd _chpwd_dirstack


# Bind key to ncurses application: ncmpcpp ALT+L to show ncmpcpp
_ncmpcppShow() {
  ncmpcpp <$TTY
  zle redisplay
}
zle -N _ncmpcppShow
bindkey '^[\' _ncmpcppShow # Alt+\ to show ncmpcpp


## File manager key binds
_cdUndoKey() {
  popd
  zle       reset-prompt
  print
  ls
  zle       reset-prompt
}

_cdParentKey() {
  pushd ..
  zle      reset-prompt
  print
  ls
  zle       reset-prompt
}

zle -N                 _cdParentKey
zle -N                 _cdUndoKey
bindkey '^[[1;3A'      _cdParentKey # Alt+Up    to cd ..
bindkey '^[[1;3D'      _cdUndoKey  # Alt+Left   to cd -
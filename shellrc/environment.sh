## Note that Display Environment Variables are not set here, it should be set in Window Manager's startup script.
## For example, Hyprland loads $HOME/.config/hypr/configs/env.conf first.

export NNN_FIFO=/tmp/nnn.fifo
export TMPDIR=/tmp

export NNN_BMS='h:$HOME/;d:$HOME/Downloads;s:${DOTROOT}'
export NNN_ARCHIVE="\\.(7z|bz|bz2|gz|rar|rpm|tar|tgz|zip)$"
NNN_PLUG_DEFAULT='b:boom;p:preview-tui;j:autojump;v:imgview;t:nmount;d:diffs;f:finder'
NNN_PLUG_INLINE='E:!go run "$nnn"*'
NNN_PLUG="$NNN_PLUG_DEFAULT;$NNN_PLUG_INLINE"
export NNN_PLUG



## Input method
export INPUT_METHOD=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx
export IMSETTINGS_MODULE=fcitx

## XDG Base Directory Specification
## User directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
export XDG_DESKTOP_DIR=${XDG_DESKTOP_DIR:-$HOME/Desktop}
export XDG_DOCUMENTS_DIR=${XDG_DOCUMENTS_DIR:-$HOME/Documents}
export XDG_DOWNLOAD_DIR=${XDG_DOWNLOAD_DIR:-$HOME/Downloads}
export XDG_MUSIC_DIR=${XDG_MUSIC_DIR:-$HOME/Music}
export XDG_PICTURES_DIR=${XDG_PICTURES_DIR:-$HOME/Pictures}
export XDG_PUBLICSHARE_DIR=${XDG_PUBLICSHARE_DIR:-$HOME/Public}
export XDG_TEMPLATES_DIR=${XDG_TEMPLATES_DIR:-$HOME/Templates}
export XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-$HOME/Videos}
## System directories
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg}
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share:/usr/share}

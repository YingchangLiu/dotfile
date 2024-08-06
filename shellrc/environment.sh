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
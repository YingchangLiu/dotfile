sleep 30m
if pgrep -x "swaylock" > /dev/null
then
    echo "swaylock is running"
    hyprctl dispatch dpms off eDP-1
fi

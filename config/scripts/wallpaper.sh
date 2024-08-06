#!/usr/bin/env bash
wallpath=${DOTROOT}/wallpaper/
if [[ -f /tmp/currentwall ]];then
    image=$( find ${wallpath} -type f | grep -v $(cat /tmp/currentwall) | shuf | head -n 1)
else
    image=$(find ${wallpath} -type f | shuf | head -n 1)
fi


#if [[ -f /tmp/currentwall ]];then
#	image=$( find /usr/share/backgrounds/ -type f | grep -v $(cat /tmp/currentwall) | shuf | head -n 1)
#else
#	image=$(find /usr/share/backgrounds/ -type f | shuf | head -n 1)
#fi

echo $image > /tmp/currentwall 2>&1

swaybg_instances=$(ps axh | grep swaybg | grep -v grep | awk '{print $1}')
#setsid -f swaybg -i $image
swaybg -i $image -m fill &
sleep 1
for instance in $swaybg_instances; do
	kill -9 $instance 1>/dev/null 2>&1
done


#types=("wipe" "outer" "grow" "left" "right" "center" "any" "random")
#trantype=${types[$RANDOM % ${#types[@]} ]}
#echo $trantype
#swww img $image --transition-type $trantype --transition-step 255 --transition-fps 144


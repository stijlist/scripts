#! /bin/bash
# chromium-ctrl-m-rebind
current=`xdotool getwindowfocus`
chromiums=`xdotool search -name chromium`
for chromium in $chromiums
do
 if $current = $chromium
 xdotool key "Enter"
 break
done

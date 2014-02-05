#!/bin/bash 
# A very simple Bash script to download a YouTube video 
# and extract the music file from it. 
address=$1 
regex='v=(.*)' 
if [[ $address =~ $regex ]]; then 
    video_id=${BASH_REMATCH[1]}
    video_id=$(echo $video_id | cut -d'&' -f1) 
    video_title="$(youtube-dl --get-title $address)" 
    youtube-dl $address 
    ext="$2" 
    ffmpeg -i $video_title.$ext "$video_title".wav 
    lame "$video_title".wav "$video_title".mp3 
    rm $video_id.$ext "$video_title".wav 
else 
    echo "Sorry but the system encountered a problem." 
fi

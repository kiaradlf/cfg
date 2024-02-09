#!/usr/bin/env sh
export wallpaper_dir=~/Pictures/wallpapers/
ls $wallpaper_dir | anyrun --plugins libstdin.so | while read -r img ; do
  pidof swaybg && kill -9 $(pidof swaybg)
  swaybg -m fill -o '*' -i $wallpaper_dir$img
  wallust run $wallpaper_dir$img;
done

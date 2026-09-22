#!/bin/sh

DIR="/sys/class/power_supply/BAT0"
if [ ! -d "$DIR" ]; then
  echo -n "No Battery"
  exit
fi

CAP=$(cat $DIR/capacity)
STA=$(cat $DIR/status)
echo -n "($STA: $CAP)"

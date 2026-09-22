#!/bin/sh

if [ -z "$DISPLAY" ]; then
	echo "DISPLAY is not set"
	exit
fi

xprop -root -set WM_NAME "$(date +%H:%M:%S)"

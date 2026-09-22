#!/bin/sh

STAT="$(ps aux | awk '$3 != 0.0 && $4 != 0.0' | column -t -l 11 -R 2,3,4,5,6,9,10)"
echo "$STAT" | head -n1
echo "$STAT" | sed '1d' | sort -k3,3nr

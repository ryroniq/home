#!/bin/sh

DF="$(df -h 2>/dev/null | awk '$3 != 0' | sed '1s/.*/\U&/')"
echo "$DF" | head -n1
echo "$DF" | sed '1d' | sort -k6,6
echo

free -m | sed -e '1s/^/MEMORY /' -e '1s/.*/\U&/' -e '2s/^Mem:/phys/' -e '3s/^Swap:/swap/' | column -t -R 2,3,4,5,6,7
echo

uptime | column -t -o ' '

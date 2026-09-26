#!/bin/sh
# Usage: status-step.sh +1 | -1
step=${1:-1}

v=$(tmux display -p '#{status}')
case "$v" in
  off|0) n=0 ;;
  on|1)  n=1 ;;
  *)     n=$v ;;
esac

n=$((n + step))
[ "$n" -lt 0 ] && n=0
[ "$n" -gt 5 ] && n=5

case "$n" in
  0) s=off ;;
  1) s=on ;;
  *) s=$n ;;
esac

tmux set status "$s"

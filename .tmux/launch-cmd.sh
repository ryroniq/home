#!/bin/sh

cmd=$(cat <<'EOF' | fzf
zsh
top
htop
btop
python
git log
EOF
)

[[ -n $cmd ]] && eval "$cmd"

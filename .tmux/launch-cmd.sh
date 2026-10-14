#!/bin/sh

cmd=$(cat <<'EOF' | fzf
zsh
top
htop
btop
python
git log
lazygit
EOF
)

[[ -n $cmd ]] && eval "$cmd"

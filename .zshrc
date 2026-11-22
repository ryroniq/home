[ -f $HOME/.aliasrc ] && source $HOME/.aliasrc
[ -f $HOME/.aliasrc.local ] && source $HOME/.aliasrc.local
[ -f $HOME/.zshenv.local ] && source $HOME/.zshenv.local

typeset -U PATH path
path=(~/.bin ~/.launcher ~/.scripts ~/.local/bin "$path[@]")
export PATH

export EDITOR=vi
export LESS='-R'
export COLORTERM=truecolor
export KEYTIMEOUT=1

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

autoload checkmail

autoload -Uz compinit promptinit
compinit
promptinit

zstyle ':completion:*' menu select
zstyle ':completion:*:default' menu select=1
zstyle ':completion::complete:*' gain-privileges 1

WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
stty -ixon

setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_expire_dups_first
HISTFILE=$HOME/.zsh_history
SAVEHIST=5000
HISTSIZE=5000

bindkey -e

bindkey '^P'   history-beginning-search-backward
bindkey '^N'   history-beginning-search-forward
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey '^R'   history-incremental-search-backward
bindkey '^S'   history-incremental-search-forward

zmodload -i zsh/complist
bindkey -M menuselect "^H" backward-char
bindkey -M menuselect "^I" complete-word
bindkey -M menuselect "^J" down-history
bindkey -M menuselect "^K" up-history
bindkey -M menuselect "^L" forward-char

PROMPT='%F{green}>%f '
RPROMPT=''

precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

yp() {
  (( $# )) || { print -u2 "usage: yp <file>"; return 1 }
  [[ -e $1 ]] || { print -u2 "yp: no such file: $1"; return 1 }
  local p=${1:A}
  if [[ -z $DISPLAY ]]; then
    print -u2 "yp: DISPLAY not set, not copied"
  elif (( ! $+commands[xclip] )); then
    print -u2 "yp: xclip not found, not copied"
  else
    print -rn -- $p | xclip -selection clipboard
  fi
  print -r -- $p
}

qrshow() {
    local sel=${1:-primary} mode=$2 data qr rows cols img

    data=$(xclip -o -selection "$sel" 2>/dev/null)
    if [[ -z $data ]]; then
        echo "qrshow: '$sel' selection is empty" >&2
        return 1
    fi

    printf '%s\n' "$data"

    # auto: show in the terminal if it fits, else fall back to feh
    if [[ $mode != g ]]; then
        qr=$(printf '%s' "$data" | qrencode -t ANSIUTF8 -m 2) || return 1
        rows=$(printf '%s\n' "$qr" | wc -l)
        cols=${COLUMNS:-$(tput cols)}
        # each line holds 2 module rows, so width ≈ 2 × lines
        if [[ $mode == t ]] || (( rows * 2 <= cols && rows < ${LINES:-$(tput lines)} )); then
            printf '%s\n' "$qr"
            return
        fi
    fi

    img=$(mktemp --suffix=.png) || return 1
    if printf '%s' "$data" | qrencode -s 10 -m 2 -o "$img"; then
        feh --title "QR ($sel)" "$img"
    fi
    rm -f "$img"
}

alias qrencode-primary='qrshow primary'
alias qrencode-clipboard='qrshow clipboard'

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

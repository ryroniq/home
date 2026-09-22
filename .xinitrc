#!/bin/sh

userresources=$HOME/.Xresources
userresources_local=$HOME/.Xresources.local
sysresources=/etc/X11/xinit/Xresources

setxkbmap us -option compose:menu

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$userresources_local" ]; then
	xrdb -merge "$userresources_local"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if command -v fcitx5 &> /dev/null; then
	fcitx5 -d
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS=@im=fcitx
fi

command -v feh &> /dev/null && [ -x $HOME/.fehbg ] && $HOME/.fehbg

[ -f $HOME/.xinitrc.env ] && source $HOME/.xinitrc.env
[ -x $HOME/.xinitrc.local ] && $HOME/.xinitrc.local

if [ -x $HOME/.xinitrc.wm ]; then
	exec $HOME/.xinitrc.wm
else
	while true; do
		dwm
		[ $? -ne 1 ] && exit
	done
fi

#!/bin/bash

SELFDIR=`dirname "$0"`
SELFDIR=`cd "$SELFDIR" && pwd`

cd "$SELFDIR"

time setup_ogl.sh

if [ -e "/etc/X11/Xsession.d/98vboxadd-xclient" ]; then 
    echo "Trying to run '/etc/X11/Xsession.d/98vboxadd-xclient'..."
    sudo sh /etc/X11/Xsession.d/98vboxadd-xclient 2>&1
fi

CMD=$1

if [ -z "$CMD" ]; then
  if [ -z "$DISPLAY" ]; then 
    CMD=bash
  else
    CMD=xterm
  fi
  ARGS=""
else
  shift
  ARGS=$@
fi

# xhost +
xcompmgr -fF -I-.002 -O-.003 -D1 &
# xcompmgr &
# TODO: choose a comp. manager...
compton &

# requires: qclosebutton (qt4-default)
# xdotool

qclosebutton "$SELFDIR/x_64x64.png" xfullscreen $CMD $ARGS 2>&1

exit $?



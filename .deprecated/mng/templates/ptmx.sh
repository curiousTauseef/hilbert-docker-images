#!/bin/sh

set -v                                                                                                                                 
set -x                                                                                                                                 

unset DISPLAY

while : 
do
  ls -la /dev/pts/ptmx
  chmod a+rw /dev/pts/ptmx
  sleep 20
done


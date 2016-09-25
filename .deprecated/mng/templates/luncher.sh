#!/bin/sh

set -v
set -x

#
# Run docker-compose within 'ddd'
#
# This script will attempt to mirror the host paths by using volumes for the
# following paths:
#   * $(pwd)
#   * $(dirname $COMPOSE_FILE) if it's set
#   * $HOME if it's set
#
# You can add additional volumes (or any docker run options) using
# the $COMPOSE_OPTIONS environment variable.
#

SELFDIR=`dirname "$0"`
SELFDIR=`cd "$SELFDIR" && pwd`
cd "${SELFDIR}/"

## set -e
## unset DISPLAY

# echo $PWD

# echo "Args: "
# echo "["
# echo "$@"
# echo "]"

# export 

if [ -r "./station.cfg" ]; then
    . "./station.cfg"
fi

if [ -r "./startup.cfg" ]; then
    . "./startup.cfg"
fi

if [ -r "/tmp/lastapp.cfg" ]; then
    . "/tmp/lastapp.cfg"
fi

if [ -r "./docker.cfg" ]; then
    . "./docker.cfg"
fi

if [ -r "./compose.cfg" ]; then
    . "./compose.cfg"
fi

if [ -f ./compose ];
then
  if [ ! -x ./compose ];
  then
     chmod -f a+x ./compose
  fi
  
  if [ ! -x ./compose ];
  then
     sudo -n -P chmod -f a+x ./compose
  fi

  if [ -x ./compose ]; then
     # --no-build --no-color 
     exec ./compose --skip-hostname-check "$@"
  else
     echo "Warning: could not make '$PWD/compose' into an executable: "
     ls -la $PWD/compose
  fi
fi

if hash docker-compose 2>/dev/null; then
  exec docker-compose --skip-hostname-check "$@"
fi

echo "ERROR: Sorry no executable '$PWD/compose' or global docker-compose on the system!"
exit 1

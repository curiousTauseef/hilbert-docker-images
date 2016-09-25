#!/bin/bash

SELFDIR=`dirname "$0"`
SELFDIR=`cd "$SELFDIR" && pwd`

## set -e

if [ -z "$CFG_DIR" ]; then
    export CFG_DIR="$HOME/.config/dockapp"
fi

cd $CFG_DIR

if [ -r "$CFG_DIR/startup.cfg" ]; then
    . "$CFG_DIR/startup.cfg"
fi

if [ -r "$CFG_DIR/docker.cfg" ]; then
    . "$CFG_DIR/docker.cfg"
fi

#if [ -r "$CFG_DIR/compose.cfg" ]; then
#    . "$CFG_DIR/compose.cfg"
#fi

### TODO: run in a loop?

if [ -r "$CFG_DIR/lastapp.cfg" ]; then
    . "$CFG_DIR/lastapp.cfg"
    
    d="${current_app}"
 
    "$CFG_DIR/docker-compose.sh" stop "$d"
    "$CFG_DIR/docker-compose.sh" kill "$d"
    "$CFG_DIR/docker-compose.sh" rm -f "$d"
   
    mv -f "$CFG_DIR/lastapp.cfg" "$CFG_DIR/lastapp.cfg.bak"
    unset current_app
else
    d="${default_app}"
 
    "$CFG_DIR/docker-compose.sh" stop "$d"
    "$CFG_DIR/docker-compose.sh" kill "$d"
    "$CFG_DIR/docker-compose.sh" rm -f "$d"
fi

#### ARGUMENT!!!
export current_app="$@"
echo "export current_app='${current_app}'" > "$CFG_DIR/lastapp.cfg"

"$CFG_DIR/docker-compose.sh" up -d "$current_app"


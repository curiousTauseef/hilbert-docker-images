#!/bin/bash

set -v
set -x

SELFDIR=`dirname "$0"`
SELFDIR=`cd "$SELFDIR" && pwd`

## set -e

cd "$SELFDIR/"

# ACTION="$1"
### start, stop, 
# shift

### TODO: read the following default cache location from station.cfg!
CMD=$(basename "$0" '.sh')

TARGET_HOST_NAME="$1"

   if [ -z "${TARGET_HOST_NAME}" ]; then
      echo "ERROR: no station argument given to this script $0: [$@]!"
      exit 1
   fi

shift

### station id
ARGS=$@
CMD="~/.config/dockapp/$CMD.sh"

   ./remote.sh "${TARGET_HOST_NAME}" "exit 0" &> /dev/null
   if [ $? -ne 0 ]; then
      echo "ERROR: no access to station '${TARGET_HOST_NAME}'!"
      exit 1
   fi

   ./remote.sh "${TARGET_HOST_NAME}" "test -x $CMD && exit 0 || exit 1" &> /dev/null
   if [ $? -ne 0 ]; then
      echo "ERROR: no executable shell script '$CMD' on station '${TARGET_HOST_NAME}'!"
      exit 1
   fi

echo "Running custom management command: '$CMD $ARGS' on station '${TARGET_HOST_NAME}'... "
exec ./remote.sh "${TARGET_HOST_NAME}" $CMD $ARGS

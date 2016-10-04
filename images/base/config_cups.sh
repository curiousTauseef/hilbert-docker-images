#!/bin/bash

I="$@"

if [ -z "$I" ]; then

   if [ ! -z "$CUPS_SERVER" ]; then 
      I="$CUPS_SERVER"
   else


      if [ ! -z "$HIP" ]; then 
         I="$HIP:631/version=1.1" 
      else
         echo "Sorry - cannot determine the printer server!"
	 exit 1 
      fi
      export CUPS_SERVER="$I"

   fi

else

   if [ ! -z "$CUPS_SERVER" ]; then 
      echo "Overwriting '$I' with '$CUPS_SERVER'"
      I="$CUPS_SERVER"
   else
      export CUPS_SERVER="$I"
   fi
fi

echo "Server: '$I', CUPS_SERVER: '$CUPS_SERVER'"
echo

mkdir -p /etc/cups/

echo "ServerName $I" > /etc/cups/client.conf

lpstat -l -t -v -s -p

export P=$(lpstat -p 2>&1 | grep '^printer ' | head -n 1 | sed -e 's@^printer @@g' -e 's@ .*@@g')

echo "Default printer: '$P'"

lpoptions -d "$P"

lpstat -d

#! /bin/bash

# ubuntu/debian
DEBIAN_FRONTEND=noninteractive apt-get -y -q upgrade "$@"


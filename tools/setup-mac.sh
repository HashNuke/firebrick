#!/usr/bin/env bash

if [ "$1" = "clear" ]; then
  sudo pfctl -d
else
  sudo pfctl -evf $(dirname $0)/smtp-port-forward.pfconf
fi

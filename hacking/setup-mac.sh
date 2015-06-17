#!/usr/bin/env bash

sudo pfctl -evf $(dirname $0)/smtp-port-forward.pfconf

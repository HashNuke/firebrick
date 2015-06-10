#!/usr/bin/env bash
echo -e "\
rdr-anchor \"forwarding\" \
\n\
load anchor \"forwarding\" from \"$HOME/forward-rules.pfconf\"" >> /etc/pf.conf

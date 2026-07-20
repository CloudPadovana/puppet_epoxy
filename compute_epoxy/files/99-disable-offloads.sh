#!/bin/bash

INTERFACE="eno3"

if [ "$1" == "$INTERFACE" ] && [ "$2" == "up" ]; then
	/usr/sbin/ethtool -K "$INTERFACE" tx-gre-segmentation off tx-gre-csum-segmentation off
fi

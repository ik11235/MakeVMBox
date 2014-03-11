#!/bin/sh

VEGRANT="vagrant"
VIRTUALBOX="virtualbox"

if [ ! `which ${VIRTUALBOX}` ] || [ ! `which ${VEGRANT}` ]; then
    echo 'Vegrant or VirtualBox not found'
    exit 1;
fi

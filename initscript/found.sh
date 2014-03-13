#!/bin/sh

while true
do
    read ANSo
#    PATH=${(which ${ANS}`
    echo "ANS is ${ANS}";
    echo "PATH is ${PATH}";
    
    if [ -n "${PATH}" ]; then
	echo "found";
	echo "${PATH}";
    else
	echo "not found";       
    fi    
done

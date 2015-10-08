#!/bin/bash

if [ $# -lt 1 ]
then
    exit
fi

ID=`echo $1 | grep -Eo "[0-9]{6,}\.html" | cut -d. -f1`
OUT=`grep input $1 | grep -Eo 'value="[^"]*"' | cut -d= -f2- | sed 's/"//g' | sed '{$!{N;s/\n/\t/g}}' | sed '{$!{N;s/\n/\t/g}}' | sed '{$!{N;s/\n/\t/g}}' | sed ':a;N;$!ba;s/\n/ /g' | recode html..utf-8`
echo "${ID}	${OUT}"

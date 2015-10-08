#!/bin/bash

if [ $# -lt 1 ]
then
    exit
fi

for i in `ls -v $1/*`
do
    grep addresslink $i | grep -Eo "ContributionReport\?act[^\"]+" | cut -d? -f2 | sed 's/&amp;/\&/g'
done > $1.txt

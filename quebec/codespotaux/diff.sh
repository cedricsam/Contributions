#!/bin/bash

if [ $# -lt 2 ]
then
    echo "two input files needed: ref and new"
    exit
fi

while read i
do
    DIFF=`grep -E "^$i" $1 | wc -l`
    if [ ${DIFF} -eq 0 ]
	then echo "$i" >> $2.missing
    fi
done < $2


#!/bin/bash

if [ $# -lt 1 ]
then
    exit
fi

for i in `ls -v $1`
do
    ./parse_page.py $1/$i
done > $1.pages.csv

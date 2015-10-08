#!/bin/bash

if [ $# -lt 1 ]
then
    exit
fi

find $1.contribs -type f > $1.contribs.list.tsv #-exec ./parse_contributor.sh {} \; > $1.contribs.tsv

while read i
do
    ./parse_contributor.sh $i
done < $1.contribs.list.tsv > $1.contribs.tsv

cut -f5 $1.contribs.tsv | sort -u > $1.postalcodes.txt

cat $1.postalcodes.txt > cp.txt.$1

cat cp.txt cp.txt.$1 | sort -u > cp.txt.tmp

mv cp.txt.tmp cp.txt

mkdir -p geocode

ls geocode | sed 's/\.json//' > geocoded.txt

grep -v -F -x -f geocoded.txt cp.txt > cp.missing.txt

#${HOME}/bin/geocode.sh cp.missing.txt geocode 1 1

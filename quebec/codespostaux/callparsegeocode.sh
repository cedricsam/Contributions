#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Missing dir name"
    exit
fi

DIR=$1

D=`date +%Y%m%d-%H%M`

if [ $# -ge 2 ]
then
    D=$2
fi

rm ${DIR}.${D}.csv
touch ${DIR}.${D}.csv

#for i in `find ${DIR} -name "*.json"`
#do
#    parsegeocode.py "${i}" >> ${DIR}.${D}.csv
#done
find ${DIR} -name "*.json" -exec ${HOME}/bin/parsegeocode.py "{}" >> ${DIR}.${D}.csv \;
sort -u ${DIR}.${D}.csv ${DIR}.${D}.csv.tmp
mv ${DIR}.${D}.csv.tmp ${DIR}.${D}.csv

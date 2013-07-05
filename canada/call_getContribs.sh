#!/bin/bash

if [ $# -lt 3 ]
then
    echo "Missing file and entity id (1=candidat, 2=leadership, 3=investiture, 5=association, 6=partis) and return"
    exit
fi
period=-1
if [ $# -gt 3 ]
then
    period=$4
fi

while read i
do
    F=""
    for p in `seq 1000`
    do
        FN="$2-$i-$p-$3.html"
        if [ -s $FN ]
        then
            break
        fi
        getContribs.sh $2 $i $p $3 $period
        if [ $p -gt 1 ] && [ `wc -c ${FN} | cut -d" " -f1` -eq `wc -c ${F} | cut -d" " -f1` ]
        then
            rm $FN
            break
        fi
        F=$FN
    done
done < $1

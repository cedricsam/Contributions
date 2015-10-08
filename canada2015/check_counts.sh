#!/bin/bash

for i in `find -maxdepth 1 -type d -regex .*\.contribs | sort`
do
    S=`echo $i | sed 's/\.contribs//'`
    N=`ls $i | wc -l`
    NP=`ls $S/*.html | wc -l`
    NNP=`echo "$NP * 200" | bc -l`
    T=`wc -l ${S}.txt | cut -d" " -f1`
    P=`echo "$N / $T * 100" | bc -l`
    R=""
    if [ `echo "$P < 100" | bc` -eq 1 ]
    then
        D=`echo "$T - $N" | bc`
        PCT=`printf "%0.2f" $P`
        R="$PCT % - with $D to go"
    else
        R="DONE"
    fi
    echo "$S $N of $T ($R) [$NP / $NNP]"
done
echo

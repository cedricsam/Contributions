#!/bin/bash

if [ $# -lt 1 ]
then
    F="contributors"
fi

URL="http://www.elections.ca/scripts/webpep/fin2/contributor.aspx"
while read i
do
    ID="${id_row}"
    if [ ! -s "${ID}.html" ]
    then
        id_type=`echo $i | cut -d, -f1`
        id_client=`echo $i | cut -d, -f2`
        id_row=`echo $i | cut -d, -f3`
        seqno=`echo $i | cut -d, -f4`
        id_part=`echo $i | cut -d, -f5`
        entity=`echo $i | cut -d, -f6`
        option=`echo $i | cut -d, -f7`
        retrn=`echo $i | cut -d, -f8`
        ARGS="type=$id_type&client=$id_client&row=$id_row&seqno=$seqno&part=$id_part&entity=$entity&lang=e&option=$option&return=$retrn"
        echo "${URL}?${ARGS}"
        curl -s "${URL}?${ARGS}" -o "${F}/${ID}.html"
    fi
done < ${F}.ids.csv

#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Missing dir"
    exit
fi

COLS="id_row,id_client,name,party,candidate,association,riding,entity,option,period,id_type,id_part,seqno,return,type,endperiod,date,class,part,through,monetary,nonmonetary,city,prov,postalcode,year"

D=`date +%Y%m%d-%H%M`

FO="contrib$1.${D}.csv"
echo ${COLS} > ${FO}
for i in `ls -atv $1/*.html`
do
    iconv -flatin1 -tutf8 $i > $i.utf8
    parse_contribs.py $i.utf8
    #rm $i.utf8
done > ${FO}

#!/bin/bash
first=0
N=0
while read i
do
    let N=$N+1
    if [ $first -eq 0 ]
    then
        first=1
        continue
    fi
    RET=1
    section=`echo "$i" | cut -f1`
    if [[ $section =~ .*R.* ]]
    then 
        RET=2
    fi
    id_row=`echo "$i" | cut -f2`
    CITY=`echo "$i" | cut -f4 | sed "s/'/''/g"`
    PROV=`echo "$i" | cut -f5 | sed "s/'/''/g"`
    PC=`echo "$i" | cut -f6 | sed "s/'/''/g"`
    SQL="UPDATE contribs2015 SET (city, province, postalcode) = ('$CITY','$PROV','$PC') WHERE returntype = $RET and id_row = $id_row"
    if [[ $id_row =~ ^[^0-9]+$ ]]
    then
        echo "$N - BAD ID_ROW: $i" 2>> insert_errors.log
    fi
    echo "$N - $SQL"
    psql -h 127.0.0.1 -U lp -c "${SQL}" 2>> insert_errors.log
done < contribs.contributors.tsv

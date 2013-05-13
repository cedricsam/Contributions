#!/bin/bash

if [ $# -ge 1 ]
then
    D=$1
else
    D=`date +%Y%m%d-%H%M`
fi

DIR="donateurs-${D}"
DIROUT="donateurs-out-${D}"
if [ ! -d ${DIR} ]
then
    echo "Missing directory: ${DIR}"
    exit
else
    cd ${DIR}
fi

if [ ! -s "1.html" ]
then
    echo "Missing 1.html"
    cd - 2> /dev/null
    exit
fi

N=`ls -at *.html | sort -n | tail -1 | cut -d. -f1`

mkdir -p ../${DIROUT}

for i in `seq ${N}`
do
    B=`grep -n '<table class="tableau" summary="">' $i.html | cut -d: -f1`;A=`grep -n '<td colspan="7">Enregistrements ' $i.html | cut -d: -f1`
    let A=$A+3
    let X=$A-$B
    let X=$X+2
    head -${A} $i.html | tail -${X} > ../${DIROUT}/$i.html 
done

cd ../${DIROUT}
rm all_reports.${D}.html
echo "<root>" > all_reports.${D}.html

for i in `seq 1 ${N}`
do
    let H=`wc -l $i.html | cut -d" " -f1`-5
    let T=$H-10
    head -$H $i.html | tail -$T >> all_reports.${D}.html 
done
echo "</root>" >> all_reports.${D}.html

sed -i 's/<!--.\+-->//g' all_reports.${D}.html # remove comment
iconv -flatin1 -tutf8 all_reports.${D}.html > all_reports.utf8.${D}.html
zip all_reports.${D}.zip all_reports.utf8.${D}.html
rm all_reports.${D}.html

cd .. 2> /dev/null

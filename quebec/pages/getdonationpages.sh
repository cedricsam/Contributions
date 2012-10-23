#!/bin/bash

D=`date +%Y%m%d-%H%M`

N=590

for i in `ls *.html`
do
    B=`grep -n '<table class="tableau" summary="">' $i | cut -d: -f1`;A=`grep -n '<td colspan="7">Enregistrements ' $i | cut -d: -f1`
    let A=$A+3
    let X=$A-$B
    let X=$X+2
    head -${A} $i | tail -${X} > $i.trunc 
done

for i in `seq 1 ${N}`
do
    let H=`wc -l $i.html.trunc | cut -d" " -f1`-5
    let T=$H-10
    head -$H $i.html.trunc | tail -$T >> all_reports.${D}.html 
done

iconv -flatin1 -tutf8 all_reports.${D}.html > all_reports.utf8.${D}.html
zip all_reports.${D}.zip all_reports.utf8.${D}.html

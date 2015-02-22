#!/bin/bash

D=`date +%Y%m%d-%H`

touch "links.${D}.txt"

for i in `ls -rt ../*.html`
do
    grep -Eo '/WPAPPS/WPF/EN/PP/ContributionReport[^"]+' "${i}" | grep addrclientid | cut -d: -f2 | cut -d? -f2 >> links.${D}.txt
done

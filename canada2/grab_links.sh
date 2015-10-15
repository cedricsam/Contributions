#!/bin/bash

D=`date +%Y%m%d-%H`

touch "links.${D}.txt"

for i in `ls -rt ../*.html`
do
    grep -Eo '/WPAPPS/WPF/EN/[A-Z]{2,}/ContributionReport[^"]+' "${i}" | grep addrclientid | cut -d: -f2 | cut -d? -f2 | sed 's/queryid=[^&]\+/queryid=/' | sed 's/&amp;/\&/g' >> links.${D}.txt
done

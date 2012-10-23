#!/bin/bash

# gets the IDs from donateurs pages
# also gets the missing ones compared with a ref file

D=`date +%Y%m%d-%H%M`

#REFFILE="donateurs-2011-2012_20120616.tsv"
REFFILE="donateurs-2011-2012_20120729.tsv"

rm dons.missing.txt
rm dons.missing

for f in `ls *.html`
do
    grep -oE "/francais/provincial/financement-et-depenses-electorales/recherche-sur-les-donateurs.php\?idrech=[0-9]+&an=[0-9]+&fkent=[0-9]+" $f >> tousliens_${D}.txt
done

cut -d? -f2 tousliens_${D}.txt | sed 's/idrech=//g' | sed 's/&an=/\t/g' | sed 's/&fkent=/\t/g' > tousliens_${D}.tsv

sort -u tousliens_${D}.tsv > tousliens_sorted_${D}.tsv

mv tousliens_sorted_${D}.tsv tousliens_${D}.tsv

rm tousliens_${D}.txt

touch dons.missing.txt

while read i
do
    ID=`echo "$i" | cut -f1`
    Y=`echo "$i" | cut -f2`
    FK=`echo "$i" | cut -f3 | sed 's/^0*//g'`
    echo "$i" >> dons.missing.txt
    grep -E "^`echo -e "$ID\t$Y\t$FK"`" "${REFFILE}" | wc -l >> dons.missing.txt 
done < tousliens_${D}.tsv

grep -E "^0$" dons.missing.txt -B1 > dons.missing
grep -vE "^0$" dons.missing | grep -v "-" | sort -u | sort -n > urls.${D}.tsv

rm urls.tsv
ln -s urls.${D}.tsv urls.tsv

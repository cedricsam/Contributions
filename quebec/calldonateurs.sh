#!/bin/bash

FTID="MY_FUSION_TABLE_ID"

cd /var/bigdata/contribquebec

D=`date +%Y%m%d-%H%M`

# Obtenir les pages pour tous les partis/fkent de 2011 a aujourd'hui (voir details dans script)
./pages/getdonateurspages.sh ${D}

# Concatener les pages
./pages/getdonationpages.sh ${D}

# Corriger les caracteres dans le HTML, parser les pages concatenees via script python, et generer csv
./pages/parse_contribs.py donateurs-out-${D}/all_reports.utf8.${D}.html > donateurs-out-${D}/all_contribs.${D}.csv

# Effacer tout et remettre une copie fraiche dans la base de donnees
psql -h 127.0.0.1 -U lp -c "truncate dons"
psql -h 127.0.0.1 -U lp -c "\\copy dons from 'donateurs-out-${D}/all_contribs.${D}.csv' csv header"

# Effacer tout et remettre une copie fraiche dans Fusion Tables a partir des pages de cette passe
${HOME}/bin/ftsql.py POST "DELETE FROM ${FTID}"
TRIES=0
while true
do
    let TRIES=$TRIES+1
    rm error.${D}.log
    touch error.${D}.log
    ${HOME}/bin/ftimportrowsfromcsv.sh donateurs-out-${D}/all_contribs.${D}.csv ${FTID} > error.${D}.log 2> error.${D}.log
    cat error.${D}.log
    if [ `grep -i "error" error.${D}.log | wc -l` -le 0 ] || [ $TRIES -gt 2 ]
    then
        break
    fi
done
cat error.${D}.log
rm error.${D}.log

# Une copie fraiche des donateurs obtenus dans les pages de cette passe
psql -h 127.0.0.1 -U lp -tAc "select idrech, an, fkent from dons order by idrech, fkent, an" | sed 's/|/\t/g' > donateurs-out-${D}/donateurs.${D}.tsv

# Trouver les nouveaux donateurs-annee-fkent dans les pages par rapport au master (popups deja downloades)
head -1 donateurs-master.tsv > donateurs-out-${D}/donateurs.diff.${D}.tsv
while read i
do
    FOUND=`grep -E "^$i$" donateurs-master.tsv | wc -l`
    if [ ${FOUND} -eq 0 ]
    then
        echo "$i" >> donateurs-out-${D}/donateurs.diff.${D}.tsv
    fi
done < donateurs-out-${D}/donateurs.${D}.tsv

# Get popups
popups/popups.sh donateurs-out-${D}/donateurs.diff.${D}.tsv

# Parser les popups et outputter le csv
./popups/parse_popups.sh > popups-data.${D}.csv
rm popups-data.csv
ln -s popups-data.${D}.csv popups-data.csv

# Inserer le data des donateurs (muni + code postal + dateajout) dans la base de donnees
cp popups-data.${D}.csv popups-data.${D}.orig.csv
TRIES=0
while true
do
    let TRIES=$TRIES+1
    rm error.${D}.log
    touch error.${D}.log
    psql -h 127.0.0.1 -U lp -c "\\copy donateurs from 'popups-data.${D}.csv' csv header" 2> error.${D}.log
    cat error.${D}.log
    if [ ! -s error.${D}.log ] || [ $TRIES -gt 30 ]
    then
        break
    fi
    if [ `grep "duplicate key value violates unique constraint" error.${D}.log | wc -l | cut -d" " -f1` -ge 1 ]
    then
        IDDUP=`grep "DETAIL" error.${D}.log | grep -oE "[0-9\-]+"`
        echo "Enlever duplicats avec id ${IDDUP} de popups-data"
        grep -vE "^${IDDUP}," popups-data.${D}.csv > popups-data-undup.${D}.csv
        mv popups-data-undup.${D}.csv popups-data.${D}.csv
        continue
    fi
done
#rm popups-data.${D}.csv
#rm popups-data.${D}.orig.csv
if [ `md5sum popups-data.${D}.csv | cut -d" " -f1` != `md5sum popups-data.${D}.orig.csv | cut -d" " -f1` ]
then
    rm popups-data.${D}.orig.csv
fi

# Remplacer master donateurs si pas vide
head -1 donateurs-master.tsv > donateurs-new-master-${D}.tsv
psql -h 127.0.0.1 -U lp -tAc "select idrech, an, fkent from donateurs order by idrech, fkent, an" | sed 's/|/\t/g' > donateurs-new-master-${D}.tsv
if [ `wc -l donateurs-new-master-${D}.tsv | cut -d" " -f1` -gt 1 ]
then
    rm donateurs-master-*.tsv
    mv donateurs-new-master-${D}.tsv donateurs-master-${D}.tsv
    ln -s donateurs-master-${D}.tsv donateurs-master.tsv
else
    rm donateurs-new-master-${D}.tsv
fi

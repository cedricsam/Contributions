#!/bin/bash

DIR="/var/bigdata/contribquebec"
FILESDIR="popups-files"

if [ $# -ge 1 ]
then
    D=$1
else
    D=`date +%Y%m%d-%H%M`
fi


HEADER="id,idrech,an,fkent,nom,prenom,municipalite,codepostal,dateajout"
echo "${HEADER}"
for i in `ls ${DIR}/${FILESDIR} | sort -n`
do
    DATA=`grep "class='affinfo'" "${DIR}/${FILESDIR}/${i}" | sed "s/^[ \t]\+//g" | sed "s/<\/div>\r//" | sed "s/ class='affinfo'//" | iconv -flatin1`
    ID=`echo ${i} | cut -d. -f1`
    IDRECH=`echo ${ID} | cut -d- -f1`
    AN=`echo ${ID} | cut -d- -f2`
    FKENT=`echo ${ID} | cut -d- -f3`
    nom=`echo ${DATA} | grep -oE ">Nom : ([^<]*)" | cut -d: -f2- | sed 's/^ \+//' | sed 's/ \+$//'`
    NOM=`echo ${nom} | cut -d, -f1 | sed 's/^ \+//' | sed 's/ \+$//'`
    PRENOM=`echo ${nom} | cut -d, -f2- | sed 's/, / /g' | sed 's/^ \+//' | sed 's/ \+$//'`
    MUNI=`echo ${DATA} | grep -oE ">Municipalité : ([^<]*)" | cut -d: -f2- | sed 's/^ \+//' | sed 's/ \+$//'`
    CP=`echo ${DATA} | grep -oE ">Code postal : ([^<]*)" | cut -d: -f2- | sed 's/^ \+//' | sed 's/ \+$//'`
    LINE="${ID},${IDRECH},${AN},${FKENT},${NOM},${PRENOM},${MUNI},${CP}"
    echo "${LINE}"
done

#!/bin/bash

URLBASE="http://electionsquebec.qc.ca/francais/provincial/financement-et-depenses-electorales/recherche-sur-les-donateurs.php"
# gets pages

if [ $# -ge 1 ]
then
    D=$1
else
    D=`date +%Y%m%d-%H%M`
fi

DIR="donateurs-${D}"

mkdir -p ${DIR}
cd ${DIR}

#COOKIE=" test=test_cookie; annee=2013|2012|2011; parti=00049|00075|9994|00059|00084|00085|00089|00087|00091|00077|00081|00083|00070|9998|00079|00088|99910|99911|99913|99999|99912|00052|00086|00073|99916|00010|00034|00080|00016|99921|99922|00063|00061|00082|00065|99926|00090|99927|99928|99929; cia=12030|12006|1009|12008|12020|12014|12001|12011|12024|12043|12004|12005|11001|12009|1008; dia=00096|00099|00097|00098|00095"
COOKIE=" test=test_cookie; annee=2013|2012|2011; parti=00049|00075|00059|00084|00085|00089|00087|00091|00077|00081|00083|00070|00079|00088|00052|00086|00073|00010|00034|00080|00016|00063|00061|00082|00065|00090; cia=12030|12006|1009|12008|12020|12014|12001|12011|12024|12043|12004|12005|11001|12009|1008; dia=00096|00099|00097|00098|00095"
COOKIE="`curl -XPOST -sI "${URLBASE}" | grep -oE "Set-Cookie: [^;]+" | cut -d: -f2`; ${COOKIE}"
DATA="control_1%5B%5D=2013&control_1%5B%5D=2012&control_1%5B%5D=2011&ckparti=on&ckdia=on&ckcia=on&ckent=on&control_2%5B%5D=00049&control_2%5B%5D=00075&control_2%5B%5D=00059&control_2%5B%5D=00084&control_2%5B%5D=00085&control_2%5B%5D=00089&control_2%5B%5D=00087&control_2%5B%5D=00091&control_2%5B%5D=00077&control_2%5B%5D=00081&control_2%5B%5D=00083&control_2%5B%5D=00070&control_2%5B%5D=00079&control_2%5B%5D=00088&control_2%5B%5D=00052&control_2%5B%5D=00086&control_2%5B%5D=00073&control_2%5B%5D=00010&control_2%5B%5D=00034&control_2%5B%5D=00080&control_2%5B%5D=00016&control_2%5B%5D=00063&control_2%5B%5D=00061&control_2%5B%5D=00082&control_2%5B%5D=00065&control_2%5B%5D=00090&control_3%5B%5D=00096&control_3%5B%5D=00099&control_3%5B%5D=00097&control_3%5B%5D=00098&control_3%5B%5D=00095&control_4%5B%5D=12030&control_4%5B%5D=12006&control_4%5B%5D=1009&control_4%5B%5D=12008&control_4%5B%5D=12020&control_4%5B%5D=12014&control_4%5B%5D=12001&control_4%5B%5D=12011&control_4%5B%5D=12024&control_4%5B%5D=12043&control_4%5B%5D=12004&control_4%5B%5D=12005&control_4%5B%5D=11001&control_4%5B%5D=12009&control_4%5B%5D=1008&control_5%5B%5D=1&control_5%5B%5D=2&control_6%5B%5D=Pouliot%2C+Adrien+D.&control_6%5B%5D=Brisson%2C+Daniel&control_6%5B%5D=David%2C+Jean&control_6%5B%5D=Couillard%2C+Philippe&control_6%5B%5D=Bachand%2C+Raymond&control_6%5B%5D=Moreau%2C+Pierre&nom=&somme_minimum=&somme_maximum=&action=resultat&liste_tri=NOM_PRENOM_DONATEUR"

curl -sb "${COOKIE}" -d "${DATA}" "${URLBASE}" -o donateurs-firstpage.${D}.html

N=`grep "Fin >>" donateurs-firstpage.${D}.html | grep -oE "\?page=[0-9]+" | cut -d= -f2`

if [ `echo ${N} | wc -c` -gt 1 ]
then
    mv donateurs-firstpage.${D}.html 1.html
else
    exit
fi

for i in `seq 2 ${N}`
do
    #echo $i
    URL="${URLBASE}?page=${i}"
    curl -sb "${COOKIE}" "${URL}" -o ${i}.html
done;

cd - > /dev/null

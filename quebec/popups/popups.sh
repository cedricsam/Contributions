#!/bin/bash

DIR="/var/bigdata/contribquebec/popups-files"

SLEEPLONG=3600
COUNT=0
while read i
do
    let COUNT=${COUNT}+1
    echo ${COUNT}
    idrech=`echo "$i" | cut -f1`
    an=`echo "$i" | cut -f2`
    fkent=`echo "$i" | cut -f3`
    FO="${DIR}/${idrech}-${an}-${fkent}.html"
    if [ "$idrech" == "idrech" ] # skip header row
    then
        echo "skip"
        continue
    fi
    if [ `grep "/includes/anti_bot_image/securite.php" ${FO} 2> /dev/null | wc -l` -eq 1 ] || [ ! -s ${FO} ]
    then
	D1=`date +%N`
	D2=`date +%N`
	#INF="--interface eth`rand -M 2 -s ${D1}`"
	#INF="--interface wlan0"
	#if [ `rand -M 2 -s ${D2}` -eq 0 ]; then INF="--interface wlan0"; fi
	#X=`rand -M 3 -s ${D2}`
	#if [ ${X} -lt 2 ]; then INF=${INF}:${X}; fi
	#echo "${INF}"
	echo Getting: "${FO}"
	#echo "http://www.electionsquebec.qc.ca/applications/donateur_popup.php?idrech=${idrech}&an=${an}&fkent=${fkent}&langue=fr"
	#curl -s ${INF} "http://www.electionsquebec.qc.ca/applications/donateur_popup.php?idrech=${idrech}&an=${an}&fkent=${fkent}&langue=fr" -o "${FO}"
        URL="http://www.electionsquebec.qc.ca/applications/donateur_popup.php?idrech=${idrech}&an=${an}&fkent=${fkent}&langue=fr"
	curl -s "${URL}" -o "${FO}"
	if [ `grep "/includes/anti_bot_image/securite.php" ${FO} 2> /dev/null | wc -l` -eq 1 ]
	then
            NEXTTIME=`date -u -d"6:00 tomorrow" +%s`
            NOW=`date +%s`
            let SLEEPTIME=$NOW-$NEXTTIME
	    echo "Anti-bot active! Sleeping ${SLEEPTIME} until ${NEXTTIME}"
	    sleep ${SLEEPTIME}
            curl -s "${URL}" -o "${FO}"
	else
	    sleep 1
	fi
    else
	echo OK: ${FO}
    fi
done < $1

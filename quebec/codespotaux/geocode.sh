#!/bin/bash

COUNT=0
FOLDER="json"

D=`date +%s`

if [ $# -lt 1 ]
then
    echo "Missing file"
    exit
fi

while read cp
do
    CP=`echo ${cp} | sed 's/ /%20/g'`
    fCP=`echo ${cp} | sed 's/ //g'`
    echo ${cp}
    if [ `grep OK ${FOLDER}/${fCP}.json 2> /dev/null | wc -l` -eq 1 ]
    then
	echo "Already OK: ${FOLDER}/${fCP}.json"
	continue
    fi
    curl -s "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&region=ca&address=${CP}" -o ${FOLDER}/${fCP}.json
    echo "${FOLDER}/${fCP}.json"
    let COUNT=${COUNT}+1
    if [ ${COUNT} -gt 2400 ] || [ `grep OVER_QUERY_LIMIT ${FOLDER}/${fCP}.json 2> /dev/null | wc -l` -eq 1 ]
    then
	echo "MARK SET -- ${COUNT}: `date`"
	NEXTMIDNIGHT=`date -d"tomorrow" +%Y-%m-%d `
	DNEXT=`date -d${NEXTMIDNIGHT} +%s`
	DNOW=`date +%s`
	let SLEEPTIME=${DNEXT}-${DNOW}
	#echo "SLEEPING ${SLEEPTIME} SECONDS -- until `date -d${NEXTMIDNIGHT}`"
	#sleep ${SLEEPTIME}
	SLEEPTIME=86400
	echo "SLEEPING ${SLEEPTIME} SECONDS -- until `date -d"+1 day"`"
	sleep ${SLEEPTIME}
	COUNT=0
    fi
    sleep 0.75 
done < $1


#!/bin/bash

if [ $# -lt 2 ]
then
    exit
fi

ERRORS_ALLOWED=20
ERRORS=0

# 1 = section (PP = parties)
# 2 = nb of pages

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
COOKIE="ASP.NET_SessionId=lqojafp3qdugzaxk5kvw44y3"
BASEURL="http://www.elections.ca/WPAPPS/WPF"
LANG="EN"
SECTION=`echo "$1" | tr [a-z] [A-Z]`
BASEURL="${BASEURL}/${LANG}/${SECTION}/ContributionReport?"

case ${SECTION} in
    "PP"*)
        QS="act=C2&returntype=1&option=4&queryid=&period=0&fromperiod=0&toperiod=0&exactMatch=False&contribrange=-1&contribclass=1%2C%206%2C%2012&selectallcontribclasses=True&totalReportPages=$2"
    ;;
    "EDA"*)
        QS="act=C2&returntype=1&option=4&queryid=&exactMatch=False&contribrange=-1&selectallcontribclasses=False&totalReportPages=$2"
    ;;
    *)
        exit
    ;;
esac

for i in `seq 1 $2`
do
    if [ ! $QUERYID ]
    then
        QUERYID="`${DIR}/get_contribqueryid.sh ${SECTION}`"
    fi
    LINK=`echo "${QS}" | sed "s/queryid=/queryid=${QUERYID}/"`
    FO="${i}.html"
    if [ -s ${FO} ]
    then
        continue
    fi
    curl -b "${COOKIE}" "${BASEURL}${LINK}&reportPage=${i}" | sed -n '/<table id="[cC][^\"]\+" class="DataTable">/,/<\/table>/p' > "${FO}"
    if [ ! -s ${FO} ]
    then
        let ERRORS=${ERRORS}+1
        echo "error: ${i}"
        QUERYID=""
        if [ ${ERRORS} -gt ${ERRORS_ALLOWED} ]
        then
            exit
        fi
    fi
done

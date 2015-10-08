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
ACTUALSECTION="${SECTION}"

case ${SECTION} in
    "PPQ"*) # PP Quarterly
        QS="act=C23&returntype=1&option=4&queryid=&period=1&fromperiod=0&toperiod=0&exactMatch=False&contribrange=-1&contribclass=18%2C19%2C20%2C21&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="PP"
    ;;
    "PPR"*) # PP reviewed by EC (returntype=2)
        QS="act=C2&returntype=2&option=4&queryid=&period=0&fromperiod=0&toperiod=0&exactMatch=False&contribrange=-1&contribclass=1%2C%206%2C%2012&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="PP"
    ;;
    "PP"*) # PP Annual
        QS="act=C2&returntype=1&option=4&queryid=&period=0&fromperiod=0&toperiod=0&exactMatch=False&contribrange=-1&contribclass=1%2C%206%2C%2012&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="PP"
    ;;
    "EDAR"*) # Riding associations reviewed by EC
        QS="act=C2&returntype=2&option=4&queryid=&exactMatch=False&contribrange=-1&selectallcontribclasses=False&totalReportPages=$2"
        ACTUALSECTION="EDA"
    ;;
    "EDA"*) # Riding associations
        QS="act=C2&returntype=1&option=4&queryid=&exactMatch=False&contribrange=-1&selectallcontribclasses=False&totalReportPages=$2"
        ACTUALSECTION="EDA"
    ;;
    "LCR"*)
	EVENTID=`echo $SECTION | sed 's/^LCR//g'`
        QS="act=C2&returntype=2&option=4&queryid=&period=3&eventid=${EVENTID}&exactMatch=False&contribrange=-1&selectallcontribclasses=False&totalReportPages=$2"
        ACTUALSECTION="LC"
    ;;
    "LC"*)
	EVENTID=`echo $SECTION | sed 's/^LC//g'`
        QS="act=C2&returntype=1&option=4&queryid=&period=3&eventid=${EVENTID}&exactMatch=False&contribrange=-1&selectallcontribclasses=False&totalReportPages=$2"
        ACTUALSECTION="LC"
    ;;
    "CCR"*)
	EVENTID=`echo $SECTION | sed 's/^CCR//g'`
        QS="act=C2&returntype=2&option=4&queryid=&eventid=${EVENTID}&exactMatch=False&contribrange=-1&contribclass=12%2C14%2C15%2C16%2C17&contribrange=-1&province=-1&district=-1&party=-1&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="CC"
    ;;
    "CC"*)
	EVENTID=`echo $SECTION | sed 's/^CC//g'`
        QS="act=C2&returntype=1&option=4&queryid=&eventid=${EVENTID}&exactMatch=False&contribrange=-1&contribclass=12%2C14%2C15%2C16%2C17&contribrange=-1&province=-1&district=-1&party=-1&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="CC"
    ;;
    "NCR"*)
	ACT=`echo $SECTION | sed 's/^NCR//g'`
        QS="act=C${ACT}&returntype=2&option=4&queryid=&contribclass=12%2C14%2C15%2C16%2C17%2C18%2C19%2C20%2C21&contribrange=-1&province=-1&district=-1&party=-1&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="NC"
    ;;
    "NC"*)
	ACT=`echo $SECTION | sed 's/^NC//g'`
        QS="act=C${ACT}&returntype=1&option=4&queryid=&contribclass=12%2C14%2C15%2C16%2C17%2C18%2C19%2C20%2C21&contribrange=-1&province=-1&district=-1&party=-1&selectallcontribclasses=True&totalReportPages=$2"
        ACTUALSECTION="NC"
    ;;
    *)
        exit
    ;;
esac

BASEURL="${BASEURL}/${LANG}/${ACTUALSECTION}/ContributionReport?"

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
    echo $i
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

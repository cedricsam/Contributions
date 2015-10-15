#!/bin/bash

if [ $# -lt 2 ]
then
    exit
fi

if [ ! -s $2 ]
then
    exit
fi

ERRORS_ALLOWED=20
ERRORS=0

# 1 = section (PP = parties)
# 2 = file with links

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
COOKIE="ASP.NET_SessionId=lqojafp3qdugzaxk5kvw44y3"
BASEURL="http://www.elections.ca/WPAPPS/WPF"
LANG="EN"
SECTION=`echo "$1" | tr [a-z] [A-Z]`
BASEURL="${BASEURL}/${LANG}/${SECTION}/ContributionReport?"

echo $1 $2 $URL
QUERYID=""

while read link
do
    if [ ! $QUERYID ]
    then
        QUERYID="`${DIR}/get_contribqueryid.sh ${SECTION}`"
    fi
    LINK=`echo "${link}" | sed "s/queryid=/queryid=${QUERYID}/"`
    LINE_ID=`echo "${LINK}" | grep -oE "&(amp;)?ln_no=[0-9]+" | cut -d= -f2`
    FO="${LINE_ID}.html"
    if [ -s ${FO} ]
    then
        continue
    fi
    URL="${BASEURL}${LINK}"
    echo $URL
    curl -b "${COOKIE}" "${URL}" | sed -n '/<fieldset id="addrssinfo2">/,/<\/fieldset>/p' > ${FO}
    if [ ! -s ${FO} ]
    then
        let ERRORS=${ERRORS}+1
        rm ${FO}
        QUERYID=""
        if [ ${ERRORS} -gt ${ERRORS_ALLOWED} ]
        then
            exit
        fi
    fi
done < $2

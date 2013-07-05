#!/bin/bash

if [ $# -lt 3 ]
then
    echo "requires an entity, filter (id) and page"
    exit
fi
period=-1
if [ $# -gt 4 ]
then
    period=$5
fi
ids=$2
if [ $1 -eq 2 ]
then
    ids=""
fi

#curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$2&id=0&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=-1" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3.html
curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$ids&id=&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=1%7C6%7C12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=${period}" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3-$4.html
exit

if [ $1 -eq 1 ] # candidat / election 2
then
    curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$2&id=&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=-1" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3-$4.html
elif [ $1 -eq 2 ] # chefferie / leadership 1
then
    curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$2&id=&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=1%7C6%7C12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=3" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3-$4.html
elif [ $1 -eq 3 ] # investiture / nomination 2
then
    curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$2&id=&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=-1" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3-$4.html
elif [ $1 -eq 5 ] # assos 2
then
    curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$2&id=&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=1%7C6%7C12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=-1" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3-$4.html
elif [ $1 -eq 6 ] # partis / parties 1
then
    curl -s -d "entity=$1&lang=e&filter=$2&option=4&ids=$2&id=&part=&page=$3&sort=0&return=$4&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=1%7C6%7C12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=0" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $1-$2-$3-$4.html
fi

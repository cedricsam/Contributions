#!/bin/bash

if [ $# -lt 2 ]
then
    echo "requires a page number and filter"
    exit
fi

curl -v -d "entity=1&lang=e&filter=$2&option=4&ids=&id=0&part=&page=$1&sort=0&return=2&PrevReturn=0&style=0&table=&searchentity=0&contribname=&contribclass=12&contribprov=-1&contribrange=-1&contribed=-1&contribpp=-1&contribfiscalfrom=0&contribfiscalto=0&EVENTARGUMENT=&period=-1" "http://www.elections.ca/scripts/webpep/fin2/detail_report.aspx" -o $2-$1.html

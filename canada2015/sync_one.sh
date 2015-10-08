#!/bin/bash

if [ $# -lt 2 ]
then
    exit
fi

s=$1
h=$2

rsync -qav ${h}:electionscanada/${s}.contribs/ ${s}.contribs

wc ${s}.txt 
ls ${s}.contribs | wc

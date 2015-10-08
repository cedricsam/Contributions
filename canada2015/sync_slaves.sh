#!/bin/bash

#for d in PP2011 PP2009 PP2007 PPR2011 PPR2009 PPR2007
#do
#    while read i
#    do
#        rsync -qav ${i}:electionscanada/${d}.contribs/ ${d}.contribs
#    done < slaves_only.txt
#    find ${d}.contribs -size 0 -type f -regex .*\.html -exec rm {} \;
#done

while read i
do
    rsync -qav ${i}:geocode/json/ geocode
done < slaves_geocoders.txt

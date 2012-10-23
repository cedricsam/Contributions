#!/bin/bash

for i in `ls *.html`
do
FOO=`grep -E "texteaff|decodeaff" $i | grep -v function`
echo $i $FOO >> donateurs.filtered.txt
done;

iconv -f latin1 -t utf8 donateurs.filtered.txt > donateurs.filtered.utf8.txt

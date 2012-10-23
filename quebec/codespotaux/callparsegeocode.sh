#!/bin/bash

for i in `ls json/*.json`
do
    echo $i
    ./parsegeocode.py $i >> cp.csv
done

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import csv
import xml.etree.ElementTree as ET
import datetime

if len(sys.argv) <= 1:
    sys.exit()

f = open(sys.argv[1], "r")

intext = f.read()
intext = re.sub(r"^.*<table","<table",intext)
intext = "<html>%s</html>" % intext

try:
    root = ET.fromstring(intext)
except Exception as e:
    print str(e)
    print sys.argv[1]
    sys.exit()

cols = []
tableheader = root[0][1]
for th in tableheader:
    cols.append(th.get("id"))

cw = csv.writer(sys.stdout)

subels = ["span", "a"]
table = root[0][2:len(root[0])]
for row in table:
    outrow = []
    rowNbr = addrclientid = returntype = None
    for i in range(len(row)):
        td = row[i]
        td_text = td.text
        for subel in subels:
            if td.find(subel) is not None:
                td_text = td.find(subel).text
        if i < 5:
            try:
                td_text = td_text.encode("utf8")
                td_text.encode('ascii', 'ignore')
            except:
                pass
        if cols[i] in ["mon_amt","non_mon_amt"] and td_text is not None:
            td_text = td_text.replace(",","")
        elif cols[i] in ["contr_full_name"]:
            if td.find("a") is None:
                rowNbr = -1
            else:
                contr_link = td.find("a").get("href")
                m = re.search(r"rowNbr=(\d+)", contr_link)
                if m is not None:
                    rowNbr = m.group(1)
                m = re.search(r"addrclientid=(\d+)", contr_link)
                if m is not None:
                    addrclientid = m.group(1)
                m = re.search(r"returntype=(\d)", contr_link)
                if m is not None:
                    returntype = m.group(1)
        elif cols[i] == "recvd_dt" and len(td_text.strip()) > 0:
            dt = datetime.datetime.strptime(td_text,"%b %d, %Y")
            td_text = dt.strftime("%Y-%m-%d")
        if td_text is not None: td_text = td_text.strip()
        outrow.append(td_text)
    outrow.insert(0, returntype)
    outrow.insert(0, addrclientid)
    outrow.insert(0, rowNbr)
    cw.writerow(outrow)

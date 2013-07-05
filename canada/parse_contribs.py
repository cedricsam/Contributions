#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import csv
import datetime
import xml.etree.ElementTree as ET
from bs4 import BeautifulSoup
#import pprint
import types

cols = ["id_row","id_client","name","party","candidate","association","riding","entity","option","period","id_type","id_part","seqno","return","type","endperiod","date","class","part","through","monetary","nonmonetary","city","prov","postalcode","year"]

if len(sys.argv) <= 1:
    print "Missing file"
    sys.exit()
out = sys.stdout
cw = csv.DictWriter(out, cols)
#cw.writeheader()

f = open(sys.argv[1], "r")
intext = f.read()

intext = re.sub(r"&nbsp;", " ", intext)
soup = BeautifulSoup(intext)

r = dict()

try:
    table = soup.find(class_="table_text")
    if table is None:
        sys.exit()
    trs = table.findAll("tr")
except Exception as e:
    sys.stderr.write(sys.argv[1]+"\n")
    sys.stderr.write(str(e)+"\n")
    sys.exit()
h = list()
headers = [None]*len(cols)

for tr in trs:
    if tr["class"][0] not in ["odd_row", "even_row"] and len(h) <= 0:
        for td in tr.findAll("td"):
            h.append(td.string.split("/"))
        i = 0
        for hh in h:
            ii = 0
            for hhh in hh:
                if "Name of contributor" in hhh:
                    headers[cols.index("name")] = "" + str(i) + "," + str(ii)
                elif "Political Party" in hhh:
                    headers[cols.index("party")] = "" + str(i) + "," + str(ii)
                elif "Type" in hhh:
                    headers[cols.index("type")] = "" + str(i) + "," + str(ii)
                elif "End Period" in hhh:
                    headers[cols.index("endperiod")] = "" + str(i) + "," + str(ii)
                elif "Name of contestant" in hhh:
                    headers[cols.index("candidate")] = "" + str(i) + "," + str(ii)
                elif "Association name" in hhh:
                    headers[cols.index("association")] = "" + str(i) + "," + str(ii)
                elif "Electoral district" in hhh:
                    headers[cols.index("riding")] = "" + str(i) + "," + str(ii)
                elif "Date received" in hhh:
                    headers[cols.index("date")] = "" + str(i) + "," + str(ii)
                elif "Class of contributor" in hhh:
                    headers[cols.index("class")] = "" + str(i) + "," + str(ii)
                elif "Part # of the return" in hhh:
                    headers[cols.index("part")] = "" + str(i) + "," + str(ii)
                elif "Contribution transferred to (leadership contestant)" in hhh:
                    headers[cols.index("through")] = "" + str(i) + "," + str(ii)
                elif "Monetary ($)" in hhh:
                    headers[cols.index("monetary")] = "" + str(i) + "," + str(ii)
                elif "Non-monetary ($)" in hhh:
                    headers[cols.index("nonmonetary")] = "" + str(i) + "," + str(ii)
                elif "fiscal period" in hhh:
                    headers[cols.index("year")] = "" + str(i) + "," + str(ii)
                ii += 1
            i += 1
        continue
    tds = tr.findAll("td")
    name_i = 0
    if headers[cols.index("name")] is not None:
        name_i = int(headers[cols.index("name")].split(",")[0])
    r["name"] = tds[name_i].a.string
    acontributor = tds[name_i].find("a")
    acontributorlink = acontributor["href"]
    # values from the contributor link
    m = re.search(r"type=(\d)", acontributorlink)
    if m is not None: r["id_type"] = int(m.group(1))
    m = re.search(r"row=(\d+)", acontributorlink)
    if m is not None: r["id_row"] = int(m.group(1))
    m = re.search(r"client=(\d+)", acontributorlink)
    if m is not None: r["id_client"] = int(m.group(1))
    m = re.search(r"seqno=(\d+)", acontributorlink)
    if m is not None: r["seqno"] = int(m.group(1))
    m = re.search(r"part=([^&]+)", acontributorlink)
    if m is not None: r["id_part"] = m.group(1)
    m = re.search(r"entity=(\d)", acontributorlink)
    if m is not None: r["entity"] = int(m.group(1))
    m = re.search(r"option=(\d)", acontributorlink)
    if m is not None: r["option"] = int(m.group(1))
    m = re.search(r"period=(\d)", acontributorlink)
    if m is not None: r["period"] = int(m.group(1))
    m = re.search(r"return=(\d)", acontributorlink)
    if m is not None: r["return"] = int(m.group(1))
    index = 0
    for h in headers:
        if h is not None:
            i = int(h.split(",")[0])
            ii = int(h.split(",")[1])
            try:
                r[cols[index]] = tds[i].string.split("/")[ii].strip()
            except AttributeError as e:
                r[cols[index]] = None
            if cols[index] == "date":
                m = re.search(r"([A-z]{3})\.? (\d{,2}),? (\d{4})", r[cols[index]])
                if m is not None:
                    dd = datetime.datetime.strptime(m.group(1) + " " + m.group(2) + " " + m.group(3), "%b %d %Y")
                    d = datetime.datetime.strftime(dd, "%Y-%m-%d")
                    r[cols[index]] = d
            if "monetary" in cols[index]:
                r[cols[index]] = r[cols[index]].replace(" ","").replace(",","").replace("$","")
        index += 1
    for a in cols:
        if a in r and r[a] is not None and type(r[a]) is not types.IntType:
            try:
                r[a] = r[a].encode("utf8")
            except:
                pass
            try:
                r[a] = r[a].strip()
            except Exception as e:
                pass
    try:
        cw.writerow(r)
    except Exception as e:
        pass
        #print str(e)
        #print r

#print h
#print r

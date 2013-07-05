#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import csv
from bs4 import BeautifulSoup

if len(sys.argv) <= 1:
    sys.exit()
cols = ["id_row","return","name","city","prov","postalcode"]
cw = csv.DictWriter(sys.stdout, cols)

f = open(sys.argv[1], "r")
intext = f.read()
intext = re.sub(r"&nbsp;", " ", intext)
soup = BeautifulSoup(intext)

r = dict()
m = re.search(r"(\d+)", sys.argv[1])
if m is not None:
    r["id_row"] = m.group(1)
#r["link"] = soup.find("form")["action"]
link = soup.find("form")["action"]
m = re.search(r"return=(\d)", link)
if m is not None:
    r["return"] = m.group(1)
r["name"] = soup.find(id="lblFullName").string
r["city"] = soup.find(id="lblCity").string
r["prov"] = soup.find(id="lblProvince").string
r["postalcode"] = soup.find(id="lblPostalCode").string

cw.writerow(r)

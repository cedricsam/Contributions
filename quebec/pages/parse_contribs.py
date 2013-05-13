#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import csv
import xml.etree.ElementTree as ET
import pprint
import types
import cgi
import HTMLParser

h = HTMLParser.HTMLParser()

pp = pprint.PrettyPrinter(indent=4)

if len(sys.argv) <= 1:
    print "Missing file"
    sys.exit()

f = open(sys.argv[1], "r")

def escapeHtmlAttr (matchObj):
    return matchObj.group(1)+'="'+cgi.escape(matchObj.group(2))+'"'+matchObj.group(3)

def escapeHtmlAttrSpecial (matchObj):
    #return matchObj.group(1)+'="'+cgi.escape(matchObj.group(2)).replace("'","&#39;")+'"'+matchObj.group(3)
    return matchObj.group(1)+'="'+cgi.escape(matchObj.group(2), quote=True)+'"'+matchObj.group(3)

def escapeHtmlInner (matchObj):
    #return ">" + cgi.escape(matchObj.group(1)).replace("'","&#39;") + "<"
    return ">" + cgi.escape(matchObj.group(1), quote=True)+ "<"

intext = f.read()#5000000)
intext = re.sub(r"([a-zA-Z_0-9]+)='([^']*)'( |>{1})", escapeHtmlAttr, intext)
intext = re.sub(r"(title)='(.*)'( id)", escapeHtmlAttrSpecial, intext)
intext = re.sub(r">([^<>]*)<", escapeHtmlInner, intext)
#intext = re.sub(r">([^<]*)", ">" + cgi.escape("\\1").encode('ascii', 'xmlcharrefreplace'), re.sub(r"' id=", '" id=', re.sub(r"title='", 'title="', re.sub(r"([a-zA-Z_0-9]+)='([^']*)'( |>{1})", '\\1="'+cgi.escape('\\2').encode('ascii', 'xmlcharrefreplace')+'"\\3', intext))))

root = ET.fromstring(intext)

out = list()
cols = ["id", "idrech", "an", "fkent", "nom", "prenom", "montant", "nb_dons", "parti", "candidat"]
cw = csv.DictWriter(sys.stdout, cols)
cw.writeheader()
for tr in root:
    r = dict()
    if len(tr[0]) <= 0:
        continue
    ahref = tr[0][0].get("href")
    m = re.search(r"\?idrech=([0-9]+)&an=([0-9]{4})&fkent=([0-9]{5})", ahref)
    if m is None:
        continue
    r["idrech"] = int(m.group(1))
    r["an"] = int(m.group(2))
    r["fkent"] = int(m.group(3))
    r["id"] = str(r["idrech"]) + "-" + str(r["an"]) + "-" + str(r["fkent"])
    nom = tr[0][0].get("title").replace("Regrouper toutes les contributions de ", "").replace(" en utilisant le code postal et la ville", "").encode("utf8")
    r["nom"] = nom.split(",")[0].strip()
    r["prenom"] = ",".join(nom.split(",")[1:len(nom.split(", "))]).strip()
    r["montant"] = re.sub(",", ".", re.sub(r"[\$  ]+", "", tr[1].text))#.replace("$","").replace(" ", "").replace(",",".")
    r["nb_dons"] = int(tr[2].text)
    parti = re.sub(r"<a[^>]+>.+</a>", "", re.sub(r"<td[^>]+>(.+)</td>", "\\1", ET.tostring(tr[3]))).strip()
    r["parti"] = h.unescape(parti).encode("utf8")
    r["candidat"] = ""
    if "<br />" in parti:
        parti = h.unescape(parti)
        r["parti"] = parti.split("<br />")[0]
        r["candidat"] = parti.split("<br />")[1]
        r["id"] += "-" + r["candidat"].split(",")[0].strip().lower()
    #print r
    try:
        cw.writerow(r)
    except UnicodeEncodeError as e:
        print str(e)
        print r



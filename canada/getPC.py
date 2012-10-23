#!/usr/bin/env python

import sys
import pg
import httplib
import time

def validatePostalCode(postalCode):
    r = True
    if len(postalCode) == 5: #zipcode? 
	r = False
    elif len(postalCode) <> 6:
	r = False
    else:
    	for i in range(6):
	    if i % 2: #  == 1 si impair
		if not postalCode[i].isdigit(): # doit etre un chiffre
		    r = False
	    else:
		if not postalCode[i].isalpha(): # doit etre une lettre
		    r = False
    return r

if len(sys.argv) > 1:
    limit = int(sys.argv[1])
    pgconn = pg.connect('DBNAME', '127.0.0.1', 5432, None, None, 'USERNAME', 'PASSWORD')
    pc_rows = pgconn.query("SELECT postalcode FROM postalcodes WHERE the_geom IS NULL LIMIT %d " % limit)
    pcs = pc_rows.getresult()
    for pc in pcs:
	q = pc[0]
	if validatePostalCode(q):
	    time.sleep(1)
	    key = 'GOOGLE_MAPS_API_KEY'
	    path = "/maps/geo?q=%(q)s&gl=ca&sensor=false&output=csv&key=%(key)s" % {'q' : q, 'key' : key}
	    conn = httplib.HTTPConnection("maps.google.com", timeout=5)
	    try:
		conn.request("GET", path)
	    except (Exception):
		print "socket.gaierror: timeout"
		continue
	    r = conn.getresponse()
	    if r.status == 200:
		a = r.read().split(',')
		acc = a[1]
		lat = a[2]
		lng = a[3]
		print '%(status)s: %(latlng)s (%(q)s) ' % {'status' : r.reason, 'latlng' : lat + ',' + lng, 'q': q}
		wkt = "POINT(" + lng + " " + lat + ")"
		pgconn.query("UPDATE postalcodes SET the_geom = ST_GeomFromText('%(wkt)s',4326) WHERE postalcode = '%(pc)s' " % { 'wkt': wkt, 'pc': pc[0]})
	    else:
		print 'error: %s' % r.status, r.reason
	else:
	    print 'not postal code: %s' % q

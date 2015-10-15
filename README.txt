Contributions Projects

Canada2 (2015):
- Data source: http://www.elections.ca/WPAPPS/WPF/
- A new site introduced during summer 2013
- Depends mostly on cURL
- In development (only fully supports getting party donations)
- Scripts:
        * get_contribqueryid.sh: gets the queryid to make other requests
        * get_contribpages.sh: gets listing pages
        * get_contribreport.sh: gets the important information, the postal code, municipality and province of contributor
- Make sure to get your own session ID by visiting the elections.ca website and checking your Developer Tools console

Canada (2009-2011):
- Data source: http://elections.ca/scripts/webpep/fin/welcome.aspx?&lang=e
- Final product (EN): http://www.lapresse.ca/actualites/elections-federales/political-financing-map/
- Scripts:
	* codepostal.php: gets popups with postal codes and stores the info
	* connect.inc: database information for the php scripts
	* contributions.sql: database schema needed to keep the data
	* getContribs.sh: gets the pages, but you have to find and change the URLs yourself by using the developer tools for each type of contrib data
	* getPC.py: geocodes the postal codes from the DB (run after codepostal.php)
	* storecontribs.php: takes contributions pages, parses them and stores them in the database

Quebec (2012):
- Data source: http://www.electionsquebec.qc.ca/francais/provincial/financement-et-depenses-electorales/recherche-sur-les-donateurs.php
- How-to scrape: https://docs.google.com/document/d/1p7TXlksqWKSO8Y-QgYns5z0fDlXGt5KqIzGbF6jex2w/edit
- Final product (FR): http://www.lapresse.ca/actualites/elections-quebec-2012/carte-du-financement-politique-au-quebec/

By Cedric Sam (cedricsam@gmail.com)

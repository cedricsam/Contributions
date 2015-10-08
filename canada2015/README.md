# Contribs 2015 (Canada 2015)

This is code with minimal documentation because of time constraints (sorry!).

Basically it's a scraper for the Elections Canada [political donations database](http://elections.ca/WPAPPS/WPF/), rewritten from past incarnations that existed since 2011, notably the last one published [on my GitHub](https://github.com/cedricsam/Contributions/tree/master/canada2) in February 2015. The Elections Canada website changed in summer 2013 and this is the version that these scripts work for. The scraping was done in about three weeks between the end of July and mid-August 2015, prior to the October 19, 2015 general election.

I've added some text files such as `sections.txt` and `pages_count.txt` to give an idea on how the scraping was done (two years at the time for PP and EDA entities, both as submitted and revised by EC -- e.g. PPR2013 is for Political Parties 2013-14 revised). The SQL schema dump `contribs2015.sql` helps you understand how reports were generated from the data. Unfortunately, we did most of the work on an ad hoc basis and it's hard to explain what each script does. We did do the scraping in parallel, sometimes running more than 100 Amazon EC2 instances at the same time, using cronjobs on those slaves that run just after boot time on text files with URLs that we would send to them from our master (see `sync_one.sh` and `sync_slaves.sh`).

The Elections Canada database requires a queryid to be generated from a given search for political entities' financial reports (you should check the script `get_contribqueryid.sh`). Entity ids are hard-coded into that script and some have changed because Elections Canada are continuously adding them (for 2014, we assume). Be sure to update that script

The end product of this code are feature stories and a map in the La Presse+ and Star Touch newspaper apps from La Presse and Toronto Star respectively. It is by large a team effort and credits for these stories and the map are in the raw data file below and in those pages republished on these news organisations' webpages:

* LaPresse.ca: [lapresse.ca/dons](http://lapresse.ca/dons)
* TheStar.ca: [thestar.ca](http://thestar.com)

Raw data for this project can be found here with methodology in both English and French (ZIP, ~24 Mb): [lapresse.ca/contributions2015](http://lapresse.ca/contributions2015)

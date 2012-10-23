#!/bin/bash

# gets pages

N=590
# Cookie must be changed before getting... the essential is the "PHPSESSID" part. Get the cookie with the Developer tools on Safari and Chrome
COOKIE="PHPSESSID=25im92q32tuv7um9b3gmmakt23; test=test_cookie; annee=2012|2011; parti=00049|00075|00059|00085|00084|00089|00087|00077|00083|00070|00079|00088|00063|00052|00086|00073|00010|00034|00080|00016|00061|00082|00065; cia=1009|11001|1008; dia=00096|00099|00097|00098|00095"

for i in `seq ${N}`
do
    echo $i
    curl -b "${COOKIE}" "http://www.electionsquebec.qc.ca/francais/provincial/financement-et-depenses-electorales/recherche-sur-les-donateurs.php?page=${i}" -o ${i}.html
done;

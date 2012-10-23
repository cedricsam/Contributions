<?php
/* Might not work out of the box. Also need to modify for each type of contributions (parties, associations, elections). */
$path = "/PATH/TO/DIRECTORY/WITH/CONTRIBPAGES/";
$pgconn = pg_connect("host=127.0.0.1 port=5432 dbname=DBNAME user=USERNAME password=PASSWORD");
if ($handle = opendir($path)) {
    sort($handle, SORT_NUMERIC);
    while (($file = readdir($handle)) !== false)
    {
	if ($file != "." && $file != ".." && $file != "getContribs.sh")
	{
	    preg_match('/^(.*).html/', $file, $out);
	    $doc = new DOMDocument();
	    $doc->loadHTMLFile($path . $file);
#$tables = $doc->getElementByName('table');
	    $xpath = new DOMXPath($doc);
	    $contributors = $xpath->query('/html/body/form[1]/table[3]/tr[2]/td[3]/table[4]');
	    $n = 0;
	    foreach($contributors->item(0)->childNodes as $tr) {
		$n++;
		if($n<2)continue;
		$tds = $tr->childNodes;
		$link = $tds->item(0)->firstChild->getAttribute('href');
		$name = pg_escape_string($tds->item(0)->nodeValue);
		$details = pg_escape_string($tds->item(1)->nodeValue);
		$dateStr = trim($tds->item(2)->nodeValue);
		$type = pg_escape_string(trim($tds->item(3)->nodeValue));
		$through = pg_escape_string(trim($tds->item(4)->nodeValue));
		$monetary = trim(str_replace(",","",$tds->item(5)->nodeValue));
		$nonmonetary = trim(str_replace(",","",$tds->item(6)->nodeValue));
		preg_match('/client=(\d+)&row=(\d+)/', $link, $matches);
		$idClient = (int)$matches[1];
		$idRow = (int)$matches[2];
		/*if (strlen($name) <= 2) $name = "";
		if (strlen($monetary) <= 2) $monetary = "";
		if (strlen($nonmonetary) <= 2) $nonmonetary = "";*/
		if (strlen($through) <= 3) $through = "";
		if (strlen($dateStr) <= 3) $date = "";
		else $date = format_date($dateStr);
		$sql = "INSERT INTO contribparties (id_row, id_client, name, details, date, classpart, through, monetary, nonmonetary, year) VALUES ($idRow, $idClient, '$name', '$details', '$date', '$type', '$through', '$monetary', '$nonmonetary', 2010) ";
		print $sql . "\n";
		#pg_query($sql);
	    }
	print "FILE: " . $file . "\n";
	}
    }
    closedir($handle);
}

function format_date($dateStr) {
    preg_match('/(\w{3}+)\.? (\d+), (\d+)/', $dateStr, $matches);
    switch(strtolower($matches[1])) {
	case "jan":
	    $month = '01';
	    break;
	case "feb":
	    $month = '02';
	    break;
	case "mar":
	    $month = '03';
	    break;
	case "apr":
	    $month = '04';
	    break;
	case "may":
	    $month = '05';
	    break;
	case "jun":
	    $month = '06';
	    break;
	case "jul":
	    $month = '07';
	    break;
	case "aug":
	    $month = '08';
	    break;
	case "sep":
	    $month = '09';
	    break;
	case "oct":
	    $month = '10';
	    break;
	case "nov":
	    $month = '11';
	    break;
	case "dec":
	    $month = '12';
	    break;
    }
    $day = (int)$matches[2];
    if($day<10) $day = "0$day";
    $year = $matches[3];
    
    $out = "$year/$month/$day";
    #echo $dateStr . " " . $out;
    if(strlen(trim($out))!=10) die($out);
    return $out; 
}
?>


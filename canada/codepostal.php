<?php
require_once('connect.inc');
$offset = $argv[1];
$row_count = $argv[2];
$tablename = $argv[3];
if(!$offset) $offset = 0;
if(!$row_count) $row_count = 0;
if(!$tablename) $tablename = "contribparties";
$query_timeout= 15;
$sql = "SELECT id_row, id_client FROM $tablename WHERE postalcode IS NULL ORDER BY id_row LIMIT $row_count OFFSET $offset ";
echo "sql: $sql";
$result = pg_query($sql);
while($row = @pg_fetch_assoc($result)) {
    $city = "";
    $prov = "";
    $postalCode = "";
    $idClient = (int)$row['id_client'];
    $idRow = (int)$row['id_row'];
    #echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=6&lang=e&option=4&period=0\n");
    #echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&seqno=&part=2a&entity=1&lang=e&option=4&return=1\n");
    if ($tablename == "contribassociations") echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&seqno=&part=2a&entity=5&lang=e&option=4&return=1\n");
    else if ($tablename == "contribparties") echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=6&lang=e&option=4&period=0\n");
    else if ($tablename == "contribelections") echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=1&lang=e&option=4&period=1\n");
    #else if ($tablename == "contribparties") echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&seqno=&part=2a&entity=6&lang=e&option=4&return=1\n");
    #else if ($tablename == "contribparties") echo("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=6&lang=e&option=4&period=1\n");
    try {
	if ($tablename == "contribassociations") $file = fopen("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&seqno=&part=2a&entity=5&lang=e&option=4&return=1", "r");
	else if ($tablename == "contribparties") $file = fopen("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=6&lang=e&option=4&period=0", "r");
	else if ($tablename == "contribelections") $file = fopen("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=1&lang=e&option=4&period=1", "r");
	#else if ($tablename == "contribparties") $file = fopen("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&seqno=&part=2a&entity=6&lang=e&option=4&return=1", "r");
	else exit();
	stream_set_blocking($file, FALSE);
	stream_set_timeout($file, $query_timeout);
	$status = socket_get_status($file);
	//$file = fopen("http://www.elections.ca/scripts/webpep/fin2/contributor.aspx?type=1&client=$idClient&row=$idRow&part=2a&entity=6&lang=e&option=4&period=0", "r");
    } catch (Exception $e) {
	echo("Timeout: Unable to open remote file.");
	continue;
    }
    if (!$file) {
	echo("Unable to open remote file.");
	continue;
    }
    while (!feof ($file)  && !$status['timed_out']) {
	$line = fgets($file, 1024);
	if (strlen(trim($city))<1 && preg_match("@\"lblCity\"\>(.*)\</span\>@i", $line, $out)) {
	    $city = pg_escape_string(utf8_encode($out[1]));
	    continue;
	}
	if (strlen(trim($prov))<1 && preg_match("@\"lblProvince\"\>(.*)\</span\>@i", $line, $out)) {
	    $prov = pg_escape_string(utf8_encode($out[1]));
	    continue;
	}
	if (strlen(trim($postalCode))<1 && preg_match("@\"lblPostalCode\"\>(.*)\</span\>@i", $line, $out)) {
	    $postalCode = strtolower(trim(str_replace(" ","",($out[1]))));
	    $postalCode = str_replace("-","",($postalCode));
	    continue;
	}
    }
    $sql = "INSERT INTO postalcodes VALUES ('$postalCode', NULL) ";
    pg_query($connection, $sql);
    $sql = "UPDATE $tablename SET city = '$city', prov = '$prov', postalcode = '$postalCode' WHERE id_row = $idRow ";
    echo "sql: $sql";
    pg_query($connection, $sql);
    echo "$idRow, $city, $prov, $postalCode\n";
    /*if(pg_affected_rows($connection)!=1) {
	die('Row could not be updated');
    }*/
}
?>


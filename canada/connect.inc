<?php
 $username = 'USERNAME';
 $password = 'PASSWORD';
 $database = 'SERVER';
 $server = 'localhost';
 $port = 5432;

// Opens a connection to a PG server.
$connection = pg_connect("host=$server port=$port user=$username password=$password dbname=$database");
if (!$connection) 
{
  die('Not connected : ' . pg_last_error());
}

?>

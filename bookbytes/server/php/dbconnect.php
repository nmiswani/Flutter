<?php
$servername = "infinitebe.com";
$username   = "infinmwk_wani";
$password   = "#pNF,zxBwKak";
$dbname     = "infinmwk_wani_bookbytes_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
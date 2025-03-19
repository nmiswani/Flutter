<?php
if (!isset($_POST['email'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$email = $_POST['email'];

$sqlcheck = "SELECT * FROM `tbl_customers` WHERE `customer_email` = '$email'";
$result = $conn->query($sqlcheck);
if ($result->num_rows > 0) {
    $response = array('status' => 'exists', 'data' => null);
} else {
    $response = array('status' => 'not_exists', 'data' => null);
}
sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

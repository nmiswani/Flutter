<?php
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $code = $_POST['code'];

    $query = "SELECT * FROM `tbl_customers` WHERE `customer_email` ='$email' AND `reset_code` ='$code'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $customerData = mysqli_fetch_assoc($result);
        echo json_encode(["status" => "success", "customer" => $customerData]);
    } else {
        echo json_encode(["status" => "fail"]);
    }
}
?>

<?php
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $new_password = $_POST['password'];

    // Encrypt password before saving (use password_hash for better security)
    $hashed_password = md5($new_password);

    $update = "UPDATE `tbl_customers` SET `customer_password` = '$hashed_password', reset_code=NULL WHERE customer_email='$email'";

    if (mysqli_query($conn, $update)) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "fail"]);
    }
}
?>

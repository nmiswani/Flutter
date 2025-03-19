<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

//require 'phpmailer/phpmailer/src/Exception.php';
//require 'phpmailer/phpmailer/src/PHPMailer.php';
//require 'phpmailer/phpmailer/src/SMTP.php';

header('Content-Type: application/json'); // Ensure response is JSON
include 'db_connect.php';

//Load Composer's autoloader
require './vendor/autoload.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];

    // Check if email is provided
    if (empty($email)) {
        echo json_encode(["status" => "fail", "message" => "Email is required"]);
        exit();
    }

    // Query to check if email exists
    $checkEmail = "SELECT * FROM `tbl_customers` WHERE `customer_email` = ?";
    $stmt = mysqli_prepare($conn, $checkEmail);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if (!$result) {
        echo json_encode(["status" => "fail", "message" => "Database error: " . mysqli_error($conn)]);
        exit();
    }

    if (mysqli_num_rows($result) > 0) {
        $code = rand(1000, 9999); // Generate 4-digit code

        // Update reset code
        $updateCode = "UPDATE `tbl_customers` SET `reset_code` = ? WHERE `customer_email` = ?";
        $stmt = mysqli_prepare($conn, $updateCode);
        mysqli_stmt_bind_param($stmt, "ss", $code, $email);
        $updateResult = mysqli_stmt_execute($stmt);

        if (!$updateResult) {
            echo json_encode(["status" => "fail", "message" => "Failed to update reset code"]);
            exit();
        }

        // Send email (Ensure SMTP is configured)
        $subject = "Password Reset Code";
        $message = "Your password reset code is: $code";
        $headers = "From: no-reply@yourwebsite.com\r\n";
        $headers .= "Reply-To: no-reply@yourwebsite.com\r\n";
        $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

        if (mail($email, $subject, $message, $headers)) {
            echo json_encode(["status" => "success", "message" => "Reset code sent"]);
        } else {
            echo json_encode(["status" => "fail", "message" => "Failed to send email"]);
        }
    } else {
        echo json_encode(["status" => "fail", "message" => "Email not registered"]);
    }
}
?>

<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php'; // Make sure composer installed PHPMailer

$mail = new PHPMailer(true);

try {
    // Server settings
    $mail->isSMTP();
    $mail->Host = 'smtp.gmail.com';
    $mail->SMTPAuth = true;
    $mail->Username = 'your-email@gmail.com'; // Replace with your Gmail
    $mail->Password = 'your-app-password'; // Replace with your Gmail App Password
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port = 587;

    // Sender and recipient
    $mail->setFrom('your-email@gmail.com', 'Your Website');
    $mail->addAddress('test@example.com'); // Change to the recipient email

    // Email content
    $mail->Subject = 'Test Email';
    $mail->Body    = 'This is a test email from PHPMailer.';

    // Send email
    $mail->send();
    echo "Email sent successfully!";
} catch (Exception $e) {
    echo "Failed to send email. Error: {$mail->ErrorInfo}";
}
?>

<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require './phpmailer/phpmailer/src/Exception.php';
require './phpmailer/phpmailer/src//PHPMailer.php';
require './phpmailer/phpmailer/src/SMTP.php';

include 'db_connect.php';
//C:\xampp\htdocs\pomm\php\vendor\phpmailer\phpmailer\src
require './vendor/autoload.php';

if (isset($_POST['forget'])) {
  $email = $_POST['email'];

  $sql = "SELECT `customer_email` FROM `tbl_customers` WHERE `customer_email` = ? ";
  $prepare = $conn->prepare($sql);
  $prepare->execute([$email]);
  $rowCount = $prepare->rowCount();
    
//Instantiation and passing `true` enables exceptions
$mail = new PHPMailer(true);
echo "Trying to send email";
try {
    //Server settings
    $mail->SMTPDebug = 0;                      //Enable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'nursyazwanimuzakir@gmail.com';                     //SMTP username
    $mail->Password   = '12345';                               //SMTP password
    $mail->SMTPSecure = 'tls';         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;                                    //TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above

    //Recipients
    $mail->setFrom('nursyazwanimuzakir@gmail.com', 'Mailer');
    $mail->addAddress($email);     //Add a recipient
    
    
    //Content
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Here is the subject';
    $mail->Body    = 'This is the HTML message body <b>in bold!</b>';
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
}
?>
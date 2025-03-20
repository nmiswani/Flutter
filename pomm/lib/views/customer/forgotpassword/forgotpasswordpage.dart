import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';
import 'verifycodepage.dart';
import 'package:pomm/models/customer.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  Customer? customer; // Store customer data

  void sendVerificationCode() async {
    String email = _emailController.text.trim();

    // Validate email before sending request
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your email.")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/forgot_password_test.php"),
        body: {"email": email},
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == "success") {
        customer = Customer.fromJson(jsonResponse['customer']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyCodePage(customer: customer!),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Email not registered.")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your registered email:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendVerificationCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

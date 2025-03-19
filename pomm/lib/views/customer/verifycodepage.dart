import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';
import 'resetpasswordpage.dart';
import 'package:pomm/models/customer.dart';

class VerifyCodePage extends StatefulWidget {
  final Customer customer;
  const VerifyCodePage({Key? key, required this.customer}) : super(key: key);

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _codeController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  void verifyCode() async {
    String code = _codeController.text.trim();

    // Validate if the code is entered
    if (code.isEmpty) {
      showSnackBar("Please enter the verification code.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/verify_code.php"),
        body: {"email": widget.customer.customeremail, "code": code},
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == "success") {
        if (!mounted) return; // Prevent navigation errors
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(customer: widget.customer),
          ),
        );
      } else {
        showSnackBar("Invalid code! Please try again.");
      }
    } catch (e) {
      showSnackBar("An error occurred. Please try again.");
    }

    setState(() {
      isLoading = false;
    });
  }

  // Function to show SnackBar messages
  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Code")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the 4-digit code sent to your email:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter code",
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
                onPressed: isLoading ? null : verifyCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Verify",
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

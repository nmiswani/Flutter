import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';
import 'resetpasswordpage.dart';
import 'package:pomm/models/customer.dart';

class VerifyCodePage extends StatefulWidget {
  final Customer customer;
  const VerifyCodePage({super.key, required this.customer});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      "DEBUG: Customer Email in VerifyCodePage = ${widget.customer.customeremail}",
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void verifyCode() {
    String? email = widget.customer.customeremail?.trim();
    String codes = codeController.text.trim();

    if (email == null || email.isEmpty) {
      showSnackBar("Error: Email is missing.");
      return;
    }

    if (codes.isEmpty) {
      showSnackBar("Please enter the verification code.");
      return;
    }

    debugPrint("DEBUG: Sending Email = $email, Code = $codes");

    setState(() {
      isLoading = true;
    });

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/verify_code.php"),
          body: {"email": email, "codes": codes},
        )
        .then((response) {
          debugPrint("DEBUG: API Response: ${response.body}");

          setState(() {
            isLoading = false;
          });

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);

            if (data['status'] == "success" && data['data'] != null) {
              // Customer customer = Customer.fromJson(data['data']);

              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ResetPasswordPage(
                          customerdata: Customer(
                            customeremail: email, // ✅ Ensure email is set
                          ),
                        ),
                  ),
                );
              }
            } else {
              showSnackBar("Invalid verification code.");
            }
          } else {
            showSnackBar("Server error. Please try again.");
          }
        })
        .catchError((error) {
          setState(() {
            isLoading = false;
          });
          showSnackBar("Error: ${error.toString()}");
        });
  }

  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
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
              controller: codeController,
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

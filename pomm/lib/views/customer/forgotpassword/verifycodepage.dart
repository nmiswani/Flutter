import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      "Customer email in VerifyCodePage: ${widget.customer.customeremail}",
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Password Reset",
          style: GoogleFonts.inter(fontSize: 17, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Text(
                  "Please enter your 4-digit code\ngiven for verification.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(height: 70),
              makeInput(
                icon: Icons.email,
                hint: "Enter 4-digit code here",
                controller: codeController,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.10,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Verify",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    bool showVisibilityToggle = false,
    VoidCallback? onTapVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 70,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 236, 231, 231),
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.black),
              suffixIcon:
                  showVisibilityToggle
                      ? IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: onTapVisibilityToggle,
                      )
                      : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              errorStyle: GoogleFonts.inter(color: Colors.red),
              hintStyle: GoogleFonts.inter(color: Colors.black54, fontSize: 14),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  void verifyCode() {
    String? email = widget.customer.customeremail?.trim();
    String codes = codeController.text.trim();

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email is missing", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (codes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter the verification code",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    debugPrint("Sending email: $email, code: $codes");

    setState(() {
      isLoading = true;
    });

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/verify_code.php"),
          body: {"email": email, "codes": codes},
        )
        .then((response) {
          debugPrint("API response: ${response.body}");

          setState(() {
            isLoading = false;
          });

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success" && data['data'] != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Your code has been verified",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ResetPasswordPage(
                          customerdata: Customer(customeremail: email),
                        ),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Invalid verification code",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Server error. Please try again",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        })
        .catchError((error) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error: ${error.toString()}",
                style: GoogleFonts.inter(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}

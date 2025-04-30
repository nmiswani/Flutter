import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';
import 'verifycodepage.dart';
import 'package:pomm/models/customer.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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
                  "Please enter your registered\nemail below and 4-digit code will\nbe sent to your email.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(height: 50),
              makeInput(
                icon: Icons.email,
                hint: "Email",
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.10,
                  child: ElevatedButton(
                    onPressed: () {
                      sendVerificationCode();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Submit",
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

  Future<void> sendVerificationCode() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter your email", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/forgotpwd.php"),
        body: {"email": email},
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == "success") {
        if (jsonResponse.containsKey('customer')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Code has been sent to your email",
                style: GoogleFonts.inter(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      VerifyCodePage(customer: Customer(customeremail: email)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Customer data missing",
                style: GoogleFonts.inter(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email not registered", style: GoogleFonts.inter()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "An error occurred. Please try again",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

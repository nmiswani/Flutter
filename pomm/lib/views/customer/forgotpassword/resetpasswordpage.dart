import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/views/customer/loginregister/logincustomerpage.dart';

class ResetPasswordPage extends StatefulWidget {
  final Customer customerdata;
  const ResetPasswordPage({super.key, required this.customerdata});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      "Customer email in VerifyCodePage: ${widget.customerdata.customeremail}",
    );
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
                  "Please enter your new password.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                ),
              ),
              const SizedBox(height: 40),
              makeInput(
                icon: Icons.lock,
                hint: "New password",
                controller: newPasswordController,
                obscureText: !_isObscureNew,
                showVisibilityToggle: true,
                onTapVisibilityToggle: () {
                  setState(() {
                    _isObscureNew = !_isObscureNew;
                  });
                },
                validator: _validatePassword,
              ),
              makeInput(
                icon: Icons.lock,
                hint: "Re-enter new password",
                controller: confirmPasswordController,
                obscureText: !_isObscureConfirm,
                showVisibilityToggle: true,
                onTapVisibilityToggle: () {
                  setState(() {
                    _isObscureConfirm = !_isObscureConfirm;
                  });
                },
                validator: _validatePassword,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.10,
                  child: ElevatedButton(
                    onPressed: () {
                      resetPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Confirm",
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
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(161, 236, 231, 231),
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter password';
    } else {
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
    }
    return null;
  }

  void resetPassword() {
    String? email = widget.customerdata.customeremail?.trim();
    String password = newPasswordController.text.trim();
    String confirmpassword = confirmPasswordController.text.trim();

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email is missing", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password.isEmpty || confirmpassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter password", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password != confirmpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint("Sending email: $email, password: $password");

    setState(() {
      isLoading = true;
    });

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/reset_password.php"),
          body: {"email": email, "password": password},
        )
        .then((response) {
          var jsondata = jsonDecode(response.body);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Password successfully updated",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginCustomerPage(),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update password",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}

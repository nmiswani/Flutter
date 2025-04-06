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
      "DEBUG: Customer Email in VerifyCodePage = ${widget.customerdata.customeremail}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Password Reset",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildPasswordField(
                "New Password",
                newPasswordController,
                _isObscureNew,
                () {
                  setState(() {
                    _isObscureNew = !_isObscureNew;
                  });
                },
              ),
              const SizedBox(height: 15),
              _buildPasswordField(
                "Re-enter new password",
                confirmPasswordController,
                _isObscureConfirm,
                () {
                  setState(() {
                    _isObscureConfirm = !_isObscureConfirm;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  "Confirm",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isObscure,
    VoidCallback toggleVisibility,
  ) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  void resetPassword() {
    String? email = widget.customerdata.customeremail?.trim();
    String password = newPasswordController.text.trim();
    String confirmpassword = confirmPasswordController.text.trim();

    if (email == null || email.isEmpty) {
      showSnackBar("Error: Email is missing.");
      return;
    }
    if (password.isEmpty || confirmpassword.isEmpty) {
      showSnackBar("Please enter a password");
      return;
    }
    if (password != confirmpassword) {
      showSnackBar("Passwords do not match");
      return;
    }

    debugPrint("DEBUG: Sending Email = $email, Password = $password");

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
            showSnackBar("Password updated successfully");

            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginCustomerPage(),
                ),
              );
            }
          } else {
            showSnackBar("Failed to update password");
          }
        });
  }

  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

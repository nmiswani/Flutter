import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/customerdashboard.dart';
import 'package:pomm/views/customer/forgotpassword/forgotpasswordpage.dart';
import 'package:pomm/views/customer/loginregister/registercustomerpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/views/loginclerkadminpage.dart';

class LoginCustomerPage extends StatefulWidget {
  const LoginCustomerPage({super.key});

  @override
  State<LoginCustomerPage> createState() => _LoginCustomerPageState();
}

class _LoginCustomerPageState extends State<LoginCustomerPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 100),
                  Image.asset(
                    'assets/images/loginicon.png',
                    height: 170,
                    width: 240,
                  ),
                  Text(
                    "UTARA GADGET SOLUTION",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 50),
                  makeInput(
                    icon: Icons.email,
                    hint: "Email",
                    controller: emailController,
                    validator: _validateEmail,
                  ),
                  makeInput(
                    icon: Icons.lock,
                    hint: "Password",
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    showVisibilityToggle: true,
                    onTapVisibilityToggle: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    validator: _validatePassword,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _navigateToResetPassword,
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1,
                      child: ElevatedButton(
                        onPressed: () {
                          _loginUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "Login",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToRegisterPage,
                        child: Text(
                          " Register",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Clerk or admin?",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToLoginPage,
                        child: Text(
                          " Login",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
              fillColor: const Color.fromARGB(255, 255, 236, 236),
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

  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterCustomerPage()),
    );
  }

  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginClerkAdminPage()),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(
          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
        ).hasMatch(value)) {
      return 'Enter registered email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Enter registered password';
    }
    return null;
  }

  void _loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "These field are required",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/login_customer.php"),
          body: {"email": email, "password": password},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              Customer customer = Customer.fromJson(data['data']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "You have successfully logged in",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CustomerDashboardPage(customerdata: customer),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Login failed. Invalid email or password",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}

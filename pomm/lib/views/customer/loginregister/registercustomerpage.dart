import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/views/customer/loginregister/logincustomerpage.dart';
import 'dart:convert';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:http/http.dart' as http;

class RegisterCustomerPage extends StatefulWidget {
  const RegisterCustomerPage({super.key});

  @override
  State<RegisterCustomerPage> createState() => _RegisterCustomerPageState();
}

class _RegisterCustomerPageState extends State<RegisterCustomerPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
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
                  const SizedBox(height: 115),
                  Text(
                    "Register",
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Create an account, it's free!",
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  makeInput(
                    icon: Icons.account_circle,
                    hint: "Name",
                    controller: nameController,
                    validator: _validateName,
                  ),
                  makeInput(
                    icon: Icons.email,
                    hint: "Email",
                    controller: emailController,
                    validator: _validateEmail,
                  ),
                  makeInput(
                    icon: Icons.phone,
                    hint: "Phone Number",
                    controller: phoneNumberController,
                    validator: _validatePhoneNumber,
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
                  const SizedBox(height: 35),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1,
                      child: ElevatedButton(
                        onPressed: () {
                          String name = nameController.text.trim();
                          String email = emailController.text.trim();
                          String phone = phoneNumberController.text.trim();
                          String password = passwordController.text.trim();

                          if (name.isEmpty &&
                              email.isEmpty &&
                              phone.isEmpty &&
                              password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "These fields are required",
                                  style: GoogleFonts.inter(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            showConfirmationDialog(context);
                          }
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
                            "Register",
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
                        "Already have an account?",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
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

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginCustomerPage()),
    );
  }

  String? _validateName(String? value) {
    if (value == null || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name cannot have symbols or numbers';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(
          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
        ).hasMatch(value)) {
      return 'Enter valid email (e.g. example@gmail.com)';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter valid phone number (e.g. 0123456789)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Register new account',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?', style: GoogleFonts.inter()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes', style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
                _registerSuccessful();
              },
            ),
            TextButton(
              child: Text('No', style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerSuccessful() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneNumberController.text.trim();
    String password = passwordController.text.trim();

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/register_customer.php"),
          body: {
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            print(data);
            if (data['status'] == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "You have successfully registered",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => const LoginCustomerPage(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Registration failed. Email already exists",
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

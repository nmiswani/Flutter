// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, avoid_print

import 'dart:convert';

import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:bookbytes/main.dart';
import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isPasswordVisible = false;
  bool agreeWithTerms = false;
  String eula = "";

  // Function to navigate to the login page
  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Function to navigate back to the main app
  void _navigateToMyApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            _navigateToMyApp(); // Navigate back to MyApp
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Create an account, It's free",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Column(
                  children: <Widget>[
                    makeInput(
                      icon: Icons.account_circle,
                      hint: "Username",
                      controller: usernameController,
                      validator: _validateUsername,
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
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: agreeWithTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              agreeWithTerms = value ?? false;
                            });
                          },
                        ),
                        GestureDetector(
                            onTap: _showEULA,
                            child: const Text("Agree with terms")),
                        const Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            ),
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 50,
                            onPressed: () {
                              // Trigger validation when the button is pressed
                              if (_formKey.currentState?.validate() ?? false) {
                                // Show confirmation dialog
                                showConfirmationDialog(context);
                              }
                            },
                            color: Colors.lightBlueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        // Navigate to login page
                        _navigateToLogin();
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height:
                        20), // Removed space below "Already have an account"
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Validator for the username
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a username';
    }
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Username cannot contain symbols';
    }
    return null;
  }

  // Validator for the email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Enter a valid email address (e.g. sofia@gmail.com)';
    }
    return null;
  }

  // Validator for the phone number
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter a valid phone number (e.g. 0123456789)';
    }
    return null;
  }

  // Validator for the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a password';
    } else {
      if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }
    }
    return null;
  }

  // Widget for creating input fields
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
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode
              .onUserInteraction, // Trigger validation on user interaction
          decoration: InputDecoration(
            labelText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: showVisibilityToggle
                ? IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: onTapVisibilityToggle,
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          validator: hint == 'Username' ? _validateUsername : validator,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  // Function to show the confirmation dialog
  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text('Register new account?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                if (agreeWithTerms) {
                  _registerSuccessful();
                  _navigateToLogin();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please agree to the terms'),
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Registration canceled"),
                  backgroundColor: Colors.red,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  // Function to load the End User License Agreement (EULA)
  void loadEula() async {
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  // Function to show the EULA dialog
  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  // Function to handle successful registration
  void _registerSuccessful() {
    String _name = usernameController.text;
    String _email = emailController.text;
    String _phone = phoneNumberController.text;
    String _pass = passwordController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/register_user.php"),
        body: {
          "name": _name,
          "email": _email,
          "phone": _phone,
          "password": _pass
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration successful"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}

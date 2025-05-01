import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/clerk.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/admindashboard.dart';
import 'package:pomm/views/clerk/order/clerkorderpage.dart';
import 'package:pomm/views/customer/loginregister/logincustomerpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginClerkAdminPage extends StatefulWidget {
  const LoginClerkAdminPage({super.key});

  @override
  State<LoginClerkAdminPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginClerkAdminPage> {
  TextEditingController userIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadpref();
  }

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
                    'assets/images/loginicon_ca.png',
                    height: 135,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "CLERK & ADMIN OF\nUTARA GADGET SOLUTION",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 45),
                  makeInput(
                    icon: Icons.email,
                    hint: "User ID",
                    controller: userIDController,
                    validator: _validateUserID,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          saveremovepref(value!);
                          setState(() {
                            _isChecked = value;
                          });
                        },
                      ),
                      Text(
                        "Remember me",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
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
                        "Login as customer?",
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

  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginCustomerPage()),
    );
  }

  String? _validateUserID(String? value) {
    if (value == null ||
        !RegExp(
          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
        ).hasMatch(value)) {
      return 'Enter registered user ID';
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
    String email = userIDController.text.trim();
    String password = passwordController.text.trim();
    String loginUrl;

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

    if (email == "adminpomm@gmail.com") {
      loginUrl = "${MyServerConfig.server}/pomm/php/login_admin.php";
    } else if (email == "clerkpomm@gmail.com") {
      loginUrl = "${MyServerConfig.server}/pomm/php/login_clerk.php";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Invalid user ID or password",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    http
        .post(Uri.parse(loginUrl), body: {"email": email, "password": password})
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              if (email == "adminpomm@gmail.com") {
                Admin admin = Admin.fromJson(data['data']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "You have successfully logged in",
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (content) => AdminDashboardPage(admin: admin),
                  ),
                );
              } else if (email == "clerkpomm@gmail.com") {
                Clerk clerk = Clerk.fromJson(data['data']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "You have successfully logged in",
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (content) => OrderClerkPage(clerk: clerk),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Login failed. Invalid user ID or password",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }

  void saveremovepref(bool value) async {
    String userID = userIDController.text;
    String password = passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('userID', userID);
      await prefs.setString('pass', password);
      await prefs.setBool('rem', value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preferences stored", style: GoogleFonts.inter()),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      await prefs.setString('userID', '');
      await prefs.setString('pass', '');
      await prefs.setBool('rem', false);
      userIDController.text = '';
      passwordController.text = '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preferences removed", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = (prefs.getString('userID')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('rem')) ?? false;
    if (_isChecked) {
      userIDController.text = userID;
      passwordController.text = password;
    }
    setState(() {});
  }
}

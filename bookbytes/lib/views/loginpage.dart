import 'dart:convert';
import 'mainpage.dart';
import 'registerpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    loadpref();
  }

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  // Validator for the email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Validator for the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a password';
    }
    if (value.length < 6) {
      return 'Enter a valid password';
    }
    return null;
  }

  // Inside the makeInput function
  Widget makeInput({
    required IconData icon,
    required String hint,
    obscureText = false,
    required TextEditingController controller,
    Widget? suffixIcon,
    String? labelText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
            labelText: labelText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          Colors.transparent, // Set background color of Scaffold to transparent
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 224, 200), // Start color
              Color.fromARGB(255, 255, 255, 255), // End color
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/loginpage.png'),
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: makeInput(
                                icon: Icons.email,
                                hint: "Email",
                                controller: emailController,
                                labelText: 'Email',
                                validator: _validateEmail,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: makeInput(
                                icon: Icons.lock,
                                hint: "Password",
                                obscureText: !isPasswordVisible,
                                controller: passwordController,
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(width: 30),
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
                              //_saveCredentials();
                            },
                          ),
                          const Text("Remember me"),
                          const SizedBox(
                            width: 74,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          child: ElevatedButton(
                            onPressed: () {
                              _loginUser(); // Navigate to LoginPage
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account?"),
                          GestureDetector(
                            onTap: () {
                              _navigateToRegistration();
                            },
                            child: const Text(
                              " Create a new account",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
          ],
        ),
      ),
    );
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String email = emailController.text;
    String pass = passwordController.text;

    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/login_user.php"),
        body: {"email": email, "password": pass}).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => MainPage(
                        userdata: user,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed. Please create a new account"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void saveremovepref(bool value) async {
    String email = emailController.text;
    String password = passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('rem', value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        backgroundColor: Colors.green,
      ));
    } else {
      //remove pref
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('rem', false);
      emailController.text = '';
      passwordController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('rem')) ?? false;
    if (_isChecked) {
      emailController.text = email;
      passwordController.text = password;
    }
    setState(() {});
  }
}

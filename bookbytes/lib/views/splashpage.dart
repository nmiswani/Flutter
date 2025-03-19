// ignore_for_file: unused_local_variable

import 'loginpage.dart';
import 'welcomepage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkandlogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/cover.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Content
          const Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Adjusted alignment
              children: [
                // Content at the top
                Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: Text(
                    "BookBytes",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Progress Indicator in the center
                CircularProgressIndicator(),
                // Bottom
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    "Version 3.0",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> isUserRegistered(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedEmail = (prefs.getString('email')) ?? '';
    String storedPassword = (prefs.getString('pass')) ?? '';

    return email == storedEmail && password == storedPassword;
  }

  checkandlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool rem = (prefs.getBool('rem')) ?? false;

    if (rem) {
      http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/login_user.php"),
        body: {"email": email, "password": password},
      ).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            User user = User.fromJson(data['data']);
            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (content) => const LoginPage()),
              ),
            );
          } else {
            User user = User(
              userid: "0",
              useremail: "", //"unregistered@email.com",
              username: "", //"Unregistered",
              userphone: "",
              userpassword: "",
            );
            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (content) => const WelcomePage()),
              ),
            );
          }
        }
      });
    } else {
      // Check if the user is registered using the isUserRegistered function
      bool isRegisteredUser = await isUserRegistered(email, password);

      if (isRegisteredUser) {
        // User is not chosen to remember credentials but is a registered user
        User user = User(
          userid: "0",
          useremail: "", //"unregistered@email.com",
          username: "", //"Unregistered",
          userphone: "",
          userpassword: "",
        );
        Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (content) => const LoginPage()),
          ),
        );
      } else {
        // User is not chosen to remember credentials and is not a registered user
        User user = User(
          userid: "0",
          useremail: "", //"unregistered@email.com",
          username: "", //"Unregistered",
          userphone: "",
          userpassword: "",
        );
        Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (content) => const WelcomePage()),
          ),
        );
      }
    }
  }
}

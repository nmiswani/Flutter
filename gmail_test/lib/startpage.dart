import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmail_test/myserverconfig.dart';

import 'package:http/http.dart' as http;

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(91, 158, 113, 0.612),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 180),

                const SizedBox(height: 40),

                // Register Button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text("Login"),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Login Button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      testGmail();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text("Register"),
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                // Clerk or Admin Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Clerk or Admin?"),
                    GestureDetector(onTap: () {}, child: Text(" Login")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void testGmail() {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/gmail_test/php/phpmailer.php"),
          body: {}, // Add required fields if needed
        )
        .then((response) {
          print("Response: ${response.body}");
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == 'success') {
              print("Gmail sent successfully.");
            } else {
              print("Gmail sending failed.");
            }
          } else {
            print("Server error: ${response.statusCode}");
          }
        })
        .catchError((error) {
          print("Error occurred: $error");
        });
  }
}

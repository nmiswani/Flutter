import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';
import 'package:pomm/models/customer.dart';
import 'package:pomm/views/startpage.dart';

class ResetPasswordPage extends StatefulWidget {
  final Customer customer;
  const ResetPasswordPage({super.key, required this.customer});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  void resetPassword() async {
    setState(() {
      isLoading = true;
    });

    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/reset_password.php"),
      body: {
        "email": widget.customer.customeremail!,
        "password": _passwordController.text,
      },
    );

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password reset failed!")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter new password:"),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "New Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : resetPassword,
              child: isLoading ? CircularProgressIndicator() : Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'loginpage.dart';
import '../models/user.dart';

class CommunityPage extends StatefulWidget {
  final User userdata;

  const CommunityPage({super.key, required this.userdata});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            _navigateToLogin(); // Navigate back to LoginPage
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        title: const Row(
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Community Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // Function to navigate to the login page
  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}

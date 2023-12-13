import 'package:flutter/material.dart';
import 'loginpage.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
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
          'Book Page',
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

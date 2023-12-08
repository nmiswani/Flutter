import 'package:bookbytes/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyApp()), // Import the LoginPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/icon.png', scale: 2.5),
            const SizedBox(height: 20),
            const Text(
              "BookBytes Forever",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(),
            const SizedBox(height: 200),
            const Text(
              "Version 0.1",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gmail_test/startpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: StartPage());
  }
}

import 'package:bookbytes/views/splashpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookBytes',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const SplashPage(),
    );
  }
}

import 'package:pomm/views/startpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POMM App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const StartPage(),
    );
  }
}

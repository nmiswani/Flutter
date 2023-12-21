import 'package:bookbytes/models/user.dart';
import 'package:flutter/material.dart';

class AddToCartPage extends StatelessWidget {
  const AddToCartPage({Key? key, required User userdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookByte',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}

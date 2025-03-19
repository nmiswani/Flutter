import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';

class OrderPage extends StatefulWidget {
  final Customer customer;
  const OrderPage({super.key, required this.customer});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<Widget> tabchildren;
  String maintitle = "Order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0,
        title: Text(
          "Cart",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

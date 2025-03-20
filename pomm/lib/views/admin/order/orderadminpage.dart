import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';

class OrderAdminPage extends StatefulWidget {
  final Admin admin;
  const OrderAdminPage({super.key, required this.admin});

  @override
  State<OrderAdminPage> createState() => _OrderAdminPageState();
}

class _OrderAdminPageState extends State<OrderAdminPage> {
  late List<Widget> tabchildren;
  String maintitle = "Order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0,
        title: Text(
          "Order",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/views/admin/order/adminorderpage.dart';
import 'package:pomm/views/admin/product/productadminpage.dart';
import 'package:pomm/views/admin/salesreport/reportpage.dart';

class AdminDashboardPage extends StatefulWidget {
  final Admin admin;
  const AdminDashboardPage({super.key, required this.admin});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Admin";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      ProductAdminPage(admin: widget.admin),
      AdminOrderPage(admin: widget.admin),
      ReportPage(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Product"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Sales Report",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Product";
      }
      if (_currentIndex == 1) {
        maintitle = "Order";
      }
      if (_currentIndex == 2) {
        maintitle = "Sales Report";
      }
    });
  }
}

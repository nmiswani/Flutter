import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/views/customer/order/orderpage.dart';
import 'package:pomm/views/customer/product/productpage.dart';
import 'package:pomm/views/customer/profile/profilepage.dart';

class CustomerProfileDashboardPage extends StatefulWidget {
  final Customer customerdata;
  const CustomerProfileDashboardPage({super.key, required this.customerdata});

  @override
  State<CustomerProfileDashboardPage> createState() =>
      _CustomerProfileDashboardPageState();
}

class _CustomerProfileDashboardPageState
    extends State<CustomerProfileDashboardPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 2;
  String maintitle = "Customer";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      ProductPage(customerdata: widget.customerdata),
      OrderPage(customerdata: widget.customerdata),
      ProfilePage(customerdata: widget.customerdata),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
        maintitle = "Profile";
      }
    });
  }
}

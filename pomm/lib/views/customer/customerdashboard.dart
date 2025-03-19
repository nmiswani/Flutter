import 'package:flutter/material.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/views/customer/orderpage.dart';
import 'package:pomm/views/customer/productpage.dart';
import 'package:pomm/views/customer/profilepage.dart';

class CustomerDashboardPage extends StatefulWidget {
  final Customer customerdata;
  const CustomerDashboardPage({super.key, required this.customerdata});

  @override
  State<CustomerDashboardPage> createState() => _CustomerDashboardPageState();
}

class _CustomerDashboardPageState extends State<CustomerDashboardPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      ProductPage(customerdata: widget.customerdata),
      OrderPage(customer: widget.customerdata),
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
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
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

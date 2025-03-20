import 'package:flutter/material.dart';
import 'package:pomm/views/customer/order/orderdetailpage.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _selectedIndex = 0; // 0: Current, 1: Completed, 2: Canceled
  String searchQuery = "";
  late List<Widget> tabchildren;
  String maintitle = "Order";

  List<Map<String, String>> currentOrders = [
    {"orderId": "ORD123", "date": "21 Mar 2025", "status": "Processing"},
    {"orderId": "ORD124", "date": "22 Mar 2025", "status": "Packing"},
  ];

  List<Map<String, String>> completedOrders = [
    {"orderId": "ORD100", "date": "15 Mar 2025", "status": "Delivered"},
  ];

  List<Map<String, String>> canceledOrders = [
    {"orderId": "ORD099", "date": "14 Mar 2025", "status": "Canceled by Admin"},
  ];

  // Function to get the orders list based on selected tab
  List<Map<String, String>> getFilteredOrders() {
    List<Map<String, String>> orders =
        _selectedIndex == 0
            ? currentOrders
            : _selectedIndex == 1
            ? completedOrders
            : canceledOrders;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      orders =
          orders
              .where(
                (order) => order["orderId"]!.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("Store Name", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),

            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search order ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Tab Buttons (Current, Completed, Canceled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabButton("Current", 0),
                _tabButton("Completed", 1),
                _tabButton("Canceled", 2),
              ],
            ),
            const SizedBox(height: 10),

            // Display Filtered Order List
            Expanded(child: _buildOrderList()),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
          searchQuery = ""; // Clear search when switching tabs
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == index ? Colors.black : Colors.white,
        foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
      ),
      child: Text(title),
    );
  }

  Widget _buildOrderList() {
    List<Map<String, String>> orders = getFilteredOrders();

    if (orders.isEmpty) {
      return const Center(child: Text("No orders available"));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.receipt_long, size: 40),
            title: Text("Order ID: ${orders[index]['orderId']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order Date: ${orders[index]['date']}"),
                Text("Status: ${orders[index]['status']}"),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => OrderDetailPage(orderDetails: orders[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

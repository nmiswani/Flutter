import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/order/adminorderdetailpage.dart';
import 'package:pomm/views/admin/order/canceldetailadminpage.dart';
import 'package:pomm/views/loginclerkadminpage.dart';

class AdminOrderPage extends StatefulWidget {
  final Admin admin;
  const AdminOrderPage({super.key, required this.admin});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  List<Order> orderList = <Order>[];
  List<Order> newOrders = [];
  List<Order> currentOrders = [];
  List<Order> completedOrders = [];
  List<Order> canceledOrders = [];
  int _selectedIndex = 0;
  late double screenWidth, screenHeight;
  int axiscount = 2;
  String id = "";
  String orderTracking = "";
  late List<Widget> tabchildren;
  String maintitle = "Order";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders(orderTracking);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 500) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Adjust the height as needed
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 55, 97, 70),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 55, 97, 70),
          elevation: 0.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Admin's Dashboard",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Utara Gadget Solution Store, UUM",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              elevation: 1.5,
              shadowColor: Colors.black87,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    orderTracking = value;
                  });
                  loadOrders(value); // search function
                },
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: 'Search order tracking...',
                  hintStyle: GoogleFonts.poppins(color: Colors.black45),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 227, 227, 227),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // horizontal scrolling
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  _tabButton("New", 0),
                  const SizedBox(width: 10),
                  _tabButton("Current", 1),
                  const SizedBox(width: 10),
                  _tabButton("Completed", 2),
                  const SizedBox(width: 10),
                  _tabButton("Canceled", 3),
                ],
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                loadOrders(orderTracking);
              },
              child:
                  getFilteredOrders().isEmpty
                      ? const Center(child: Text("No Order"))
                      : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: getFilteredOrders().length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 5.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            color: const Color.fromARGB(248, 202, 229, 206),
                            child: InkWell(
                              onTap: () async {
                                Order order = Order.fromJson(
                                  getFilteredOrders()[index].toJson(),
                                );
                                Cart cart = Cart.fromJson(
                                  getFilteredOrders()[index].toJson(),
                                );

                                if (order.orderStatus == "Canceled" ||
                                    order.orderStatus == "Request to cancel") {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (content) => CancelDetailAdminPage(
                                            order: order,
                                            admin: widget.admin,
                                            cart: cart,
                                          ),
                                    ),
                                  );
                                } else {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (content) => AdminOrderDetailPage(
                                            order: order,
                                            cart: cart,
                                            admin: widget.admin,
                                          ),
                                    ),
                                  );
                                }
                                loadOrders(orderTracking);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      truncateString(
                                        "Order Tracking : ${getFilteredOrders()[index].orderTracking ?? "No Tracking"}",
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Date : ${formatDate(getFilteredOrders()[index].orderDate)}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Status : ${getFilteredOrders()[index].orderStatus ?? "No Status"}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginClerkAdminPage()),
      (route) => false, // Removes all previous pages from the stack
    );
  }

  String truncateString(String str) {
    if (str.length > 100) {
      str = str.substring(0, 100);
      return "$str...";
    } else {
      return str;
    }
  }

  // Function to format date
  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "No Date";
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat("dd/MM/yyyy").format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget _tabButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // removes the rounded corners
        ),
        backgroundColor:
            _selectedIndex == index
                ? const Color.fromARGB(255, 55, 97, 70)
                : Colors.white,
        foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
      ),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 14)),
    );
  }

  List<Order> getFilteredOrders() {
    return _selectedIndex == 0
        ? newOrders
        : _selectedIndex == 1
        ? currentOrders
        : _selectedIndex == 2
        ? completedOrders
        : canceledOrders;
  }

  void loadOrders(String orderTracking) {
    http
        .get(
          Uri.parse(
            "${MyServerConfig.server}/pomm/php/load_order_clerkadmin.php?orderTracking=$orderTracking",
          ),
        )
        .then((response) {
          log(response.body);

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);

            if (data['status'] == "success" && data['data'] != null) {
              List<dynamic> ordersJson = data['data']['orders'];

              if (ordersJson.isNotEmpty) {
                // Clear all lists before loading new data
                orderList.clear();
                newOrders.clear();
                currentOrders.clear();
                completedOrders.clear();
                canceledOrders.clear();

                Map<String, Order> uniqueOrderMap = {};

                for (var json in ordersJson) {
                  Order order = Order.fromJson(json);
                  if (order.orderId != null &&
                      !uniqueOrderMap.containsKey(order.orderId)) {
                    uniqueOrderMap[order.orderId!] = order;
                  }
                }

                // Assign unique orders to the list
                orderList = uniqueOrderMap.values.toList();

                // Categorize orders
                for (var order in orderList) {
                  switch (order.orderStatus) {
                    case "Order placed":
                      newOrders.add(order);
                      break;
                    case "In process":
                    case "Out for delivery":
                    case "Ready for pickup":
                    case "Request to cancel":
                      currentOrders.add(order);
                      break;
                    case "Received":
                    case "Delivered":
                      completedOrders.add(order);
                      break;
                    case "Canceled":
                      canceledOrders.add(order);
                      break;
                  }
                }
              }
            }
          }

          log("Loaded ${orderList.length} unique orders");
          setState(() {});
        })
        .catchError((error) {
          print("Error loading orders: $error");
        });
  }
}

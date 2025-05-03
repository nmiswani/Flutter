import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/clerk.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/clerk/order/clerkcanceldetailpage.dart';
import 'package:pomm/views/clerk/order/clerkorderdetailpage.dart';
import 'package:pomm/views/loginclerkadminpage.dart';

class OrderClerkPage extends StatefulWidget {
  final Clerk clerk;
  const OrderClerkPage({super.key, required this.clerk});

  @override
  State<OrderClerkPage> createState() => _OrderClerkPageState();
}

class _OrderClerkPageState extends State<OrderClerkPage> {
  List<Order> orderList = <Order>[];
  List<Order> newOrders = [];
  List<Order> currentOrders = [];
  List<Order> completedOrders = [];
  List<Order> canceledOrders = [];
  List<Order> cancelRequestOrders = [];
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
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Clerk Dashboard",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2.5),
                Text(
                  "Utara Gadget Solution Store",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 18, right: 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (content) => LoginClerkAdminPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      orderTracking = value;
                    });
                    loadOrders(value);
                  },
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    hintText: 'Search order tracking',
                    hintStyle: GoogleFonts.inter(color: Colors.black45),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                    _tabButton("Cancel Request", 3),
                    const SizedBox(width: 10),
                    _tabButton("Canceled", 4),
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
                        ? Center(
                          child: Text(
                            "Please wait... or no orders found.",
                            style: GoogleFonts.inter(),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: getFilteredOrders().length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 1.5,
                              margin: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: _getCardColor(
                                getFilteredOrders()[index].orderStatus,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  Order order = Order.fromJson(
                                    getFilteredOrders()[index].toJson(),
                                  );
                                  Cart cart = Cart.fromJson(
                                    getFilteredOrders()[index].toJson(),
                                  );

                                  if (order.orderStatus == "Canceled" ||
                                      order.orderStatus ==
                                          "Request to cancel") {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (content) => CancelDetailClerkPage(
                                              order: order,
                                              clerk: widget.clerk,
                                              cart: cart,
                                            ),
                                      ),
                                    );
                                  } else {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (content) => ClerkOrderDetailPage(
                                              order: order,
                                              cart: cart,
                                              clerk: widget.clerk,
                                            ),
                                      ),
                                    );
                                  }
                                  loadOrders(orderTracking);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        truncateString(
                                          "Order Tracking: ${getFilteredOrders()[index].orderTracking ?? "No Tracking"}",
                                        ),
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Created Date: ${formatDate(getFilteredOrders()[index].orderDate)}",
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Status: ${getFilteredOrders()[index].orderStatus ?? "No Status"}",
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
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
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: _selectedIndex == index ? Colors.black : Colors.white,
        foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
      ),
      child: Text(title, style: GoogleFonts.inter()),
    );
  }

  List<Order> getFilteredOrders() {
    return _selectedIndex == 0
        ? newOrders
        : _selectedIndex == 1
        ? currentOrders
        : _selectedIndex == 2
        ? completedOrders
        : _selectedIndex == 3
        ? cancelRequestOrders
        : canceledOrders;
  }

  Color _getCardColor(String? status) {
    switch (status) {
      case "Order placed":
        return Colors.purple.shade100;
      case "In process":
        return Colors.blue.shade200;
      case "Out for delivery":
      case "Ready for pickup":
        return Colors.brown.shade200;
      case "Delivered":
      case "Picked up":
        return Colors.green.shade200;
      case "Request to cancel":
        return Colors.orange.shade200;
      case "Canceled":
        return Colors.red.shade200;
      default:
        return Colors.white;
    }
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
                // Clear all lists first
                newOrders.clear();
                orderList.clear();
                currentOrders.clear();
                completedOrders.clear();
                cancelRequestOrders.clear();
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
                      currentOrders.add(order);
                      break;
                    case "Picked up":
                    case "Delivered":
                      completedOrders.add(order);
                      break;
                    case "Request to cancel":
                      cancelRequestOrders.add(order);
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

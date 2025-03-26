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
import 'package:pomm/views/clerk/order/canceldetailpage.dart';
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
  late List<Widget> tabchildren;
  String maintitle = "Order";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders(id);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    axiscount = screenWidth > 500 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 55, 97, 70)),
        title: Text(
          "Order",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      body: Column(
        children: [
          // ✅ First Row: New, Current, Completed
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _tabButton("New", 0),
              _tabButton("Current", 1),
              _tabButton("Completed", 2),
            ],
          ),
          const SizedBox(height: 10),
          // ✅ Second Row: Cancel Request, Canceled
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _tabButton("Cancel Request", 3),
              _tabButton("Canceled", 4),
            ],
          ),
          const SizedBox(height: 10),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                loadOrders(id);
              },
              child:
                  getFilteredOrders().isEmpty
                      ? const Center(child: Text("No Order"))
                      : GridView.count(
                        crossAxisCount: axiscount,
                        childAspectRatio: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        padding: const EdgeInsets.all(10),
                        children: List.generate(getFilteredOrders().length, (
                          index,
                        ) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            color: const Color.fromARGB(248, 214, 227, 216),
                            child: InkWell(
                              onTap: () async {
                                // Get the correct order based on the filtered list
                                Order order = Order.fromJson(
                                  getFilteredOrders()[index].toJson(),
                                );
                                Cart cart = Cart.fromJson(
                                  getFilteredOrders()[index].toJson(),
                                );

                                if (order.orderStatus == "Canceled") {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (content) => CancelDetailPage(
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
                                loadOrders(id);
                              },

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            "Order Tracking : ${getFilteredOrders()[index].orderTracking ?? "No Tracking"}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
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
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
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
    if (str.length > 20) {
      str = str.substring(0, 20);
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
        backgroundColor: _selectedIndex == index ? Colors.black : Colors.white,
        foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
      ),
      child: Text(title),
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

  void loadOrders(String id) {
    http
        .get(
          Uri.parse(
            "${MyServerConfig.server}/pomm/php/load_order_clerkadmin.php?id=$id",
          ),
        )
        .then((response) {
          log(response.body);

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);

            if (data['status'] == "success" && data['data'] != null) {
              List<dynamic> ordersJson = data['data']['orders'];

              if (ordersJson.isNotEmpty) {
                orderList.clear();
                orderList =
                    ordersJson.map((json) => Order.fromJson(json)).toList();

                newOrders.clear();
                currentOrders.clear();
                completedOrders.clear();
                canceledOrders.clear();
                cancelRequestOrders.clear();

                for (var order in orderList) {
                  if (order.orderStatus == "Order placed") {
                    newOrders.add(order);
                  } else if (order.orderStatus == "In process" ||
                      order.orderStatus == "Out for delivery" ||
                      order.orderStatus == "Ready for pickup") {
                    currentOrders.add(order);
                  } else if (order.orderStatus == "Received" ||
                      order.orderStatus == "Delivered") {
                    completedOrders.add(order);
                  } else if (order.orderStatus == "Request to cancel") {
                    cancelRequestOrders.add(order);
                  } else if (order.orderStatus == "Canceled") {
                    canceledOrders.add(order);
                  }
                }
              }
            }
          }
          log("Loaded ${orderList.length} orders");
          setState(() {});
        })
        .catchError((error) {
          print("Error loading orders: $error");
        });
  }
}

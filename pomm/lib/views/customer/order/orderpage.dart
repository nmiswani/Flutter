import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/order/canceldetailcustomerpage.dart';
import 'package:pomm/views/customer/order/orderdetailpage.dart';

class OrderPage extends StatefulWidget {
  final Customer customerdata;
  const OrderPage({super.key, required this.customerdata});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> orderList = <Order>[];
  List<Order> currentOrders = [];
  List<Order> completedOrders = [];
  List<Order> canceledOrders = [];
  int _selectedIndex = 0;
  late double screenWidth, screenHeight;
  int axiscount = 2;
  String customerid = "";
  late List<Widget> tabchildren;
  String maintitle = "Order";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders(customerid);
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 55, 97, 70)),
        title: Text(
          "Order",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _tabButton("Current", 0),
              _tabButton("Completed", 1),
              _tabButton("Canceled", 2),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                loadOrders(customerid);
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
                            color:
                                _selectedIndex == 0
                                    ? _getCardColor(
                                      getFilteredOrders()[index].orderStatus,
                                    )
                                    : const Color.fromARGB(
                                      248,
                                      214,
                                      227,
                                      216,
                                    ), // default color for other tabs
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
                                          (content) => CancelDetailCustomerPage(
                                            order: order,
                                            customer: widget.customerdata,
                                            cart: cart,
                                          ),
                                    ),
                                  );
                                } else {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (content) => OrderDetailPage(
                                            customerdata: widget.customerdata,
                                            order: order,
                                            cart: cart,
                                          ),
                                    ),
                                  );
                                }
                                loadOrders(customerid);
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
        ? currentOrders
        : _selectedIndex == 1
        ? completedOrders
        : canceledOrders;
  }

  Color _getCardColor(String? status) {
    switch (status) {
      case "Order placed":
        return Colors.pink.shade100;
      case "In process":
        return Colors.orange.shade100;
      case "Out for delivery":
        return Colors.green.shade100;
      case "Request to cancel":
        return Colors.red.shade100;
      default:
        return const Color.fromARGB(248, 214, 227, 216); // default fallback
    }
  }

  void loadOrders(String customerid) async {
    try {
      String customerid = widget.customerdata.customerid.toString();
      final response = await http.get(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_order_customer.php?customerid=$customerid",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success" && data['data'] != null) {
          List<dynamic> ordersJson = data['data']['orders'];

          if (ordersJson.isNotEmpty) {
            // Clear all lists first
            orderList.clear();
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

            // Convert map values to list
            orderList = uniqueOrderMap.values.toList();

            // Sort into respective categories
            for (var order in orderList) {
              if (order.orderStatus == "Order placed" ||
                  order.orderStatus == "In process" ||
                  order.orderStatus == "Out for delivery" ||
                  order.orderStatus == "Ready for pickup" ||
                  order.orderStatus == "Request to cancel") {
                currentOrders.add(order);
              } else if (order.orderStatus == "Received" ||
                  order.orderStatus == "Delivered") {
                completedOrders.add(order);
              } else if (order.orderStatus == "Canceled") {
                canceledOrders.add(order);
              }
            }
          }
        }
      }
      log("Loaded ${orderList.length} unique orders");
      setState(() {});
    } catch (error) {
      print("Error loading orders: $error");
    }
  }
}

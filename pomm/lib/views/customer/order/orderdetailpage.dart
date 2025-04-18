import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/order/orderstatuspage.dart';

class OrderDetailPage extends StatefulWidget {
  final Customer customerdata;
  final Order order;
  final Cart cart;

  const OrderDetailPage({
    super.key,
    required this.order,
    required this.customerdata,
    required this.cart,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<dynamic> orderItems = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_orderdetails_customer.php",
        ),
        body: {'order_id': widget.order.orderId},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          setState(() {
            orderItems = data['products']; // <- change this line
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(child: Text("Failed to load order details"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Info
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (content) => OrderStatusPage(
                                  customerdata: widget.customerdata,
                                  order: widget.order,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shipping Information",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Tracking number: ${widget.order.orderTracking}",
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Order Items
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Details",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orderItems.length,
                              itemBuilder: (context, index) {
                                var item = orderItems[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${MyServerConfig.server}/pomm/assets/products/${item['product_id']}.jpg",
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (
                                                context,
                                                url,
                                                error,
                                              ) => Image.asset(
                                                "assets/images/default_product.jpg",
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Product: ${item['product_title']}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            "Quantity: ${item['cart_qty']}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Order ID: ${widget.order.orderId}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            Text(
                              "Subtotal: RM${widget.order.orderSubtotal}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            Text(
                              "Delivery Charge: RM${widget.order.deliveryCharge}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            Text(
                              "Total: RM${widget.order.orderTotal}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
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
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/clerk.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/clerk/order/orderstatusclerkpage.dart';

class ClerkOrderDetailPage extends StatefulWidget {
  final Clerk clerk;
  final Order order;
  final Cart cart;

  const ClerkOrderDetailPage({
    super.key,
    required this.order,
    required this.cart,
    required this.clerk,
  });

  @override
  State<ClerkOrderDetailPage> createState() => _ClerkOrderDetailPageState();
}

class _ClerkOrderDetailPageState extends State<ClerkOrderDetailPage> {
  String? imageUrl;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchProductImage();
  }

  Future<void> fetchProductImage() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_image_order.php?order_id=${widget.order.orderId}",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success" && data['image_url'] != null) {
          setState(() {
            imageUrl = data['image_url'];
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
    } catch (error) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Information (Navigates to OrderStatusPage)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (content) => OrderStatusClerkPage(
                          clerk: widget.clerk,
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

            // Customer Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Information",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Name: ${widget.order.customerName}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Phone: ${widget.order.customerPhone}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Email: ${widget.order.customerEmail}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            // Order Details
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
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Placeholder color
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                              isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  ) // ✅ Show loading indicator
                                  : hasError || imageUrl == null
                                  ? Image.asset(
                                    "assets/images/default_product.jpg", // ✅ Default image for errors
                                    fit: BoxFit.cover,
                                  )
                                  : CachedNetworkImage(
                                    imageUrl: imageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Image.asset(
                                          "assets/images/default_product.jpg",
                                        ),
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Name: ${widget.order.productTitle}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),

                            Text(
                              "Quantity: ${widget.order.cartQty}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Order ID: ${widget.order.orderId}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    // Text(
                    //   "Cart ID: ${widget.order.cartId}",
                    //   style: GoogleFonts.poppins(fontSize: 12),
                    // ),
                    Text(
                      "Subtotal: RM${widget.order.orderSubtotal}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Delivery Charge: RM${widget.order.deliveryCharge}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Total: RM ${widget.order.orderTotal}",
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

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';

class CancelDetailCustomerPage extends StatefulWidget {
  final Customer customer;
  final Order order;
  final Cart cart;

  const CancelDetailCustomerPage({
    super.key,
    required this.order,
    required this.cart,
    required this.customer,
  });

  @override
  State<CancelDetailCustomerPage> createState() =>
      _CancelDetailCustomerPageState();
}

class _CancelDetailCustomerPageState extends State<CancelDetailCustomerPage> {
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //"Canceled",
                          "${widget.order.orderStatus}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "Tracking number: ${widget.order.orderTracking}",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
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

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/clerk.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/clerk/order/clerkorderpage.dart';

class PendingOrderPage extends StatefulWidget {
  final Clerk clerk;
  final Order order;
  const PendingOrderPage({super.key, required this.clerk, required this.order});

  @override
  State<PendingOrderPage> createState() => _PendingOrderPageState();
}

class _PendingOrderPageState extends State<PendingOrderPage> {
  List<Order> orderList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Pending Order",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer Information",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Name: ${widget.order.customerName ?? "Unknown"}",
                    style: GoogleFonts.poppins(),
                  ),
                  Text(
                    "Phone number: ${widget.order.customerPhone ?? "-"}",
                    style: GoogleFonts.poppins(),
                  ),
                  Text("Shipping address: ", style: GoogleFonts.poppins()),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Order Details Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Details",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300], // Placeholder for image
                        child: Center(child: Icon(Icons.image, size: 30)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order.productTitle ?? "No Product",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.order.productDesc ?? "-",
                            style: GoogleFonts.poppins(),
                          ),
                          Text(
                            "Quantity: ${widget.order.cartQty ?? 1}",
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order ID", style: GoogleFonts.poppins()),
                      Text(
                        widget.order.orderId?.toString() ?? "No ID",
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.order.orderTotal ?? "RM 0.00",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing for delivery...")),
                  );
                },
                icon: const Icon(Icons.local_shipping, color: Colors.black),
                label: Text(
                  "Process for delivery",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing for pickup...")),
                  );
                },
                icon: const Icon(Icons.store, color: Colors.black),
                label: Text(
                  "Process for pickup",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void processDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           "Process Order",
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         content: const Text("Are you sure?"),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Yes", style: TextStyle()),
  //             onPressed: () {
  //               Navigator.of(context).pop();

  //               final productQty = widget.product.productQty;
  //               final qtyInt =
  //                   productQty != null ? int.tryParse(productQty) : null;

  //               if (qtyInt != null && qtyInt > 0) {
  //                 insertCart();
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text("Process order failed"),
  //                     backgroundColor: Colors.red,
  //                   ),
  //                 );
  //               }
  //             },
  //           ),
  //           TextButton(
  //             child: const Text("No"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void processOrder() {
  //   http
  //       .post(
  //         Uri.parse("${MyServerConfig.server}/pomm/php/update_order.php"),
  //         body: {
  //           "customer_id": widget.customerdata.customerid.toString(),
  //           "product_id": widget.product.productId.toString(),
  //           "product_price": widget.product.productPrice.toString(),
  //         },
  //       )
  //       .then((response) {
  //         log(response.body);
  //         if (response.statusCode == 200) {
  //           var data = jsonDecode(response.body);
  //           if (data['status'] == "success") {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text("Successful"),
  //                 backgroundColor: Colors.green,
  //               ),
  //             );
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (content) => OrderClerkPage(clerk: widget.clerk),
  //               ),
  //             );
  //           } else {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text("Failed to process"),
  //                 backgroundColor: Colors.red,
  //               ),
  //             );
  //           }
  //         }
  //       });
  // }
}

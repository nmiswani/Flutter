import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/clerk.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';

class OrderStatusPickupPage extends StatefulWidget {
  final Clerk clerk;
  final Order order;

  const OrderStatusPickupPage({
    super.key,
    required this.clerk,
    required this.order,
  });

  @override
  State<OrderStatusPickupPage> createState() => _OrderStatusClerkPageState();
}

class _OrderStatusClerkPageState extends State<OrderStatusPickupPage> {
  String currentStatus = "Order placed"; // Default order status

  // Retrieve tracking number and shipping address from order
  late String trackingNumber;
  late String shippingAddress;

  // List of order statuses with icons
  final List<Map<String, dynamic>> statusOptions = [
    {"status": "Order placed", "icon": Icons.shopping_cart},
    {"status": "In process", "icon": Icons.autorenew},
    {"status": "Order dispatched", "icon": Icons.local_shipping},
    {"status": "Delivered", "icon": Icons.check_circle},
    {"status": "Ready for pickup", "icon": Icons.storefront},
  ];

  Future<void> updateOrderStatus(String newStatus) async {
    setState(() {
      currentStatus = newStatus;
    });

    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/update_order_status.php"),
        body: {
          "order_id": widget.order.orderId, // Ensure correct order ID is sent
          "status": newStatus,
        },
      );

      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order status updated to: $newStatus")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed: ${data['message']}")));
      }
    } catch (error) {
      print("Error updating order status: $error");
    }
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Update Order Status",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                statusOptions.map((status) {
                  return ListTile(
                    leading: Icon(status["icon"], color: Colors.blue),
                    title: Text(
                      status["status"],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the first dialog
                      showConfirmUpdateDialog(
                        status["status"],
                      ); // Show confirmation
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  // ✅ Confirm Update Dialog
  void showConfirmUpdateDialog(String selectedStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Update",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to update the order status to '$selectedStatus'?",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ❌ Cancel
              child: Text(
                "No",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog
                updateOrderStatus(selectedStatus); // ✅ Update order
              },
              child: Text(
                "Yes",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    trackingNumber = widget.order.orderTracking ?? "No Tracking";
    shippingAddress = widget.order.shippingAddress ?? "No Address Provided";
  }

  Color getStatusColor(String status) {
    return (status == currentStatus) ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Status",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📦 Shipping Details Card (Newly Added)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📦 Shipping Information",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tracking Number: $trackingNumber",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Shipping Address:",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shippingAddress,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📌 Order Tracking Timeline
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children:
                    statusOptions.map((status) {
                      return ListTile(
                        leading: Icon(
                          status["icon"],
                          color: getStatusColor(status["status"]),
                        ),
                        title: Text(
                          status["status"],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(status["status"]),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // 🔄 Update Order Status Button
            Center(
              child: ElevatedButton(
                onPressed: showUpdateDialog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  "Update Order Status",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

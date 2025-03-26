import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';

class OrderStatusPage extends StatefulWidget {
  final Customer customerdata;
  final Order order;

  const OrderStatusPage({
    super.key,
    required this.order,
    required this.customerdata,
  });

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  late String currentStatus;
  late String trackingNumber;
  late String shippingAddress;
  String newStatus = "Request to cancel";

  // ✅ Status options with icons
  final List<Map<String, dynamic>> statusOptions = [
    {"status": "Order placed", "icon": Icons.shopping_cart},
    {"status": "In process", "icon": Icons.autorenew},
    {"status": "Out for delivery", "icon": Icons.local_shipping},
    {"status": "Delivered", "icon": Icons.check_circle},
    {"status": "Ready for pickup", "icon": Icons.storefront},
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Set currentStatus correctly from the order object
    setState(() {
      currentStatus = widget.order.orderStatus ?? "Order placed";
    });

    trackingNumber = widget.order.orderTracking ?? "No Tracking";
    shippingAddress = widget.order.shippingAddress ?? "No Address Provided";
  }

  Color getStatusColor(String status) {
    return (status == currentStatus) ? Colors.blue : Colors.grey.shade400;
  }

  // ✅ Function to cancel order status
  Future<void> cancelOrderStatus(String newStatus) async {
    setState(() {
      currentStatus = newStatus;
    });

    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/update_order_status.php"),
        body: {
          "order_id": widget.order.orderId, // ✅ Ensure correct order ID
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

  // ✅ Show cancel dialog
  void showCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Cancel Order",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure to cancel the order?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle()),
              onPressed: () {
                cancelOrderStatus(newStatus);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            // 📦 Shipping Details Card
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

            // 🔄 Cancel Order Button
            Center(
              child: ElevatedButton(
                onPressed:
                    currentStatus == "Order placed"
                        ? showCancelDialog
                        : null, // Disable if not "Order placed"
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  "Cancel Order",
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/order.dart';

class OrderStatusAdminPage extends StatefulWidget {
  final Admin admin;
  final Order order;

  const OrderStatusAdminPage({
    super.key,
    required this.admin,
    required this.order,
  });

  @override
  State<OrderStatusAdminPage> createState() => _OrderStatusAdminPageState();
}

class _OrderStatusAdminPageState extends State<OrderStatusAdminPage> {
  late String currentStatus;

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
          ],
        ),
      ),
    );
  }
}

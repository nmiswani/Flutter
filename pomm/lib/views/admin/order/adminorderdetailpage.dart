import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/views/admin/order/orderstatusadminpage.dart';

class AdminOrderDetailPage extends StatefulWidget {
  final Admin admin;
  final Order order;
  final Cart cart;

  const AdminOrderDetailPage({
    super.key,
    required this.order,
    required this.admin,
    required this.cart,
  });

  @override
  State<AdminOrderDetailPage> createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
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
                        (content) => OrderStatusAdminPage(
                          admin: widget.admin,
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
                          color: Colors.grey[300], // Placeholder for image
                          child: const Center(
                            child: Icon(Icons.image, size: 30),
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

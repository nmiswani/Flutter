import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/views/clerk/order/orderstatuspage.dart';

class OrderDetailPage extends StatelessWidget {
  final Customer customerdata;
  final Order order;
  final Product product;

  const OrderDetailPage({
    super.key,
    required this.order,
    required this.customerdata,
    required this.product,
  });

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
                        (content) =>
                            OrderStatusPage(customerdata: customerdata),
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
                            order.orderTracking ?? "No Tracking",
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
                      "Name: ${order.customerName}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Phone: ${order.customerPhone}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Shipping Address: ${order.shippingAddress}",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Name: ${order.productTitle}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            Text(
                              "Description: ${order.productDesc}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            Text(
                              "Quantity: ${order.productQty}",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Order ID: ${order.orderId}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Subtotal: RM${order.orderSubtotal}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Delivery Charge: RM${order.deliveryCharge}",
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    Text(
                      "Total: RM ${order.orderTotal}",
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

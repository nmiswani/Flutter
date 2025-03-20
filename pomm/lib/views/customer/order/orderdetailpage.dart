import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> orderDetails;

  const OrderDetailPage({super.key, required this.orderDetails});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Information Section
            Card(
              elevation: 2,
              child: ListTile(
                title: const Text("Shipping Information"),
                subtitle: Text(
                  "Tracking number: ${widget.orderDetails['trackingNumber']}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TrackingPage(
                            trackingNumber:
                                widget.orderDetails['trackingNumber'],
                          ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Order Details Section
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          widget.orderDetails['imageUrl'] != null
                              ? Image.network(
                                widget.orderDetails['imageUrl'],
                                fit: BoxFit.cover,
                              )
                              : const Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                    ),

                    const SizedBox(width: 12),

                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.orderDetails['productName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.orderDetails['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Quantity: ${widget.orderDetails['quantity']}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Order Summary
            _buildOrderSummary("Order ID", widget.orderDetails['orderId']),
            _buildOrderSummary(
              "Subtotal",
              "RM ${widget.orderDetails['subtotal']}",
            ),
            _buildOrderSummary(
              "Delivery Charge",
              "RM ${widget.orderDetails['deliveryCharge']}",
            ),
            _buildOrderSummary(
              "Total",
              "RM ${widget.orderDetails['total']}",
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingPage extends StatelessWidget {
  final String trackingNumber;

  const TrackingPage({super.key, required this.trackingNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking Information")),
      body: Center(
        child: Text(
          "Tracking Number: $trackingNumber",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

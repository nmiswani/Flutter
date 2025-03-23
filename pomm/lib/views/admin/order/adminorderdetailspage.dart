import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';

class AdminOrderDetailsPage extends StatefulWidget {
  final Order order;
  const AdminOrderDetailsPage({super.key, required this.order});

  @override
  State<AdminOrderDetailsPage> createState() => _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState extends State<AdminOrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pending Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Information",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text("Name: ${widget.order.customerName}"),
                    Text("Phone: ${widget.order.customerPhone}"),
                    Text("Shipping Address: UUM"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 40),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.order.productTitle}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Description: ${widget.order.productDesc}"),
                            Text("Quantity: ${widget.order.productQty}"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("Order ID: ${widget.order.orderId}"),
                    Text("Subtotal: RM${widget.order.orderTotal}"),
                    Text("Delivery Charge: RM5"),
                    Text(
                      "Total: RM${widget.order.orderTotal}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => updateOrderStatus("Out for Delivery"),
              icon: Icon(Icons.local_shipping),
              label: Text("Process for Delivery"),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => updateOrderStatus("Ready for Pickup"),
              icon: Icon(Icons.store),
              label: Text("Process for Pickup"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateOrderStatus(String status) async {
    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/update_order_status.php",
    );
    try {
      final response = await http.post(
        url,
        body: {'order_id': widget.order, 'status': status},
      );

      final result = jsonDecode(response.body);
      if (response.statusCode == 200 && result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order updated to $status successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

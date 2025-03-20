import 'package:flutter/material.dart';
import 'package:pomm/models/customer.dart';
import 'billpage.dart';

class PaymentPage extends StatefulWidget {
  final Customer customerdata;
  const PaymentPage({super.key, required this.customerdata});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final String paymentId = "PAY123456";
  final String customerName = "John Doe";
  final String customerEmail = "johndoe@example.com";
  final String customerPhone = "+60123456789";
  final double totalAmount = 49.99;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.store, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Store name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Bank details"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment ID: $paymentId"),
                    const SizedBox(height: 10),
                    const Text("Customer details:"),
                    Text("Name: $customerName"),
                    Text("Email: $customerEmail"),
                    Text("Phone number: $customerPhone"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Total: RM$totalAmount"),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to BillPage with the data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (content) =>
                              BillPage(customerdata: widget.customerdata),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Pay", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/views/customer/order/orderpage.dart';

class BillPage extends StatefulWidget {
  final Customer customerdata;

  const BillPage({super.key, required this.customerdata});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey[300], // Placeholder for receipt image
              child: const Center(
                child: Icon(Icons.receipt_long, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Receipt details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text("Payment ID: ${widget.customerdata.customername}"),
                    Text("Name: ${widget.customerdata.customername}"),
                    Text("Email: ${widget.customerdata.customeremail}"),
                    Text("Phone number: ${widget.customerdata.customerphone}"),
                    Text("Paid amount: RM${widget.customerdata.customername}"),
                    const Text("Paid status: Successful"),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (content) => OrderPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Track Order feature coming soon!"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Track Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

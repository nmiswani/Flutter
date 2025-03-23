import 'package:flutter/material.dart';
import 'package:pomm/models/customer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillPage extends StatefulWidget {
  final Customer customer;
  final double totalprice;

  const BillPage({super.key, required this.customer, required this.totalprice});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  var loadingPercentage = 0;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    print(widget.customer.customerphone);
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://wani.infinitebe.com/pomm/php/payment.php?&customerid=${widget.customer.customerid}&email=${widget.customer.customeremail}&phone=${widget.customer.customerphone}&name=${widget.customer.customername}&amount=${widget.totalprice}',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [Text("Bill", style: TextStyle(color: Colors.white))],
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(child: WebViewWidget(controller: controller)),
    );
  }
}

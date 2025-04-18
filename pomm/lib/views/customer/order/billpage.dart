import 'package:flutter/material.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillPage extends StatefulWidget {
  final Customer customer;
  final List<Cart> cartList;
  final double totalprice, orderSubtotal, deliveryCharge;
  final String shippingAddress;

  const BillPage({
    super.key,
    required this.customer,
    required this.totalprice,
    required this.shippingAddress,
    required this.orderSubtotal,
    required this.deliveryCharge,
    required this.cartList,
  });

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
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
              'https://wani.infinitebe.com/pomm/php/payment.php'
              '?customerid=${widget.customer.customerid}'
              '&email=${widget.customer.customeremail}'
              '&phone=${widget.customer.customerphone}'
              '&name=${widget.customer.customername}'
              '&amount=${widget.totalprice}'
              '&shipping=${widget.shippingAddress}'
              '&subtotal=${widget.orderSubtotal}'
              '&deliverycharge=${widget.deliveryCharge}',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Bill", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

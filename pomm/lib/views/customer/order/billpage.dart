import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/views/customer/customerdashboard.dart';
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
  bool paymentDone = false;

  @override
  void initState() {
    super.initState();
    print(widget.customer.customerphone);

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                if (url.contains('payment_update.php')) {
                  setState(() {
                    paymentDone = true;
                  });
                }
              },
            ),
          )
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
        title: Text(
          "Payment",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (paymentDone) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CustomerDashboardPage(customerdata: widget.customer),
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

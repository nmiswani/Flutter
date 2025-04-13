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

    String cartIds = widget.cartList
        .map((cart) => cart.cartId.toString())
        .join(",");
    String productIds = widget.cartList
        .map((item) => item.productId.toString())
        .join(",");

    String url =
        Uri.parse('https://wani.infinitebe.com/pomm/php/payment.php')
            .replace(
              queryParameters: {
                "customerid": widget.customer.customerid.toString(),
                "email": widget.customer.customeremail,
                "phone": widget.customer.customerphone,
                "name": widget.customer.customername,
                "amount": widget.totalprice.toStringAsFixed(2),
                "shipping": widget.shippingAddress,
                "subtotal": widget.orderSubtotal.toStringAsFixed(2),
                "deliverycharge": widget.deliveryCharge.toStringAsFixed(2),
                "cartid": cartIds,
                "productid": productIds,
              },
            )
            .toString();

    print("[BillPage] Payment URL: $url");

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                if (request.url.contains("return_url")) {
                  Navigator.pop(context, "success");
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url));
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

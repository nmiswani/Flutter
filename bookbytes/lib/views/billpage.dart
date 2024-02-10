import 'package:bookbytes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillPage extends StatefulWidget {
  final User user;
  final double totalprice;

  const BillPage({super.key, required this.user, required this.totalprice});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  var loadingPercentage = 0;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    print(widget.user.userphone);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
            'https://wani.infinitebe.com/bookbytes/php/payment.php?&userid=${widget.user.userid}&email=${widget.user.useremail}&phone=${widget.user.userphone}&name=${widget.user.username}&amount=${widget.totalprice}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              "Bill",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:bookbytes/models/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final double totalprice;

  const BillScreen({super.key, required this.user, required this.totalprice});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
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
            'https://slumberjer.com/bookbytes/php/payment.php?&userid=${widget.user.userid}&email=${widget.user.useremail}&phone=${widget.user.userphone}&name=${widget.user.username}&amount=${widget.totalprice}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}

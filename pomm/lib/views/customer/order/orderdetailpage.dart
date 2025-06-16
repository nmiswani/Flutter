import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/order/orderstatuspage.dart';
import 'package:printing/printing.dart';

class OrderDetailPage extends StatefulWidget {
  final Customer customerdata;
  final Order order;
  final Cart cart;

  const OrderDetailPage({
    super.key,
    required this.order,
    required this.customerdata,
    required this.cart,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<dynamic> orderItems = [];
  bool isLoading = true;
  bool hasError = false;
  bool isOrderDetailsExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? Center(
                child: Text(
                  "Failed to load order details",
                  style: GoogleFonts.inter(),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => OrderStatusPage(
                                  customerdata: widget.customerdata,
                                  order: widget.order,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shipping Information",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Order Tracking: ${widget.order.orderTracking}",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Details",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orderItems.length,
                              itemBuilder: (context, index) {
                                var item = orderItems[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${MyServerConfig.server}/pomm/assets/products/${item['product_id']}.jpg",
                                          width: 55,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (
                                                context,
                                                url,
                                                error,
                                              ) => Image.asset(
                                                "assets/images/default_product.jpg",
                                                width: 55,
                                                height: 55,
                                                fit: BoxFit.cover,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Product: ${item['product_title']}",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Quantity: ${item['cart_qty']}",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Price: RM${item['product_price']}",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Divider(thickness: 0.5, color: Colors.grey),
                            if (isOrderDetailsExpanded) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal:",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  Text(
                                    "RM${widget.order.orderSubtotal}",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery Charge:",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  Text(
                                    "RM${widget.order.deliveryCharge}",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 0.5, color: Colors.grey),
                            ],
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOrderDetailsExpanded =
                                        !isOrderDetailsExpanded;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Order Total: ",
                                      style: GoogleFonts.inter(fontSize: 14),
                                    ),
                                    Text(
                                      "RM${widget.order.orderTotal}",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      isOrderDetailsExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order ID",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "UGS${widget.order.orderId}",
                                  style: GoogleFonts.inter(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Created:",
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                                Text(
                                  widget.order.orderDate != null
                                      ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(widget.order.orderDate!),
                                      )
                                      : 'N/A',
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                              ],
                            ),
                            if (widget.order.orderStatus == "Delivered" ||
                                widget.order.orderStatus == "Picked up") ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Completed:",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  Text(
                                    widget.order.statusCompletedDate != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                            widget.order.statusCompletedDate!,
                                          ),
                                        )
                                        : 'N/A',
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (widget.order.orderStatus == "Delivered" ||
                        widget.order.orderStatus == "Picked up") ...[
                      GestureDetector(
                        onTap: () {
                          if (widget.order.orderId != null) {
                            printingMethod(widget.order.orderId!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Order ID is missing",
                                  style: GoogleFonts.inter(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order Receipt",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Receipt for #UGS${widget.order.orderId}",
                                      style: GoogleFonts.inter(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Future<void> fetchOrderDetails() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_orderdetails_clerkadmin.php",
        ),
        body: {'order_id': widget.order.orderId},
      );
      // print('statusCompletedDate: ${widget.order.statusCompletedDate}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(response.body);
        if (data['status'] == "success") {
          setState(() {
            orderItems = data['products'];
            print("TEST");
            // fix kat bawah ni
            widget.order.statusInProcessDate = data['status_inprocess_date'];
            widget.order.statusDeliveryPickupDate =
                data['status_deliverypickup_date'];
            widget.order.statusCompletedDate = data['status_completed_date'];
            widget.order.statusCanceledDate = data['status_canceled_date'];
            print(data['status_completed_date']);
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> printingMethod(String orderId) async {
    final generateDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/print_order_receipt.php?generateDate=$generateDate",
    );

    try {
      final response = await http.post(url, body: {'order_id': orderId});

      if (response.statusCode == 200) {
        final htmlData = response.body;

        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async {
            return await Printing.convertHtml(format: format, html: htmlData);
          },
        );
      } else {
        print("Failed to load receipt. Status Code: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Unable to load the receipt. Please try again later",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error loading receipt: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Network or server issue. Please check your connection",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

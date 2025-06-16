import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/clerk.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/clerk/order/clerkorderpage.dart';

class CancelDetailClerkPage extends StatefulWidget {
  final Clerk clerk;
  final Order order;
  final Cart cart;

  const CancelDetailClerkPage({
    super.key,
    required this.order,
    required this.cart,
    required this.clerk,
  });

  @override
  State<CancelDetailClerkPage> createState() => _CancelDetailClerkPageState();
}

class _CancelDetailClerkPageState extends State<CancelDetailClerkPage> {
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
                    Card(
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
                                  "${widget.order.orderStatus}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "Order Tracking: ${widget.order.orderTracking}",
                                  style: GoogleFonts.inter(fontSize: 12),
                                ),
                              ],
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Customer Information",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Name: ${widget.order.customerName}",
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            Text(
                              "Phone: ${widget.order.customerPhone}",
                              style: GoogleFonts.inter(fontSize: 12),
                            ),
                            Text(
                              "Email: ${widget.order.customerEmail}",
                              style: GoogleFonts.inter(fontSize: 12),
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
                            if (widget.order.orderStatus !=
                                "Request to cancel") ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cancellation Approved:",
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  Text(
                                    widget.order.statusCanceledDate != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                            widget.order.statusCanceledDate!,
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

                    if (widget.order.orderStatus == "Request to cancel")
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 70.0,
                          horizontal: 5,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: approveDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Approve Cancellation",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }

  void approveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Approve cancellation",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure want to approve?",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.inter()),
              onPressed: () {
                approveCancellation("Canceled");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderClerkPage(clerk: widget.clerk),
                  ),
                );
              },
            ),
            TextButton(
              child: Text("No", style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> approveCancellation(String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/update_order_status.php"),
        body: {
          "order_id": widget.order.orderId,
          "status": newStatus,
          "order_tracking": widget.order.orderTracking,
        },
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          widget.order.orderStatus = newStatus;
          widget.order.statusCanceledDate = DateTime.now().toIso8601String();
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cancellation approved", style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to withdraw cancellation",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error updating status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating status", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchOrderDetails() async {
    try {
      final response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_orderdetails_clerkadmin.php",
        ),
        body: {'order_id': widget.order.orderId},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          setState(() {
            orderItems = data['products'];
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
}

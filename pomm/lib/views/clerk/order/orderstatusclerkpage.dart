import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/clerk.dart';
import 'package:pomm/models/order.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/clerk/order/clerkorderpage.dart';

class OrderStatusClerkPage extends StatefulWidget {
  final Clerk clerk;
  final Order order;

  const OrderStatusClerkPage({
    super.key,
    required this.clerk,
    required this.order,
  });

  @override
  State<OrderStatusClerkPage> createState() => _OrderStatusClerkPageState();
}

class _OrderStatusClerkPageState extends State<OrderStatusClerkPage> {
  late String currentStatus;
  late String trackingNumber;
  late String shippingAddress;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.orderStatus ?? "Order placed";
    trackingNumber = widget.order.orderTracking ?? "No Tracking";
    shippingAddress = widget.order.shippingAddress ?? "No Address Provided";
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> statusOptions = getStatusOptions();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 231, 231),
      appBar: AppBar(
        title: Text(
          widget.order.orderStatus ?? "Unknown Status",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                          "Order Tracking",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          trackingNumber,
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping Address",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          shippingAddress,
                          style: GoogleFonts.inter(fontSize: 13),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 10,
                ),
                child: Column(
                  children: List.generate(statusOptions.length, (index) {
                    final status = statusOptions[index];
                    final isLast = index == statusOptions.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              formatDate(getStatusDate(status["status"])),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // space before the bullet
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: getStatusColor(status["status"]),
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 40,
                                color: getTimelineLineColor(
                                  index,
                                  statusOptions,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Text(
                                  status["status"],
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: getStatusColor(status["status"]),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  status["icon"],
                                  color: getStatusColor(status["status"]),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            if (currentStatus != "Delivered" && currentStatus != "Picked up")
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 70.0,
                  horizontal: 5,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: showUpdateDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Update Order Status",
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

  Color getTimelineLineColor(int index, List<Map<String, dynamic>> statuses) {
    final currentIndex = statuses.indexWhere(
      (s) => s["status"] == currentStatus,
    );
    return (index < currentIndex) ? Colors.black : Colors.grey.shade300;
  }

  String getStatusDate(String status) {
    switch (status) {
      case "Order placed":
        return widget.order.orderDate ?? "";
      case "In process":
        return widget.order.statusInProcessDate ?? "";
      case "Ready for pickup":
      case "Out for delivery":
        return widget.order.statusDeliveryPickupDate ?? "";
      case "Picked up":
      case "Delivered":
        return widget.order.statusCompletedDate ?? "";
      case "Request to cancel":
      case "Canceled":
        return widget.order.statusCanceledDate ?? "";
      default:
        return "";
    }
  }

  List<Map<String, dynamic>> getStatusOptions() {
    List<Map<String, dynamic>> base;
    if (shippingAddress == "In-store Pickup") {
      base = [
        {"status": "Order placed", "icon": Icons.shopping_cart},
        {"status": "In process", "icon": Icons.autorenew},
        {"status": "Ready for pickup", "icon": Icons.storefront},
        {"status": "Picked up", "icon": Icons.check_circle},
      ];
    } else {
      base = [
        {"status": "Order placed", "icon": Icons.shopping_cart},
        {"status": "In process", "icon": Icons.autorenew},
        {"status": "Out for delivery", "icon": Icons.local_shipping},
        {"status": "Delivered", "icon": Icons.check_circle},
      ];
    }
    if (currentStatus == "Request to cancel") {
      base.add({
        "status": "Request to cancel",
        "icon": Icons.cancel_schedule_send,
      });
    } else if (currentStatus == "Canceled") {
      base.add({"status": "Canceled", "icon": Icons.cancel});
    }
    return base;
  }

  Color getStatusColor(String status) {
    final date = getStatusDate(status);
    return (date.isNotEmpty && date != "0000-00-00 00:00:00.000000")
        ? Colors.black
        : Colors.grey.shade400;
  }

  String formatDate(String? dateString) {
    if (dateString == null ||
        dateString.isEmpty ||
        dateString == "0000-00-00 00:00:00.000000") {
      return "";
    }
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat("dd/MM/yyyy").format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  List<Map<String, dynamic>> getNextStatusOptions() {
    List<Map<String, dynamic>> allStatuses = getStatusOptions();
    String shipping = "In-store Pickup";

    if (currentStatus == "Order placed") {
      return allStatuses.where((s) => s["status"] == "In process").toList();
    } else if (currentStatus == "In process") {
      return allStatuses
          .where(
            (s) =>
                s["status"] ==
                (shipping == "In-store Pickup"
                    ? "Ready for pickup"
                    : "Out for delivery"),
          )
          .toList();
    } else if (currentStatus == "Out for delivery" &&
        shipping != "In-store Pickup") {
      return allStatuses.where((s) => s["status"] == "Delivered").toList();
    } else if (currentStatus == "Ready for pickup" &&
        shipping == "In-store Pickup") {
      return allStatuses.where((s) => s["status"] == "Picked up").toList();
    }

    return [];
  }

  void showUpdateDialog() {
    final nextStatuses = getNextStatusOptions();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Update Order Status",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content:
              nextStatuses.isEmpty
                  ? Text(
                    "No further status updates available",
                    style: GoogleFonts.inter(fontSize: 14),
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        nextStatuses.map((status) {
                          return ListTile(
                            leading: Icon(status["icon"], color: Colors.black),
                            title: Text(
                              status["status"],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () async {
                              await updateOrderStatus(status["status"]);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          OrderClerkPage(clerk: widget.clerk),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
          actions: [
            TextButton(
              child: Text("Close", style: GoogleFonts.inter(fontSize: 14)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateOrderStatus(String newStatus) async {
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
      if (data['status'] == "success") {
        setState(() {
          currentStatus = newStatus;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Order status updated to $newStatus",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to update order status",
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
}

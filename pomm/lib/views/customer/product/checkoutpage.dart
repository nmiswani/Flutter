import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/order/billpage.dart';

class CheckoutPage extends StatefulWidget {
  final Customer customerdata;
  const CheckoutPage({super.key, required this.customerdata});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Cart> cartList = [];
  double total = 0.0;
  double deliveryCharge = 0.00;

  List<String> shippingOptions = ["Delivery", "In-store Pickup"];
  String selectedShippingOption = "In-store Pickup";
  List<String> deliveryaddresslist = [
    "Laluan A",
    "Laluan B",
    "Laluan C",
    "Laluan D",
    "Luar Kampus",
  ];
  String? selectedDeliveryAddress;

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                _buildShippingContainer(),
                ...cartList.map((item) => _buildCartItem(item)).toList(),
              ],
            ),
          ),
          _buildOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildCartItem(Cart item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minLeadingWidth: 0,
        horizontalTitleGap: 10,
        dense: true,
        title: Text(
          item.productTitle!,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "RM${double.parse(item.productPrice!).toStringAsFixed(2)}",
          style: GoogleFonts.inter(fontSize: 12),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "${MyServerConfig.server}/pomm/assets/products/${item.productId}.jpg",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        trailing: Text(
          "Qty: ${item.cartQty}",
          style: GoogleFonts.inter(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildShippingContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Shipping Option",
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          DropdownButton<String>(
            value: selectedShippingOption,
            isExpanded: true,
            items:
                shippingOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: GoogleFonts.inter(fontSize: 12.5),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedShippingOption = value!;
                selectedDeliveryAddress = null;
                deliveryCharge =
                    selectedShippingOption == "Delivery" ? 5.00 : 0.00;
              });
            },
          ),
          const SizedBox(height: 10),
          if (selectedShippingOption == "Delivery") ...[
            Text(
              "Select Delivery Address",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            DropdownButton<String>(
              value: selectedDeliveryAddress,
              isExpanded: true,
              hint: Text(
                "Choose your delivery address",
                style: GoogleFonts.inter(fontSize: 12.5),
              ),
              items:
                  deliveryaddresslist.map((address) {
                    return DropdownMenuItem(
                      value: address,
                      child: Text(
                        address,
                        style: GoogleFonts.inter(fontSize: 13),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDeliveryAddress = value!;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", calculateSubtotal(), fontSize: 14),
          _buildSummaryRow("Delivery Charge", deliveryCharge, fontSize: 14),
          Divider(color: Colors.white),
          _buildSummaryRow(
            "Total",
            calculateTotal(),
            fontSize: 14.5,
            isBold: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (selectedShippingOption == "Delivery" &&
                  selectedDeliveryAddress == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please select delivery address",
                      style: GoogleFonts.inter(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              String shippingAddress =
                  selectedShippingOption == "Delivery"
                      ? selectedDeliveryAddress!
                      : "In-store Pickup";
              await loadUserCart();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (content) => BillPage(
                        customer: widget.customerdata,
                        totalprice: calculateTotal(),
                        shippingAddress: shippingAddress,
                        orderSubtotal: calculateSubtotal(),
                        deliveryCharge: deliveryCharge,
                        cartList: cartList,
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Place Order",
              style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (label == "Delivery Charge") ...[
              GestureDetector(
                onTap: () {
                  _showDeliveryInfoDialog();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          "RM${value.toStringAsFixed(2)}",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  double calculateSubtotal() {
    return cartList.fold(
      0.0,
      (sum, item) =>
          sum + double.parse(item.productPrice!) * int.parse(item.cartQty!),
    );
  }

  double calculateTotal() {
    return calculateSubtotal() + deliveryCharge;
  }

  Future<void> loadUserCart() async {
    try {
      String customerid = widget.customerdata.customerid.toString();
      final response = await http.get(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_checkout.php?customerid=$customerid",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          setState(() {
            cartList.clear();
            total = (data['data']['total_price'] as num).toDouble();
            for (var v in data['data']['carts']) {
              cartList.add(Cart.fromJson(v));
            }
          });
        } else {
          setState(() {
            cartList.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cart is empty", style: GoogleFonts.inter()),
              backgroundColor: Colors.red,
            ),
          );
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }
      }
    } catch (error) {
      print("Error loading customer cart: $error");
    }
  }

  void _showDeliveryInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Delivery info",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "The delivery charge is RM5 and we will contact you when we are ready to deliver.",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: [
            TextButton(
              child: Text("OK", style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

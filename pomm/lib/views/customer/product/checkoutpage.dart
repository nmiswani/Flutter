import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/order/billpage.dart';
import 'package:pomm/views/customer/product/productpage.dart';

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
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ...cartList.map((item) => _buildCartItem(item)).toList(),
                _buildShippingCard(),
              ],
            ),
          ),
          _buildOrderSummary(),
        ],
      ),
    );
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
            const SnackBar(
              content: Text("Cart is empty"),
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

  Widget _buildShippingCard() {
    return Card(
      color: Colors.green.shade100,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Shipping Option",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedShippingOption,
              isExpanded: true,
              items:
                  shippingOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedShippingOption = value!;
                  selectedDeliveryAddress = null;
                  deliveryCharge =
                      (selectedShippingOption == "Delivery") ? 5.00 : 0.00;
                });
              },
            ),
            const SizedBox(height: 10),
            if (selectedShippingOption == "Delivery") ...[
              Text(
                "Select Delivery Address",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedDeliveryAddress,
                isExpanded: true,
                hint: const Text("Choose your delivery address"),
                items:
                    deliveryaddresslist.map((address) {
                      return DropdownMenuItem(
                        value: address,
                        child: Text(address),
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
      ),
    );
  }

  Widget _buildCartItem(Cart item) {
    return Card(
      child: ListTile(
        leading: Image.network(
          "${MyServerConfig.server}/pomm/assets/products/${item.productId}.jpg",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          item.productTitle!,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "RM${double.parse(item.productPrice!).toStringAsFixed(2)}",
        ),
        trailing: Text("Qty: ${item.cartQty}"),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", calculateSubtotal()),
          _buildSummaryRow("Delivery Charge", deliveryCharge),
          const Divider(color: Colors.white),
          _buildSummaryRow("Total", calculateTotal(), isBold: true),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (selectedShippingOption == "Delivery" &&
                  selectedDeliveryAddress == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select a delivery address"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              String shippingAddress =
                  (selectedShippingOption == "Delivery")
                      ? selectedDeliveryAddress!
                      : "In-store Pickup";

              await loadUserCart();

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BillPage(
                        customer: widget.customerdata,
                        totalprice: calculateTotal(),
                        shippingAddress: shippingAddress,
                        orderSubtotal: calculateSubtotal(),
                        deliveryCharge: deliveryCharge,
                        cartList: cartList,
                      ),
                ),
              );

              if (result == "success") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Payment completed successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );

                // Optional: Refresh cart or navigate back
                setState(() {
                  cartList.clear();
                });

                // Delay briefly before navigating
                await Future.delayed(const Duration(seconds: 2));

                // Navigate to homepage (replace this with your actual home route)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProductPage(customerdata: widget.customerdata),
                  ), // ⬅️ Change this
                  (Route<dynamic> route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 55, 97, 70),
            ),
            child: Text(
              "Place Order",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "RM${value.toStringAsFixed(2)}",
          style: GoogleFonts.poppins(
            color: Colors.white,
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
}

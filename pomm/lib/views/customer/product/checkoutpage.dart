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
  double deliveryCharge = 5.00;

  // ✅ Shipping Option List
  List<String> shippingOptions = ["Delivery", "In-store Pickup"];
  String selectedShippingOption = "In-store Pickup"; // Default selection

  // ✅ Delivery Address List
  List<String> deliveryaddresslist = [
    "Laluan A",
    "Laluan B",
    "Laluan C",
    "Laluan D",
    "Luar Kampus",
  ];
  String? selectedDeliveryAddress; // Selected delivery address

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
                _buildShippingCard(), // ✅ Updated Shipping Card
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
            Navigator.of(context).pop(); // Go back if cart is empty
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
                  selectedDeliveryAddress = null; // Reset address selection
                });
              },
            ),
            const SizedBox(height: 10),

            // ✅ Show Delivery Address Dropdown ONLY IF "Delivery" is selected
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: GoogleFonts.poppins(color: Colors.white)),
              Text(
                "RM${calculateSubtotal().toStringAsFixed(2)}",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery Charge",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              Text(
                selectedShippingOption == "Delivery"
                    ? "RM${deliveryCharge.toStringAsFixed(2)}"
                    : "RM0.00",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ],
          ),
          Divider(color: Colors.white),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "RM${calculateTotal().toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
                  selectedShippingOption == "Delivery"
                      ? selectedDeliveryAddress!
                      : "In-store Pickup";

              await loadUserCart(); // Reload cart before navigating
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (content) => BillPage(
                        customer: widget.customerdata,
                        totalprice: total,
                        shippingAddress: shippingAddress,
                      ),
                ),
              );
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

  double calculateSubtotal() {
    double subtotal = 0.0;
    for (var item in cartList) {
      subtotal += double.parse(item.productPrice!) * int.parse(item.cartQty!);
    }
    return subtotal;
  }

  double calculateTotal() {
    return calculateSubtotal() +
        (selectedShippingOption == "Delivery" ? deliveryCharge : 0);
  }
}

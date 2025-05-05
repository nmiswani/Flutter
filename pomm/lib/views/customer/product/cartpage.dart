import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomm/models/cart.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/product/checkoutpage.dart';

class CartPage extends StatefulWidget {
  final Customer customer;
  const CartPage({super.key, required this.customer});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = [];
  double total = 0.0;

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
          "My Cart",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          cartList.isEmpty
              ? Center(
                child: Text(
                  "Please wait... or no products found",
                  style: GoogleFonts.inter(),
                ),
              )
              : Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(child: _buildCartItemsList()),
                  _buildCheckoutSection(),
                ],
              ),
    );
  }

  Widget _buildCartItemsList() {
    return ListView.builder(
      itemCount: cartList.length,
      itemBuilder: (context, index) {
        final cartItem = cartList[index];
        return _buildCartItem(cartItem);
      },
    );
  }

  Widget _buildCartItem(Cart cartItem) {
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
          cartItem.productTitle.toString(),
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "RM${cartItem.productPrice.toString()}",
          style: GoogleFonts.inter(fontSize: 12),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "${MyServerConfig.server}/pomm/assets/products/${cartItem.productId}.jpg",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        trailing: _buildCartItemActions(cartItem),
      ),
    );
  }

  Widget _buildCartItemActions(Cart cartItem) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => decrementQuantity(cartItem),
          child: const Icon(Icons.remove, color: Colors.black, size: 14),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            cartItem.cartQty.toString(),
            style: GoogleFonts.inter(fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => incrementQuantity(cartItem),
          child: const Icon(Icons.add, color: Colors.black, size: 14),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => showRemoveItemDialog(cartItem),
          child: const Icon(Icons.delete, color: Colors.red, size: 16),
        ),
      ],
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total RM${calculateSubtotal().toStringAsFixed(2)}",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (content) =>
                                CheckoutPage(customerdata: widget.customer),
                      ),
                    );
                    loadUserCart();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Checkout",
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void loadUserCart() async {
    try {
      String customerid = widget.customer.customerid.toString();
      final response = await http.get(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_cart.php?customerid=$customerid",
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("API Response: $data");

        if (data['status'] == "success" && data['data'] != null) {
          cartList.clear();
          data['data']['carts'].forEach((v) {
            Cart cartItem = Cart.fromJson(v);
            print("Cart Product ID: ${cartItem.productId}");
            cartList.add(cartItem);
          });

          setState(() {});
        }
      }
    } catch (error) {
      print("Error loading customer cart: $error");
    }
  }

  incrementQuantity(Cart cartItem) async {
    final availableStock = await fetchProductStock(cartItem.productId!);

    int currentQuantity = int.parse(cartItem.cartQty!);

    if (availableStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error checking stock", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (currentQuantity >= availableStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Quantity available is only $availableStock left",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    updateQuantity(cartItem, currentQuantity + 1);
  }

  Future<int?> fetchProductStock(String productId) async {
    try {
      final url =
          "${MyServerConfig.server}/pomm/php/get_product_stock2.php?product_id=$productId";
      print("Fetching stock from: $url");

      final response = await http.get(Uri.parse(url));

      print("Status code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Parsed data: $data");

        if (data['status'] == "success") {
          return int.tryParse(data['qty'].toString());
        }
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }

  decrementQuantity(Cart cartItem) async {
    int currentQuantity = int.parse(cartItem.cartQty!);
    if (currentQuantity > 1) {
      updateQuantity(cartItem, currentQuantity - 1);
    } else {
      showRemoveItemDialog(cartItem);
    }
  }

  double calculateSubtotal() {
    double subtotal = 0.0;

    cartList.forEach((item) {
      subtotal += double.parse(item.productPrice!) * int.parse(item.cartQty!);
    });
    return subtotal;
  }

  int calculateTotalItems() {
    int totalItems = 0;

    cartList.forEach((item) {
      totalItems += int.parse(item.cartQty!);
    });
    return totalItems;
  }

  void showRemoveItemDialog(Cart cartItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Remove product",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure want to remove ${cartItem.productTitle}?",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.inter()),
              onPressed: () {
                removeCartItem(cartItem);
                Navigator.of(context).pop();
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

  void removeCartItem(Cart cartItem) async {
    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/delete_cart.php"),
        body: {"cart_id": cartItem.cartId},
      );

      if (response.statusCode == 200) {
        setState(() {
          cartList.remove(cartItem);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Product removed successful",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        loadUserCart();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              
              "Failed to remove product",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print("Error deleting cart item: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void updateQuantity(Cart cartItem, int newQuantity) async {
    setState(() {
      cartItem.cartQty = newQuantity.toString();
    });
    await updateCartQuantity(
      cartItem.cartId!,
      cartItem.cartQty!,
      cartItem.productPrice!,
    );
  }

  Future<void> updateCartQuantity(
    String cartId,
    String newQuantity,
    String productPrice,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/update_cart.php"),
        body: {
          "cart_id": cartId,
          "cart_qty": newQuantity,
          "product_price": productPrice,
        },
      );

      var data = jsonDecode(response.body);
      print("Server Response: $data");

      if (response.statusCode == 200 && data['status'] == "success") {
        print("Cart quantity & product price updated successfully.");
        setState(() {
          loadUserCart();
        });
      } else {
        print("Failed to update cart: ${data['data']}");
      }
    } catch (error) {
      print("Error updating cart quantity: $error");
    }
  }
}

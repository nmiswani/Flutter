import 'dart:convert';
import 'package:bookbytes/models/cart.dart';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/views/billscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared/myserverconfig.dart';

class CartPage extends StatefulWidget {
  final User user;

  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = [];
  double total = 0.0;
  List<List<Cart>> _groupedCartItems = [];

  @override
  void initState() {
    super.initState();
    loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Cart"),
        elevation: 0.0,
      ),
      body: cartList.isEmpty
          ? const Center(child: Text("No Data"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _groupedCartItems.length,
                    itemBuilder: (context, sellerIndex) {
                      final sellerCart = _groupedCartItems[sellerIndex];
                      final seller = sellerCart.first.sellerId!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Shop $seller",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Column(
                            children: sellerCart.map((cartItem) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    cartItem.bookTitle.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    "RM ${cartItem.bookPrice.toString()}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      "${MyServerConfig.server}/bookbytes/assets/books/${cartItem.bookId}.png",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            decrementQuantity(cartItem),
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        cartItem.cartQty.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            incrementQuantity(cartItem),
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            showRemoveItemDialog(cartItem),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subtotal",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "RM${calculateSubtotal().toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Delivery Charge",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showDeliveryInfoDialog();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "RM${(recalculateTotal() - calculateSubtotal()).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        height: 16,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total RM${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => BillScreen(
                                            user: widget.user,
                                            totalprice: total,
                                          )));
                              loadUserCart();
                            },
                            icon: const Icon(Icons.shopping_cart,
                                color: Colors.white),
                            label: Text(
                              "Check Out (${calculateTotalItems()})",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green, // Set the button color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  loadUserCart() async {
    try {
      String userid = widget.user.userid.toString();
      final response = await http.get(
        Uri.parse(
            "${MyServerConfig.server}/bookbytes/php/load_cart.php?userid=$userid"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          cartList.clear();
          total = 0.0;
          data['data']['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            total += double.parse(v['book_price']) * int.parse(v['cart_qty']);
          });
          _groupCartItems();
          total = recalculateTotal();
          setState(() {});
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      print("Error loading user cart: $error");
    }
  }

  incrementQuantity(Cart cartItem) async {
    updateQuantity(cartItem, int.parse(cartItem.cartQty!) + 1);
  }

  decrementQuantity(Cart cartItem) async {
    int currentQuantity = int.parse(cartItem.cartQty!);
    if (currentQuantity > 1) {
      updateQuantity(cartItem, currentQuantity - 1);
    } else {
      showRemoveItemDialog(cartItem);
    }
  }

  void showRemoveItemDialog(Cart cartItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Remove book?",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        content: Text("Are you sure want to remove ${cartItem.bookTitle}?"),
        actions: [
          TextButton(
            onPressed: () {
              RemoveCartItem(cartItem);
              Navigator.pop(context);
            },
            child: const Text("Remove"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  updateQuantity(Cart cartItem, int newQuantity) async {
    setState(() {
      cartItem.cartQty = newQuantity.toString();
      total = recalculateTotal();
    });

    await updateCartQuantity(cartItem.cartId!, cartItem.cartQty!);
  }

  updateCartQuantity(String cartId, String newQuantity) async {
    try {
      await http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/update_cart.php"),
        body: {
          "cart_id": cartId,
          "cart_qty": newQuantity,
        },
      );

      await loadUserCart();
    } catch (error) {
      print("Error updating cart quantity: $error");
    }
  }

  RemoveCartItem(Cart cartItem) async {
    try {
      final response = await http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/delete_cart.php"),
        body: {
          "cart_id": cartItem.cartId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          cartList.remove(cartItem);
          total = recalculateTotal();
        });
        await loadUserCart();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to remove item"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print("Error deleting cart item: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double calculateSubtotal() {
    double subtotal = 0.0;

    _groupedCartItems.forEach((sellerCart) {
      sellerCart.forEach((item) {
        subtotal += double.parse(item.bookPrice!) * int.parse(item.cartQty!);
      });
    });

    return subtotal;
  }

  double recalculateTotal() {
    double newTotal = 0.0;

    _groupedCartItems.forEach((sellerCart) {
      double sellerSubtotal = 0.0;

      sellerCart.forEach((item) {
        sellerSubtotal +=
            double.parse(item.bookPrice!) * int.parse(item.cartQty!);
      });
      newTotal += sellerSubtotal + 10.0;
    });

    return newTotal;
  }

  int calculateTotalItems() {
    int totalItems = 0;
    _groupedCartItems.forEach((sellerCart) {
      sellerCart.forEach((item) {
        totalItems += int.parse(item.cartQty!);
      });
    });
    return totalItems;
  }

  void _groupCartItems() {
    _groupedCartItems = [];
    final groupedMap = <String, List<Cart>>{};
    cartList.forEach((item) {
      groupedMap.putIfAbsent(item.sellerId!, () => []).add(item);
    });
    _groupedCartItems = groupedMap.values.toList();
  }

  void _showDeliveryInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delivery charge info",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        content: const Text("Charge price for each seller is RM10"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

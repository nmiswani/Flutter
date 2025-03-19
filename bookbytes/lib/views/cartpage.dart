import 'dart:convert';
import 'package:bookbytes/models/cart.dart';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/views/billpage.dart';
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              "Book Cart",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
      ),
      body: cartList.isEmpty
          ? const Center(child: Text(""))
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
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.store_mall_directory_rounded,
                                ),
                                const SizedBox(
                                    width:
                                        8), // Adjust the space between the icon and text as needed
                                Text(
                                  "${getShopName(seller)} ",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded,
                                    size: 15),
                              ],
                            ),
                          ),
                          Column(
                            children: sellerCart.map((cartItem) {
                              return Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
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
                                  contentPadding: const EdgeInsets.all(8),
                                  title: Text(
                                    cartItem.bookTitle.toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "RM${cartItem.bookPrice.toString()}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      "${MyServerConfig.server}/bookbytes/assets/books/${cartItem.bookId}.png",
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            decrementQuantity(cartItem),
                                        padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        cartItem.cartQty.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            incrementQuantity(cartItem),
                                        padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            showRemoveItemDialog(cartItem),
                                        padding: EdgeInsets.zero,
                                        iconSize: 20,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total RM${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 120, // Set the desired width here
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => BillPage(
                                      user: widget.user,
                                      totalprice: total,
                                    ),
                                  ),
                                );
                                loadUserCart();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.deepOrange,
                                backgroundColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                minimumSize: Size.zero, // Remove fixed width
                                side: const BorderSide(
                                  color: Colors.deepOrange,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                "CHECK OUT",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
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
          "Remove book",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

// Add a method to get shop name by sellerId
  String getShopName(String sellerId) {
    switch (sellerId) {
      case '1':
        return 'One-Stop Books';
      case '2':
        return 'Big Bad Wolf';
      case '3':
        return 'Books Lounge';
      case '4':
        return 'BookBerry';
      case '5':
        return 'Cybernaut Digital Library';
      default:
        return 'Unknown Shop';
    }
  }

  void _showDeliveryInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delivery info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'package:http/http.dart' as http;
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/customerdashboard.dart';
import 'package:pomm/views/customer/product/cartpage.dart';

class ProductDetailsPage extends StatefulWidget {
  final Customer customerdata;
  final Product product;

  const ProductDetailsPage({
    super.key,
    required this.customerdata,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late double screenWidth, screenHeight;
  int randomValue = Random().nextInt(100000);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product.productTitle.toString(),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CustomerDashboardPage(
                      customerdata: widget.customerdata,
                    ),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Gambar full width tanpa padding
          SizedBox(
            height: screenHeight / 3,
            width: screenWidth,
            child: CachedNetworkImage(
              imageUrl:
                  "${MyServerConfig.server}/pomm/assets/products/${widget.product.productId}.jpg?v=$randomValue",
              fit: BoxFit.cover,
              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) => const Icon(Icons.error, size: 50),
            ),
          ),

          // Product Info
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.045),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productTitle.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.productDesc.toString(),
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "RM${widget.product.productPrice}",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.productQty == "0"
                        ? "No stock"
                        : "${widget.product.productQty} available stock",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color:
                          widget.product.productQty == "0"
                              ? Colors.red
                              : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Butang Add to Cart
          Container(
            width: MediaQuery.of(context).size.width / 1.10,
            margin: const EdgeInsets.only(bottom: 13),
            child: ElevatedButton(
              onPressed: () {
                insertCartDialog();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 47),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Add to Cart",
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void insertCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Insert to cart",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure want to add?",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.inter()),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final alreadyInCart = await checkCartTable();
                final productQty = widget.product.productQty;
                final qtyInt =
                    productQty != null ? int.tryParse(productQty) : null;

                final productId = widget.product.productId.toString();
                final availableStock = await fetchProductStock(productId);

                if (!mounted) return;

                if (availableStock == null || availableStock <= 0) {
                  showSnackbar("Product out of stock", isError: true);
                  return;
                }

                if (alreadyInCart) {
                  final currentCartQty = await getCurrentCartQty(productId);

                  if (currentCartQty == null) {
                    showSnackbar(
                      "Unable to retrieve cart quantity",
                      isError: true,
                    );
                    return;
                  }

                  if (currentCartQty >= availableStock) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Product has already been inserted before",
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );

                    return;
                  }

                  final updated =
                      await updateCartQty(); // You must implement this
                  if (updated) {
                    showSnackbar("Quantity updated in cart", isError: false);
                  } else {
                    showSnackbar("Failed to update quantity", isError: true);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (content) => CartPage(customer: widget.customerdata),
                    ),
                  );
                  return;
                }

                if (qtyInt == null || qtyInt <= 0) {
                  showSnackbar("Product out of stock", isError: true);
                  return;
                }

                insertCart(); // You must implement this
              },
            ),
            TextButton(
              child: Text("No", style: GoogleFonts.inter()),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }

  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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

  Future<int?> getCurrentCartQty(String productId) async {
    try {
      final url =
          "${MyServerConfig.server}/pomm/php/get_cart_qty.php?product_id=$productId&customer_id=${widget.customerdata.customerid}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          return int.tryParse(data['qty'].toString());
        }
      }
    } catch (e) {
      print("Error fetching cart qty: $e");
    }
    return null;
  }

  Future<bool> checkCartTable() async {
    try {
      var response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/check_cart_table.php"),
        body: {
          "product_id": widget.product.productId.toString(),
          "customer_id": widget.customerdata.customerid.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "exists") {
          return true;
        }
      }
    } catch (e) {
      print("Error checking cart table: $e");
    }
    return false;
  }

  Future<bool> updateCartQty() async {
    try {
      var response = await http.post(
        Uri.parse("${MyServerConfig.server}/pomm/php/update_cart_qty.php"),
        body: {"product_id": widget.product.productId.toString()},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          return true; // Berjaya update qty
        }
      }
    } catch (e) {
      print("Error updating cart qty: $e");
    }
    return false;
  }

  void insertCart() {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/insert_cart.php"),
          body: {
            "customer_id": widget.customerdata.customerid.toString(),
            "product_id": widget.product.productId.toString(),
            "product_price": widget.product.productPrice.toString(),
            "product_title": widget.product.productTitle.toString(),
          },
        )
        .then((response) {
          developer.log(response.body);
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added to cart successful",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => CartPage(customer: widget.customerdata),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to add to cart",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}

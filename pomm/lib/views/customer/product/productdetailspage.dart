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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Card(
                      elevation: 3,
                      child: SizedBox(
                        height: screenHeight / 3,
                        width: screenWidth * 0.91,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${MyServerConfig.server}/pomm/assets/products/${widget.product.productId}.jpg?v=$randomValue",
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Product Details Table
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.045),
                    child: Table(
                      border: TableBorder.all(color: Colors.black, width: 1.5),
                      columnWidths: const {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(3.5),
                      },
                      children: [
                        buildTableRow(
                          "Name",
                          widget.product.productTitle.toString(),
                        ),
                        buildTableRow(
                          "Description",
                          widget.product.productDesc.toString(),
                        ),
                        buildTableRow(
                          "Price",
                          "RM${widget.product.productPrice}",
                        ),
                        buildTableRow(
                          "Quantity",
                          "${widget.product.productQty}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width / 1.10,
            margin: const EdgeInsets.only(bottom: 50),
            color: Colors.white,
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
                  Icon(Icons.shopping_cart, color: Colors.white),
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

  TableRow buildTableRow(String label, String value) {
    return TableRow(
      children: [
        // Column Label - Black background, white text
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Column Value - Black background, white text
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  void insertCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
              onPressed: () {
                Navigator.of(context).pop();

                final productQty = widget.product.productQty;
                final qtyInt =
                    productQty != null ? int.tryParse(productQty) : null;

                if (qtyInt != null && qtyInt > 0) {
                  insertCart();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Product out of stock",
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
                    "Added to cart successfully",
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

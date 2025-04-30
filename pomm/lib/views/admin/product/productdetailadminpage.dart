import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/product/updateproductpage.dart';

class ProductDetailAdminPage extends StatefulWidget {
  final Admin admin;
  final Product product;

  const ProductDetailAdminPage({
    super.key,
    required this.admin,
    required this.product,
  });

  @override
  State<ProductDetailAdminPage> createState() => _ProductDetailAdminPageState();
}

class _ProductDetailAdminPageState extends State<ProductDetailAdminPage> {
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (content) => UpdateProductPage(
                        product: widget.product,
                        admin: widget.admin,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
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
            margin: const EdgeInsets.only(bottom: 51),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                deleteDialog();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Delete Product",
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

  void deleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Delete product",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure want to delete?",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProduct();
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

  void deleteProduct() {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/delete_product.php"),
          body: {"productid": widget.product.productId},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Product deleted successful",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to delete product",
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

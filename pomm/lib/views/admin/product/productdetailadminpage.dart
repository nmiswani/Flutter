import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.productTitle.toString(),
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
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
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Image
                  SizedBox(
                    height: screenHeight * 0.35,
                    width: screenWidth,
                    child: ClipRRect(
                      child: Image.network(
                        "${MyServerConfig.server}/pomm/assets/products/${widget.product.productId}.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Product Details Table
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
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

          // Delete Button (Fixed at Bottom)
          Container(
            width: MediaQuery.of(context).size.width / 2,
            margin: const EdgeInsets.only(bottom: 80),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {
                deleteDialog();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    size: screenWidth * 0.05,
                    color: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    "Delete",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
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
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Adjusted padding
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03), // Adjusted padding
            child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
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
          title: const Text(
            "Delete product",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle()),
              onPressed: () {
                deleteProduct();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("No"),
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Delete Success")));
              // Navigate back to the product list
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Failed")));
            }
          }
        });
  }
}

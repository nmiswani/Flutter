import 'dart:convert';
import 'dart:developer';

import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookDetailsPage extends StatefulWidget {
  final User userdata;
  final Book book;

  const BookDetailsPage(
      {super.key, required this.userdata, required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late double screenWidth, screenHeight;
  bool bookowner = false;

  @override
  Widget build(BuildContext context) {
    if (widget.userdata.userid == widget.book.userId) {
      bookowner = true;
    } else {
      bookowner = false;
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.bookTitle.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book Image
            SizedBox(
              height: screenHeight * 0.38,
              width: screenWidth,
              child: ClipRRect(
                child: Image.network(
                  "${MyServerConfig.server}/bookbytes/assets/books/${widget.book.bookId}.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Book Details Table
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjusted padding
              child: Table(
                border: TableBorder.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(3.5),
                },
                children: [
                  buildTableRow("Author", widget.book.bookAuthor.toString()),
                  buildTableRow("ISBN", widget.book.bookIsbn.toString()),
                  buildTableRow("Description", widget.book.bookDesc.toString()),
                  buildTableRow("Price", "RM${widget.book.bookPrice}"),
                  buildTableRow(
                    "Quantity",
                    "${widget.book.bookQty} (${widget.book.bookStatus})",
                  ),
                ],
              ),
            ),
            // Add to Cart Button
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                margin: const EdgeInsets.only(top: 8), // Add margin for spacing
                child: ElevatedButton(
                  onPressed: () {
                    insertCartDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: screenWidth * 0.05, // Adjusted icon size
                        color: Colors.white,
                      ),
                      SizedBox(width: screenWidth * 0.02), // Adjusted spacing
                      Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // Adjusted font size
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Adjusted padding
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
              ),
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
          title: const Text(
            "Insert to cart",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                final bookQty = widget.book.bookQty;
                final qtyInt = bookQty != null ? int.tryParse(bookQty) : null;

                if (qtyInt != null && qtyInt > 0) {
                  insertCart();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Book out of stock"),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
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
    http.post(
        Uri.parse("${MyServerConfig.server}/bookbytes/php/insert_cart.php"),
        body: {
          "buyer_id": widget.userdata.userid.toString(),
          "seller_id": widget.book.userId.toString(),
          "book_id": widget.book.bookId.toString(),
          "book_status": widget.book.bookStatus.toString(),
          "book_price": widget.book.bookPrice.toString(),
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Added to cart successfully"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to add to cart"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}

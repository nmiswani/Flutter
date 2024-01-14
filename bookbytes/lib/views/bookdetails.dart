import 'dart:convert';
import 'dart:developer';

import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookDetails extends StatefulWidget {
  final User userdata;
  final Book book;

  const BookDetails({super.key, required this.userdata, required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Book Image
            SizedBox(
              height: screenHeight * 0.4,
              width: screenWidth,
              child: Image.network(
                "${MyServerConfig.server}/bookbytes/assets/books/${widget.book.bookId}.png",
                fit: BoxFit.cover,
              ),
            ),
            // Book Details
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "By ${widget.book.bookAuthor}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("ISBN ${widget.book.bookIsbn}"),
                    const SizedBox(height: 16),
                    Text(
                      widget.book.bookDesc.toString(),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "RM${widget.book.bookPrice}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Quantity Available: ${widget.book.bookQty} (${widget.book.bookStatus} Book)",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width / 2.2,
              child: Container(
                padding: const EdgeInsets.all(8.0),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
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

  void insertCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Insert to cart?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
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
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            message.contains("Success") ? Colors.green : Colors.red,
      ),
    );
  }
}

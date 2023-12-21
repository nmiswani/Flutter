import 'dart:convert';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:bookbytes/views/editbookpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookDetails extends StatefulWidget {
  final User user;
  final Book book;

  const BookDetails({super.key, required this.user, required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  late double screenWidth, screenHeight;
  bool bookowner = false;

  @override
  Widget build(BuildContext context) {
    if (widget.user.userid == widget.book.userId) {
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
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                enabled: bookowner,
                child: const Text("Update"),
              ),
              PopupMenuItem<int>(
                enabled: bookowner,
                value: 1,
                child: const Text("Delete"),
              ),
            ],
            onSelected: (value) {
              if (value == 0) {
                if (widget.book.userId == widget.book.userId) {
                  updateDialog();
                } else {
                  showSnackBar("Not allowed!");
                }
              } else if (value == 1) {
                if (widget.book.userId == widget.book.userId) {
                  deleteDialog();
                } else {
                  showSnackBar("Not allowed!");
                }
              }
            },
          ),
        ],
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
                        color: Colors.grey,
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
          ],
        ),
      ),
    );
  }

  void updateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update this book?"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => EditBookPage(
                      user: widget.user,
                      book: widget.book,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                showSnackBar("Canceled");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text("Delete this book?"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteBook();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                showSnackBar("Canceled");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteBook() {
    http.post(
      Uri.parse("${MyServerConfig.server}/bookbytes/php/delete_book.php"),
      body: {
        "userid": widget.user.userid.toString(),
        "bookid": widget.book.bookId.toString(),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          showSnackBar("Delete Success");
          Navigator.of(context).pop();
        } else {
          showSnackBar("Delete Failed");
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

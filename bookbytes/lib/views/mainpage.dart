// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';
import 'package:bookbytes/models/book.dart';
import 'package:bookbytes/models/user.dart';
import 'package:bookbytes/shared/mydrawer.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:bookbytes/views/bookdetails.dart';
import 'package:bookbytes/views/newbookpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final User userdata;
  const MainPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Book> bookList = <Book>[];
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;

  var color;
  String title = "";

  @override
  void initState() {
    super.initState();
    loadBooks(title);
  }

  int axiscount = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Book List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: showSearchDialog,
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
        elevation: 0.0,
      ),
      drawer: MyDrawer(
        page: "books",
        userdata: widget.userdata,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadBooks(title);
        },
        child: bookList.isEmpty
            ? const Center(child: Text("No Book's Data"))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "BookBytes offers $numofresult books",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      padding: const EdgeInsets.all(10),
                      children: List.generate(bookList.length, (index) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                            onTap: () async {
                              Book book =
                                  Book.fromJson(bookList[index].toJson());
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) => BookDetails(
                                    user: widget.userdata,
                                    book: book,
                                  ),
                                ),
                              );
                              loadBooks(title);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      "${MyServerConfig.server}/bookbytes/assets/books/${bookList[index].bookId}.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          truncateString(bookList[index]
                                              .bookTitle
                                              .toString()),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "RM${bookList[index].bookPrice}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Available ${bookList[index].bookQty} unit",
                                          style: const TextStyle(
                                            fontSize: 14,
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
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if ((curpage - 1) == index) {
                          color = Colors.deepOrange;
                        } else {
                          color = Colors.black;
                        }
                        return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadBooks(title);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        /*floatingActionButton: FloatingActionButton(
        onPressed: newBook,
        child: const Icon(Icons.add),
      ),*/
      ),
    );
  }

  void newBook() {
    if (widget.userdata.userid.toString() == "0") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please register an account"),
        backgroundColor: Colors.red,
      ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewBookPage(
                    userdata: widget.userdata,
                  )));
    }
  }

  String truncateString(String str) {
    if (str.length > 20) {
      str = str.substring(0, 20);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadBooks(String title) {
    http
        .get(
      Uri.parse(
          "${MyServerConfig.server}/bookbytes/php/load_books.php?title=$title&pageno=$curpage"),
    )
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        log(response.body);
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          bookList.clear();
          data['data']['books'].forEach((v) {
            bookList.add(Book.fromJson(v));
          });
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Book Not Found"),
            backgroundColor: Colors.red,
          ));
        }
      }
      setState(() {});
    });
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    title = searchController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Search Title",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepOrange),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Enter book title",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  loadBooks(searchController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    "Search",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

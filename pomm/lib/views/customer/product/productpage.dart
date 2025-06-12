import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/chat/chatcustomerpage.dart';
import 'package:pomm/views/customer/product/cartpage.dart';
import 'package:pomm/views/customer/product/productdetailspage.dart';

class ProductPage extends StatefulWidget {
  final Customer customerdata;
  const ProductPage({super.key, required this.customerdata});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> productList = <Product>[];
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  int axiscount = 2;
  var color;
  int randomValue = Random().nextInt(100000);
  String title = "";
  late List<Widget> tabchildren;
  String maintitle = "Product";
  String selectedSortOrder = "asc"; // Default: ascending

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts(title);
    loadHotProductSales();
    loadCurrentCart();
  }

  Map<String, int> todaySales = {}; // Simpan quantity_sold ikut productId

  Future<void> loadHotProductSales() async {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      var response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/get_hotsales.php?currentDate=$currentDate",
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            todaySales = Map<String, int>.from(jsonData['sales']);
            print(todaySales);
          });
        }
      } else {
        print("Failed to load hot sales. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading hot sales: $e");
    }
  }

  int currentCart = 0; // Simpan total kuantiti barang dalam cart

  Future<void> loadCurrentCart() async {
    String customerId = widget.customerdata.customerid.toString();
    try {
      var response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/get_current_cart.php?customer_id=$customerId",
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            currentCart = jsonData['total_cart_items'] ?? 0;
            print("Total items in cart: $currentCart");
          });
        }
      } else {
        print("Failed to load cart. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Product",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          // Chat dulu
          IconButton(
            icon: const Icon(Icons.chat, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ChatCustomerPage(customerdata: widget.customerdata),
                ),
              );
            },
          ),
          // Cart last (kanan)
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CartPage(customer: widget.customerdata),
                    ),
                  ).then((_) {
                    loadCurrentCart();
                  });
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              if (currentCart > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      currentCart.toString(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                elevation: 0.5,
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    curpage = 1;
                    loadProducts(value);
                  },
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    hintText: 'Search products',
                    hintStyle: GoogleFonts.inter(color: Colors.black45),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              title: Text(
                                "Filter by price",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Sort by Low to High
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSortOrder =
                                            "asc"; // Set to ascending
                                      });
                                      loadPriceProductsAsc(
                                        'searchQuery', // Gantikan dengan 'searchController.text' jika perlu
                                        sortOrder: "asc",
                                      );
                                      Navigator.pop(context); // Close dialog
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 16.0,
                                      ),
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      decoration: BoxDecoration(
                                        color:
                                            selectedSortOrder == "asc"
                                                ? Colors.blue.shade100
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                        border: Border.all(
                                          color:
                                              selectedSortOrder == "asc"
                                                  ? Colors.blue
                                                  : Colors.grey,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color:
                                                selectedSortOrder == "asc"
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            "Price: Low to High",
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color:
                                                  selectedSortOrder == "asc"
                                                      ? Colors.blue
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Sort by High to Low
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSortOrder =
                                            "desc"; // Set to descending
                                      });
                                      loadPriceProductsDesc(
                                        'searchQuery', // Gantikan dengan 'searchController.text' jika perlu
                                        sortOrder: "desc",
                                      );
                                      Navigator.pop(context); // Close dialog
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 16.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            selectedSortOrder == "desc"
                                                ? Colors.blue.shade100
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                        border: Border.all(
                                          color:
                                              selectedSortOrder == "desc"
                                                  ? Colors.blue
                                                  : Colors.grey,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_downward,
                                            color:
                                                selectedSortOrder == "desc"
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            "Price: High to Low",
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color:
                                                  selectedSortOrder == "desc"
                                                      ? Colors.blue
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Close",
                                    style: GoogleFonts.inter(),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.filter_list, color: Colors.black),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  loadProducts(searchController.text);
                },
                child:
                    productList.isEmpty
                        ? Center(
                          child: Text(
                            "Please wait... or no products found",
                            style: GoogleFonts.inter(),
                          ),
                        )
                        : Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                itemCount: productList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: axiscount,
                                      childAspectRatio: 0.8,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 4,
                                    ),
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final product = productList[index];
                                  final productId =
                                      product.productId.toString();
                                  final quantitySold =
                                      todaySales[productId] ?? 0;

                                  return Stack(
                                    children: [
                                      Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () async {
                                            Product product = Product.fromJson(
                                              productList[index].toJson(),
                                            );
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (content) =>
                                                        ProductDetailsPage(
                                                          customerdata:
                                                              widget
                                                                  .customerdata,
                                                          product: product,
                                                        ),
                                              ),
                                            );
                                            loadProducts(searchController.text);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                  child: Image.network(
                                                    "${MyServerConfig.server}/pomm/assets/products/${product.productId}.jpg?v=$randomValue",
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Image.asset(
                                                        "assets/images/default_product.jpg",
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        truncateString(
                                                          product.productTitle
                                                              .toString(),
                                                        ),
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                      Text(
                                                        "RM${product.productPrice}",
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                      Text(
                                                        "${product.productQty} available",
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color:
                                                              int.tryParse(
                                                                        product
                                                                            .productQty
                                                                            .toString(),
                                                                      ) ==
                                                                      0
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (quantitySold > 10)
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  10.0,
                                                                ),
                                                              ),
                                                        ),
                                                    title: Text(
                                                      "Hot item",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Upon reaching more than 10 sales this month.",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text(
                                                          "Close",
                                                          style:
                                                              GoogleFonts.inter(),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                              ),
                                              child: Text(
                                                'HOT ITEM',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: numofpage,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final isCurrentPage = (curpage - 1) == index;
                                  final color =
                                      isCurrentPage
                                          ? Colors.black
                                          : Colors.grey;

                                  return TextButton(
                                    onPressed: () {
                                      curpage = index + 1;
                                      loadProducts(searchController.text);
                                    },
                                    child: Text(
                                      (index + 1).toString(),
                                      style: GoogleFonts.inter(color: color),
                                    ),
                                  );
                                },
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

  String truncateString(String str) {
    if (str.length > 50) {
      str = str.substring(0, 50);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadProducts(String title) {
    http
        .get(
          Uri.parse(
            "${MyServerConfig.server}/pomm/php/load_products.php?title=$title&pageno=$curpage",
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              productList.clear();
              data['data']['products'].forEach((v) {
                productList.add(Product.fromJson(v));
              });
              numofpage = int.parse(data['numofpage'].toString());
              numofresult = int.parse(data['numberofresult'].toString());
            } else {
              productList.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Product not found",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() {});
          }
        });
  }

  Future<void> loadPriceProductsAsc(
    String searchQuery, {
    required String sortOrder,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_filtered_products_asc.php",
        ),
        body: {
          'title': title,
          'pageno': curpage.toString(),
          'sortOrder': sortOrder, // NEW PARAM
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          productList.clear();
          data['data']['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
        } else {
          productList.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Product not found", style: GoogleFonts.inter()),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {});
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  Future<void> loadPriceProductsDesc(
    String searchQuery, {
    required String sortOrder,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_filtered_products_desc.php",
        ),
        body: {
          'title': title,
          'pageno': curpage.toString(),
          'sortOrder': sortOrder, // NEW PARAM
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          productList.clear();
          data['data']['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
        } else {
          productList.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Product not found", style: GoogleFonts.inter()),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {});
      }
    } catch (e) {
      print("Error loading products: $e");
    }
  }
}

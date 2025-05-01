import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/product/addproductpage.dart';
import 'package:pomm/views/admin/product/productdetailadminpage.dart';
import 'package:pomm/views/loginclerkadminpage.dart';

class ProductAdminPage extends StatefulWidget {
  final Admin admin;
  const ProductAdminPage({super.key, required this.admin});

  @override
  State<ProductAdminPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductAdminPage> {
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

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts(title);
    loadHotProductSales();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Admin Dashboard",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2.5),
                Text(
                  "Utara Gadget Solution Store",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 18, right: 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (content) => LoginClerkAdminPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ],
        ),
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  loadProducts(title);
                },
                child:
                    productList.isEmpty
                        ? Center(
                          child: Text(
                            "No product's data",
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
                                      product.productId
                                          .toString(); // update if needed
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
                                                        ProductDetailAdminPage(
                                                          admin: widget.admin,
                                                          product: product,
                                                        ),
                                              ),
                                            );
                                            loadProducts(title);
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
                                                      "Upon reaching more than 10 sales this month",
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
                                      loadProducts(title);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
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
}

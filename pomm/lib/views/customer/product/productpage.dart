import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pomm/models/customer.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/shared/myserverconfig.dart';
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
  String title = "";
  late List<Widget> tabchildren;
  String maintitle = "Product";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts(title);
  }

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;
    // axiscount = screenWidth > 500 ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Product",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.black, // Maroon color
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => CartPage(customer: widget.customerdata),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
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
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    curpage = 1;
                    loadProducts(value);
                  },
                  style: GoogleFonts.inter(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    hintText: 'Search products',
                    hintStyle: GoogleFonts.inter(
                      color: Colors.black45,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
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
                            style: GoogleFonts.inter(fontSize: 15),
                          ),
                        )
                        : Column(
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: axiscount,
                                childAspectRatio: 0.85,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 5,
                                padding: const EdgeInsets.all(12),
                                children: List.generate(productList.length, (
                                  index,
                                ) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
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
                                                (content) => ProductDetailsPage(
                                                  customerdata:
                                                      widget.customerdata,
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
                                              child: Image.network(
                                                "${MyServerConfig.server}/pomm/assets/products/${productList[index].productId}.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    truncateString(
                                                      productList[index]
                                                          .productTitle
                                                          .toString(),
                                                    ),
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    "RM${productList[index].productPrice}",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${productList[index].productQty} available",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: Colors.red,
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
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 16,
                                      ),
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
    if (str.length > 20) {
      str = str.substring(0, 20);
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
          log(response.body);
          if (response.statusCode == 200) {
            log(response.body);
            var data = jsonDecode(response.body);
            if (data['status'] == "success") {
              productList.clear();
              data['data']['products'].forEach((v) {
                productList.add(Product.fromJson(v));
              });
              numofpage = int.parse(data['numofpage'].toString());
              numofresult = int.parse(data['numberofresult'].toString());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product not found"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
          setState(() {});
        });
  }
}

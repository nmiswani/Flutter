import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  String maintitle = "Product";
  late List<Widget> tabchildren;

  List<Product> productList = <Product>[];
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  int axiscount = 2;
  var color;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    axiscount = (screenWidth > 500) ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 55, 97, 70),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 55, 97, 70),
          elevation: 0.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Admin's Dashboard",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Utara Gadget Solution Store, UUM",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Material(
              elevation: 1.5,
              shadowColor: Colors.black87,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  curpage = 1; // Reset to first page when searching
                  loadProducts(value);
                },
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: 'Search product...',
                  hintStyle: GoogleFonts.poppins(color: Colors.black45),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 227, 227, 227),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                loadProducts(searchController.text);
              },
              child:
                  productList.isEmpty
                      ? Center(
                        child: Text(
                          "No product's data",
                          style: GoogleFonts.poppins(),
                        ),
                      )
                      : Column(
                        children: [
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: axiscount,
                              childAspectRatio: 0.8,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              padding: const EdgeInsets.all(12),
                              children: List.generate(productList.length, (
                                index,
                              ) {
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      Product product = Product.fromJson(
                                        productList[index].toJson(),
                                      );
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  ProductDetailAdminPage(
                                                    admin: widget.admin,
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
                                          flex: 3,
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
                                                const SizedBox(height: 5),
                                                Text(
                                                  truncateString(
                                                    productList[index]
                                                        .productTitle
                                                        .toString(),
                                                  ),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  "RM${productList[index].productPrice}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "${productList[index].productQty} available",
                                                  style: GoogleFonts.poppins(
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
                                color =
                                    ((curpage - 1) == index)
                                        ? Colors.black
                                        : Colors.grey;
                                return TextButton(
                                  onPressed: () {
                                    curpage = index + 1;
                                    loadProducts(searchController.text);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginClerkAdminPage()),
      (route) => false,
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
                const SnackBar(
                  content: Text("Product not found"),
                  backgroundColor: Colors.red,
                ),
              );
            }
            setState(() {});
          }
        });
  }
}

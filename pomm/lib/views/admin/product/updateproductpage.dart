import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/admin.dart';
import 'dart:convert';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/models/product.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;
  final Admin admin;
  const UpdateProductPage({
    super.key,
    required this.product,
    required this.admin,
  });

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  var val = 50;
  Random random = Random();
  bool isDisable = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.productTitle ?? "";
    _descriptionController.text = widget.product.productDesc ?? "";
    _priceController.text = widget.product.productPrice?.toString() ?? "";
    _quantityController.text = widget.product.productQty?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Product"),
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                elevation: 3,
                child: SizedBox(
                  height: screenHeight / 3,
                  width: screenWidth * 0.9,
                  child: CachedNetworkImage(
                    imageUrl:
                        "${MyServerConfig.server}/pomm/assets/products/${widget.product.productId}.jpg",
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, size: 50),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator:
                          (val) =>
                              val == null || val.length < 3
                                  ? "Product name must be at least 3 characters"
                                  : null,
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        icon: Icon(Icons.abc),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator:
                          (val) =>
                              val == null || val.length < 10
                                  ? "Product description must be at least 10 characters"
                                  : null,
                      maxLines: 3,
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Product Description',
                        icon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? "Enter a valid price"
                                        : null,
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Product Price',
                              icon: Icon(Icons.money),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            validator:
                                (val) =>
                                    val == null ||
                                            val.isEmpty ||
                                            int.tryParse(val) == null ||
                                            int.parse(val) <= 0
                                        ? "Quantity must be greater than 0"
                                        : null,
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              icon: Icon(Icons.numbers),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: updateDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            55,
                            97,
                            70,
                          ),
                        ),
                        child: const Text(
                          "Update Product",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text("Update product?", style: TextStyle()),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                updateProduct();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text("No", style: TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateProduct() {
    String productname = _nameController.text;
    String productdescription = _descriptionController.text;
    String productprice = _priceController.text;
    String productquantity = _quantityController.text;

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/update_product.php"),
          body: {
            "productid": widget.product.productId,
            "productname": productname,
            "productdescription": productdescription,
            "productprice": productprice,
            "productquantity": productquantity,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Update Product Success")),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Update Failed")));
            }
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Update Failed")));
            Navigator.pop(context);
          }
        });
  }
}

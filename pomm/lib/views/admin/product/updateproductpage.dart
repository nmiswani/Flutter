import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/models/product.dart';
import 'package:pomm/views/admin/admindashboard.dart';

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

  File? _image;
  var val = 50;
  Random random = Random();
  bool isDisable = false;
  int randomValue = Random().nextInt(100000);

  late String originalName;
  late String originalDescription;
  late String originalPrice;
  late String originalQuantity;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.productTitle ?? "";
    _descriptionController.text = widget.product.productDesc ?? "";
    _priceController.text = widget.product.productPrice?.toString() ?? "";
    _quantityController.text = widget.product.productQty?.toString() ?? "";

    // Simpan nilai asal
    originalName = _nameController.text;
    originalDescription = _descriptionController.text;
    originalPrice = _priceController.text;
    originalQuantity = _quantityController.text;
  }

  bool isDataChanged() {
    return _nameController.text != originalName ||
        _descriptionController.text != originalDescription ||
        _priceController.text != originalPrice ||
        _quantityController.text != originalQuantity;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Update Product",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isDataChanged()) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboardPage(admin: widget.admin),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Card(
                elevation: 3,
                child: SizedBox(
                  height: screenHeight / 3,
                  width: screenWidth * 0.91,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${MyServerConfig.server}/pomm/assets/products/${widget.product.productId}.jpg?v=$randomValue",
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error, size: 50),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: isDisable ? null : _updateImageDialog,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    buildStyledTextFormField(
                      controller: _nameController,
                      label: 'Product Name',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is required';
                        } else if (!RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(val)) {
                          return 'Only letters, numbers, and spaces allowed';
                        } else if (val.length > 15) {
                          return 'Must be no more than 15 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      allowOnlyTextAndNumbers: true,
                    ),

                    const SizedBox(height: 15),
                    buildStyledTextFormField(
                      controller: _descriptionController,
                      label: 'Product Description',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is required';
                        } else if (!RegExp(
                          r'^[a-zA-Z0-9\s.,()@%&/]+$',
                        ).hasMatch(val)) {
                          return 'Only letters, numbers, spaces and dot (.) allowed';
                        } else if (val.length < 15) {
                          return 'Must be at least 15 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      allowTextNumberDot: true,
                    ),

                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: buildStyledTextFormField(
                            controller: _priceController,
                            label: "Product Price",
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? "Enter a valid price"
                                        : null,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: buildStyledTextFormField(
                            controller: _quantityController,
                            label: "Quantity",
                            validator:
                                (val) =>
                                    val == null ||
                                            val.isEmpty ||
                                            int.tryParse(val) == null ||
                                            int.parse(val) <= 0
                                        ? "Greater than 0"
                                        : null,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    SizedBox(
                      width: screenWidth * 1,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: updateDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Update Product",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.white,
                          ),
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

  Widget buildStyledTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    int maxLines = 1,
    bool allowOnlyTextAndNumbers = false, // for Product Name
    bool allowTextNumberDot = false, // for Product Description
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters:
          allowOnlyTextAndNumbers
              ? [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
              ] // No dot
              : allowTextNumberDot
              ? [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9\s.,()@%&/]'),
                ),
              ] // Allow dot
              : null,
      style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: GoogleFonts.inter(fontSize: 12, color: Colors.red),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  _updateImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Select from",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed:
                    () => {Navigator.of(context).pop(), _galleryPicker()},
                icon: const Icon(Icons.browse_gallery),
                label: Text("Gallery", style: GoogleFonts.inter()),
              ),
              TextButton.icon(
                onPressed: () => {Navigator.of(context).pop(), _cameraPicker()},
                icon: const Icon(Icons.camera_alt),
                label: Text("Camera", style: GoogleFonts.inter()),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _galleryPicker() async => _pickImage(ImageSource.gallery);
  Future<void> _cameraPicker() async => _pickImage(ImageSource.camera);

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image selected", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    File imageFile = File(pickedFile.path);

    if (!await imageFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Image file does not exist",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _image = imageFile;
    });
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
      _updateProductImage();
    }
  }

  Future<void> _updateProductImage() async {
    if (_image == null) {
      return;
    }
    File imageFile = File(_image!.path);
    print(imageFile);
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http
        .post(
          Uri.parse(
            "${MyServerConfig.server}/pomm/php/update_product_image.php",
          ),
          body: {
            "productid": widget.product.productId.toString(),
            "image": base64Image.toString(),
          },
        )
        .then((response) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            val = random.nextInt(1000);
            setState(() {
              randomValue = Random().nextInt(100000);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Product image updated successful",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update product image",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
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
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Update product",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure want to update?",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.inter()),
              onPressed: () {
                updateProduct();
              },
            ),
            TextButton(
              child: Text("No", style: GoogleFonts.inter()),
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

    bool isChanged =
        productname != widget.product.productTitle ||
        productdescription != widget.product.productDesc ||
        productprice != widget.product.productPrice?.toString() ||
        productquantity != widget.product.productQty?.toString();

    if (!isChanged) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No changes made to the product",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
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
                SnackBar(
                  content: Text(
                    "Product updated successful",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to update product",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update product",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
          }
        });
  }
}

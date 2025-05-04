import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomm/shared/myserverconfig.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _updateImageDialog,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 3,
                  child: SizedBox(
                    height: screenHeight / 3,
                    width: screenWidth * 0.91,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image:
                              _image != null
                                  ? FileImage(_image!) as ImageProvider
                                  : AssetImage(pathAsset),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child:
                          _image == null ? const Center(child: Text("")) : null,
                    ),
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
                      icon: Icons.abc,
                      validator:
                          (val) =>
                              val == null || val.length > 15
                                  ? "Product name must be no more than 15 characters"
                                  : null,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    buildStyledTextFormField(
                      controller: _descriptionController,
                      label: 'Product Description',
                      icon: Icons.description,
                      validator:
                          (val) =>
                              val == null || val.length < 15
                                  ? "Product description must be at least 10 characters"
                                  : null,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: buildStyledTextFormField(
                            controller: _priceController,
                            label: 'Product Price',
                            icon: Icons.money,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? "Enter a valid price"
                                        : null,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildStyledTextFormField(
                            controller: _quantityController,
                            label: 'Quantity',
                            icon: Icons.numbers,
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
                    const SizedBox(height: 42),
                    SizedBox(
                      width: screenWidth * 1,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: addDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Add Product",
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

  // Custom styled TextFormField widget
  Widget buildStyledTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: GoogleFonts.inter(fontSize: 12, color: Colors.red),
        icon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color.fromARGB(255, 236, 231, 231),
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
      File imageFile = File(croppedFile.path);
      _image = imageFile;

      setState(() {});
    }
  }

  void addDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Check your input", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please take picture", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
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
            "Add new product",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure want to add?",
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
                addProduct();
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

  void addProduct() {
    String productname = _nameController.text;
    String productdescription = _descriptionController.text;
    String productprice = _priceController.text;
    String productquantity = _quantityController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());

    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/add_product.php"),
          body: {
            "productname": productname,
            "productdescription": productdescription,
            "productprice": productprice,
            "productquantity": productquantity,
            "image": base64Image,
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            if (jsondata['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Product added successful",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to add product",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to add product",
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

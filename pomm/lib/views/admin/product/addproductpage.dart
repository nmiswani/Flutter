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
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      resizeToAvoidBottomInset:
          false, // prevents layout shift when keyboard opens
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80), // space for button
            child: Column(
              children: [
                GestureDetector(
                  onTap: _updateImageDialog,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                    child: Card(
                      elevation: 3,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image:
                                _image != null
                                    ? FileImage(_image!) as ImageProvider
                                    : AssetImage(pathAsset),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:
                            _image == null
                                ? const Center(child: Text(""))
                                : null,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        // keep this for form overflow
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.poppins(), // Apply font style
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
                              style: GoogleFonts.poppins(),
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
                                    style: GoogleFonts.poppins(),
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
                                    textInputAction: TextInputAction.next,
                                    style: GoogleFonts.poppins(),
                                    validator:
                                        (val) =>
                                            val == null ||
                                                    val.isEmpty ||
                                                    int.tryParse(val) == null ||
                                                    int.parse(val) <= 0
                                                ? "Greater than 0"
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed button at bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  addDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Add Product",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Select from",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed:
                    () => {Navigator.of(context).pop(), _galleryPicker()},
                icon: const Icon(Icons.browse_gallery),
                label: Text("Gallery", style: GoogleFonts.poppins()),
              ),
              TextButton.icon(
                onPressed: () => {Navigator.of(context).pop(), _cameraPicker()},
                icon: const Icon(Icons.camera_alt),
                label: Text("Camera", style: GoogleFonts.poppins()),
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
          content: Text("No image selected", style: GoogleFonts.poppins()),
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
            style: GoogleFonts.poppins(),
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
          toolbarColor: const Color.fromARGB(255, 55, 97, 70),
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
          content: Text("Check your input", style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please take picture", style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Add new product?",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text("Are you sure?", style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text("Yes", style: GoogleFonts.poppins()),
              onPressed: () {
                Navigator.of(context).pop();
                addProduct();
              },
            ),
            TextButton(
              child: Text("No", style: GoogleFonts.poppins()),
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
                    "Add product successful",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Add product failed",
                    style: GoogleFonts.poppins(),
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
                  "Add product failed",
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
          }
        });
  }
}

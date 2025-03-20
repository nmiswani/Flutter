import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
        title: const Text("Add Product"),
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _updateImageDialog,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
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
                        _image == null ? const Center(child: Text("")) : null,
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
                            textInputAction: TextInputAction.next,
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
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: addDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            55,
                            97,
                            70,
                          ),
                        ),
                        child: const Text(
                          "Add Product",
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

  _updateImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text(
            "Select from",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed:
                    () => {Navigator.of(context).pop(), _galleryPicker()},
                icon: const Icon(Icons.browse_gallery),
                label: const Text("Gallery"),
              ),
              TextButton.icon(
                onPressed: () => {Navigator.of(context).pop(), _cameraPicker()},
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No image selected")));
      return;
    }

    File imageFile = File(pickedFile.path);

    if (!await imageFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image file does not exist")),
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
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text("Add new product?", style: TextStyle()),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle()),
              onPressed: () {
                Navigator.of(context).pop();
                addProduct();
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
                const SnackBar(content: Text("Add Product Successful")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Add Product Failed")),
              );
            }
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Add Product Failed")));
            Navigator.pop(context);
          }
        });
  }
}

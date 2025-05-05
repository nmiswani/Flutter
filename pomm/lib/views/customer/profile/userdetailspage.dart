import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';

import 'dart:convert';
import 'dart:math';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomm/views/customer/customerprofiledashboard.dart';

class UserDetailsPage extends StatefulWidget {
  final Customer customerdata;
  const UserDetailsPage({super.key, required this.customerdata});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  late double screenWidth, screenHeight;
  File? _image;
  var val = 50;
  Random random = Random();
  bool isDisable = false;
  int randomValue = Random().nextInt(100000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 231, 231),
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CustomerProfileDashboardPage(
                      customerdata: widget.customerdata,
                    ),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "${MyServerConfig.server}/pomm/assets/profileimages/${widget.customerdata.customerid}.jpg?v=$randomValue",
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) => Image.network(
                              "${MyServerConfig.server}/pomm/assets/profileimages/default_profile.jpg",
                              scale: 2,
                              fit: BoxFit.cover,
                            ),
                        fit: BoxFit.cover,
                        width: 130,
                        height: 130,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: isDisable ? null : _updateImageDialog,
                      child: Text(
                        "Edit",
                        style: GoogleFonts.inter(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _profileItem(
                "Name",
                widget.customerdata.customername ?? "Unknown",
                () => _updateProfileDialog("name"),
              ),
              _profileItem(
                "Email",
                widget.customerdata.customeremail ?? "example@email.com",
                () => _updateProfileDialog("email"),
              ),
              _profileItem(
                "Phone number",
                widget.customerdata.customerphone ?? "Unknown",
                () => _updateProfileDialog("phone number"),
              ),
              _profileItem(
                "Password",
                "********",
                () => _updateProfileDialog("password"),
                isLink: true,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(
    String label,
    String value,
    VoidCallback onTap, {
    bool isLink = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "     $label",
          style: GoogleFonts.inter(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: isLink ? Colors.green : Colors.black,
                    fontSize: 14,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _updateProfileDialog(String infoType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Update $infoType",
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (infoType == "name") ...[
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'New name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: GoogleFonts.inter(fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new name';
                      }
                      return null;
                    },
                  ),
                ] else if (infoType == "email") ...[
                  TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'New email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: GoogleFonts.inter(fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new email';
                      }
                      return null;
                    },
                  ),
                ] else if (infoType == "phone number") ...[
                  TextFormField(
                    controller: _phoneController,
                    style: GoogleFonts.inter(fontSize: 14),
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'New phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: GoogleFonts.inter(fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new phone number';
                      }
                      return null;
                    },
                  ),
                ] else if (infoType == "password") ...[
                  TextFormField(
                    controller: _oldpasswordController,
                    style: GoogleFonts.inter(fontSize: 14),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Old password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: GoogleFonts.inter(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newpasswordController,
                    style: GoogleFonts.inter(fontSize: 14),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: GoogleFonts.inter(fontSize: 14),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm", style: GoogleFonts.inter()),
              onPressed: () {
                Navigator.of(context).pop();
                if (infoType == "name") {
                  _updateName(_nameController.text);
                } else if (infoType == "email") {
                  _updateEmail(_emailController.text);
                } else if (infoType == "phone number") {
                  _updatePhone(_phoneController.text);
                } else if (infoType == "password") {
                  changePass();
                }
              },
            ),
          ],
        );
      },
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
      _updateProfileImage();
    }
  }

  Future<void> _updateProfileImage() async {
    if (_image == null) {
      return;
    }
    File imageFile = File(_image!.path);
    print(imageFile);
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    // print(base64Image);
    http
        .post(
          Uri.parse(
            "${MyServerConfig.server}/pomm/php/update_profile_image.php",
          ),
          body: {
            "customerid": widget.customerdata.customerid.toString(),
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
                  "Profile image updated successful",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update profile image",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  void _updateName(String newname) {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/update_profile.php"),
          body: {
            "customerid": widget.customerdata.customerid,
            "newname": newname,
          },
        )
        .then((response) {
          var jsondata = jsonDecode(response.body);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            setState(() {
              widget.customerdata.customername = newname;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Name updated successful",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update name",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  void _updateEmail(String newemail) {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/update_profile.php"),
          body: {
            "customerid": widget.customerdata.customerid,
            "newemail": newemail,
          },
        )
        .then((response) {
          var jsondata = jsonDecode(response.body);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            setState(() {
              widget.customerdata.customeremail = newemail;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Email updated successful",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Update failed or email is already in use",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  void _updatePhone(String newphone) {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/update_profile.php"),
          body: {
            "customerid": widget.customerdata.customerid,
            "newphone": newphone,
          },
        )
        .then((response) {
          var jsondata = jsonDecode(response.body);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            setState(() {
              widget.customerdata.customerphone = newphone;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Phone number updated successful",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update phone number",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }

  void changePass() {
    http
        .post(
          Uri.parse("${MyServerConfig.server}/pomm/php/update_profile.php"),
          body: {
            "customerid": widget.customerdata.customerid,
            "oldpass": _oldpasswordController.text,
            "newpass": _newpasswordController.text,
          },
        )
        .then((response) {
          var jsondata = jsonDecode(response.body);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Password updated successful",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update password",
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}

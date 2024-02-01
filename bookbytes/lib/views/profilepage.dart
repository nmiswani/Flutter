import 'dart:convert';
import 'package:bookbytes/shared/mydrawer.dart';
import 'package:bookbytes/shared/myserverconfig.dart';
import 'package:bookbytes/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  final User userdata;
  const ProfilePage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(),
      ),
      drawer: MyDrawer(
        page: 'profile',
        userdata: widget.userdata,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 78,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      "${MyServerConfig.server}/bookbytes/assets/profileimages/${widget.userdata.userid}.jpg",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Card(
                color: const Color.fromARGB(255, 255, 234, 217),
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                elevation: 1.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    alignment: Alignment.center,
                    width: 40, // Adjust the width as needed
                    child: const Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                  subtitle: Text(
                    widget.userdata.username.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _updateProfileDialog("name");
                    },
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 255, 234, 217),
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                elevation: 1.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    alignment: Alignment.center,
                    width: 40, // Adjust the width as needed
                    child: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                  subtitle: Text(
                    widget.userdata.useremail.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _updateProfileDialog("email");
                    },
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 255, 234, 217),
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                elevation: 1.5,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    alignment: Alignment.center,
                    width: 40, // Adjust the width as needed
                    child: const Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                  subtitle: Text(
                    widget.userdata.userphone.toString(),
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _updateProfileDialog("phone number");
                    },
                  ),
                ),
              ),
              Card(
                color: const Color.fromARGB(255, 255, 234, 217),
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    alignment: Alignment.center,
                    width: 40, // Adjust the width as needed
                    child: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                  subtitle: const Text(
                    "********",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _updateProfileDialog("password");
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  margin:
                      const EdgeInsets.only(top: 6), // Add margin for spacing
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (content) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfileDialog(String infoType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Update $infoType?",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (infoType == "name") ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'New name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new name';
                      }
                      return null;
                    },
                  ),
                ] else if (infoType == "email") ...[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'New email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new email';
                      }
                      return null;
                    },
                  ),
                ] else if (infoType == "phone number") ...[
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'New phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new phone number';
                      }
                      return null;
                    },
                  ),
                ] else if (infoType == "password") ...[
                  TextFormField(
                    controller: _oldpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Old password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newpasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
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
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _updateName(String newname) {
    http.post(
      Uri.parse("${MyServerConfig.server}/bookbytes/php/update_profile.php"),
      body: {
        "userid": widget.userdata.userid,
        "newname": newname,
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        setState(() {
          widget.userdata.username = newname;
        });
        _showSnackBar("Name updated successfully", true);
      } else {
        _showSnackBar("Failed to update name", false);
      }
    });
  }

  void _updateEmail(String newemail) {
    http.post(
      Uri.parse("${MyServerConfig.server}/bookbytes/php/update_profile.php"),
      body: {
        "userid": widget.userdata.userid,
        "newemail": newemail,
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        setState(() {
          widget.userdata.useremail = newemail;
        });
        _showSnackBar("Email updated successfully", true);
      } else {
        _showSnackBar("Failed to update email", false);
      }
    });
  }

  void _updatePhone(String newphone) {
    http.post(
      Uri.parse("${MyServerConfig.server}/bookbytes/php/update_profile.php"),
      body: {
        "userid": widget.userdata.userid,
        "newphone": newphone,
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        setState(() {
          widget.userdata.userphone = newphone;
        });
        _showSnackBar("Phone number updated successfully", true);
      } else {
        _showSnackBar("Failed to update phone number", false);
      }
    });
  }

  void changePass() {
    http.post(
      Uri.parse("${MyServerConfig.server}/bookbytes/php/update_profile.php"),
      body: {
        "userid": widget.userdata.userid,
        "oldpass": _oldpasswordController.text,
        "newpass": _newpasswordController.text,
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        _showSnackBar("Password updated successfully", true);
      } else {
        _showSnackBar("Failed to update password", false);
      }
    });
  }
}

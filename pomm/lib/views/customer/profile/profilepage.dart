import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/customer/loginregister/logincustomerpage.dart';
import 'package:pomm/views/customer/profile/aboutuspage.dart';
import 'package:pomm/views/customer/profile/userdetailspage.dart';
import 'package:pomm/views/customer/profile/helppage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final Customer customerdata;
  const ProfilePage({super.key, required this.customerdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  int randomValue = Random().nextInt(100000);

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    String customerId = widget.customerdata.customerid.toString();

    try {
      final response = await http.post(
        Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_profile.php?customerid=$customerId",
        ),
        body: {},
      );
      if (response.statusCode == 200) {
        var customer = jsonDecode(response.body);
        print(response.body);
        if (customer['status'] == "success") {
          setState(() {
            widget.customerdata.customername = customer['customer_name'];
            widget.customerdata.customeremail = customer['customer_email'];

            print(customer['customer_name']);
            print(customer['customer_email']);
          });
        } else {
          setState(() {});
        }
      } else {
        print("Server error: ${response.statusCode}");
        throw Exception("Server returned status code ${response.statusCode}");
      }
    } catch (error) {
      print("Error loading profile data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "An error occurred while loading profile",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 231, 231),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  imageUrl:
                      "${MyServerConfig.server}/pomm/assets/profileimages/${widget.customerdata.customerid}.jpg?v=$randomValue",
                  placeholder:
                      (context, url) => const SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Image.network(
                        "${MyServerConfig.server}/pomm/assets/profileimages/default_profile.jpg",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                widget.customerdata.customername ?? 'Unknown',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                widget.customerdata.customeremail ?? 'Unknown',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
              ),
              trailing: const Icon(Icons.qr_code, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            UserDetailsPage(customerdata: widget.customerdata),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          _optionCard([
            _optionTile(Icons.info_outline, "About Us", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsPage()),
              );
            }),
            _dividerLine(),
            _optionTile(Icons.help_outline, "Help", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpPage()),
              );
            }),
          ]),
          const SizedBox(height: 4),
          _optionCard([
            _optionTile(Icons.logout, "Logout", () {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginCustomerPage(),
                  ),
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "You have been logged out",
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            }),
          ]),
        ],
      ),
    );
  }

  Widget _optionCard(List<Widget> children) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(children: children),
    );
  }

  Widget _optionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _dividerLine() {
    return const Divider(
      height: 0.5,
      color: Colors.grey,
      indent: 15,
      endIndent: 15,
    );
  }
}

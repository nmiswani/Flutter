import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'chatadminpage.dart';

class ChatListAdminPage extends StatefulWidget {
  final Admin admin;

  const ChatListAdminPage({super.key, required this.admin});

  @override
  _ChatListAdminPageState createState() => _ChatListAdminPageState();
}

class _ChatListAdminPageState extends State<ChatListAdminPage> {
  List<Customer> customers = [];
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    loadChatCustomers();

    refreshTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel(); // Optional: double protection
        return;
      }
      loadChatCustomers();
    });
  }

  @override
  void dispose() {
    // Cancel timer when exiting the page
    refreshTimer?.cancel();
    super.dispose();
  }

  void loadChatCustomers() async {
    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/get_chat_users.php"),
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (!mounted) return; // ✅ Tambah baris ini
      setState(() {
        customers = List<Customer>.from(
          jsonData.map((data) => Customer.fromJson(data)),
        );
      });
    } else {
      print("Error loading chat customers");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: AppBar(
        title: Text(
          "Customer Chat List",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          customers.isEmpty
              ? Center(
                child: Text("No customers found", style: GoogleFonts.inter()),
              )
              : ListView.separated(
                itemCount: customers.length,
                separatorBuilder:
                    (context, index) => Divider(
                      thickness: 0.8,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  Customer customer = customers[index];
                  // int randomValue = Random().nextInt(10000);
                  String profileUrl =
                      "${MyServerConfig.server}/pomm/assets/profileimages/${customer.customerid}.jpg";
                  String defaultProfile =
                      "${MyServerConfig.server}/pomm/assets/profileimages/default_profile.jpg";

                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[300],
                          child: ClipOval(
                            child: Image.network(
                              profileUrl,
                              fit: BoxFit.cover,
                              width: 44,
                              height: 44,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  defaultProfile,
                                  fit: BoxFit.cover,
                                  width: 44,
                                  height: 44,
                                );
                              },
                            ),
                          ),
                        ),
                        if (customer.unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      customer.customername ?? '',
                      style: GoogleFonts.inter(fontSize: 15),
                    ),
                    subtitle: Text(
                      customer.customeremail ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatAdminPage(
                                admin: widget.admin,
                                customerdata: customer,
                              ),
                        ),
                      ).then((_) {
                        loadChatCustomers(); // Refresh after returning
                      });
                    },
                  );
                },
              ),
    );
  }
}

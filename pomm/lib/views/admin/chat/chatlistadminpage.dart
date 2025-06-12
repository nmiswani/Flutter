import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'chatadminpage.dart'; // import chat page

class ChatListAdminPage extends StatefulWidget {
  final Admin admin;

  const ChatListAdminPage({super.key, required this.admin});

  @override
  _ChatListAdminPageState createState() => _ChatListAdminPageState();
}

class _ChatListAdminPageState extends State<ChatListAdminPage> {
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    loadChatCustomers();
  }

  void loadChatCustomers() async {
    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/get_chat_users.php"),
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
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
      appBar: AppBar(title: Text("Customer Chat List")),
      body:
          customers.isEmpty
              ? Center(child: Text("No customers found."))
              : ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  Customer customer = customers[index];
                  return ListTile(
                    title: Text(customer.customername ?? ''),
                    subtitle: Text("ID: ${customer.customerid}"),
                    trailing: Icon(Icons.chat),
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
                      );
                    },
                  );
                },
              ),
    );
  }
}

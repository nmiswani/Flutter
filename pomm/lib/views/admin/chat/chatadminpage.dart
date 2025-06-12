import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Tambah ini
import 'package:pomm/models/admin.dart';
import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';

class ChatAdminPage extends StatefulWidget {
  final Admin admin;
  final Customer customerdata;

  const ChatAdminPage({
    super.key,
    required this.admin,
    required this.customerdata,
  });

  @override
  _ChatAdminPageState createState() => _ChatAdminPageState();
}

class _ChatAdminPageState extends State<ChatAdminPage> {
  List messages = [];
  TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted) return timer.cancel(); // Stop jika page ditutup
      fetchMessages();
    });
  }

  void fetchMessages() async {
    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/get_messages.php"),
      body: {
        "customer_id": widget.customerdata.customerid,
        "admin_id": widget.admin.adminid,
      },
    );

    if (response.statusCode == 200) {
      try {
        var jsonData = json.decode(response.body);
        setState(() {
          messages = jsonData;
        });
      } catch (e) {
        print("JSON parse error: ${response.body}");
      }
    } else {
      print("HTTP error: ${response.statusCode}");
    }
  }

  void sendMessage() async {
    String messageText = _msgController.text.trim();
    if (messageText.isEmpty) return;

    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/send_message.php"),
      body: {
        "customer_id": widget.customerdata.customerid,
        "admin_id": widget.admin.adminid,
        "sender_role": "admin",
        "message": messageText,
      },
    );

    if (response.statusCode == 200 && response.body.trim() == "success") {
      _msgController.clear();
      fetchMessages();
    } else {
      print("Failed to send message: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.customerdata.customername}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var msg = messages[index];
                bool isMe = msg['sender_role'] == 'admin';

                DateTime dateTime = DateTime.parse(msg['chat_date']);
                String fullDate = DateFormat('yyyy-MM-dd').format(dateTime);
                String displayTime = DateFormat('hh:mm a').format(dateTime);

                bool showDateHeader = true;
                if (index > 0) {
                  DateTime prevDateTime = DateTime.parse(
                    messages[index - 1]['chat_date'],
                  );
                  String prevDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(prevDateTime);
                  showDateHeader = fullDate != prevDate;
                }

                return Column(
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat('dd MMM yyyy').format(dateTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment:
                            isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? Colors.green[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(msg['message']),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Text(
                              displayTime,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(hintText: "Type a message..."),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

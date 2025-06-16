import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:pomm/models/customer.dart';
import 'package:pomm/shared/myserverconfig.dart';

class ChatCustomerPage extends StatefulWidget {
  final Customer customerdata;

  const ChatCustomerPage({super.key, required this.customerdata});

  @override
  _ChatCustomerPageState createState() => _ChatCustomerPageState();
}

class _ChatCustomerPageState extends State<ChatCustomerPage> {
  List messages = [];
  TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted) return timer.cancel();
      fetchMessages();
    });
  }

  void fetchMessages() async {
    int oldLength = messages.length;

    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/get_messages.php"),
      body: {"customer_id": widget.customerdata.customerid, "admin_id": "1"},
    );

    if (response.statusCode == 200) {
      try {
        var jsonData = json.decode(response.body);
        if (!mounted) return;

        setState(() {
          messages = jsonData;
        });

        if (jsonData.length > oldLength) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      } catch (e) {
        print("Error parsing messages: $e");
      }
    } else {
      print("HTTP error ${response.statusCode}");
    }
  }

  void sendMessage() async {
    String messageText = _msgController.text.trim();
    if (messageText.isEmpty) return;

    var response = await http.post(
      Uri.parse("${MyServerConfig.server}/pomm/php/send_message.php"),
      body: {
        "customer_id": widget.customerdata.customerid,
        "admin_id": "1",
        "sender_role": "customer",
        "message": messageText,
      },
    );

    if (response.statusCode == 200 && response.body.trim() == "success") {
      _msgController.clear();
      fetchMessages();
    } else {
      print("Failed to send message");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Chat with Seller",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var msg = messages[index];
                bool isCustomer = msg['sender_role'] == 'customer';

                DateTime dateTime = DateTime.parse(msg['chat_date']);
                String displayDate = DateFormat('dd MMM yyyy').format(dateTime);
                String displayTime = DateFormat('hh:mm a').format(dateTime);

                bool showDateHeader = true;
                if (index > 0) {
                  DateTime prevDate = DateTime.parse(
                    messages[index - 1]['chat_date'],
                  );
                  showDateHeader =
                      DateFormat('yyyy-MM-dd').format(prevDate) !=
                      DateFormat('yyyy-MM-dd').format(dateTime);
                }

                return Column(
                  crossAxisAlignment:
                      isCustomer
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              displayDate,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Slidable(
                        key: ValueKey(index),
                        direction: Axis.horizontal,
                        startActionPane:
                            !isCustomer
                                ? ActionPane(
                                  motion: BehindMotion(),
                                  extentRatio: 0.3,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        displayTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : null,
                        endActionPane:
                            isCustomer
                                ? ActionPane(
                                  motion: BehindMotion(),
                                  extentRatio: 0.3,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 50.0,
                                      ),
                                      child: Text(
                                        displayTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : null,
                        child: Align(
                          alignment:
                              isCustomer
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isCustomer
                                      ? Colors.blue[100]
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg['message'],
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: GoogleFonts.inter(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.black),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

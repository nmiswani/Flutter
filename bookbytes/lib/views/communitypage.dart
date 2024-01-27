import 'package:flutter/material.dart';

import '../models/user.dart';
import '../shared/mydrawer.dart';

class CommunityPage extends StatefulWidget {
  final User userdata;

  const CommunityPage({super.key, required this.userdata});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Row(
            children: [
              Text(
                "Community Page",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          )),
      drawer: MyDrawer(
        page: "community",
        userdata: widget.userdata,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/communitypage.png', // Replace with your image asset path
              height: 300, // Adjust the height as needed
              width: 300, // Adjust the width as needed
            ),
            const SizedBox(height: 20),
            const Text(
              "Community Page",
              style: TextStyle(
                fontSize: 20, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

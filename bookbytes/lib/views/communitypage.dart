import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';
import '../shared/mydrawer.dart';

class CommunityPage extends StatefulWidget {
  final User userdata;

  const CommunityPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final String phoneNumber =
      '+0192793200'; // Replace with the actual phone number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              "Community",
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
        ),
      ),
      drawer: MyDrawer(
        page: "community",
        userdata: widget.userdata,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome ${widget.userdata.username}\n to BookBytes Community!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "Step into the vibrant world of BookBytes, where readers unite on the illustrious BookBytes Community Page. Here, the magic of words comes alive, weaving a tapestry of shared stories, diverse perspectives, and boundless imagination. Picture a cozy corner online, adorned with shelves of literary treasures and the whispers of countless tales. This is where readers from every corner of the globe converge, not just as book enthusiasts but as a vibrant community of wordsmiths.",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // Add an interactive button for more engagement
                ElevatedButton(
                  onPressed: () async {
                    await launch('tel:$phoneNumber');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Explore BookBytes",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

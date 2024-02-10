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
  final String phoneNumber = '0198175752'; // Replace with the phone number

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
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepOrange,
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
                  height: 70,
                  width: 70,
                ),
                const SizedBox(height: 15),
                Text(
                  "Welcome ${widget.userdata.username}\n to BookBytes Community!",
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    "Step into the vibrant world of BookBytes, where readers unite on the illustrious BookBytes Community Page. Here, the magic of words comes alive, weaving a tapestry of shared stories, diverse perspectives, and boundless imagination. Picture a cozy corner online, adorned with shelves of literary treasures and the whispers of countless tales. This is where readers from every corner of the globe converge, not just as book enthusiasts but as a vibrant community of wordsmiths.",
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                // Add an interactive button for more engagement
                ElevatedButton(
                  onPressed: () async {
                    await launch('tel:$phoneNumber');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the content horizontally
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Bookbytes Contact Number",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((MapEntry<String, String> e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'bookbytesco@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'BookBytes Customer',
                      }),
                    );

                    try {
                      await launchUrl(emailLaunchUri);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the content horizontally
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "bookbytesco@gmail.com",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

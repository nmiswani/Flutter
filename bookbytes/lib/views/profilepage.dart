import 'package:bookbytes/shared/mydrawer.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  final User userdata;
  const ProfilePage({super.key, required this.userdata});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              "My Account",
              style: TextStyle(
                color: Colors.white,
              ),
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
        page: 'account',
        userdata: widget.userdata,
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 50),
                const CircleAvatar(
                  radius: 85,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.userdata.username.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.userdata.useremail.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(30),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black), // Border color
                    ),
                    child: buildUpdateButton(
                      "Update ${updateLabels[index]}",
                      updateIcons[index],
                      () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> updateLabels = [
    "Username",
    "Email",
    "Phone Number",
    "Password",
  ];

  List<IconData> updateIcons = [
    Icons.person,
    Icons.email_outlined,
    Icons.phone,
    Icons.lock_outlined,
  ];

  Widget buildUpdateButton(
      String label, IconData icon, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

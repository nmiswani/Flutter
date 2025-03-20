import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/clerk.dart';
import 'package:pomm/views/loginpage_clerkadmin.dart';

class ClerkDashboardPage extends StatefulWidget {
  final Clerk clerk;
  const ClerkDashboardPage({super.key, required this.clerk});

  @override
  State<ClerkDashboardPage> createState() => _ClerkDashboardPageState();
}

class _ClerkDashboardPageState extends State<ClerkDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 55, 97, 70)),
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (content) => LoginClerkAdminPage()),
              );
            },
            icon: const Icon(Icons.login, color: Colors.white),
          ),
        ],
        elevation: 0.0,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginClerkAdminPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 55, 97, 70),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            "Product",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/views/admin/salesreport/dailyreportpage.dart';
import 'package:pomm/views/admin/salesreport/monthlyreportpage.dart';
import 'package:pomm/views/admin/salesreport/yearlyreportpage.dart';
import 'package:pomm/views/loginclerkadminpage.dart'; // Import Login Page

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String maintitle = "Sales Report";
  late List<Widget> tabchildren;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Adjust the height as needed
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 55, 97, 70),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 55, 97, 70),
          elevation: 0.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Admin's Dashboard",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Utara Gadget Solution Store, UUM",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildReportButton("Daily Report", const DailyReportPage()),
            _buildReportButton("Monthly Report", const MonthlyReportPage()),
            _buildReportButton("Yearly Report", const YearlyReportPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(String title, Widget page) {
    return Card(
      color: const Color.fromARGB(255, 55, 97, 70),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        title: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
          ),
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            ),
        tileColor: const Color.fromARGB(248, 202, 229, 206),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginClerkAdminPage()),
      (route) => false, // Removes all previous pages from the stack
    );
  }
}

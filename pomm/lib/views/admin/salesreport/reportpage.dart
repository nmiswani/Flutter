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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 55, 97, 70)),
        title: Text(
          "Sales Report",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // White icon
            onPressed: _logout,
          ),
        ],
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
      child: ListTile(
        title: Center(
          child: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            ),
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

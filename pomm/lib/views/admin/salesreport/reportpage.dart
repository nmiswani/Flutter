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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Admin Dashboard",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2.5),
                Text(
                  "Utara Gadget Solution Store",
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 18, right: 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (content) => LoginClerkAdminPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.5),
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
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(fontSize: 15, color: Colors.white),
          ),
        ),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            ),
      ),
    );
  }
}

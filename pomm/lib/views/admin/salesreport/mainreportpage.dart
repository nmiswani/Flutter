import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/views/admin/salesreport/dailyreportpage.dart';
import 'package:pomm/views/admin/salesreport/monthlyreportpage.dart';
import 'package:pomm/views/admin/salesreport/yearlyreportpage.dart';

class MainReportPage extends StatefulWidget {
  const MainReportPage({super.key});

  @override
  State<MainReportPage> createState() => _MainReportPageState();
}

class _MainReportPageState extends State<MainReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sales Report",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
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
}

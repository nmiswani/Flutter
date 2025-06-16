import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/views/admin/salesreport/dailyreportpage.dart';
import 'package:pomm/views/admin/salesreport/monthlyreportpage.dart';
import 'package:pomm/views/admin/salesreport/yearlyreportpage.dart';
import 'package:pomm/views/loginclerkadminpage.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
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
              padding: const EdgeInsets.only(top: 18),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginClerkAdminPage()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImageCard(
              imagePath: 'assets/images/daily.jpg',
              label: 'DAILY REPORT',
              page: const DailyReportPage(),
            ),
            const SizedBox(height: 4),
            _buildImageCard(
              imagePath: 'assets/images/monthly.jpg',
              label: 'MONTHLY REPORT',
              page: const MonthlyReportPage(),
            ),
            const SizedBox(height: 4),
            _buildImageCard(
              imagePath: 'assets/images/yearly.jpg',
              label: 'YEARLY REPORT',
              page: const YearlyReportPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard({
    required String imagePath,
    required String label,
    required Widget page,
  }) {
    return GestureDetector(
      onTap:
          () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(label, style: GoogleFonts.inter(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

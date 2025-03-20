import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/views/admin/salesreport/dailyreportpage.dart';

class MainReportPage extends StatefulWidget {
  final Admin admin;
  const MainReportPage({super.key, required this.admin});

  @override
  State<MainReportPage> createState() => _MainReportPageState();
}

class _MainReportPageState extends State<MainReportPage> {
  String maintitle = "Sales Report";
  late List<Widget> tabchildren;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        elevation: 0,
        title: Text(
          "Sales Report",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
      ),
      body: _buildSalesReportPage(), // Ensure the report page is displayed
    );
  }

  // Method for displaying Sales Report categories
  Widget _buildSalesReportPage() {
    final List<Map<String, dynamic>> reports = [
      {
        'title': 'Daily Report',
        'onTap':
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyReportPage()),
            ),
      },
      {
        'title': 'Monthly Report',
        'onTap': () {
          // TODO: Navigate to Monthly Report Page when ready
        },
      },
      {
        'title': 'Yearly Report',
        'onTap': () {
          // TODO: Navigate to Yearly Report Page when ready
        },
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Sales Reports",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: const Color.fromARGB(248, 214, 227, 216),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        report['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: report['onTap'] as void Function()?,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportDetailsPage extends StatelessWidget {
  final DateTime selectedDate;
  final double totalSales;
  final int totalOrders;

  const ReportDetailsPage({
    super.key,
    required this.selectedDate,
    required this.totalSales,
    required this.totalOrders,
  });

  String generateSummary() {
    // Determine correct date format based on report type
    String formattedDate;
    if (selectedDate.day == 1 && selectedDate.month == 1) {
      // Yearly Report (Only Year)
      formattedDate = DateFormat('yyyy').format(selectedDate);
    } else if (selectedDate.day == 1) {
      // Monthly Report (Only Month & Year)
      formattedDate = DateFormat('MMMM yyyy').format(selectedDate);
    } else {
      // Daily Report (Full Date)
      formattedDate = DateFormat('dd MMMM yyyy').format(selectedDate);
    }

    // Generate summary based on total sales and total orders
    if (totalSales > 300 && totalOrders > 10) {
      return "A strong performance in $formattedDate, with RM$totalSales in sales and $totalOrders orders. Sales are picking up well, indicating good customer interest.";
    } else if (totalSales > 200 && totalOrders > 7) {
      return "A steady day in $formattedDate, reaching RM$totalSales with $totalOrders orders. A slight boost in promotions could improve sales further.";
    } else if (totalOrders > 5 && totalSales < 150) {
      return "Although $totalOrders orders were placed in $formattedDate, total sales only reached RM$totalSales. Customers may be opting for lower-priced items or smaller purchases.";
    } else if (totalSales > 250 && totalOrders < 5) {
      return "Sales in $formattedDate totaled RM$totalSales with only $totalOrders orders. This suggests fewer but higher-value purchases. Expanding customer reach could help increase order volume.";
    } else if (totalOrders < 3 && totalSales < 100) {
      return "Sales on $formattedDate were RM$totalSales with only $totalOrders orders. This was a slow period, and additional marketing efforts may be needed to attract customers.";
    } else {
      return "Sales on $formattedDate totaled RM$totalSales with $totalOrders orders. There is potential for improvement through promotions or customer engagement strategies.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format selectedDate for display
    String formattedDate;
    if (selectedDate.day == 1 && selectedDate.month == 1) {
      formattedDate = DateFormat('yyyy').format(selectedDate);
    } else if (selectedDate.day == 1) {
      formattedDate = DateFormat('MMMM yyyy').format(selectedDate);
    } else {
      formattedDate = DateFormat('dd MMMM yyyy').format(selectedDate);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Sales Report",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // Date Display
            Text(
              "Report for: $formattedDate",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Bar chart visualization
            Text(
              "Sales & Orders Overview",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: totalSales + 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Sales");
                            case 1:
                              return const Text("Orders");
                            default:
                              return const Text("");
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: totalSales,
                          color: Colors.blue,
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: totalOrders.toDouble(),
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Summary Section
            Card(
              color: const Color.fromARGB(248, 214, 227, 216),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Summary:",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      generateSummary(),
                      style: GoogleFonts.poppins(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Print Button
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                margin: const EdgeInsets.only(top: 6),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Printing Report...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Print",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

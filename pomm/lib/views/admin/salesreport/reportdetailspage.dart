import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportDetailsPage extends StatefulWidget {
  final DateTime selectedDate;
  final double totalSales;
  final int totalOrders;

  const ReportDetailsPage({
    super.key,
    required this.selectedDate,
    required this.totalSales,
    required this.totalOrders,
  });

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  String generateSummary() {
    String formattedDate;
    if (widget.selectedDate.day == 1 && widget.selectedDate.month == 1) {
      formattedDate = DateFormat('yyyy').format(widget.selectedDate);
    } else if (widget.selectedDate.day == 1) {
      formattedDate = DateFormat('MMMM yyyy').format(widget.selectedDate);
    } else {
      formattedDate = DateFormat('dd MMMM yyyy').format(widget.selectedDate);
    }

    String salesFormatted = widget.totalSales.toStringAsFixed(2);

    if (widget.totalSales > 300 && widget.totalOrders > 10) {
      return "A strong performance in $formattedDate, with RM$salesFormatted in sales and ${widget.totalOrders} orders. Sales are picking up well, indicating good customer interest.";
    } else if (widget.totalSales > 200 && widget.totalOrders > 7) {
      return "A steady day in $formattedDate, reaching RM$salesFormatted with ${widget.totalOrders} orders. A slight boost in promotions could improve sales further.";
    } else if (widget.totalOrders > 5 && widget.totalSales < 150) {
      return "Although ${widget.totalOrders} orders were placed in $formattedDate, total sales only reached RM$salesFormatted. Customers may be opting for lower-priced items or smaller purchases.";
    } else if (widget.totalSales > 250 && widget.totalOrders < 5) {
      return "Sales in $formattedDate totaled RM$salesFormatted with only ${widget.totalOrders} orders. This suggests fewer but higher-value purchases. Expanding customer reach could help increase order volume.";
    } else if (widget.totalOrders < 3 && widget.totalSales < 100) {
      return "Sales on $formattedDate were RM$salesFormatted with only ${widget.totalOrders} orders. This was a slow period, and additional marketing efforts may be needed to attract customers.";
    } else {
      return "Sales on $formattedDate totaled RM$salesFormatted with ${widget.totalOrders} orders. There is potential for improvement through promotions or customer engagement strategies.";
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    if (widget.selectedDate.day == 1 && widget.selectedDate.month == 1) {
      formattedDate = DateFormat('yyyy').format(widget.selectedDate);
    } else if (widget.selectedDate.day == 1) {
      formattedDate = DateFormat('MMMM yyyy').format(widget.selectedDate);
    } else {
      formattedDate = DateFormat('dd MMMM yyyy').format(widget.selectedDate);
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
            Text(
              "Report for: $formattedDate",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
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
                  maxY: widget.totalSales + 10,
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
                          toY: widget.totalSales,
                          color: Colors.blue,
                          width: 20,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: widget.totalOrders.toDouble(),
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

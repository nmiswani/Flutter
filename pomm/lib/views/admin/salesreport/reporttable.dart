import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportTable extends StatelessWidget {
  final DateTime selectedDate;
  final double totalSales;
  final int totalOrders;

  const ReportTable({
    super.key,
    required this.selectedDate,
    required this.totalSales,
    required this.totalOrders,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Report Table',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report for: $formattedDate',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Table summary
            Table(
              border: TableBorder.all(color: Colors.black54),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.green.shade100),
                  children: [
                    _buildTableHeader("Item"),
                    _buildTableHeader("Value"),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell("Total Sales"),
                    _buildTableCell("RM${totalSales.toStringAsFixed(2)}"),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell("Total Orders"),
                    _buildTableCell("$totalOrders"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: Text("Back", style: GoogleFonts.poppins(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 14)),
    );
  }
}

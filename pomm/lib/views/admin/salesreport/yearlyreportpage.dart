import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/salesreport.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';
import 'reportdetailspage.dart';

class YearlyReportPage extends StatefulWidget {
  const YearlyReportPage({super.key});

  @override
  State<YearlyReportPage> createState() => _YearlyReportPageState();
}

class _YearlyReportPageState extends State<YearlyReportPage> {
  String? _selectedYear;
  SalesReport? _salesReport;

  Future<void> _fetchSalesReport() async {
    if (_selectedYear == null) return;

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/sales_yearly.php?year=$_selectedYear",
    );

    try {
      final response = await http.get(url);
      print("API Response: ${response.body}"); // ✅ Debugging Line

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _salesReport = SalesReport.fromJson(data);
        });
      } else {
        setState(() {
          _salesReport = null;
        });
      }
    } catch (e) {
      print("Error fetching sales data: $e");
    }
  }

  void _selectYear() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Select Year"),
            content: SizedBox(
              width: double.maxFinite, // ✅ Ensures the dialog expands properly
              child: SingleChildScrollView(
                // ✅ Allows content to be scrollable
                child: ListBody(
                  // ✅ Prevents viewport error
                  children: List.generate(25, (index) {
                    int year = DateTime.now().year - index;
                    return ListTile(
                      title: Text(year.toString()),
                      onTap: () {
                        setState(() {
                          _selectedYear = year.toString();
                        });
                        Navigator.pop(context); // Close dialog first
                        _fetchSalesReport(); // Fetch data after selection
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDataAvailable =
        _salesReport != null &&
        (_salesReport!.totalSales > 0 || _salesReport!.totalOrders > 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yearly Report",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year Picker Field
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Year",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectYear,
                ),
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: _selectedYear ?? "Select year",
              ),
            ),
            const SizedBox(height: 20),

            // Sales Report Section
            Text(
              "Sales Report",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sales Report",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    (_salesReport != null &&
                            (_salesReport!.totalSales > 0 ||
                                _salesReport!.totalOrders > 0))
                        ? "Summary of sales activities."
                        : "No data found",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color:
                          (_salesReport != null &&
                                  (_salesReport!.totalSales > 0 ||
                                      _salesReport!.totalOrders > 0))
                              ? Colors.black
                              : Colors.red,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed:
                          isDataAvailable
                              ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ReportDetailsPage(
                                          selectedDate: DateTime(
                                            int.parse(_selectedYear!),
                                          ), // Converts year string to DateTime
                                          totalSales: _salesReport!.totalSales,
                                          totalOrders:
                                              _salesReport!.totalOrders,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      child: const Text("View details"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Total Sales and Orders
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Sales",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (_salesReport != null && _salesReport!.totalSales > 0)
                              ? "RM${_salesReport!.totalSales}"
                              : "No data found",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                (_salesReport != null &&
                                        _salesReport!.totalSales > 0)
                                    ? Colors.black
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Order",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (_salesReport != null &&
                                  _salesReport!.totalOrders > 0)
                              ? "${_salesReport!.totalOrders}"
                              : "No data found",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                (_salesReport != null &&
                                        _salesReport!.totalOrders > 0)
                                    ? Colors.black
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

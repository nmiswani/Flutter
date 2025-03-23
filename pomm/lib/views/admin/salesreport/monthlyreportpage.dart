import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:convert';

import 'package:pomm/models/salesreport.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'reportdetailspage.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  String? _selectedMonth;
  SalesReport? _salesReport;

  Future<void> _fetchSalesReport() async {
    if (_selectedMonth == null) return;

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/sales_monthly.php?month=$_selectedMonth",
    );
    try {
      final response = await http.get(url);
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

  void _selectMonth() async {
    DateTime? pickedDate = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedMonth = DateFormat('yyyy-MM').format(pickedDate);
      });
      _fetchSalesReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDataAvailable =
        _salesReport != null &&
        (_salesReport!.totalSales > 0 || _salesReport!.totalOrders > 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monthly Report",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Picker Field
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Month",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectMonth,
                ),
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: _selectedMonth ?? "Select month",
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
                                          selectedDate: DateFormat(
                                            'yyyy-MM',
                                          ).parse(
                                            _selectedMonth!,
                                          ), // Converts "2024-03" to DateTime
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:pomm/models/salesreport.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/salesreport/reporttable.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({super.key});

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  String? _selectedDate;
  SalesReport? _salesReport;

  Future<void> _fetchSalesReport(String sqlFormattedDate) async {
    if (sqlFormattedDate.isEmpty) return;

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/sales_daily.php?date=$sqlFormattedDate",
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

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        // Format _selectedDate for display (dd-MM-yyyy format)
        _selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

        // Format _selectedDate for SQL (yyyy-MM-dd format)
        String sqlFormattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

        // Pass formatted date to the SQL query
        _fetchSalesReport(sqlFormattedDate);
      });
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
          "Daily Report",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
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
            const SizedBox(height: 15),
            // Date Picker Field
            Material(
              elevation: 1,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select date",
                  labelStyle: GoogleFonts.poppins(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: _selectDate,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                style: GoogleFonts.poppins(fontSize: 14),
                controller: TextEditingController(
                  text: _selectedDate ?? "Select date",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sales Report Section
            Text(
              "Sales Report",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(248, 202, 229, 206),
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // shadow direction: bottom only
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sales Report",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isDataAvailable
                        ? "Summary of sales activities."
                        : "No data found",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDataAvailable ? Colors.black : Colors.red,
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
                                        (context) => ReportTable(
                                          selectedDate: DateFormat(
                                            'dd-MM-yyyy',
                                          ).parse(_selectedDate!),
                                          totalSales: _salesReport!.totalSales,
                                          totalOrders:
                                              _salesReport!.totalOrders,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // No border radius
                        ),
                      ),
                      child: Text(
                        "View details",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Total Sales and Orders
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(248, 202, 229, 206),
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(
                            0,
                            2,
                          ), // shadow direction: bottom only
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Sales",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (_salesReport != null && _salesReport!.totalSales > 0)
                              ? "RM${_salesReport!.totalSales.toStringAsFixed(2)}"
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
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(248, 202, 229, 206),
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(
                            0,
                            2,
                          ), // shadow direction: bottom only
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Order",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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

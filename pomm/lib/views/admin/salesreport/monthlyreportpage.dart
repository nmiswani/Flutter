import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:convert';

import 'package:pomm/models/salesreport.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/salesreport/reportmonthlytable.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  String? _selectedMonth;
  SalesReport? _salesReport;

  @override
  Widget build(BuildContext context) {
    bool isDataAvailable =
        _salesReport != null &&
        (_salesReport!.totalSales > 0 || _salesReport!.totalOrders > 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monthly Report",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Material(
              elevation: 3,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelStyle: GoogleFonts.inter(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: _selectMonth,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 14),
                controller: TextEditingController(
                  text: _selectedMonth ?? "Select month",
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Summary of Report",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sales Report",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isDataAvailable
                          ? "Summary of sales activities"
                          : "No data found",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight:
                            isDataAvailable
                                ? FontWeight.normal
                                : FontWeight.normal,
                        color: isDataAvailable ? Colors.black : Colors.red,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed:
                            isDataAvailable
                                ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Sales report retrieved successful",
                                        style: GoogleFonts.inter(),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ReportMonthlyTable(
                                            selectedDate: DateFormat(
                                              'MMMM yyyy',
                                            ).parse(_selectedMonth!),
                                            totalSales:
                                                _salesReport!.totalSales,
                                            totalOrders:
                                                _salesReport!.totalOrders,
                                          ),
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "View details",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    icon: Icons.attach_money,
                    title: "Total Sales",
                    value:
                        (_salesReport != null && _salesReport!.totalSales > 0)
                            ? "RM${_salesReport!.totalSales.toStringAsFixed(2)}"
                            : "No data found",
                    iconColor: Colors.black,
                    isDataAvailable:
                        _salesReport != null && _salesReport!.totalSales > 0,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatsCard(
                    icon: Icons.shopping_bag_outlined,
                    title: "Total Order",
                    value:
                        (_salesReport != null && _salesReport!.totalOrders > 0)
                            ? "${_salesReport!.totalOrders}"
                            : "No data found",
                    iconColor: Colors.black,
                    isDataAvailable:
                        _salesReport != null && _salesReport!.totalOrders > 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required bool isDataAvailable,
  }) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight:
                    isDataAvailable ? FontWeight.w600 : FontWeight.normal,
                color: isDataAvailable ? Colors.black : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchSalesReport(String sqlFormattedDate) async {
    if (sqlFormattedDate.isEmpty) return;

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/sales_monthly.php?date=$sqlFormattedDate",
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
        _selectedMonth = DateFormat('MMMM yyyy').format(pickedDate);
        String sqlFormattedDate = DateFormat('yyyy-MM').format(pickedDate);
        _fetchSalesReport(sqlFormattedDate);
      });
    }
  }
}

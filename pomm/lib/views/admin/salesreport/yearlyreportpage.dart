import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/salesreport.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'dart:convert';

import 'package:pomm/views/admin/salesreport/reportyearlytable.dart';

class YearlyReportPage extends StatefulWidget {
  const YearlyReportPage({super.key});

  @override
  State<YearlyReportPage> createState() => _YearlyReportPageState();
}

class _YearlyReportPageState extends State<YearlyReportPage> {
  String? _selectedYear;
  SalesReport? _salesReport;

  @override
  Widget build(BuildContext context) {
    bool isDataAvailable =
        _salesReport != null &&
        (_salesReport!.totalSales > 0 || _salesReport!.totalOrders > 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yearly Report",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 236, 231, 231),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Material(
              elevation: 1,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select year",
                  labelStyle: GoogleFonts.inter(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white, // White background for the date card
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: _selectYear,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Radius set to 10
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 14),
                controller: TextEditingController(
                  text: _selectedYear ?? "Select year",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Sales Report",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white, // White background for the card
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sales Report",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isDataAvailable
                        ? "Summary of sales activities."
                        : "No data found",
                    style: GoogleFonts.inter(
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
                                        (context) => ReportYearlyTable(
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
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for the card
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
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
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          (_salesReport != null && _salesReport!.totalSales > 0)
                              ? "RM${_salesReport!.totalSales.toStringAsFixed(2)}"
                              : "No data found",
                          style: GoogleFonts.inter(
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
                      color: Colors.white, // White background for the card
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
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
                          style: GoogleFonts.inter(
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
                          style: GoogleFonts.inter(
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

  Future<void> _fetchSalesReport() async {
    if (_selectedYear == null) return;

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/sales_yearly.php?date=$_selectedYear",
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
          (context) => Theme(
            data: Theme.of(context).copyWith(
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            child: AlertDialog(
              backgroundColor: Colors.white,
              content: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: List.generate(6, (index) {
                      int year = DateTime.now().year - index;
                      return ListTile(
                        title: Text(year.toString()),
                        onTap: () {
                          setState(() {
                            _selectedYear = year.toString();
                          });
                          Navigator.pop(context);
                          _fetchSalesReport();
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

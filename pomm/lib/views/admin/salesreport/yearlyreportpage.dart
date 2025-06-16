import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pomm/models/salesreport.dart';
import 'package:pomm/shared/myserverconfig.dart';
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
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Material(
              elevation: 3,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedYear ?? "Select Year",
                ),
                decoration: InputDecoration(
                  labelStyle: GoogleFonts.inter(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: _selectYear,
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

            /// Sales Report Card
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                                          (context) => ReportYearlyTable(
                                            selectedDate: DateTime(
                                              int.parse(_selectedYear!),
                                            ),
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

            /// Stats Card Row
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

  /// Stats Card Widget
  Widget _buildStatsCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required bool isDataAvailable,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: iconColor),
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

  /// Fetch Yearly Sales Report
  Future<void> _fetchSalesReport() async {
    if (_selectedYear == null) return;
    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/sales_yearly.php?date=$_selectedYear",
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

  /// Year Picker Dialog
  void _selectYear() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
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
                },
              ),
            ),
          ),
    );
  }
}

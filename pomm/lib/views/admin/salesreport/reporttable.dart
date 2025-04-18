import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pomm/shared/myserverconfig.dart';

class ReportTable extends StatefulWidget {
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
  State<ReportTable> createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  List<dynamic> productList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final detailsUrl = Uri.parse(
      "${MyServerConfig.server}/pomm/php/load_sales_report_table.php?date=$formattedDate",
    );

    try {
      final response = await http.get(detailsUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          productList = data['products_sold'] ?? [];
        });
      } else {
        setState(() {
          productList = [];
        });
      }
    } catch (e) {
      print("Error loading product details: $e");
      setState(() {
        productList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sales Report - $displayDate",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 55, 97, 70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Sales: RM${widget.totalSales.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text(
                      "Total Orders: ${widget.totalOrders}",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          productList.isEmpty
                              ? Center(
                                child: Text(
                                  "No products sold on this day.",
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              )
                              : SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  children: [
                                    // Table Headers
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Product Title',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Product ID',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Quantity Sold',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Balance',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Product Rows
                                    ...productList
                                        .map(
                                          (item) => TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    item['product_title'] ??
                                                        'Unknown Product',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    item['product_id']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    item['quantity_sold']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    item['balance_qty']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:printing/printing.dart';

class ReportYearlyTable extends StatefulWidget {
  final DateTime selectedDate;
  final double totalSales;
  final int totalOrders;

  const ReportYearlyTable({
    super.key,
    required this.selectedDate,
    required this.totalSales,
    required this.totalOrders,
  });

  @override
  State<ReportYearlyTable> createState() => _ReportYearlyTableState();
}

class _ReportYearlyTableState extends State<ReportYearlyTable> {
  List<Map<String, dynamic>> fullProductList = [];
  List<Map<String, dynamic>> currentPageList = [];
  List<Map<String, dynamic>> filteredProductList = [];
  bool isLoading = true;
  int numofpage = 1;
  int curpage = 1;
  final int itemsPerPage = 10;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = DateFormat('yyyy').format(widget.selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Sales Report for $displayDate",
          style: GoogleFonts.inter(fontSize: 17, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => printingMethod(),
          ),
        ],
      ),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 0.5,
                      borderRadius: BorderRadius.circular(10),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => _filterProducts(value),
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          hintText: 'Search products',
                          hintStyle: GoogleFonts.inter(color: Colors.black45),
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Total Sales: RM${widget.totalSales.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Total Orders: ${widget.totalOrders}",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child:
                                filteredProductList.isEmpty
                                    ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Text(
                                          "No products found",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                    : SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: FittedBox(
                                          child: DataTable(
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                  Colors.black,
                                                ),
                                            headingTextStyle: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                            columns: const [
                                              DataColumn(
                                                label: Text("Product ID"),
                                              ),
                                              DataColumn(
                                                label: Text("Product Title"),
                                              ),
                                              DataColumn(
                                                label: Text("Quantity Sold"),
                                              ),
                                              DataColumn(
                                                label: Text("Balance Quantity"),
                                              ),
                                            ],
                                            rows:
                                                currentPageList.map((product) {
                                                  final balanceQty =
                                                      int.tryParse(
                                                        product['balance_qty']
                                                            .toString(),
                                                      ) ??
                                                      0;
                                                  final isLowStock =
                                                      balanceQty <= 1;

                                                  return DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(
                                                          product['product_id']
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          product['product_title']
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          product['quantity_sold']
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          isLowStock
                                                              ? '${product['balance_qty']} (Low stock)'
                                                              : product['balance_qty']
                                                                  .toString(),
                                                          style: GoogleFonts.inter(
                                                            fontSize: 13,
                                                            color:
                                                                isLowStock
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: numofpage,
                              itemBuilder: (context, index) {
                                final isCurrentPage = (curpage - 1) == index;
                                final color =
                                    isCurrentPage ? Colors.black : Colors.grey;

                                return TextButton(
                                  onPressed: () {
                                    setState(() {
                                      curpage = index + 1;
                                      _updateCurrentPage();
                                    });
                                  },
                                  child: Text(
                                    (index + 1).toString(),
                                    style: GoogleFonts.inter(color: color),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _filterProducts(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredProductList = List.from(fullProductList);
      } else {
        filteredProductList =
            fullProductList.where((product) {
              return product['product_title'].toString().toLowerCase().contains(
                lowerQuery,
              );
            }).toList();
      }
      curpage = 1;
      numofpage = (filteredProductList.length / itemsPerPage).ceil();
      _updateCurrentPage();
    });
  }

  void _updateCurrentPage() {
    final startIndex = (curpage - 1) * itemsPerPage;
    final endIndex =
        (startIndex + itemsPerPage > filteredProductList.length)
            ? filteredProductList.length
            : startIndex + itemsPerPage;

    currentPageList = filteredProductList.sublist(startIndex, endIndex);
  }

  Future<void> _fetchAllProductDetails() async {
    final formattedDate = DateFormat('yyyy').format(widget.selectedDate);
    int page = 1;
    bool keepFetching = true;
    List<Map<String, dynamic>> allProducts = [];

    try {
      while (keepFetching) {
        final url = Uri.parse(
          "${MyServerConfig.server}/pomm/php/load_sales_report_table_yearly.php?date=$formattedDate&pageno=$page",
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print(data); // Check the response

          final List<dynamic> products = data['products_sold'] ?? [];

          if (products.isEmpty) {
            keepFetching = false;
          } else {
            allProducts.addAll(products.cast<Map<String, dynamic>>());

            if (page >= (data['numofpage'] ?? 1)) {
              keepFetching = false;
            } else {
              page++;
            }
          }
        } else {
          keepFetching = false;
        }
      }

      setState(() {
        fullProductList = allProducts;
        filteredProductList = List.from(fullProductList);
        numofpage = (filteredProductList.length / itemsPerPage).ceil();
        _updateCurrentPage();
      });

      // Check if no products were fetched
      if (fullProductList.isEmpty) {
        print("No data found.");
        // Optionally, you can show a dialog or a snackbar here
      }
    } catch (e) {
      print("Error loading product details: $e");
      setState(() {
        fullProductList = [];
        filteredProductList = [];
        currentPageList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> printingMethod() async {
    final reportType = "yearly";
    final formattedDate = DateFormat('yyyy').format(widget.selectedDate);
    final generateDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final url = Uri.parse(
      "${MyServerConfig.server}/pomm/php/load_printing_report.php?date=$formattedDate&reportType=$reportType&generateDate=$generateDate",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final htmlData = response.body;

        // Attempt to print the PDF from the HTML data
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async {
            return await Printing.convertHtml(format: format, html: htmlData);
          },
        );
      } else {
        // Log more details about the error response
        print("Failed to load report. Status Code: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Unable to load the report. Please try again later",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network or other issues
      print("Error loading report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Network or server issue. Please check your connection",
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

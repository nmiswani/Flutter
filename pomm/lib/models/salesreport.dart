class SalesReport {
  final double totalSales;
  final int totalOrders;

  SalesReport({required this.totalSales, required this.totalOrders});

  factory SalesReport.fromJson(Map<String, dynamic> json) {
    return SalesReport(
      totalSales: double.tryParse(json['total_sales'].toString()) ?? 0.0,
      totalOrders: int.tryParse(json['total_orders'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales.toStringAsFixed(2), // Keep 2 decimal places
      'total_orders': totalOrders,
    };
  }
}

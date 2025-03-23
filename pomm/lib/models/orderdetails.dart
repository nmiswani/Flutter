class OrderDetails {
  String? orderdetailId;
  String? orderBill;
  String? productId;
  String? productTitle;
  String? orderdetailQty;
  String? orderdetailPaid;
  String? customerId;
  String? adminId;
  String? orderdetailDate;

  OrderDetails({
    this.orderdetailId,
    this.orderBill,
    this.productId,
    this.productTitle,
    this.orderdetailQty,
    this.orderdetailPaid,
    this.customerId,

    this.adminId,
    this.orderdetailDate,
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    orderBill = json['order_bill'];
    productId = json['product_id'];
    productTitle = json['product_title'];
    orderdetailQty = json['orderdetail_qty'];
    orderdetailPaid = json['orderdetail_paid'];
    customerId = json['customer_id'];

    adminId = json['admin_id'];
    orderdetailDate = json['orderdetail_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderdetail_id'] = orderdetailId;
    data['order_bill'] = orderBill;
    data['product_id'] = productId;
    data['product_title'] = productTitle;
    data['orderdetail_qty'] = orderdetailQty;
    data['orderdetail_paid'] = orderdetailPaid;
    data['customer_id'] = customerId;

    data['admin_id'] = adminId;
    data['orderdetail_date'] = orderdetailDate;
    return data;
  }
}

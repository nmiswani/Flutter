class Order {
  String? orderId;
  String? orderDate;
  String? orderStatus;
  String? orderTotal;

  String? customerName;
  String? customerPhone;
  String? productTitle;
  String? productDesc;
  String? productQty;

  String? orderBill;
  String? adminId;
  String? customerId;
  String? orderTracking;
  String? shippingAddress;

  Order({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.orderTotal,

    this.customerName,
    this.customerPhone,
    this.productTitle,
    this.productDesc,
    this.productQty,

    this.orderBill,
    this.adminId,
    this.customerId,
    this.orderTracking,
    this.shippingAddress,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    orderTotal = json['order_total'];

    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    productTitle = json['product_title'];
    productDesc = json['product_desc'];
    productQty = json['product_qty'];

    orderBill = json['order_bill'];
    adminId = json['admin_id'];
    customerId = json['customer_id'];
    orderTracking = json['order_tracking'];
    shippingAddress = json['shipping_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['order_total'] = orderTotal;

    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['product_title'] = productTitle;
    data['product_desc'] = productDesc;
    data['product_qty'] = productQty;

    data['order_bill'] = orderBill;
    data['admin_id'] = adminId;
    data['customer_id'] = customerId;
    data['order_tracking'] = orderTracking;
    data['shipping_address'] = shippingAddress;

    return data;
  }
}

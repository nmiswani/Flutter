class Order {
  String? orderId;
  String? orderDate;
  String? orderStatus;
  String? orderTotal;

  String? customerId;
  String? customerName;
  String? customerPhone;
  String? customerEmail;

  String? productId;
  String? productTitle;
  String? productDesc;
  String? cartQty;

  String? cartId;
  String? orderBill;
  String? adminId;
  String? orderTracking;
  String? shippingAddress;
  String? deliveryCharge;
  String? orderSubtotal;
  String? receiptNo;
  String? orderTime;

  String? statusInProcessDate;
  String? statusDeliveryPickupDate;
  String? statusCompletedDate;
  String? statusCanceledDate;

  Order({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.orderTotal,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.productId,
    this.productTitle,
    this.productDesc,
    this.cartQty,
    this.cartId,
    this.orderBill,
    this.adminId,
    this.orderTracking,
    this.shippingAddress,
    this.deliveryCharge,
    this.orderSubtotal,
    this.receiptNo,
    this.orderTime,
    this.statusInProcessDate,
    this.statusDeliveryPickupDate,
    this.statusCompletedDate,
    this.statusCanceledDate,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    orderTotal = json['order_total'];

    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];

    productId = json['product_id'];
    productTitle = json['product_title'];
    productDesc = json['product_desc'];
    cartQty = json['cart_qty'];

    cartId = json['cart_id'];
    orderBill = json['order_bill'];
    adminId = json['admin_id'];
    orderTracking = json['order_tracking'];
    shippingAddress = json['shipping_address'];
    deliveryCharge = json['delivery_charge'];
    orderSubtotal = json['order_subtotal'];
    receiptNo = json['receipt_no'];
    orderTime = json['order_time'];

    statusInProcessDate = json['status_inprocess_date'];
    statusDeliveryPickupDate = json['status_deliverypickup_date'];
    statusCompletedDate = json['status_completed_date'];
    statusCanceledDate = json['status_canceled_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['order_total'] = orderTotal;

    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['customer_email'] = customerEmail;

    data['product_id'] = productId;
    data['product_title'] = productTitle;
    data['product_desc'] = productDesc;
    data['cart_qty'] = cartQty;

    data['cart_id'] = cartId;
    data['order_bill'] = orderBill;
    data['admin_id'] = adminId;
    data['order_tracking'] = orderTracking;
    data['shipping_address'] = shippingAddress;
    data['delivery_charge'] = deliveryCharge;
    data['order_subtotal'] = orderSubtotal;
    data['receipt_no'] = receiptNo;
    data['order_time'] = orderTime;

    data['status_inprocess_date'] = statusInProcessDate;
    data['status_deliverypickup_date'] = statusDeliveryPickupDate;
    data['status_completed_date'] = statusCompletedDate;
    data['status_canceled_date'] = statusCanceledDate;

    return data;
  }
}

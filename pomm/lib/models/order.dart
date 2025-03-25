class Order {
  String? orderId;
  String? orderDate;
  String? orderStatus;
  String? orderTotal;

  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? productTitle;
  String? productDesc;
  String? cartQty;
  String? productId;

  String? orderBill;
  String? adminId;
  String? customerId;
  String? orderTracking;
  String? shippingAddress;
  String? deliveryCharge;
  String? orderSubtotal;

  String? cartId;

  Order({
    this.orderId,
    this.orderDate,
    this.orderStatus,
    this.orderTotal,

    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.productTitle,
    this.productDesc,
    this.cartQty,
    this.productId,

    this.orderBill,
    this.adminId,
    this.customerId,
    this.orderTracking,
    this.shippingAddress,
    this.deliveryCharge,
    this.orderSubtotal,
    this.cartId,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    orderTotal = json['order_total'];

    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];
    productTitle = json['product_title'];
    productDesc = json['product_desc'];
    cartQty = json['cart_qty'];
    productId = json['product_id'];

    orderBill = json['order_bill'];
    adminId = json['admin_id'];
    customerId = json['customer_id'];
    orderTracking = json['order_tracking'];
    shippingAddress = json['shipping_address'];
    deliveryCharge = json['delivery_charge'];
    orderSubtotal = json['order_subtotal'];

    cartId = json['cart_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['order_total'] = orderTotal;

    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['customer_email'] = customerEmail;
    data['product_title'] = productTitle;
    data['product_desc'] = productDesc;
    data['cart_qty'] = cartQty;
    data['product_id'] = productId;

    data['order_bill'] = orderBill;
    data['admin_id'] = adminId;
    data['customer_id'] = customerId;
    data['order_tracking'] = orderTracking;
    data['shipping_address'] = shippingAddress;
    data['delivery_charge'] = deliveryCharge;
    data['order_subtotal'] = orderSubtotal;

    data['cart_id'] = cartId;

    return data;
  }
}

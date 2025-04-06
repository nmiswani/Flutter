class Customer {
  String? customerid;
  String? customeremail;
  String? customername;
  String? customerphone;
  String? customerpassword;
  String? codes;

  Customer({
    this.customerid,
    this.customeremail,
    this.customername,
    this.customerphone,
    this.customerpassword,
    this.codes,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    customerid = json['customerid'];
    customeremail = json['customeremail'];
    customername = json['customername'];
    customerphone = json['customerphone'];
    customerpassword = json['customerpassword'];
    codes = json['codes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerid'] = customerid;
    data['customeremail'] = customeremail;
    data['customername'] = customername;
    data['customerphone'] = customerphone;
    data['customerpassword'] = customerpassword;
    data['codes'] = codes;
    return data;
  }
}

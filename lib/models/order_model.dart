class OrderModel {
  List<Order>? orders;

  OrderModel({this.orders});

  OrderModel.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    } else {
      orders = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orders'] = orders?.map((v) => v.toJson()).toList() ?? [];
    return data;
  }
}

class Order {
  int? id;
  String? email;
  String? currency;
  String? financialStatus;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? totalPrice;
  String? subtotalPrice;
  String? totalTax;
  String? orderStatusUrl;
  String? confirmationNumber;
  String? phone;
  String? fulfillmentStatus;
  Customer? customer;
  Address? billingAddress;
  Address? shippingAddress;
  List<LineItem>? lineItems;

  Order({
    this.id,
    this.email,
    this.currency,
    this.financialStatus,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.totalPrice,
    this.subtotalPrice,
    this.totalTax,
    this.orderStatusUrl,
    this.confirmationNumber,
    this.phone,
    this.fulfillmentStatus,
    this.customer,
    this.billingAddress,
    this.shippingAddress,
    this.lineItems,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    currency = json['currency'];
    financialStatus = json['financial_status'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalPrice = json['total_price'];
    subtotalPrice = json['subtotal_price'];
    totalTax = json['total_tax'];
    orderStatusUrl = json['order_status_url'];
    confirmationNumber = json['confirmation_number'];
    phone = json['phone'];
    fulfillmentStatus = json['fulfillment_status'];
    customer =
    json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    billingAddress = json['billing_address'] != null
        ? Address.fromJson(json['billing_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? Address.fromJson(json['shipping_address'])
        : null;
    if (json['line_items'] != null) {
      lineItems = <LineItem>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['currency'] = currency;
    data['financial_status'] = financialStatus;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_price'] = totalPrice;
    data['subtotal_price'] = subtotalPrice;
    data['total_tax'] = totalTax;
    data['order_status_url'] = orderStatusUrl;
    data['confirmation_number'] = confirmationNumber;
    data['phone'] = phone;
    data['fulfillment_status'] = fulfillmentStatus;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (billingAddress != null) {
      data['billing_address'] = billingAddress!.toJson();
    }
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? state;

  Customer(
      {this.id, this.firstName, this.lastName, this.email, this.phone, this.state});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['state'] = state;
    return data;
  }
}

class Address {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? province;
  String? country;
  String? zip;

  Address(
      {this.firstName,
        this.lastName,
        this.address1,
        this.address2,
        this.city,
        this.province,
        this.country,
        this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    province = json['province'];
    country = json['country'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['province'] = province;
    data['country'] = country;
    data['zip'] = zip;
    return data;
  }
}

class LineItem {
  int? id;
  String? name;
  String? title;
  String? price;
  int? quantity;
  String? vendor;
  String? variantTitle;

  LineItem(
      {this.id,
        this.name,
        this.title,
        this.price,
        this.quantity,
        this.vendor,
        this.variantTitle});

  LineItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    price = json['price'];
    quantity = json['quantity'];
    vendor = json['vendor'];
    variantTitle = json['variant_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['price'] = price;
    data['quantity'] = quantity;
    data['vendor'] = vendor;
    data['variant_title'] = variantTitle;
    return data;
  }
}

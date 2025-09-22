class OrderDetailsModel {
  OrderData? orderData;

  OrderDetailsModel({this.orderData});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      orderData: json['order'] != null ? OrderData.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': orderData?.toJson(),
    };
  }
}

class OrderData {
  int? id;
  String? name;
  String? email;
  String? createdAt;
  String? currency;
  String? currentTotalPrice;
  Customer? customer;
  List<LineItem>? lineItems;
  Address? shippingAddress;
  Address? billingAddress;

  OrderData({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.currency,
    this.currentTotalPrice,
    this.customer,
    this.lineItems,
    this.shippingAddress,
    this.billingAddress,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['created_at'],
      currency: json['currency'],
      currentTotalPrice: json['current_total_price'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      lineItems: json['line_items'] != null
          ? List<LineItem>.from(json['line_items'].map((x) => LineItem.fromJson(x)))
          : [],
      shippingAddress: json['shipping_address'] != null ? Address.fromJson(json['shipping_address']) : null,
      billingAddress: json['billing_address'] != null ? Address.fromJson(json['billing_address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt,
      'currency': currency,
      'current_total_price': currentTotalPrice,
      'customer': customer?.toJson(),
      'line_items': lineItems?.map((x) => x.toJson()).toList(),
      'shipping_address': shippingAddress?.toJson(),
      'billing_address': billingAddress?.toJson(),
    };
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  DefaultAddress? defaultAddress;

  Customer({this.id, this.firstName, this.lastName, this.email, this.phone, this.defaultAddress});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      defaultAddress: json['default_address'] != null ? DefaultAddress.fromJson(json['default_address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'default_address': defaultAddress?.toJson(),
    };
  }
}

class DefaultAddress {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? province;
  String? country;
  String? zip;
  String? phone;
  String? company;

  DefaultAddress({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.province,
    this.country,
    this.zip,
    this.phone,
    this.company,
  });

  factory DefaultAddress.fromJson(Map<String, dynamic> json) {
    return DefaultAddress(
      firstName: json['first_name'],
      lastName: json['last_name'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      province: json['province'],
      country: json['country'],
      zip: json['zip'],
      phone: json['phone'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'province': province,
      'country': country,
      'zip': zip,
      'phone': phone,
      'company': company,
    };
  }
}

class LineItem {
  int? id;
  String? name;
  int? quantity;
  String? price;
  String? variantTitle;
  int? productId;
  String? imageUrl;
  LineItem({this.id, this.name, this.quantity, this.price, this.variantTitle, this.productId,this.imageUrl});

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      variantTitle: json['variant_title'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'variant_title': variantTitle,
      'product_id': productId,
    };
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
  String? phone;
  String? company;

  Address({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.province,
    this.country,
    this.zip,
    this.phone,
    this.company,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: json['first_name'],
      lastName: json['last_name'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      province: json['province'],
      country: json['country'],
      zip: json['zip'],
      phone: json['phone'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'province': province,
      'country': country,
      'zip': zip,
      'phone': phone,
      'company': company,
    };
  }
}

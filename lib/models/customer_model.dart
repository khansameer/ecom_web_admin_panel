import 'dart:convert';

/// Top-level model
class CustomerModel {
  final List<Customer>? customers;

  CustomerModel({this.customers});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customers: (json['customers'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "customers": customers?.map((e) => e.toJson()).toList(),
  };

  /// Helper to parse from raw json string
  factory CustomerModel.fromRawJson(String str) =>
      CustomerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

/// Customer Model
class Customer {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? firstName;
  final String? lastName;
  final int? ordersCount;
  final String? state;
  final String? totalSpent;
  final int? lastOrderId;
  final String? note;
  final bool? verifiedEmail;
  final String? multipassIdentifier;
  final bool? taxExempt;
  final String? tags;
  final String? lastOrderName;
  final String? email;
  final String? phone;
  final String? currency;
  final List<Address>? addresses;
  final List<dynamic>? taxExemptions;
  final MarketingConsent? emailMarketingConsent;
  final SmsMarketingConsent? smsMarketingConsent;
  final String? adminGraphqlApiId;
  final Address? defaultAddress;
  String? avatarUrl; // <-- Add this
  Customer({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.ordersCount,
    this.state,
    this.totalSpent,
    this.lastOrderId,
    this.note,
    this.verifiedEmail,
    this.multipassIdentifier,
    this.taxExempt,
    this.avatarUrl,
    this.tags,
    this.lastOrderName,
    this.email,
    this.phone,
    this.currency,
    this.addresses,
    this.taxExemptions,
    this.emailMarketingConsent,
    this.smsMarketingConsent,
    this.adminGraphqlApiId,
    this.defaultAddress,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      ordersCount: json['orders_count'],
      state: json['state'],
      avatarUrl: json['avatar'], // <-- fixed here
      totalSpent: json['total_spent'],
      lastOrderId: json['last_order_id'],
      note: json['note'],
      verifiedEmail: json['verified_email'],
      multipassIdentifier: json['multipass_identifier'],
      taxExempt: json['tax_exempt'],
      tags: json['tags'],
      lastOrderName: json['last_order_name'],
      email: json['email'],
      phone: json['phone'],
      currency: json['currency'],
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e))
          .toList(),
      taxExemptions: json['tax_exemptions'],
      emailMarketingConsent: json['email_marketing_consent'] != null
          ? MarketingConsent.fromJson(json['email_marketing_consent'])
          : null,
      smsMarketingConsent: json['sms_marketing_consent'] != null
          ? SmsMarketingConsent.fromJson(json['sms_marketing_consent'])
          : null,
      adminGraphqlApiId: json['admin_graphql_api_id'],
      defaultAddress: json['default_address'] != null
          ? Address.fromJson(json['default_address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "first_name": firstName,
    "avatar": avatarUrl,

    "last_name": lastName,
    "orders_count": ordersCount,
    "state": state,
    "total_spent": totalSpent,
    "last_order_id": lastOrderId,
    "note": note,
    "verified_email": verifiedEmail,
    "multipass_identifier": multipassIdentifier,
    "tax_exempt": taxExempt,
    "tags": tags,
    "last_order_name": lastOrderName,
    "email": email,
    "phone": phone,
    "currency": currency,
    "addresses": addresses?.map((e) => e.toJson()).toList(),
    "tax_exemptions": taxExemptions,
    "email_marketing_consent": emailMarketingConsent?.toJson(),
    "sms_marketing_consent": smsMarketingConsent?.toJson(),
    "admin_graphql_api_id": adminGraphqlApiId,
    "default_address": defaultAddress?.toJson(),
  };
}

/// Address Model
class Address {
  final int? id;
  final int? customerId;
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? address1;
  final String? address2;
  final String? city;
  final String? province;
  final String? country;
  final String? zip;
  final String? phone;
  final String? name;
  final String? provinceCode;
  final String? countryCode;
  final String? countryName;
  final bool? isDefault;

  Address({
    this.id,
    this.customerId,
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.province,
    this.country,
    this.zip,
    this.phone,
    this.name,
    this.provinceCode,
    this.countryCode,
    this.countryName,
    this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      customerId: json['customer_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      company: json['company'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      province: json['province'],
      country: json['country'],
      zip: json['zip'],
      phone: json['phone'],
      name: json['name'],
      provinceCode: json['province_code'],
      countryCode: json['country_code'],
      countryName: json['country_name'],
      isDefault: json['default'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "first_name": firstName,
    "last_name": lastName,
    "company": company,
    "address1": address1,
    "address2": address2,
    "city": city,
    "province": province,
    "country": country,
    "zip": zip,
    "phone": phone,
    "name": name,
    "province_code": provinceCode,
    "country_code": countryCode,
    "country_name": countryName,
    "default": isDefault,
  };
}

/// Email Marketing Consent
class MarketingConsent {
  final String? state;
  final String? optInLevel;
  final String? consentUpdatedAt;

  MarketingConsent({
    this.state,
    this.optInLevel,
    this.consentUpdatedAt,
  });

  factory MarketingConsent.fromJson(Map<String, dynamic> json) {
    return MarketingConsent(
      state: json['state'],
      optInLevel: json['opt_in_level'],
      consentUpdatedAt: json['consent_updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    "state": state,
    "opt_in_level": optInLevel,
    "consent_updated_at": consentUpdatedAt,
  };
}

/// SMS Marketing Consent
class SmsMarketingConsent {
  final String? state;
  final String? optInLevel;
  final String? consentUpdatedAt;
  final String? consentCollectedFrom;

  SmsMarketingConsent({
    this.state,
    this.optInLevel,
    this.consentUpdatedAt,
    this.consentCollectedFrom,
  });

  factory SmsMarketingConsent.fromJson(Map<String, dynamic> json) {
    return SmsMarketingConsent(
      state: json['state'],
      optInLevel: json['opt_in_level'],
      consentUpdatedAt: json['consent_updated_at'],
      consentCollectedFrom: json['consent_collected_from'],
    );
  }

  Map<String, dynamic> toJson() => {
    "state": state,
    "opt_in_level": optInLevel,
    "consent_updated_at": consentUpdatedAt,
    "consent_collected_from": consentCollectedFrom,
  };
}

// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.token,
    this.id,
    this.role,
    this.storeId,
    this.tenant,
    this.tenantId,
    this.customer,
    this.modules,
  });

  String token;
  int id;
  String role;
  int storeId;
  String tenant;
  int tenantId;
  Customer customer;
  List<String> modules;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        token: json["token"],
        id: json["id"],
        role: json["role"],
        storeId: json["store_id"],
        tenant: json["tenant"],
        tenantId: json["tenant_id"],
        customer: Customer.fromJson(json["customer"]),
        modules: json["modules"] != null
            ? List<String>.from(json["modules"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "role": role,
        "store_id": storeId,
        "tenant": tenant,
        "tenant_id": tenantId,
        "customer": customer.toJson(),
        "modules": List<dynamic>.from(modules.map((x) => x)),
      };
}

class Customer {
  Customer({
    this.id,
    this.customerBillingInformation,
    this.customerShippingInformation,
    this.user,
    this.address,
    this.avatar,
    this.createAt,
    this.updateAt,
    this.social,
    this.description,
    this.enabled,
    this.deleted,
    this.mailingList,
    this.nonTaxable,
    this.tenant,
  });

  int id;
  CustomerIngInformation customerBillingInformation;
  CustomerIngInformation customerShippingInformation;
  User user;
  List<Address> address;
  dynamic avatar;
  DateTime createAt;
  DateTime updateAt;
  dynamic social;
  dynamic description;
  bool enabled;
  bool deleted;
  bool mailingList;
  bool nonTaxable;
  int tenant;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        customerBillingInformation: CustomerIngInformation.fromJson(
            json["customer_billing_information"]),
        customerShippingInformation: CustomerIngInformation.fromJson(
            json["customer_shipping_information"]),
        user: User.fromJson(json["user"]),
        address:
            List<Address>.from(json["address"].map((x) => Address.fromJson(x))),
        avatar: json["avatar"],
        createAt: DateTime.parse(json["create_at"]),
        updateAt: DateTime.parse(json["update_at"]),
        social: json["social"],
        description: json["description"],
        enabled: json["enabled"],
        deleted: json["deleted"],
        mailingList: json["mailing_list"],
        nonTaxable: json["non_taxable"],
        tenant: json["tenant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_billing_information": customerBillingInformation.toJson(),
        "customer_shipping_information": customerShippingInformation.toJson(),
        "user": user.toJson(),
        "address": List<dynamic>.from(address.map((x) => x.toJson())),
        "avatar": avatar,
        "create_at": createAt.toIso8601String(),
        "update_at": updateAt.toIso8601String(),
        "social": social,
        "description": description,
        "enabled": enabled,
        "deleted": deleted,
        "mailing_list": mailingList,
        "non_taxable": nonTaxable,
        "tenant": tenant,
      };
}

class Address {
  Address({
    this.id,
    this.country,
    this.state,
    this.city,
    this.alias,
    this.address,
    this.firstName,
    this.lastName,
    this.company,
    this.phone,
    this.zipCode,
    this.email,
    this.customer,
  });

  int id;
  Country country;
  Country state;
  City city;
  String alias;
  String address;
  String firstName;
  String lastName;
  String company;
  String phone;
  String zipCode;
  String email;
  int customer;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        country: Country.fromJson(json["country"]),
        state: Country.fromJson(json["state"]),
        city: City.fromJson(json["city"]),
        alias: json["alias"],
        address: json["address"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        company: json["company"],
        phone: json["phone"],
        zipCode: json["zip_code"],
        email: json["email"],
        customer: json["customer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country.toJson(),
        "state": state.toJson(),
        "city": city.toJson(),
        "alias": alias,
        "address": address,
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "phone": phone,
        "zip_code": zipCode,
        "email": email,
        "customer": customer,
      };
}

class City {
  City({
    this.id,
    this.name,
    this.name2,
    this.state,
  });

  int id;
  String name;
  String name2;
  int state;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        name2: json["name2"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name2": name2,
        "state": state,
      };
}

class Country {
  Country({
    this.id,
    this.createAt,
    this.updateAt,
    this.name,
    this.code,
    this.name2,
    this.country,
  });

  int id;
  DateTime createAt;
  DateTime updateAt;
  String name;
  String code;
  String name2;
  int country;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        code: json["code"] == null ? null : json["code"],
        name2: json["name2"] == null ? null : json["name2"],
        country: json["country"] == null ? null : json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code == null ? null : code,
        "name2": name2 == null ? null : name2,
        "country": country == null ? null : country,
      };
}

class CustomerIngInformation {
  CustomerIngInformation({
    this.id,
    this.country,
    this.state,
    this.city,
    this.createAt,
    this.updateAt,
    this.address,
    this.firstName,
    this.lastName,
    this.company,
    this.phone,
    this.tax,
    this.zipCode,
    this.createUser,
    this.updateUser,
    this.customer,
    this.addressType,
  });

  int id;
  Country country;
  Country state;
  City city;
  DateTime createAt;
  DateTime updateAt;
  String address;
  String firstName;
  String lastName;
  String company;
  String phone;
  dynamic tax;
  String zipCode;
  int createUser;
  int updateUser;
  int customer;
  dynamic addressType;

  factory CustomerIngInformation.fromJson(Map<String, dynamic> json) =>
      CustomerIngInformation(
        id: json["id"],
        country: Country.fromJson(json["country"]),
        state: Country.fromJson(json["state"]),
        city: City.fromJson(json["city"]),
        createAt: DateTime.parse(json["create_at"]),
        updateAt: DateTime.parse(json["update_at"]),
        address: json["address"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        company: json["company"],
        phone: json["phone"],
        tax: json["tax"],
        zipCode: json["zip_code"],
        createUser: json["create_user"],
        updateUser: json["update_user"],
        customer: json["customer"],
        addressType: json["address_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country.toJson(),
        "state": state.toJson(),
        "city": city.toJson(),
        "create_at": createAt.toIso8601String(),
        "update_at": updateAt.toIso8601String(),
        "address": address,
        "first_name": firstName,
        "last_name": lastName,
        "company": company,
        "phone": phone,
        "tax": tax,
        "zip_code": zipCode,
        "create_user": createUser,
        "update_user": updateUser,
        "customer": customer,
        "address_type": addressType,
      };
}

class User {
  User({
    this.id,
    this.fullName,
    this.password,
    this.lastLogin,
    this.isSuperuser,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.isStaff,
    this.isActive,
    this.dateJoined,
    this.groups,
    this.userPermissions,
  });

  int id;
  String fullName;
  String password;
  dynamic lastLogin;
  bool isSuperuser;
  String username;
  String firstName;
  String lastName;
  String email;
  bool isStaff;
  bool isActive;
  DateTime dateJoined;
  List<dynamic> groups;
  List<dynamic> userPermissions;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        password: json["password"],
        lastLogin: json["last_login"],
        isSuperuser: json["is_superuser"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
        userPermissions:
            List<dynamic>.from(json["user_permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "password": password,
        "last_login": lastLogin,
        "is_superuser": isSuperuser,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "user_permissions": List<dynamic>.from(userPermissions.map((x) => x)),
      };
}

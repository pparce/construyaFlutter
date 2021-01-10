// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.name,
    this.sku,
    this.description,
    this.enabled,
    this.hasOptions,
    this.productImageThumbnail,
    this.productPricing,
    this.productImageMain,
    this.categories,
    this.simpleView,
    this.labels,
  });

  int id;
  String name;
  String sku;
  String description;
  bool enabled;
  bool hasOptions;
  String productImageThumbnail;
  ProductPricing productPricing;
  String productImageMain;
  List<Category> categories;
  bool simpleView;
  List<Label> labels;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        description: json["description"],
        enabled: json["enabled"],
        hasOptions: json["has_options"],
        productImageThumbnail: json["product_image_thumbnail"],
        productPricing: ProductPricing.fromJson(json["product_pricing"]),
        productImageMain: json["product_image_main"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        simpleView: json["simple_view"],
        labels: List<Label>.from(json["labels"].map((x) => Label.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "description": description,
        "enabled": enabled,
        "has_options": hasOptions,
        "product_image_thumbnail": productImageThumbnail,
        "product_pricing": productPricing.toJson(),
        "product_image_main": productImageMain,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "simple_view": simpleView,
        "labels": List<dynamic>.from(labels.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.description,
    this.category,
  });

  int id;
  String name;
  dynamic description;
  int category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: json["category"] == null ? null : json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category == null ? null : category,
      };
}

class Label {
  Label({
    this.id,
    this.name,
    this.description,
    this.code,
    this.place,
    this.position,
    this.color,
    this.background,
    this.enabled,
    this.labelDefault,
    this.qty,
    this.tenant,
  });

  int id;
  String name;
  dynamic description;
  dynamic code;
  String place;
  String position;
  String color;
  String background;
  bool enabled;
  bool labelDefault;
  double qty;
  int tenant;

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        code: json["code"],
        place: json["place"],
        position: json["position"],
        color: json["color"],
        background: json["background"],
        enabled: json["enabled"],
        labelDefault: json["default"],
        qty: json["qty"],
        tenant: json["tenant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "code": code,
        "place": place,
        "position": position,
        "color": color,
        "background": background,
        "enabled": enabled,
        "default": labelDefault,
        "qty": qty,
        "tenant": tenant,
      };
}

class ProductPricing {
  ProductPricing({
    this.id,
    this.realPrice,
    this.price,
    this.retail,
    this.cost,
    this.onSale,
    this.nonTaxable,
    this.sale,
    this.checkPrice,
  });

  int id;
  double realPrice;
  double price;
  dynamic retail;
  dynamic cost;
  bool onSale;
  bool nonTaxable;
  double sale;
  bool checkPrice;

  factory ProductPricing.fromJson(Map<String, dynamic> json) => ProductPricing(
        id: json["id"],
        realPrice: json["real_price"],
        price: json["price"],
        retail: json["retail"],
        cost: json["cost"],
        onSale: json["on_sale"],
        nonTaxable: json["non_taxable"],
        sale: json["sale"],
        checkPrice: json["check_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "real_price": realPrice,
        "price": price,
        "retail": retail,
        "cost": cost,
        "on_sale": onSale,
        "non_taxable": nonTaxable,
        "sale": sale,
        "check_price": checkPrice,
      };
}

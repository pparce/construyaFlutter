import 'dart:convert';
import 'package:construyaalcosto/models/product.dart';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({this.items, this.total});

  List<Item> items;
  double total;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        total: json["total"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "items": items,
      };
}

class Item {
  Item({this.id, this.price, this.qty, this.product, this.subTotal});

  int id;
  double price;
  int qty;
  Product product;
  double subTotal;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        price: json["price"],
        qty: json["qty"],
        subTotal: json["subTotal"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "qty": qty,
        "subTotal": subTotal,
        "product": product,
      };
}

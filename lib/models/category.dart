// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

List<Categorie> categoryFromJson(String str) =>
    List<Categorie>.from(json.decode(str).map((x) => Categorie.fromJson(x)));

String categoryToJson(List<Categorie> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categorie {
  Categorie({
    this.id,
    this.createAt,
    this.updateAt,
    this.name,
    this.description,
    this.sorting,
    this.enabled,
    this.createUser,
    this.updateUser,
    this.category,
    this.tenant,
  });

  int id;
  DateTime createAt;
  DateTime updateAt;
  String name;
  String description;
  int sorting;
  bool enabled;
  int createUser;
  int updateUser;
  int category;
  int tenant;

  factory Categorie.fromJson(Map<String, dynamic> json) => Categorie(
        id: json["id"],
        createAt: DateTime.parse(json["create_at"]),
        updateAt: DateTime.parse(json["update_at"]),
        name: json["name"],
        description: json["description"] == null ? null : json["description"],
        sorting: json["sorting"],
        enabled: json["enabled"],
        createUser: json["create_user"],
        updateUser: json["update_user"],
        category: json["category"] == null ? null : json["category"],
        tenant: json["tenant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt.toIso8601String(),
        "update_at": updateAt.toIso8601String(),
        "name": name,
        "description": description == null ? null : description,
        "sorting": sorting,
        "enabled": enabled,
        "create_user": createUser,
        "update_user": updateUser,
        "category": category == null ? null : category,
        "tenant": tenant,
      };
}

class CategoryList {
  CategoryList({this.category, this.subList, this.isExpanded});

  Categorie category;
  List<Categorie> subList;
  bool isExpanded;
}

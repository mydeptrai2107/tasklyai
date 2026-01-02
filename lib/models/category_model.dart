// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String id;
  String name;
  String color;
  String? type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["_id"],
    name: json["name"],
    color: json["color"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "color": color,
    "type": 'note',
  };
}

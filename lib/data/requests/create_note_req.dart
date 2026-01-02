// To parse this JSON data, do
//
//     final createModelReq = createModelReqFromJson(jsonString);

import 'dart:convert';

CreateNoteReq createModelReqFromJson(String str) =>
    CreateNoteReq.fromJson(json.decode(str));

String createModelReqToJson(CreateNoteReq data) => json.encode(data.toJson());

class CreateNoteReq {
  String title;
  String content;
  String category;

  CreateNoteReq({
    required this.title,
    required this.content,
    required this.category,
  });

  factory CreateNoteReq.fromJson(Map<String, dynamic> json) => CreateNoteReq(
    title: json["title"],
    content: json["content"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "category": category,
  };
}

import 'dart:convert';

NoteModel noteModelFromJson(String str) => NoteModel.fromJson(json.decode(str));

String noteModelToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
  AiSuggestions aiSuggestions;
  String id;
  String user;
  String title;
  String content;
  dynamic category;
  List<String> tags;
  String color;
  bool isPinned;
  bool isArchived;
  dynamic reminderDate;
  DateTime lastOpenedAt;
  DateTime createdAt;
  DateTime updatedAt;

  NoteModel({
    required this.aiSuggestions,
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.category,
    required this.tags,
    required this.color,
    required this.isPinned,
    required this.isArchived,
    required this.reminderDate,
    required this.lastOpenedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    aiSuggestions: AiSuggestions.fromJson(json["aiSuggestions"]),
    id: json["_id"],
    user: json["user"],
    title: json["title"],
    content: json["content"],
    category: json["category"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    color: json["color"],
    isPinned: json["isPinned"],
    isArchived: json["isArchived"],
    reminderDate: json["reminderDate"],
    lastOpenedAt: DateTime.parse(json["lastOpenedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "aiSuggestions": aiSuggestions.toJson(),
    "_id": id,
    "user": user,
    "title": title,
    "content": content,
    "category": category,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "color": color,
    "isPinned": isPinned,
    "isArchived": isArchived,
    "reminderDate": reminderDate,
    "lastOpenedAt": lastOpenedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class AiSuggestions {
  List<dynamic> tasks;

  AiSuggestions({required this.tasks});

  factory AiSuggestions.fromJson(Map<String, dynamic> json) =>
      AiSuggestions(tasks: List<dynamic>.from(json["tasks"].map((x) => x)));

  Map<String, dynamic> toJson() => {
    "tasks": List<dynamic>.from(tasks.map((x) => x)),
  };
}

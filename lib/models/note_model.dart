import 'dart:convert';

import 'package:tasklyai/models/block.dart';

NoteModel noteModelFromJson(String str) => NoteModel.fromJson(json.decode(str));

String noteModelToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
  String id;
  String userId;
  AreaId areaId;
  dynamic projectId;
  FolderId folderId;
  String title;
  String content;
  List<dynamic> tags;
  List<dynamic> attachments;
  String status;
  String energyLevel;
  dynamic dueDate;
  dynamic reminder;
  bool isArchived;
  List<Block> blocks;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  NoteModel({
    required this.id,
    required this.userId,
    required this.areaId,
    required this.projectId,
    required this.folderId,
    required this.title,
    required this.content,
    required this.tags,
    required this.attachments,
    required this.status,
    required this.energyLevel,
    required this.dueDate,
    required this.reminder,
    required this.isArchived,
    required this.blocks,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json["_id"],
    userId: json["userId"],
    areaId: AreaId.fromJson(json["areaId"]),
    projectId: json["projectId"],
    folderId: FolderId.fromJson(json["folderId"]),
    title: json["title"],
    content: json["content"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    status: json["status"],
    energyLevel: json["energyLevel"],
    dueDate: json["dueDate"],
    reminder: json["reminder"],
    isArchived: json["isArchived"],
    blocks: List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    deletedAt: json["deletedAt"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "areaId": areaId.toJson(),
    "projectId": projectId,
    "folderId": folderId.toJson(),
    "title": title,
    "content": content,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "status": status,
    "energyLevel": energyLevel,
    "dueDate": dueDate,
    "reminder": reminder,
    "isArchived": isArchived,
    "blocks": List<dynamic>.from(blocks.map((x) => x.toJson())),
    "deletedAt": deletedAt,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class AreaId {
  String id;
  String name;
  int color;
  int icon;

  AreaId({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory AreaId.fromJson(Map<String, dynamic> json) => AreaId(
    id: json["_id"],
    name: json["name"],
    color: json["color"],
    icon: json['icon'],
  );

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "color": color};
}

class Block {
  BlockType type;
  int order;
  String? textContent;
  String? mediaUrl;
  String? mediaType;
  String? mediaName;
  String id;
  List<ChecklistItem>? checklistItems;

  Block({
    required this.type,
    required this.order,
    required this.textContent,
    required this.mediaUrl,
    required this.mediaType,
    required this.mediaName,
    required this.id,
    this.checklistItems,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    type: BlockType.fromString(json["type"]),
    order: json["order"],
    textContent: json["textContent"],
    mediaUrl: json["mediaUrl"],
    mediaType: json["mediaType"],
    mediaName: json["mediaName"],
    id: json["_id"],
    checklistItems: json["checklistItems"] == null
        ? []
        : List<ChecklistItem>.from(
            json["checklistItems"]!.map((x) => ChecklistItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "order": order,
    "textContent": textContent,
    "mediaUrl": mediaUrl,
    "mediaType": mediaType,
    "mediaName": mediaName,
    "_id": id,
    "checklistItems": checklistItems == null
        ? []
        : List<dynamic>.from(checklistItems!.map((x) => x.toJson())),
  };
}

class ChecklistItem {
  String text;
  bool checked;
  String id;

  ChecklistItem({required this.text, required this.checked, required this.id});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
    text: json["text"],
    checked: json["checked"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "checked": checked,
    "_id": id,
  };
}

class FolderId {
  String id;
  String name;
  int color;
  int icon;

  FolderId({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory FolderId.fromJson(Map<String, dynamic> json) => FolderId(
    id: json["_id"],
    name: json["name"],
    color: json["color"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "color": color,
    "icon": icon,
  };
}

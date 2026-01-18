import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';

QuickNoteModel quickNoteModelFromJson(String str) =>
    QuickNoteModel.fromJson(json.decode(str));

class QuickNoteModel {
  Note note;
  FolderQuick area;
  FolderQuick folder;

  QuickNoteModel({
    required this.note,
    required this.area,
    required this.folder,
  });

  factory QuickNoteModel.fromJson(Map<String, dynamic> json) => QuickNoteModel(
    note: Note.fromJson(json["note"]),
    area: FolderQuick.fromJson(json["area"]),
    folder: FolderQuick.fromJson(json["folder"]),
  );
}

class FolderQuick {
  String id;
  String name;
  int color;
  int icon;
  bool isNew;

  FolderQuick({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.isNew,
  });

  factory FolderQuick.fromJson(Map<String, dynamic> json) => FolderQuick(
    id: json["_id"],
    name: json["name"],
    color: Colors.purple.toARGB32(),
    icon: Icons.auto_awesome.codePoint,
    isNew: json["isNew"],
  );
}

class Note {
  String userId;
  String areaId;
  String folderId;
  String title;
  String content;
  String status;
  Priority energyLevel;
  String id;

  Note({
    required this.userId,
    required this.areaId,
    required this.folderId,
    required this.title,
    required this.content,
    required this.status,
    required this.energyLevel,
    required this.id,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    userId: json["userId"],
    areaId: json["areaId"],
    folderId: json["folderId"],
    title: json["title"],
    content: json["content"],
    status: json["status"],
    energyLevel: Priority.fromString(json["energyLevel"]),
    id: json["id"],
  );
}

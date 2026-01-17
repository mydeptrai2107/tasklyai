import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/core/enum/task_status.dart';
import 'package:tasklyai/models/checklist_item.dart';

class CardModel {
  final String id;
  final String userId;
  final ProjectRef? project;

  final AreaRef? area;
  final FolderRef? folder;

  final String title;
  final String content;

  final List<String> tags;

  final List<CardAttachment> attachments;

  TaskStatus status; // todo | doing | done
  Priority energyLevel; // low | medium | high

  final DateTime? dueDate;
  final DateTime? reminder;

  final bool isArchived;

  final String? link;
  final String? imageUrl;

  final List<ChecklistItem> checklist;

  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    required this.id,
    required this.userId,
    required this.area,
    this.project,
    this.folder,
    required this.title,
    required this.content,
    required this.tags,
    required this.attachments,
    required this.status,
    required this.energyLevel,
    this.dueDate,
    this.reminder,
    required this.isArchived,
    this.link,
    this.imageUrl,
    required this.checklist,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ===============================
  // JSON
  // ===============================
  factory CardModel.fromJson(Map<String, dynamic> json) {
    final areaRaw = json['areaId'];
    final folderRaw = json['folderId'];
    final projectRaw = json['projectId'];

    return CardModel(
      id: json['_id'],
      userId: json['userId'],
      area: areaRaw is Map<String, dynamic> ? AreaRef.fromJson(areaRaw) : null,

      folder: folderRaw is Map<String, dynamic>
          ? FolderRef.fromJson(folderRaw)
          : null,
      project: projectRaw is Map<String, dynamic>
          ? ProjectRef.fromJson(projectRaw)
          : null,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => CardAttachment.fromJson(e))
          .toList(),
      status: TaskStatus.fromString(json["status"]),
      energyLevel: Priority.fromString(json["energyLevel"]),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      reminder: json['reminder'] != null
          ? DateTime.parse(json['reminder'])
          : null,
      isArchived: json['isArchived'] ?? false,
      link: json['link'],
      imageUrl: json['imageUrl'],
      checklist: (json['checklist'] as List<dynamic>? ?? [])
          .map((e) => ChecklistItem.fromJson(e))
          .toList(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'areaId': area?.id,
      'projectId': project,
      'folderId': folder?.id,
      'title': title,
      'content': content,
      'tags': tags,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'status': status,
      'energyLevel': energyLevel,
      'dueDate': dueDate?.toIso8601String(),
      'reminder': reminder?.toIso8601String(),
      'isArchived': isArchived,
      'link': link,
      'imageUrl': imageUrl,
      'checklist': checklist.map((e) => e.toJson()).toList(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ===============================
  // VIRTUAL: checklistProgress
  // ===============================
  ChecklistProgress get checklistProgress {
    if (checklist.isEmpty) {
      return ChecklistProgress(completed: 0, total: 0, percentage: 0);
    }

    final completed = checklist.where((e) => e.checked).length;
    final total = checklist.length;

    return ChecklistProgress(
      completed: completed,
      total: total,
      percentage: ((completed / total) * 100).round(),
    );
  }
}

class ChecklistProgress {
  final int completed;
  final int total;
  final int percentage;

  ChecklistProgress({
    required this.completed,
    required this.total,
    required this.percentage,
  });
}

class CardAttachment {
  final String url;
  final String name;
  final String type;

  CardAttachment({required this.url, required this.name, required this.type});

  factory CardAttachment.fromJson(Map<String, dynamic> json) {
    return CardAttachment(
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'name': name, 'type': type};
  }
}

class AreaRef {
  final String id;
  final String name;
  final int color;
  final int icon;

  AreaRef({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory AreaRef.fromJson(Map<String, dynamic> json) {
    return AreaRef(
      id: json['_id'],
      name: json['name'] ?? '',
      color: json['color'] ?? 0,
      icon: json['icon'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'color': color, 'icon': icon};
  }
}

class ProjectRef {
  final String id;
  final String name;
  final int color;
  final int icon;

  ProjectRef({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory ProjectRef.fromJson(Map<String, dynamic> json) {
    return ProjectRef(
      id: json['_id'],
      name: json['name'] ?? '',
      color: json['color'] ?? 0,
      icon: json['icon'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'color': color, 'icon': icon};
  }
}

class FolderRef {
  final String id;
  final String name;
  final int color;
  final int icon;

  FolderRef({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory FolderRef.fromJson(Map<String, dynamic> json) {
    return FolderRef(
      id: json['_id'],
      name: json['name'] ?? '',
      color: json['color'] ?? 0,
      icon: json['icon'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'color': color, 'icon': icon};
  }
}

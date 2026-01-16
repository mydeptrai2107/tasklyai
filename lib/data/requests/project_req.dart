import 'package:tasklyai/core/configs/formater.dart';

class ProjectReq {
  String name;
  String description;
  int color;
  int icon;
  String areaId;
  String? folderId;
  DateTime startDate;
  DateTime endDate;

  ProjectReq({
    required this.color,
    required this.description,
    required this.endDate,
    required this.icon,
    required this.areaId,
    this.folderId,
    required this.name,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "color": color,
    "icon": icon,
    "areaId": areaId,
    // 'parentId': folderId,
    "startDate": Formatter.dateJson(startDate),
    "endDate": Formatter.dateJson(endDate),
  };
}

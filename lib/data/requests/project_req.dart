import 'package:tasklyai/core/configs/formater.dart';

class ProjectReq {
  String name;
  String description;
  String color;
  DateTime startDate;
  DateTime endDate;

  ProjectReq({
    required this.color,
    required this.description,
    required this.endDate,
    required this.name,
    required this.startDate,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "color": color,
    "startDate": Formatter.dateJson(startDate),
    "endDate": Formatter.dateJson(endDate),
  };
}

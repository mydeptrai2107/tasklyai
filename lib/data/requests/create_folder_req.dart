class CreateFolderReq {
  final String name;
  final String description;
  final int icon;
  final int color;
  final String areaId;

  const CreateFolderReq({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.areaId,
  });

  Map<String, dynamic> toJson() => {
    "areaId": areaId,
    "color": color,
    "icon": icon,
    "name": name,
    "description": description,
  };
}

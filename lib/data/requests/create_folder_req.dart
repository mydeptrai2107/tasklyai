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
    this.areaId = '69651b0819c4b0e77870bb69',
  });

  Map<String, dynamic> toJson() => {
    "areaId": areaId,
    "color": color,
    "icon": icon,
    "name": name,
    "description": description,
  };
}

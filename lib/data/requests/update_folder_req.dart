class UpdateFolderReq {
  final String name;
  final String description;
  final int icon;
  final int color;

  const UpdateFolderReq({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "color": color,
    "icon": icon,
  };
}

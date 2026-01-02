class FetchTaskParams {
  final String? project;
  final String? category;
  final String? priority;
  final String? status;

  const FetchTaskParams({
    this.category,
    this.priority,
    this.project,
    this.status,
  });

  Map<String, dynamic> toJson() => {
    "category": category,
    "priority": priority,
    "project": project,
    "status": status,
  };
}

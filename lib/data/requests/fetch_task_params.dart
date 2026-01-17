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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      "category": category,
      "priority": priority,
      "projectId": project,
      "status": status,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }
}

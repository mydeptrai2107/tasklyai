class ChecklistItem {
  final String? id;
  String text;
  bool checked;

  ChecklistItem({this.id, required this.text, required this.checked});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      checked: json['checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'checked': checked};
  }

  ChecklistItem copyWith({String? id, String? text, bool? checked}) {
    return ChecklistItem(
      id: id ?? this.id,
      text: text ?? this.text,
      checked: checked ?? this.checked,
    );
  }
}

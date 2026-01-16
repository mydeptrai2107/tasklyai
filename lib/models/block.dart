import 'package:tasklyai/models/checklist_item.dart';

enum BlockType {
  text,
  checklist,
  mediaUrl,
  media;

  static BlockType fromString(String value) {
    switch (value) {
      case 'text':
        return BlockType.text;
      case 'checklist':
        return BlockType.checklist;
      case 'mediaUrl':
        return BlockType.mediaUrl;
      case 'media':
        return BlockType.media;
      default:
        return BlockType.text;
    }
  }
}

class NoteBlock {
  final BlockType type;
  final int order;
  final String? textContent;
  final List<ChecklistItem>? checklistItems;

  NoteBlock({
    required this.type,
    required this.order,
    this.textContent,
    this.checklistItems,
  });

  Map<String, dynamic> toJson() {
    if (type == BlockType.media) {
      return {
        "type": "media",
        "mediaType": "image",
        "mediaUrl": textContent,
        "mediaName": "mediaName",
        "order": order,
      };
    }
    return {
      'type': type.name,
      'order': order,
      if (textContent != null) 'textContent': textContent,
      if (checklistItems != null)
        'checklistItems': checklistItems!
            .map((e) => {'text': e.text, 'checked': e.checked})
            .toList(),
    };
  }
}

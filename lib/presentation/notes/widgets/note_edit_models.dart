part of '../note_edit_screen.dart';

class _EditableBlock {
  final String id;
  final String type;
  bool isPinned;
  DateTime? pinnedAt;
  int order;
  String text;
  bool checked;
  List<_ListItem> items;
  String audioUrl;
  int? audioDuration;
  String imageCaption;
  String? imageUrl;
  Map<String, dynamic>? metadata;

  _EditableBlock({
    required this.id,
    required this.type,
    required this.isPinned,
    required this.pinnedAt,
    required this.order,
    required this.text,
    required this.checked,
    required this.items,
    required this.audioUrl,
    required this.audioDuration,
    required this.imageCaption,
    required this.imageUrl,
    required this.metadata,
  });

  factory _EditableBlock.fromCardBlock(CardBlock block) {
    final items = block.listItems
        .map((e) => _ListItem(text: e.text, checked: e.checked))
        .toList();
    return _EditableBlock(
      id: block.id,
      type: block.type,
      isPinned: block.isPinned,
      pinnedAt: block.pinnedAt,
      order: block.order,
      text: block.text ?? block.checkboxLabel ?? '',
      checked: block.checkboxChecked,
      items: items,
      audioUrl: block.audioUrl ?? '',
      audioDuration: block.audioDuration,
      imageCaption: block.imageCaption ?? '',
      imageUrl: block.imageUrl,
      metadata: block.metadata,
    );
  }

  Map<String, dynamic> toBlockPayload() {
    return {
      if (id.isNotEmpty) '_id': id,
      'type': type,
      'isPinned': isPinned,
      if (pinnedAt != null) 'pinnedAt': pinnedAt!.toIso8601String(),
      'content': _toFullContentJson(),
      'metadata': metadata ?? {},
    };
  }

  Map<String, dynamic> _toFullContentJson() {
    switch (type) {
      case 'text':
      case 'heading':
        return {'text': text};
      case 'checkbox':
        return {'label': text, 'checked': checked};
      case 'list':
        return {'items': items.map((e) => e.toJson()).toList()};
      case 'audio':
        return {'audioUrl': audioUrl, 'audioDuration': audioDuration};
      case 'image':
        return {'imageUrl': imageUrl, 'imageCaption': imageCaption};
      default:
        return {};
    }
  }

  Map<String, dynamic> toContentJson() {
    switch (type) {
      case 'text':
      case 'heading':
        return {'text': text};
      case 'checkbox':
        return {'label': text, 'checked': checked};
      case 'list':
        return {'items': items.map((e) => e.toJson()).toList()};
      case 'audio':
        return {'audioUrl': audioUrl, 'audioDuration': audioDuration};
      case 'image':
        return {'imageCaption': imageCaption};
      default:
        return {};
    }
  }
}

class _ListItem {
  String text;
  bool checked;

  _ListItem({required this.text, required this.checked});

  Map<String, dynamic> toJson() {
    return {'text': text, 'checked': checked};
  }
}

enum BlockType { text, heading, checkbox, list, image, audio }

class ListItem {
  String text = '';
  bool checked = false;

  Map<String, dynamic> toJson() {
    return {'text': text, 'checked': checked};
  }
}

class DraftBlock {
  final BlockType type;
  final int order;
  bool isPinned;
  String text;
  bool checked;
  List<ListItem> items;
  String audioUrl;
  int? audioDuration;

  DraftBlock({
    required this.type,
    required this.order,
    this.isPinned = false,
    this.text = '',
    this.checked = false,
    List<ListItem>? items,
    this.audioUrl = '',
    this.audioDuration,
  }) : items = items ?? [];

  factory DraftBlock.text(int order) =>
      DraftBlock(type: BlockType.text, order: order);

  factory DraftBlock.heading(int order) =>
      DraftBlock(type: BlockType.heading, order: order);

  factory DraftBlock.checkbox(int order) =>
      DraftBlock(type: BlockType.checkbox, order: order);

  factory DraftBlock.list(int order) =>
      DraftBlock(type: BlockType.list, order: order, items: [ListItem()]);

  factory DraftBlock.audio(int order) =>
      DraftBlock(type: BlockType.audio, order: order);

  Map<String, dynamic> toJson() {
    final pinnedAt = isPinned ? DateTime.now().toIso8601String() : null;
    switch (type) {
      case BlockType.text:
        return {
          'type': 'text',
          'order': order,
          'isPinned': isPinned,
          'pinnedAt': pinnedAt,
          'content': {'text': text},
        };
      case BlockType.heading:
        return {
          'type': 'heading',
          'order': order,
          'isPinned': isPinned,
          'pinnedAt': pinnedAt,
          'content': {'text': text},
        };
      case BlockType.checkbox:
        return {
          'type': 'checkbox',
          'order': order,
          'isPinned': isPinned,
          'pinnedAt': pinnedAt,
          'content': {'label': text, 'checked': checked},
        };
      case BlockType.list:
        return {
          'type': 'list',
          'order': order,
          'isPinned': isPinned,
          'pinnedAt': pinnedAt,
          'content': {'items': items.map((e) => e.toJson()).toList()},
        };
      case BlockType.audio:
        return {
          'type': 'audio',
          'order': order,
          'isPinned': isPinned,
          'pinnedAt': pinnedAt,
          'content': {'audioUrl': audioUrl, 'audioDuration': audioDuration},
        };
      case BlockType.image:
        return {};
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/folder_dropdown.dart';
import 'package:tasklyai/models/ai_folder_suggestion.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/draft_block.dart';
import 'package:tasklyai/presentation/notes/widgets/voice_to_text_bottom_sheet.dart';
import 'package:tasklyai/presentation/project/provider/ai_provider.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key, this.folderModel});

  final FolderModel? folderModel;

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final List<String> _tags = [];
  final List<DraftBlock> _blocks = [];
  final List<_ImageBlock> _imageBlocks = [];

  late FolderModel? folderSelected;
  AiFolderSuggestion? _folderSuggestion;
  bool _isSuggesting = false;

  String? _cardId;
  bool _isSaving = false;
  int _nextOrder = 0;

  bool get isValid =>
      _titleController.text.trim().isNotEmpty && folderSelected != null;
  bool get isCreated => _cardId != null;

  @override
  void initState() {
    folderSelected = widget.folderModel;
    _tagsController.addListener(_handleTagInput);
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tagsController.removeListener(_handleTagInput);
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _linkController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Note',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: isValid && !_isSaving
                ? () {
                    _finish(context);
                  }
                : null,
            child: const Text('Finish'),
          ),
        ],
      ),
      bottomNavigationBar: _toolbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _inputCard(
              title: 'Folder *',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FolderDropdown(
                    onChanged: (value) {
                      folderSelected = value;
                      setState(() {});
                    },
                    initValue: folderSelected,
                  ),
                  const SizedBox(height: 10),
                  _aiSuggestRow(),
                  if (_folderSuggestion != null) ...[
                    const SizedBox(height: 10),
                    _suggestionCard(),
                  ],
                ],
              ),
            ),
            _inputCard(
              title: 'Title *',
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note title',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none_outlined),
                    onPressed: () => _openVoiceInput(
                      controller: _titleController,
                      append: false,
                    ),
                  ),
                ],
              ),
            ),
            _inputCard(
              title: 'Content',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _contentController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write details...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none_outlined),
                    onPressed: () => _openVoiceInput(
                      controller: _contentController,
                      append: true,
                    ),
                  ),
                ],
              ),
            ),
            _inputCard(
              title: 'Tags (type #tag + space)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_tags.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _tags
                          .map(
                            (tag) => _TagInputChip(
                              tag: tag,
                              onRemove: () => _removeTag(tag),
                            ),
                          )
                          .toList(),
                    ),
                  if (_tags.isNotEmpty) const SizedBox(height: 8),
                  TextFormField(
                    controller: _tagsController,
                    onChanged: (value) {
                      if (value.endsWith(' ')) {
                        _commitTagInputFrom(value);
                      }
                    },
                    onFieldSubmitted: (_) => _commitTagInput(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '#urgent #documentation',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Blocks', style: TextStyle(fontWeight: FontWeight.w600)),
            ..._buildBlocks(),
          ],
        ),
      ),
    );
  }

  Widget _aiSuggestRow() {
    final canSuggest = _titleController.text.trim().isNotEmpty;
    return Row(
      children: [
        const Icon(Icons.auto_awesome, size: 18, color: primaryColor),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'AI suggest folder',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: canSuggest && !_isSuggesting ? _suggestFolder : null,
          child: _isSuggesting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColor,
                  ),
                )
              : const Text('Suggest'),
        ),
      ],
    );
  }

  Widget _suggestionCard() {
    final suggestion = _folderSuggestion;
    if (suggestion == null) return const SizedBox.shrink();
    if (!suggestion.found || suggestion.suggestedFolder == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No folder suggestion found.'),
      );
    }

    final folder = suggestion.suggestedFolder!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Color(folder.color).withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  IconData(folder.icon, fontFamily: 'MaterialIcons'),
                  color: Color(folder.color),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  folder.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(suggestion.confidence * 100).round()}%',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (suggestion.reasoning.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              suggestion.reasoning,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _applySuggestedFolder(folder),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Use this folder'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _toolbar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ToolbarButton(
              icon: Icons.text_fields,
              label: 'Text',
              onTap: () => _addBlock(BlockType.text),
            ),
            _ToolbarButton(
              icon: Icons.title,
              label: 'Heading',
              onTap: () => _addBlock(BlockType.heading),
            ),
            _ToolbarButton(
              icon: Icons.check_box_outlined,
              label: 'Check',
              onTap: () => _addBlock(BlockType.checkbox),
            ),
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              label: 'List',
              onTap: () => _addBlock(BlockType.list),
            ),
            _ToolbarButton(
              icon: Icons.image_outlined,
              label: 'Image',
              onTap: () => _addBlock(BlockType.image),
            ),
            _ToolbarButton(
              icon: Icons.audiotrack_outlined,
              label: 'Audio',
              onTap: () => _addBlock(BlockType.audio),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBlocks() {
    final widgets = <Widget>[];
    for (final block in _blocks) {
      switch (block.type) {
        case BlockType.text:
        case BlockType.heading:
          widgets.add(
            _TextBlockCard(
              block: block,
              onDelete: () => _removeBlock(block),
              onChanged: () => setState(() {}),
            ),
          );
          break;
        case BlockType.checkbox:
          widgets.add(
            _CheckboxBlockCard(
              block: block,
              onDelete: () => _removeBlock(block),
              onChanged: () => setState(() {}),
            ),
          );
          break;
        case BlockType.list:
          widgets.add(
            _ListBlockCard(
              block: block,
              onDelete: () => _removeBlock(block),
              onChanged: () => setState(() {}),
            ),
          );
          break;
        case BlockType.audio:
          widgets.add(
            _AudioBlockCard(
              block: block,
              onDelete: () => _removeBlock(block),
              onChanged: () => setState(() {}),
            ),
          );
          break;
        case BlockType.image:
          break;
      }
    }

    for (final block in _imageBlocks) {
      widgets.add(
        _ImageBlockCard(
          block: block,
          onDelete: () => _removeImageBlock(block),
          onChanged: () => setState(() {}),
        ),
      );
    }

    if (widgets.isEmpty) {
      widgets.add(
        Text(
          isCreated
              ? 'Use the toolbar to add blocks.'
              : 'Use the toolbar to add blocks, or Finish to save.',
          style: const TextStyle(color: Colors.black54),
        ),
      );
    }

    return widgets;
  }

  Future<void> _addBlock(BlockType type) async {
    if (!isValid) {
      _showMessage('Title is required to create the card.');
      return;
    }
    if (!isCreated) {
      final created = await _createCard();
      if (!created) return;
    }

    switch (type) {
      case BlockType.text:
        setState(() => _blocks.add(DraftBlock.text(_nextOrder++)));
        break;
      case BlockType.heading:
        setState(() => _blocks.add(DraftBlock.heading(_nextOrder++)));
        break;
      case BlockType.checkbox:
        setState(() => _blocks.add(DraftBlock.checkbox(_nextOrder++)));
        break;
      case BlockType.list:
        setState(() => _blocks.add(DraftBlock.list(_nextOrder++)));
        break;
      case BlockType.audio:
        setState(() => _blocks.add(DraftBlock.audio(_nextOrder++)));
        break;
      case BlockType.image:
        await _addImageBlock();
        break;
    }
  }

  Future<void> _addImageBlock() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _imageBlocks.add(
        _ImageBlock(order: _nextOrder++, file: File(picked.path)),
      );
    });
  }

  void _removeBlock(DraftBlock block) {
    setState(() => _blocks.remove(block));
  }

  void _removeImageBlock(_ImageBlock block) {
    setState(() => _imageBlocks.remove(block));
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _handleTagInput() {
    final raw = _tagsController.text;
    if (raw.isEmpty || !raw.contains(' ')) return;
    if (raw.endsWith(' ')) {
      _commitTagInputFrom(raw);
    }
  }

  void _commitTagInput() {
    final raw = _tagsController.text.trim();
    if (raw.isEmpty) return;
    final extracted = _extractTags(raw);
    if (extracted.isNotEmpty) {
      for (final tag in extracted) {
        if (!_tags.contains(tag)) _tags.add(tag);
      }
      _tagsController.clear();
      setState(() {});
    }
  }

  void _commitTagInputFrom(String raw) {
    final extracted = _extractTags(raw.trim());
    if (extracted.isEmpty) return;
    for (final tag in extracted) {
      if (!_tags.contains(tag)) _tags.add(tag);
    }
    _tagsController.clear();
    setState(() {});
  }

  List<String> _extractTags(String input) {
    final reg = RegExp(r'#([\p{L}0-9_]+)', unicode: true);
    final matches = reg
        .allMatches(input)
        .map((m) => m.group(1) ?? '')
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList();
    if (matches.isNotEmpty) return matches;
    return input
        .split(RegExp(r'[\s,]+'))
        .map((e) => e.replaceAll('#', '').trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  List<String> _parseTags() {
    _commitTagInput();
    return _tags;
  }

  Future<bool> _createCard() async {
    setState(() => _isSaving = true);
    final data = {
      "areaId": folderSelected!.areaId,
      "folderId": folderSelected!.id,
      "title": _titleController.text.trim(),
      "content": _contentController.text.trim(),
      "tags": _parseTags(),
      "link": _linkController.text.trim().isEmpty
          ? null
          : _linkController.text.trim(),
    };

    final cardId = await context.read<NoteProvider>().createNote(context, data);

    if (!mounted) return false;
    setState(() {
      _cardId = cardId;
      _isSaving = false;
    });
    return cardId != null;
  }

  Future<void> _finish(BuildContext context) async {
    if (_cardId == null) {
      final created = await _createCard();
      if (created && context.mounted) {
        context.read<NoteProvider>().fetchNote(folderSelected!.id);
        Navigator.pop(context);
      }
      return;
    }
    await _saveAndExit();
  }

  Future<void> _saveAndExit() async {
    if (_cardId == null) return;
    setState(() => _isSaving = true);
    final provider = context.read<NoteProvider>();

    if (_blocks.isNotEmpty) {
      await provider.updateNote(
        context: context,
        folderId: folderSelected!.id,
        noteId: _cardId!,
        req: {'blocks': _blocks.map((e) => e.toJson()).toList()},
      );
    }

    for (final block in _imageBlocks) {
      await provider.addBlockWithFile(
        context: context,
        cardId: _cardId!,
        file: block.file,
        caption: block.caption,
        isPinned: block.isPinned,
      );
    }

    if (!mounted) return;
    setState(() {
      _blocks.clear();
      _imageBlocks.clear();
      _isSaving = false;
    });
    if (context.mounted) {
      context.read<NoteProvider>().fetchNote(folderSelected!.id);
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openVoiceInput({
    required TextEditingController controller,
    required bool append,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VoiceToTextBottomSheet(),
    );
    if (result == null || result.trim().isEmpty) return;
    if (!mounted) return;
    final text = result.trim();
    controller.text = append && controller.text.trim().isNotEmpty
        ? '${controller.text.trim()} $text'
        : text;
    setState(() {});
  }

  Future<void> _suggestFolder() async {
    final text = _contentController.text.trim().isNotEmpty
        ? '${_titleController.text.trim()}\n${_contentController.text.trim()}'
        : _titleController.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSuggesting = true);
    final result = await context.read<AiProvider>().suggestFolder(
      context,
      text,
    );
    if (!mounted) return;
    setState(() {
      _folderSuggestion = result;
      _isSuggesting = false;
    });
  }

  void _applySuggestedFolder(SuggestedFolder folder) {
    final folders = context.read<FolderProvider>().folders;
    final match = folders.where((f) => f.id == folder.id).toList();
    if (match.isNotEmpty) {
      folderSelected = match.first;
    } else {
      folderSelected = FolderModel(
        id: folder.id,
        userId: '',
        areaId: folder.areaId,
        name: folder.name,
        description: '',
        color: folder.color,
        icon: folder.icon,
        noteCount: 0,
        passwordHash: null,
        projectCount: 0,
      );
    }
    setState(() {});
  }
}

class _TagInputChip extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const _TagInputChip({required this.tag, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class _ImageBlock {
  final int order;
  final File file;
  String caption = '';
  bool isPinned = false;

  _ImageBlock({required this.order, required this.file});
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: primaryColor),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _BlockCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onDelete;

  const _BlockCard({required this.title, required this.child, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class _TextBlockCard extends StatelessWidget {
  final DraftBlock block;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _TextBlockCard({
    required this.block,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = block.type == BlockType.heading ? 'Heading' : 'Text';
    return _BlockCard(
      title: label,
      onDelete: onDelete,
      child: Column(
        children: [
          TextFormField(
            initialValue: block.text,
            onChanged: (value) {
              block.text = value;
              onChanged();
            },
            maxLines: block.type == BlockType.heading ? 1 : 4,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Type here...',
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckboxBlockCard extends StatelessWidget {
  final DraftBlock block;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _CheckboxBlockCard({
    required this.block,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _BlockCard(
      title: 'Checkbox',
      onDelete: onDelete,
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: block.checked,
                onChanged: (value) {
                  block.checked = value ?? false;
                  onChanged();
                },
              ),
              Expanded(
                child: TextFormField(
                  initialValue: block.text,
                  onChanged: (value) {
                    block.text = value;
                    onChanged();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Label',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListBlockCard extends StatelessWidget {
  final DraftBlock block;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _ListBlockCard({
    required this.block,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _BlockCard(
      title: 'List',
      onDelete: onDelete,
      child: Column(
        children: [
          for (int i = 0; i < block.items.length; i++)
            Row(
              children: [
                Checkbox(
                  value: block.items[i].checked,
                  onChanged: (value) {
                    block.items[i].checked = value ?? false;
                    onChanged();
                  },
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: block.items[i].text,
                    onChanged: (value) {
                      block.items[i].text = value;
                      onChanged();
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Item',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    block.items.removeAt(i);
                    onChanged();
                  },
                ),
              ],
            ),
          TextButton.icon(
            onPressed: () {
              block.items.add(ListItem());
              onChanged();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
        ],
      ),
    );
  }
}

class _AudioBlockCard extends StatelessWidget {
  final DraftBlock block;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _AudioBlockCard({
    required this.block,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _BlockCard(
      title: 'Audio',
      onDelete: onDelete,
      child: Column(
        children: [
          TextFormField(
            initialValue: block.audioUrl,
            onChanged: (value) {
              block.audioUrl = value;
              onChanged();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Audio URL',
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: block.audioDuration == null
                ? ''
                : block.audioDuration.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              block.audioDuration = int.tryParse(value);
              onChanged();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Duration (seconds)',
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBlockCard extends StatelessWidget {
  final _ImageBlock block;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _ImageBlockCard({
    required this.block,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _BlockCard(
      title: 'Image',
      onDelete: onDelete,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(block.file, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: block.caption,
            onChanged: (value) {
              block.caption = value;
              onChanged();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Caption (optional)',
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/folder_dropdown.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';

part 'widgets/note_edit_models.dart';
part 'widgets/note_edit_block_editor.dart';
part 'widgets/note_edit_toolbar.dart';

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen(this.item, {super.key, this.folderId});

  final CardModel item;
  final String? folderId;

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  late final TextEditingController _linkController;

  bool _isBusy = false;
  bool _didChange = false;
  List<_EditableBlock> _blocks = [];

  late String? folderSelected;

  @override
  void initState() {
    folderSelected = widget.item.folder?.id;
    _titleController = TextEditingController(text: widget.item.title);
    _contentController = TextEditingController(text: widget.item.content);
    _tagsController = TextEditingController(text: widget.item.tags.join(', '));
    _linkController = TextEditingController(text: widget.item.link ?? '');
    _blocks = _buildEditableBlocks(widget.item.blocks);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _didChange);
      },
      child: Scaffold(
        backgroundColor: bgColor,
        bottomNavigationBar: _toolbar(),
        body: Column(
          children: [
            _topHeader(context),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _headerCard(context),
                    ),
                  ),
                  if (_blocks.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No blocks yet.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverReorderableList(
                        itemCount: _blocks.length,
                        onReorder: _onReorder,
                        itemBuilder: (context, index) {
                          final block = _blocks[index];
                          return _BlockEditor(
                            key: ValueKey(block.id),
                            index: index,
                            block: block,
                            onChanged: () => setState(() {}),
                            onDelete: _isBusy
                                ? null
                                : () => _deleteBlock(block),
                            onSave: _isBusy ? null : () => _saveBlock(block),
                            onTogglePin: _isBusy
                                ? null
                                : () => _togglePin(block),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ToolbarButton(
                icon: Icons.text_fields,
                label: 'Text',
                onTap: _isBusy ? null : () => _addBlock('text'),
              ),
              _ToolbarButton(
                icon: Icons.title,
                label: 'Heading',
                onTap: _isBusy ? null : () => _addBlock('heading'),
              ),
              _ToolbarButton(
                icon: Icons.check_box_outlined,
                label: 'Check',
                onTap: _isBusy ? null : () => _addBlock('checkbox'),
              ),
              _ToolbarButton(
                icon: Icons.format_list_bulleted,
                label: 'List',
                onTap: _isBusy ? null : () => _addBlock('list'),
              ),
              _ToolbarButton(
                icon: Icons.image_outlined,
                label: 'Image',
                onTap: _isBusy
                    ? null
                    : () {
                        _addImageBlock(context);
                      },
              ),
              _ToolbarButton(
                icon: Icons.audiotrack_outlined,
                label: 'Audio',
                onTap: _isBusy ? null : () => _addBlock('audio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard(BuildContext context) {
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
          Text('Note info', style: context.theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          FolderDropdown(
            onChanged: (value) {
              folderSelected = value.id;
            },
            initFolderId: folderSelected,
          ),
          const SizedBox(height: 8),
          _softField(
            controller: _titleController,
            hintText: 'Title',
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          _softField(
            controller: _contentController,
            hintText: 'Content',
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          _softField(
            controller: _tagsController,
            hintText: 'Tags (comma separated)',
            maxLines: 1,
          ),
          const SizedBox(height: 12),
          _softField(
            controller: _linkController,
            hintText: 'https://...',
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _softField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
      ),
    );
  }

  Widget _topHeader(BuildContext context) {
    final color = _headerColor();
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 12,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          BackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context, _didChange),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Edit Note',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            onPressed: _isBusy ? null : _saveNote,
          ),
          PopupMenuButton<_EditHeaderAction>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == _EditHeaderAction.delete) {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _EditHeaderAction.delete,
                child: _HeaderMenuItem(
                  icon: Icons.delete_outline,
                  text: 'Delete',
                  isDanger: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _headerColor() {
    final folderColor = widget.item.folder?.color;
    final areaColor = widget.item.area?.color;
    if (folderColor != null) return Color(folderColor);
    if (areaColor != null) return Color(areaColor);
    return primaryColor;
  }

  List<_EditableBlock> _buildEditableBlocks(List<CardBlock> blocks) {
    final sorted = [...blocks]..sort((a, b) => a.order.compareTo(b.order));
    return sorted.map(_EditableBlock.fromCardBlock).toList();
  }

  List<String> _parseTags() {
    final raw = _tagsController.text.trim();
    if (raw.isEmpty) return [];
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _saveNote() {
    final folderId = widget.folderId ?? widget.item.folder?.id;
    if (folderId == null) return;
    context.read<NoteProvider>().updateNote(
      context: context,
      folderId: folderId,
      noteId: widget.item.id,
      req: {
        'folderId': folderSelected,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'tags': _parseTags(),
        'link': _linkController.text.trim().isEmpty
            ? null
            : _linkController.text.trim(),
      },
      isShowDialog: false,
    );
    _didChange = true;
    Navigator.pop(context, true);
  }

  void _confirmDelete() {
    final folderId = widget.folderId ?? widget.item.folder?.id;
    if (folderId == null) return;
    DialogService.confirm(
      context,
      message: 'Ban co chac chan muon xoa note?',
      onConfirm: () {
        context.read<NoteProvider>().deleteNote(
          context,
          folderId,
          widget.item.id,
        );
      },
    );
  }

  Future<void> _addBlock(String type) async {
    setState(() => _isBusy = true);
    final content = switch (type) {
      'text' || 'heading' => {'text': ''},
      'checkbox' => {'label': '', 'checked': false},
      'list' => {
        'items': [
          {'text': '', 'checked': false},
        ],
      },
      'audio' => {'audioUrl': '', 'audioDuration': 0},
      _ => {},
    };

    CardModel? updated;
    if (type == 'list' || type == 'heading') {
      final payload = _buildUpdateAllPayload(
        extraBlock: {'type': type, 'content': content},
      );
      updated = await context.read<NoteProvider>().updateAllBlocks(
        context: context,
        cardId: widget.item.id,
        blocks: payload,
      );
    } else {
      updated = await context.read<NoteProvider>().addBlock(
        context: context,
        cardId: widget.item.id,
        data: {'type': type, 'content': content},
      );
    }
    if (!mounted) return;
    if (updated != null) {
      _didChange = true;
      setState(() => _blocks = _buildEditableBlocks(updated!.blocks));
    }
    setState(() => _isBusy = false);
  }

  Future<void> _addImageBlock(BuildContext context) async {
    setState(() => _isBusy = true);
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      setState(() => _isBusy = false);
      return;
    }
    CardModel? updated;

    if (context.mounted) {
      updated = await context.read<NoteProvider>().addBlockWithFile(
        context: context,
        cardId: widget.item.id,
        file: File(picked.path),
        type: 'image',
        caption: '',
        isPinned: false,
      );
    }
    if (!mounted) return;
    if (updated != null) {
      _didChange = true;
      setState(() => _blocks = _buildEditableBlocks(updated!.blocks));
    }
    setState(() => _isBusy = false);
  }

  Future<void> _deleteBlock(_EditableBlock block) async {
    setState(() => _isBusy = true);
    CardModel? updated;
    if (block.id.isEmpty) {
      _blocks.remove(block);
      updated = await context.read<NoteProvider>().updateAllBlocks(
        context: context,
        cardId: widget.item.id,
        blocks: _buildUpdateAllPayload(),
      );
    } else {
      updated = await context.read<NoteProvider>().deleteBlock(
        context: context,
        cardId: widget.item.id,
        blockId: block.id,
      );
    }
    if (!mounted) return;
    if (updated != null) {
      _didChange = true;
      setState(() => _blocks = _buildEditableBlocks(updated!.blocks));
    }
    setState(() => _isBusy = false);
  }

  Future<void> _saveBlock(_EditableBlock block) async {
    setState(() => _isBusy = true);
    CardModel? updated;
    if (block.id.isEmpty) {
      updated = await context.read<NoteProvider>().updateAllBlocks(
        context: context,
        cardId: widget.item.id,
        blocks: _buildUpdateAllPayload(),
      );
    } else {
      updated = await context.read<NoteProvider>().updateBlock(
        context: context,
        cardId: widget.item.id,
        blockId: block.id,
        data: {'content': block.toContentJson()},
      );
    }
    if (!mounted) return;
    if (updated != null) {
      _didChange = true;
      setState(() => _blocks = _buildEditableBlocks(updated!.blocks));
    }
    setState(() => _isBusy = false);
  }

  Future<void> _togglePin(_EditableBlock block) async {
    setState(() => _isBusy = true);
    CardModel? updated;
    if (block.id.isEmpty) {
      block.isPinned = !block.isPinned;
      block.pinnedAt = block.isPinned ? DateTime.now() : null;
      updated = await context.read<NoteProvider>().updateAllBlocks(
        context: context,
        cardId: widget.item.id,
        blocks: _buildUpdateAllPayload(),
      );
    } else {
      updated = await context.read<NoteProvider>().togglePinBlock(
        context: context,
        cardId: widget.item.id,
        blockId: block.id,
      );
    }
    if (!mounted) return;
    if (updated != null) {
      _didChange = true;
      setState(() => _blocks = _buildEditableBlocks(updated!.blocks));
    }
    setState(() => _isBusy = false);
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _blocks.removeAt(oldIndex);
    _blocks.insert(newIndex, item);
    setState(() {});

    CardModel? updated;
    if (_blocks.any((block) => block.id.isEmpty)) {
      updated = await context.read<NoteProvider>().updateAllBlocks(
        context: context,
        cardId: widget.item.id,
        blocks: _buildUpdateAllPayload(),
      );
    } else {
      final orders = <Map<String, dynamic>>[];
      for (var i = 0; i < _blocks.length; i++) {
        orders.add({'blockId': _blocks[i].id, 'order': i});
      }

      updated = await context.read<NoteProvider>().reorderBlocks(
        context: context,
        cardId: widget.item.id,
        blockOrders: orders,
      );
    }
    if (!mounted) return;
    if (updated != null) {
      _didChange = true;
      setState(() => _blocks = _buildEditableBlocks(updated!.blocks));
    }
  }

  List<Map<String, dynamic>> _buildUpdateAllPayload({
    Map<String, dynamic>? extraBlock,
  }) {
    final payload = _blocks.map((block) => block.toBlockPayload()).toList();
    if (extraBlock != null) {
      payload.add(extraBlock);
    }
    return payload;
  }
}

enum _EditHeaderAction { delete }

class _HeaderMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDanger;

  const _HeaderMenuItem({
    required this.icon,
    required this.text,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : Colors.black87;
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

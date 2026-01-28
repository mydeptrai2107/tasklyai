import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/notes/note_edit_screen.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/conver_note_to_task.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen(this.item, {super.key});

  final CardModel item;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late CardModel _item;
  String? _folderId;

  @override
  void initState() {
    _item = widget.item;
    _folderId = widget.item.folder?.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchAllProjects();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blocks = _sortedBlocks(_item.blocks);
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _topHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerCard(context),
                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 12),
                  if (blocks.isEmpty)
                    const Text(
                      'No blocks yet.',
                      style: TextStyle(color: Colors.black54),
                    )
                  else
                    ...blocks.map((block) => _DocBlockView(block)),
                ],
              ),
            ),
          ),
        ],
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
          const BackButton(color: Colors.white),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Note',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          PopupMenuButton<_DetailHeaderAction>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == _DetailHeaderAction.edit) {
                _openEdit(context);
              } else if (value == _DetailHeaderAction.archive) {
                _toggleArchive();
              } else if (value == _DetailHeaderAction.convert) {
                showConvertToTaskDialog(context, _folderId, _item);
              } else if (value == _DetailHeaderAction.delete) {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _DetailHeaderAction.edit,
                child: _HeaderMenuItem(icon: Icons.edit_outlined, text: 'Edit'),
              ),
              PopupMenuItem(
                value: _DetailHeaderAction.archive,
                child: _HeaderMenuItem(
                  icon: Icons.archive_outlined,
                  text: _item.isArchived ? 'Unarchive' : 'Archive',
                ),
              ),
              const PopupMenuItem(
                value: _DetailHeaderAction.convert,
                child: _HeaderMenuItem(
                  icon: Icons.task_alt_outlined,
                  text: 'Convert to task',
                ),
              ),
              const PopupMenuItem(
                value: _DetailHeaderAction.delete,
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
    final folderColor = _item.folder?.color;
    final areaColor = _item.area?.color;
    if (folderColor != null) return Color(folderColor);
    if (areaColor != null) return Color(areaColor);
    return primaryColor;
  }

  Future<void> _openEdit(BuildContext context) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(_item, folderId: _folderId),
      ),
    );
    if (updated == true && context.mounted) {
      final refreshed = await context.read<NoteProvider>().fetchNoteById(
        context,
        _item.id,
      );
      if (refreshed != null) {
        setState(() => _item = refreshed);
      }
      if (_folderId != null && context.mounted) {
        context.read<NoteProvider>().fetchNote(_folderId!);
      }
    }
  }

  void _confirmDelete() {
    if (_folderId == null) return;
    DialogService.confirm(
      context,
      message: 'Ban co chac chan muon xoa note?',
      onConfirm: () {
        context.read<NoteProvider>().deleteNote(context, _folderId!, _item.id);
      },
    );
  }

  Future<void> _toggleArchive() async {
    final provider = context.read<NoteProvider>();
    CardModel? updated;
    if (_item.isArchived) {
      updated = await provider.unarchiveCard(context: context, card: _item);
    } else {
      updated = await provider.archiveCard(context: context, card: _item);
    }
    if (!mounted) return;
    if (updated != null) {
      setState(() => _item = updated!);
    }
  }

  List<CardBlock> _sortedBlocks(List<CardBlock> blocks) {
    final pinned = blocks.where((b) => b.isPinned).toList()
      ..sort(
        (a, b) => b.pinnedAt == null
            ? 1
            : a.pinnedAt == null
            ? -1
            : b.pinnedAt!.compareTo(a.pinnedAt!),
      );
    final others = blocks.where((b) => !b.isPinned).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return [...pinned, ...others];
  }

  Widget _headerCard(BuildContext context) {
    final tags = _item.tags;
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _item.folder?.name ?? 'No folder',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_item.isArchived)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Archived',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                Formatter.date(_item.updatedAt),
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _item.title,
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          if (_item.content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _item.content,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((tag) => _TagChip(tag: tag)).toList(),
            ),
          ],
          if (_item.link != null && _item.link!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.link, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _item.link!,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DocBlockView extends StatelessWidget {
  final CardBlock block;

  const _DocBlockView(this.block);

  @override
  Widget build(BuildContext context) {
    final type = block.type;
    Widget content;

    switch (type) {
      case 'heading':
        content = Text(
          block.text ?? '',
          style: context.theme.textTheme.titleMedium,
        );
        break;
      case 'text':
        content = Text(block.text ?? '');
        break;
      case 'checkbox':
        content = Row(
          children: [
            Icon(
              block.checkboxChecked
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: block.checkboxChecked ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(block.checkboxLabel ?? '')),
          ],
        );
        break;
      case 'list':
        content = Column(
          children: block.listItems.map((item) {
            return Row(
              children: [
                Icon(
                  item.checked
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 16,
                  color: item.checked ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(item.text)),
              ],
            );
          }).toList(),
        );
        break;
      case 'image':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '$baseUrl${block.imageUrl ?? ''}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 140,
                  child: Center(child: Icon(Icons.broken_image_outlined)),
                ),
              ),
            ),
            if ((block.imageCaption ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                block.imageCaption!,
                style: context.theme.textTheme.bodySmall,
              ),
            ],
          ],
        );
        break;
      case 'audio':
        content = Row(
          children: [
            const Icon(Icons.audiotrack_outlined),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                block.audioUrl ?? 'Audio',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (block.audioDuration != null) Text('${block.audioDuration}s'),
          ],
        );
        break;
      default:
        content = Text(block.text ?? '');
        break;
    }

    return Padding(padding: const EdgeInsets.only(bottom: 12), child: content);
  }
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('# $tag', style: const TextStyle(fontSize: 12)),
    );
  }
}

enum _DetailHeaderAction { edit, archive, convert, delete }

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

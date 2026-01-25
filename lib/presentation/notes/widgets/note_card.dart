import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/notes/note_detail_screen.dart';

class NoteCard extends StatelessWidget {
  final CardModel note;

  const NoteCard(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    CardBlock? imageBlock;
    for (final block in note.blocks) {
      if (block.type == 'image' && block.imageUrl != null) {
        imageBlock = block;
        break;
      }
    }
    final imageUrl = imageBlock?.imageUrl;
    final tags = note.tags.take(2).toList();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteDetailScreen(note)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumbnail(url: imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.titleSmall,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.bodySmall,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 24,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (note.blocks.isNotEmpty)
                            _MetaChip(
                              icon: Icons.view_agenda_outlined,
                              label: '${note.blocks.length} blocks',
                            ),
                          if (tags.isNotEmpty)
                            for (final tag in tags) ...[
                              const SizedBox(width: 6),
                              _MetaChip(icon: Icons.tag, label: tag),
                            ],
                        ],
                      ),
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
}

class _Thumbnail extends StatelessWidget {
  final String? url;

  const _Thumbnail({this.url});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: url == null
            ? const Icon(Icons.note_outlined, color: Colors.orange)
            : Image.network(
                '$baseUrl$url',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image_outlined),
              ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final double maxWidth;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.maxWidth = 140,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.black54),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

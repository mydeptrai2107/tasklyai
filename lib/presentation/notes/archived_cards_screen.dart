import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/notes/note_detail_screen.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/project/task_detail_screen.dart';

class ArchivedCardsScreen extends StatefulWidget {
  const ArchivedCardsScreen({super.key});

  @override
  State<ArchivedCardsScreen> createState() => _ArchivedCardsScreenState();
}

class _ArchivedCardsScreenState extends State<ArchivedCardsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchArchivedCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Archived'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, _) {
          final items = provider.archivedCards;
          if (items.isEmpty) {
            return const Center(
              child: Text('No archived notes or tasks.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _ArchivedCardItem(card: items[index]);
            },
          );
        },
      ),
    );
  }
}

class _ArchivedCardItem extends StatelessWidget {
  final CardModel card;

  const _ArchivedCardItem({required this.card});

  bool get _isTask => card.dueDate != null && card.project != null;

  @override
  Widget build(BuildContext context) {
    final color = _isTask ? Colors.orange : primaryColor;
    final badge = _isTask ? 'Task' : 'Note';

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (_isTask) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskDetailScreen(card)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NoteDetailScreen(card)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isTask ? Icons.task_alt : Icons.note_outlined,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (card.content.isNotEmpty)
                        Text(
                          card.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                    ],
                  ),
                ),
                _Badge(text: badge, color: color),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (card.tags.isNotEmpty) _TagChip(text: card.tags.first),
                if (card.dueDate != null)
                  _TagChip(text: Formatter.date(card.dueDate!)),
                if (_isTask) _TagChip(text: card.status.label),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await context
                        .read<NoteProvider>()
                        .unarchiveCard(context: context, card: card);
                  },
                  icon: const Icon(Icons.unarchive, size: 18),
                  label: const Text('Unarchive'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;

  const _TagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }
}

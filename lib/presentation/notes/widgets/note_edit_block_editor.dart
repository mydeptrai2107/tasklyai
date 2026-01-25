part of '../note_edit_screen.dart';

class _BlockEditor extends StatelessWidget {
  final _EditableBlock block;
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback? onSave;
  final VoidCallback? onTogglePin;
  final VoidCallback onChanged;

  const _BlockEditor({
    super.key,
    required this.index,
    required this.block,
    required this.onChanged,
    this.onDelete,
    this.onSave,
    this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (block.type) {
      case 'heading':
      case 'text':
        body = TextFormField(
          initialValue: block.text,
          onChanged: (value) {
            block.text = value;
            onChanged();
          },
          maxLines: block.type == 'heading' ? 1 : 4,
          style: TextStyle(
            fontSize: block.type == 'heading' ? 16 : 14,
            fontWeight: block.type == 'heading'
                ? FontWeight.w600
                : FontWeight.w400,
          ),
          decoration: _blockFieldDecoration(
            hintText: block.type == 'heading' ? 'Heading' : 'Text',
          ),
        );
        break;
      case 'checkbox':
        body = Row(
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
                decoration: _blockFieldDecoration(hintText: 'Label'),
              ),
            ),
          ],
        );
        break;
      case 'list':
        body = Column(
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
                      decoration: _blockFieldDecoration(hintText: 'Item'),
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
                block.items.add(_ListItem(text: '', checked: false));
                onChanged();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add item'),
            ),
          ],
        );
        break;
      case 'audio':
        body = Column(
          children: [
            TextFormField(
              initialValue: block.audioUrl,
              onChanged: (value) {
                block.audioUrl = value;
                onChanged();
              },
              decoration: _blockFieldDecoration(hintText: 'Audio URL'),
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
              decoration: _blockFieldDecoration(hintText: 'Duration (seconds)'),
            ),
          ],
        );
        break;
      case 'image':
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (block.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '$baseUrl${block.imageUrl!}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 140,
                    child: Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: block.imageCaption,
              onChanged: (value) {
                block.imageCaption = value;
                onChanged();
              },
              decoration: _blockFieldDecoration(hintText: 'Caption'),
            ),
          ],
        );
        break;
      default:
        body = const SizedBox.shrink();
        break;
    }

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TypePill(label: block.type.toUpperCase()),
              const Spacer(),
              IconButton(
                icon: Icon(
                  block.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 18,
                  color: block.isPinned ? Colors.orange : Colors.black54,
                ),
                onPressed: onTogglePin,
              ),
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ),
          const Divider(height: 16),
          body,
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSave,
              child: const Text('Save block'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _blockFieldDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF2F3F7),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    );
  }
}

class _TypePill extends StatelessWidget {
  final String label;

  const _TypePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

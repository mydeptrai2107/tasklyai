import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';

class CheckListItem {
  bool isDone;
  String text;

  CheckListItem({this.isDone = false, required this.text});
}

class AddCheckListWidget extends StatefulWidget {
  const AddCheckListWidget({super.key, this.onChanged});

  final ValueChanged<List<CheckListItem>>? onChanged;

  @override
  State<AddCheckListWidget> createState() => _AddCheckListWidgetState();
}

class _AddCheckListWidgetState extends State<AddCheckListWidget> {
  final List<CheckListItem> checkLists = [];

  void _notify() {
    widget.onChanged?.call(List.unmodifiable(checkLists));
  }

  void _addItem() {
    setState(() {
      checkLists.add(CheckListItem(text: ''));
    });
    _notify();
  }

  void _removeItem(int index) {
    setState(() {
      checkLists.removeAt(index);
    });
    _notify();
  }

  void _clearAll() {
    setState(() {
      checkLists.clear();
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              const Icon(Icons.checklist_rounded),
              const SizedBox(width: 8),
              Text('Checklist', style: textTheme.bodyLarge),
              const Spacer(),
              if (checkLists.isNotEmpty)
                InkWell(
                  onTap: _clearAll,
                  child: const Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                ),
            ],
          ),

          /// Checklist items
          for (int i = 0; i < checkLists.length; i++)
            _CheckListItemTile(
              item: checkLists[i],
              onChanged: (value) {
                setState(() {
                  checkLists[i].isDone = value;
                });
                _notify();
              },
              onTextChanged: (value) {
                checkLists[i].text = value;
                _notify();
              },
              onDelete: () => _removeItem(i),
            ),

          /// Add button
          TextButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
        ],
      ),
    );
  }
}

class _CheckListItemTile extends StatelessWidget {
  final CheckListItem item;
  final ValueChanged<bool> onChanged;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onDelete;

  const _CheckListItemTile({
    required this.item,
    required this.onChanged,
    required this.onTextChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Theme(
        data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        child: Checkbox(
          value: item.isDone,
          onChanged: (value) => onChanged(value ?? false),
        ),
      ),
      title: TextFormField(
        initialValue: item.text,
        decoration: const InputDecoration(
          hintText: 'Item...',
          border: InputBorder.none,
        ),
        style: textTheme.bodyMedium?.copyWith(
          decoration: item.isDone ? TextDecoration.lineThrough : null,
          color: item.isDone ? Colors.grey : null,
        ),
        onChanged: onTextChanged,
      ),
      trailing: InkWell(
        onTap: onDelete,
        child: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.red,
          size: 20,
        ),
      ),
    );
  }
}

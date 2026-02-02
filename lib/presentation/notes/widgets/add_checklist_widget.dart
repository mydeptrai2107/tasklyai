import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/checklist_item.dart';

class AddCheckListWidget extends StatefulWidget {
  const AddCheckListWidget({
    super.key,
    this.onChanged,
    this.initValue,
    this.title = 'Checklist',
  });

  final ValueChanged<List<ChecklistItem>>? onChanged;
  final List<ChecklistItem>? initValue;
  final String title;

  @override
  State<AddCheckListWidget> createState() => _AddCheckListWidgetState();
}

class _AddCheckListWidgetState extends State<AddCheckListWidget> {
  List<ChecklistItem> checkLists = [];

  void _notify() {
    widget.onChanged?.call(List.unmodifiable(checkLists));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkLists = List.of(widget.initValue ?? []);
      setState(() {});
    });
    super.initState();
  }

  void _addItem() {
    setState(() {
      checkLists.add(ChecklistItem(text: '', checked: false));
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
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(23),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.checklist_rounded, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (checkLists.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${checkLists.where((e) => e.checked).length}/${checkLists.length}',
                    style: textTheme.bodySmall,
                  ),
                ),
              if (checkLists.isNotEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _clearAll,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),

          /// Checklist items
          for (int i = 0; i < checkLists.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _CheckListItemTile(
                item: checkLists[i],
                onChanged: (value) {
                  setState(() {
                    checkLists[i].checked = value;
                  });
                  _notify();
                },
                onTextChanged: (value) {
                  checkLists[i].text = value;
                  _notify();
                },
                onDelete: () => _removeItem(i),
              ),
            ),

          /// Add button
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add item'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckListItemTile extends StatelessWidget {
  final ChecklistItem item;
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: item.checked ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.checked
              ? colorScheme.primary.withAlpha(65)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Theme(
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
              value: item.checked,
              activeColor: colorScheme.primary,
              onChanged: (value) => onChanged(value ?? false),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: item.text,
              decoration: const InputDecoration(
                hintText: 'Item...',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 2),
              ),
              style: textTheme.bodyMedium?.copyWith(
                decoration: item.checked ? TextDecoration.lineThrough : null,
                color: item.checked ? Colors.grey : null,
              ),
              onChanged: onTextChanged,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_forever_outlined,
              color: Colors.red.shade400,
              size: 20,
            ),
            splashRadius: 18,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}

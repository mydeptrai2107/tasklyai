import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<String> selectedTags = [];
  String selectedColor = 'blue';
  final List<String> categories = [
    'Work',
    'Personal',
    'Ideas',
    'Learning',
    'Health',
    'Q4 Roadmap',
    'Marketing Campaign',
    'Product Launch',
    'Team Building',
  ];
  final TextEditingController _customTagController = TextEditingController();

  final Map<String, Color> colors = {
    'red': Colors.red,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
  };

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn màu'),
        content: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: colors.entries
              .map(
                (entry) => GestureDetector(
                  onTap: () => Navigator.pop(context, entry.key),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ).then((color) {
      if (color != null) setState(() => selectedColor = color);
    });
  }

  void _showTagDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Tags', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final tag = categories[index];
                    final isSelected = selectedTags.contains(tag);
                    return ChoiceChip(
                      label: Text(tag, style: TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                      selectedColor: Theme.of(
                        context,
                      ).primaryColor.withAlpha(51),
                    );
                  },
                ),
              ),
              Divider(),
              TextField(
                controller: _customTagController,
                decoration: InputDecoration(
                  labelText: 'Custom Tag',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final customTag = _customTagController.text.trim();
                      if (customTag.isNotEmpty &&
                          !selectedTags.contains(customTag)) {
                        setState(() => selectedTags.add(customTag));
                        _customTagController.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  final customTag = value.trim();
                  if (customTag.isNotEmpty &&
                      !selectedTags.contains(customTag)) {
                    setState(() => selectedTags.add(customTag));
                  }
                  _customTagController.clear();
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    // Lưu logic ở đây (Hive, SharedPreferences, etc.)
    print('Title: ${_titleController.text}');
    print('Content: ${_contentController.text}');
    print('Tags: $selectedTags');
    print('Color: $selectedColor');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[selectedColor]?.withBlue(25) ?? Colors.grey[50],
      appBar: AppBar(
        title: Text('New Note'),
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.color_lens), onPressed: _showColorPicker),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText:
                    'Start writing your thoughts, or use AI to help organize your ideas.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Text('Tags', style: Theme.of(context).textTheme.titleMedium),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: selectedTags.isEmpty
                      ? null
                      : () => setState(() => selectedTags.clear()),
                  icon: Icon(Icons.clear_all, size: 16),
                  label: Text('Clear'),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _showTagDialog,
                  icon: Icon(Icons.add, size: 16),
                  label: Text('+ Tag'),
                ),
              ],
            ),
            if (selectedTags.isNotEmpty) ...[
              SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: selectedTags
                    .map(
                      (tag) => Chip(
                        label: Text(tag, style: TextStyle(fontSize: 13)),
                        onDeleted: () =>
                            setState(() => selectedTags.remove(tag)),
                        deleteIcon: Icon(Icons.close, size: 16),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _customTagController.dispose();
    super.dispose();
  }
}

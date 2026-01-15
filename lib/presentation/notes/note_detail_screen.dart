import 'package:flutter/material.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/block.dart';
import 'package:tasklyai/models/note_model.dart';
import 'package:tasklyai/presentation/notes/widgets/add_checklist_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_image_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_link_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_text_widget.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen(this.item, {super.key});

  final NoteModel item;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  String? _image;
  String? _link;
  String _content = '';
  List<CheckListItem> _checkList = [];

  late final TextEditingController _titleController;

  bool get isValid =>
      _titleController.text.trim().isNotEmpty && _content.trim().isNotEmpty;

  @override
  void initState() {
    _titleController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _titleController.text = widget.item.title;
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết note',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note title',
              ),
            ),

            AddTextWidget(
              initValue: widget.item.content,
              onChange: (value) {
                _content = value;
                setState(() {});
              },
            ),
            AddLinkWidget(
              onChange: (value) {
                _link = value;
              },
            ),
            AddCheckListWidget(
              onChanged: (list) {
                _checkList = list;
              },
            ),
            AddImageWidget(
              onImageUploaded: (value) {
                _image = value;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isValid
                    ? () {
                        final Map<String, dynamic> data = {
                          "areaId": widget.item.areaId,
                          "folderId": widget.item.folderId,
                          'title': _titleController.text.trim(),
                          'content': _content,
                          'blocks': _buildBlocks()
                              .map((e) => e.toJson())
                              .toList(),
                        };

                        debugPrint(data.toString());
                      }
                    : null,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<NoteBlock> _buildBlocks() {
    final List<NoteBlock> blocks = [];
    int order = 0;

    if (_link != null) {
      blocks.add(
        NoteBlock(type: BlockType.text, order: order++, textContent: _link),
      );
    }

    if (_checkList.isNotEmpty) {
      blocks.add(
        NoteBlock(
          type: BlockType.checklist,
          order: order++,
          checklistItems: _checkList,
        ),
      );
    }

    if (_image != null) {
      blocks.add(
        NoteBlock(type: BlockType.media, order: order++, textContent: _image),
      );
    }

    return blocks;
  }
}

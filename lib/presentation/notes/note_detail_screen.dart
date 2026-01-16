import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/checklist_item.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/add_checklist_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_image_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_link_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_text_widget.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen(this.item, {super.key});

  final CardModel item;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  String? _image;
  String? _link;
  String _content = '';
  List<ChecklistItem> _checkList = [];

  late final TextEditingController _titleController;

  bool get isValid =>
      _titleController.text.trim().isNotEmpty && _content.trim().isNotEmpty;

  @override
  void initState() {
    _titleController = TextEditingController();
    _content = widget.item.content;
    _titleController.text = widget.item.title;
    _link = widget.item.link;
    _image = widget.item.imageUrl;
    _checkList = widget.item.checklist;
    setState(() {});
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
              initValue: _link,
              onChange: (value) {
                _link = value;
              },
            ),
            AddCheckListWidget(
              initValue: _checkList,
              onChanged: (list) {
                _checkList = list;
              },
            ),
            AddImageWidget(
              initUrl: _image,
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
                          'title': _titleController.text.trim(),
                          'content': _content,
                          'link': _link,
                          'imageUrl': _image,
                          'checklist': _checkList
                              .map((e) => e.toJson())
                              .toList(),
                        };

                        debugPrint(data.toString());

                        context.read<NoteProvider>().updateNote(
                          context: context,
                          folderId: widget.item.folder!.id,
                          noteId: widget.item.id,
                          req: data,
                        );
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
}

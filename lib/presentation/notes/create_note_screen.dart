import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/checklist_item.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/add_checklist_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_image_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_link_widget.dart';
import 'package:tasklyai/presentation/notes/widgets/add_text_widget.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen(this.folderModel, {super.key});

  final FolderModel folderModel;

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  String? _image;
  String? _link;
  String _content = '';
  List<ChecklistItem> _checkList = [];

  final _titleController = TextEditingController();

  bool get isValid =>
      _titleController.text.trim().isNotEmpty && _content.trim().isNotEmpty;

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
          'Tạo Note',
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
                          "areaId": widget.folderModel.areaId,
                          "folderId": widget.folderModel.id,
                          'title': _titleController.text.trim(),
                          'content': _content,
                          'link': _link,
                          'imageUrl': _image,
                          'checklist': _checkList
                              .map((e) => e.toJson())
                              .toList(),
                        };

                        debugPrint(data.toString());

                        context.read<NoteProvider>().createNote(
                          context,
                          widget.folderModel.id,
                          data,
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

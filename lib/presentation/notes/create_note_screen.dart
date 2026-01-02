import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/data/requests/create_note_req.dart';
import 'package:tasklyai/models/category_model.dart';
import 'package:tasklyai/presentation/category/add_category_screen.dart';
import 'package:tasklyai/presentation/category/provider/category_provider.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  CategoryModel? selectedTags;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Note', style: textTheme.titleSmall),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// AI HEADER
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withAlpha(22),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.deepPurple.withAlpha(77),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Note',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Start writing your thoughts, or use AI to help organize your ideas.',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TITLE
                  AppTextField(controller: titleCtrl, hint: 'Note title'),

                  const SizedBox(height: 8),

                  /// TAGS
                  Wrap(
                    spacing: 8,
                    children: [
                      ...(selectedTags == null
                              ? <CategoryModel>[]
                              : [selectedTags!])
                          .map((tag) {
                            final color = tag.color.toColor();
                            return Chip(
                              label: Text(
                                tag.name,
                                style: TextStyle(color: color),
                              ),
                              backgroundColor: color.withAlpha(100),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: color),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              deleteIcon: Icon(
                                Icons.cancel_outlined,
                                color: color,
                              ),
                              onDeleted: () {
                                setState(() {
                                  selectedTags == null;
                                });
                              },
                            );
                          }),
                      ActionChip(
                        label: const Text('+ Add tag'),
                        onPressed: () {
                          _openTagSheet(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// CONTENT
                  AppTextField(
                    controller: contentCtrl,
                    maxLines: 10,
                    hint: 'Start writing...',
                  ),

                  GestureDetector(
                    onTap: () {
                      context.read<NoteProvider>().createNote(
                        context,
                        CreateNoteReq(
                          title: titleCtrl.text,
                          content: contentCtrl.text,
                          category: selectedTags!.id,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Tạo Note',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openTagSheet(BuildContext context) async {
    await showModalBottomSheet<List<CategoryModel>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TagBottomSheet(
        onTap: (values) {
          selectedTags = values;
          setState(() {});
        },
      ),
    );
  }
}

class TagBottomSheet extends StatefulWidget {
  const TagBottomSheet({super.key, required this.onTap});

  final Function(CategoryModel values) onTap;

  @override
  State<TagBottomSheet> createState() => _TagBottomSheetState();
}

class _TagBottomSheetState extends State<TagBottomSheet> {
  final TextEditingController customCtrl = TextEditingController();
  CategoryModel? tempSelected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, value, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section('Categories', value.categories),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCategoryScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Custom Category')],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title, List<CategoryModel> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: tags.map((tag) {
            return ChoiceChip(
              label: Text(tag.name),
              selected: tempSelected == tag,
              onSelected: (_) {
                setState(() {
                  tempSelected = tag;
                  widget.onTap.call(tempSelected!);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/models/category_model.dart';
import 'package:tasklyai/presentation/category/provider/category_provider.dart';

const List<Color> presetColors = [
  Color(0xFF6366F1), // Indigo
  Color(0xFF22C55E), // Green
  Color(0xFFF59E0B), // Amber
  Color(0xFFEF4444), // Red
  Color(0xFF3B82F6), // Blue
  Color(0xFF8B5CF6), // Purple
  Color(0xFFEC4899), // Pink
  Color(0xFF14B8A6), // Teal
];

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _controller = TextEditingController();
  Color selectedColor = presetColors.first;

  bool get isValid => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCreate(BuildContext context) {
    final category = CategoryModel(
      id: '',
      name: _controller.text.trim(),
      color: selectedColor.toHex(),
    );

    context.read<CategoryProvider>().createCategory(context, category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'New Category',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isValid) _onCreate(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _preview(),
            const SizedBox(height: 24),
            _nameField(),
            const SizedBox(height: 24),
            _colorPicker(),
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category name',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _controller,
          hint: 'e.g. Work, Personal, Health',
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _colorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: presetColors.map((color) {
            final selected = color == selectedColor;
            return GestureDetector(
              onTap: () => setState(() => selectedColor = color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _preview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedColor.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: selectedColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _controller.text.isEmpty ? 'Category name' : _controller.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: selectedColor,
            ),
          ),
        ],
      ),
    );
  }
}

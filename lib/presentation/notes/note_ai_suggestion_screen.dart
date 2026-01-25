import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/quick_note_model.dart';
import 'package:tasklyai/presentation/home/home_screen.dart';
import 'package:tasklyai/presentation/project/provider/ai_provider.dart';

class QuickNoteAIResultScreen extends StatelessWidget {
  const QuickNoteAIResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Consumer<AiProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: buildAppBar(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                _aiHeader(),
                _noteCard(theme, value.quickNoteModel!),
                _destinationCard(theme, value.quickNoteModel!),
                _actions(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= HEADER =================
  Widget _aiHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.auto_awesome, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI analyzed and organized your note',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= NOTE CARD =================
  Widget _noteCard(ThemeData theme, QuickNoteModel model) {
    final note = model.note;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NOTE', style: _sectionLabel()),
          const SizedBox(height: 8),
          Text(note.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(note.content, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(
                icon: Icons.bolt,
                label: note.energyLevel.name,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _chip(
                icon: Icons.circle,
                label: note.status,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= DESTINATION CARD =================
  Widget _destinationCard(ThemeData theme, QuickNoteModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DESTINATION', style: _sectionLabel()),
          const SizedBox(height: 12),
          _folderRow(
            icon: model.area.icon,
            color: model.area.color,
            title: model.area.name,
            isNew: model.area.isNew,
            label: 'Area',
          ),
          const SizedBox(height: 10),
          _folderRow(
            icon: model.folder.icon,
            color: model.folder.color,
            title: model.folder.name,
            isNew: model.folder.isNew,
            label: 'Folder',
          ),
        ],
      ),
    );
  }

  // ================= ACTIONS =================
  Widget _actions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        },
        child: const Text('Confirm & Save'),
      ),
    );
  }

  // ================= HELPERS =================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  TextStyle _sectionLabel() {
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
      letterSpacing: 1,
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _folderRow({
    required int icon,
    required int color,
    required String title,
    required bool isNew,
    required String label,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Color(color).withAlpha(35),
          child: Icon(
            IconData(icon, fontFamily: 'MaterialIcons'),
            color: Color(color),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        if (isNew)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'NEW $label',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        padding: const EdgeInsets.only(
          top: 30,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F8DFD), Color(0xFF6CA8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Center(
          child: Text(
            'AI Note Result ✨',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/models/ai_task_model.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/task_project/provider/ai_provider.dart';

class AiTaskSuggestionScreen extends StatelessWidget {
  const AiTaskSuggestionScreen(this.areaModel, {super.key});

  final AreaModel areaModel;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiProvider>();
    final tasks = provider.aiProject?.aiTasks ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'AI Task Suggestions',
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C9EFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _headerInfo(),
            _selectionBar(context, provider.selectedCount, tasks.length),
            _taskList(context, tasks),
            _summary(
              provider.highPriorityCount,
              provider.mediumPriorityCount,
              provider.totalMinutes,
            ),
            _actions(context, provider.selectedCount),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _headerInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI-Generated Suggestions',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Based on your project name and type, we’ve generated task suggestions.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ================= SELECT BAR =================
  Widget _selectionBar(BuildContext context, int selected, int total) {
    final provider = context.read<AiProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '$selected of $total selected',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          TextButton(
            onPressed: provider.selectAllTasks,
            child: const Text('Select All'),
          ),
          TextButton(
            onPressed: provider.clearAllTasks,
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // ================= TASK LIST =================
  Widget _taskList(BuildContext context, List<AiTaskModel> tasks) {
    final provider = context.read<AiProvider>();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final task = tasks[i];
        return GestureDetector(
          onTap: () => provider.toggleTask(task),
          child: _taskItem(task),
        );
      },
    );
  }

  Widget _taskItem(AiTaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isSelected ? const Color(0xFF6C9EFF) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            task.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.isSelected ? const Color(0xFF6C9EFF) : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.taskText,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    _priorityBadge(task.energyLevel),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.suggestedTopic,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _chip('${task.estimatedTimeMinutes} min'),
                    _chip(task.suggestedTopic),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI PARTS =================
  Widget _priorityBadge(Priority p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: p.color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(p.name, style: TextStyle(color: p.color, fontSize: 12)),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  // ================= SUMMARY =================
  Widget _summary(int high, int medium, int minutes) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('$high', 'High\nPriority'),
          _summaryItem('$medium', 'Medium\nPriority'),
          _summaryItem('$minutes', 'Total\nMinutes'),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }

  // ================= ACTIONS =================
  Widget _actions(BuildContext context, int selectedCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: selectedCount == 0
                  ? null
                  : () {
                      context.read<AiProvider>().createTaskFromAI(
                        context,
                        areaModel,
                      );
                    },
              child: const Text('⚡ Add Tasks to Project'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Skip AI Suggestions'),
          ),
        ],
      ),
    );
  }
}

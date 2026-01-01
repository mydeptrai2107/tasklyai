import 'package:flutter/material.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/dashed_outline_button.dart';
import 'package:tasklyai/presentation/task_project/new_project_screen.dart';

class TaskProjectScreen extends StatefulWidget {
  const TaskProjectScreen({super.key});

  @override
  State<TaskProjectScreen> createState() => _TaskProjectScreenState();
}

class _TaskProjectScreenState extends State<TaskProjectScreen> {
  bool isTask = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tasks & Projects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              _tab(),

              Expanded(child: isTask ? _taskList() : _projectList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabItem('Tasks', isTask, () {
            setState(() => isTask = true);
          }),
          _tabItem('Projects', !isTask, () {
            setState(() => isTask = false);
          }),
        ],
      ),
    );
  }

  Widget _tabItem(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6)]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _taskList() {
    return ListView(
      children: [
        const Text(
          'Product Development',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        _taskItem(
          title: 'Finish project proposal',
          desc: 'Complete the Q1 project proposal and send to stakeholders',
          date: 'Dec 27',
          priority: 'high',
          status: 'In Progress',
        ),

        _taskItem(
          title: 'Review design mockups',
          desc: 'Check the new mobile app designs from the design team',
          date: 'Dec 26',
          priority: 'medium',
        ),

        _taskItem(
          title: 'Submit expense report',
          desc: 'December expenses for reimbursement',
          date: 'Dec 25',
          priority: 'high',
        ),
      ],
    );
  }

  Widget _taskItem({
    required String title,
    required String desc,
    required String date,
    required String priority,
    String? status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.square, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.circle, size: 8, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(desc, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _tag('⏰ $date (Overdue)', Colors.red),
                      _tag(priority, Colors.grey),
                      if (status != null) _tag(status, primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectList() {
    return ListView(
      children: [
        _projectItem(
          title: 'Product Development',
          done: 1,
          total: 4,
          progress: 0.25,
          color: primaryColor,
        ),
        _projectItem(
          title: 'Book Project',
          done: 1,
          total: 3,
          progress: 0.33,
          color: Colors.green,
        ),
        _projectItem(
          title: 'Tokyo Trip 2025',
          done: 2,
          total: 5,
          progress: 0.4,
          color: Colors.orange,
        ),
        _projectItem(
          title: 'Career',
          done: 0,
          total: 2,
          progress: 0,
          color: Colors.purple,
        ),

        DashedOutlineButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewProjectScreen()),
            );
          },
          color: Colors.grey[350],
          child: Text('Add new project'),
        ),
      ],
    );
  }

  Widget _projectItem({
    required String title,
    required int done,
    required int total,
    required double progress,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.check_circle, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text('$done / $total tasks'),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withAlpha(51),
            color: color,
            minHeight: 6,
          ),
          const SizedBox(height: 6),
          const Text('View tasks', style: TextStyle(color: primaryColor)),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

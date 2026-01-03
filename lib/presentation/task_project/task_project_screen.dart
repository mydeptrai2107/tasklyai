import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/dashed_outline_button.dart';
import 'package:tasklyai/presentation/task_project/new_project_screen.dart';
import 'package:tasklyai/presentation/task_project/new_task_screen.dart';
import 'package:tasklyai/presentation/task_project/provider/ai_provider.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/list_project.dart';
import 'package:tasklyai/presentation/task_project/widgets/list_task.dart';

class TaskProjectScreen extends StatefulWidget {
  const TaskProjectScreen({super.key});

  @override
  State<TaskProjectScreen> createState() => _TaskProjectScreenState();
}

class _TaskProjectScreenState extends State<TaskProjectScreen> {
  bool isTask = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProjectProvider>().fetchProject();
      context.read<TaskProvider>().fetchAllTask(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tasks & Projects', style: textTheme.titleMedium),

              _tab(),

              Expanded(child: isTask ? ListTask() : ListProject()),
              DashedOutlineButton(
                onPressed: () {
                  context.read<AiProvider>().reset();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          isTask ? NewTaskScreen() : NewProjectScreen(),
                    ),
                  );
                },
                color: Colors.grey[350],
                child: Text('Add new ${isTask ? 'task' : 'project'} '),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabItem(context, 'Tasks', isTask, () {
            setState(() => isTask = true);
          }),
          _tabItem(context, 'Projects', !isTask, () {
            setState(() => isTask = false);
          }),
        ],
      ),
    );
  }

  Widget _tabItem(
    BuildContext context,
    String text,
    bool active,
    VoidCallback onTap,
  ) {
    final textTheme = context.theme.textTheme;

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
              style: textTheme.titleSmall?.copyWith(
                color: active ? Colors.black : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

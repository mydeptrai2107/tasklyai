import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/task_model.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/task_item.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TaskProvider, List<TaskModel>>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return TaskItem(value[index]);
          },
        );
      },
      selector: (_, p) => p.allTask,
    );
  }
}
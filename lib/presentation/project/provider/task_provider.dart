import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/fetch_task_params.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';
import 'package:tasklyai/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final _taskRepository = TaskRepository();

  List<CardModel> _allTask = [];
  List<CardModel> get allTask => _allTask;

  List<CardModel> _taskByProject = [];
  List<CardModel> get taskByProject => _taskByProject;

  Future<void> fetchAllTask(BuildContext context) async {
    try {
      _allTask = await _taskRepository.fetchTask();
      notifyListeners();
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> fetchTaskByProject(String project) async {
    try {
      _taskByProject = await _taskRepository.fetchTask(
        params: FetchTaskParams(project: project),
      );
    } on FormatException catch (_) {
      _taskByProject = [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> createTask(
    BuildContext context,
    ProjectModel project,
    Map<String, dynamic> data,
  ) async {
    try {
      await _taskRepository.createTask(data);
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Tạo task thành công',
          onOk: () {
            Navigator.pop(context);
          },
        );
        fetchTaskByProject(project.id);
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> updateTask({
    required BuildContext context,
    String? projectId,
    String? areaId,
    required String taskId,
    required Map<String, dynamic> params,
    bool isShowDialog = true,
  }) async {
    try {
      await _taskRepository.updateTask(params, taskId);
      if (projectId != null) fetchTaskByProject(projectId);
      if (context.mounted) {
        if (areaId != null) {
          context.read<ProjectProvider>().fetchProjectByArea(areaId);
        }
        if (isShowDialog) {
          DialogService.success(context, message: 'Cập nhật task thành công');
        }
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> deleteTask(BuildContext context, CardModel card) async {
    try {
      await _taskRepository.deleteTask(card.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Xóa task thành công')));
        if (card.project != null) {
          fetchTaskByProject(card.project!.id);
        }
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }
}

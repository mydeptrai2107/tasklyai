import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/data/requests/fetch_task_params.dart';
import 'package:tasklyai/data/requests/task_req.dart';
import 'package:tasklyai/models/task_model.dart';
import 'package:tasklyai/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final _taskRepository = TaskRepository();

  String _projectSelected = '';
  String get projectSelected => _projectSelected;

  Priority? _priority;
  Priority? get priority => _priority;

  List<String> _subTabs = [];
  List<String> get subTabs => _subTabs;

  List<TaskModel> _allTask = [];
  List<TaskModel> get allTask => _allTask;

  List<TaskModel> _taskByProject = [];
  List<TaskModel> get taskByProject => _taskByProject;

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

  Future<void> createTask(BuildContext context, TaskReq task) async {
    try {
      await _taskRepository.createTask(task);
      if (context.mounted) {
        DialogService.success(context, message: 'Tạo task thành công');
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> updateTask({
    required BuildContext context,
    required String taskId,
    required Map<String, dynamic> params,
    bool isShowDialog = true,
  }) async {
    try {
      await _taskRepository.updateTask(params, taskId);
      if (context.mounted) {
        fetchAllTask(context);
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

  void selectProject(String project) {
    _projectSelected = project;
    notifyListeners();
  }

  void selectPriority(Priority? priority) {
    _priority = priority;
    notifyListeners();
  }

  void addSubTab(String subTask) {
    List<String> clone = List.from(_subTabs);
    clone.add(subTask);
    _subTabs = clone;
    notifyListeners();
  }

  void removeSubTab(String subTask) {
    List<String> clone = List.from(_subTabs);
    clone.remove(subTask);
    _subTabs = clone;
    notifyListeners();
  }
}

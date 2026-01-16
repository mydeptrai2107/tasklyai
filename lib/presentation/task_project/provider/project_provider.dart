import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/repository/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository repository = ProjectRepository();

  List<ProjectModel> _projects = [];
  List<ProjectModel> get project => _projects;

  bool get hasProjects => _projects.isNotEmpty;


  Future<void> createProject(BuildContext context, ProjectReq project) async {
    try {
      await repository.createProject(project);
      if (context.mounted) {
        DialogService.success(context, message: 'Tạo dự án thành cộng');
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> fetchProject() async {
    try {
      _projects = await repository.fetchProject();
      notifyListeners();
    } on FormatException catch (_) {}
  }
}

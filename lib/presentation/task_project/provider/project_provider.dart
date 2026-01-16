import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/repository/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository repository = ProjectRepository();

  List<ProjectModel> _projectsArea = [];
  List<ProjectModel> get projectsArea => _projectsArea;

  bool get hasProjects => _projectsArea.isNotEmpty;

  Future<void> createProject(
    BuildContext context,
    String areaId,
    ProjectReq project,
  ) async {
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

  Future<void> fetchProjectByArea(String areaId) async {
    try {
      _projectsArea = await repository.fetchProjectByArea(areaId);
        notifyListeners();
    } on FormatException catch (_) {}
  }
}

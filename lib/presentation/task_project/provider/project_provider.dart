import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/repository/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository repository = ProjectRepository();

  Future<void> createProject(BuildContext context, ProjectModel project) async {
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
}

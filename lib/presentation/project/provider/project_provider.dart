import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/models/project_share_model.dart';
import 'package:tasklyai/repository/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository repository = ProjectRepository();

  List<ProjectModel> _projectsArea = [];
  List<ProjectModel> get projectsArea => _projectsArea;

  bool get hasProjects => _projectsArea.isNotEmpty;

  List<ProjectModel> _allProjects = [];
  List<ProjectModel> get allProjects => _allProjects;

  List<ProjectModel> _sharedWithMe = [];
  List<ProjectModel> get sharedWithMe => _sharedWithMe;

  ProjectShareSummary? _shareSummary;
  ProjectShareSummary? get shareSummary => _shareSummary;

  bool _shareLoading = false;
  bool get shareLoading => _shareLoading;

  Future<void> fetchAllProjects() async {
    try {
      _allProjects = await repository.fetchAllProjects();
      notifyListeners();
    } on FormatException catch (_) {}
  }

  Future<void> createProject(
    BuildContext context,
    String areaId,
    ProjectReq project,
  ) async {
    try {
      await repository.createProject(project);
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Tạo dự án thành cộng',
          onOk: () {
            Navigator.pop(context);
            fetchProjectByArea(areaId);
            fetchAllProjects();
          },
        );
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

  Future<void> fetchSharedWithMe() async {
    try {
      _sharedWithMe = await repository.fetchSharedWithMe();
      notifyListeners();
    } on FormatException catch (e) {
      print(e);
    }
  }

  Future<ProjectModel?> updateProject(
    BuildContext context,
    String areaId,
    String projectId,
    ProjectReq req,
  ) async {
    try {
      final updated = await repository.updateProject(projectId, req.toJson());
      await fetchProjectByArea(areaId);
      await fetchAllProjects();
      return updated;
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<void> deleteProject(
    BuildContext context,
    String areaId,
    String projectId,
  ) async {
    try {
      await repository.deleteProject(projectId);
      await fetchProjectByArea(areaId);
      await fetchAllProjects();
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> fetchSharedUsers(String projectId) async {
    try {
      _shareLoading = true;
      notifyListeners();
      final data = await repository.fetchSharedUsers(projectId);
      _shareSummary = ProjectShareSummary.fromJson(data);
    } on FormatException catch (_) {
    } finally {
      _shareLoading = false;
      notifyListeners();
    }
  }

  Future<void> shareProject(
    BuildContext context,
    String projectId,
    String email,
  ) async {
    try {
      await repository.shareProject(projectId, email);
      await fetchSharedUsers(projectId);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> unshareProject(
    BuildContext context,
    String projectId,
    String userId,
  ) async {
    try {
      await repository.unshareProject(projectId, userId);
      await fetchSharedUsers(projectId);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }
}

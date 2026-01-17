import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/ai_project_model.dart';
import 'package:tasklyai/models/ai_task_model.dart';
import 'package:tasklyai/presentation/notes/widgets/task_ai_suggest_bottom_sheet.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';
import 'package:tasklyai/repository/ai_repository.dart';

class AiProvider extends ChangeNotifier {
  bool _aiIsLoading = false;
  bool get aiIsLoading => _aiIsLoading;

  AiProjectModel? _aiProject;
  AiProjectModel? get aiProject => _aiProject;

  String _recording = '';
  String get recording => _recording;

  final _aiRepository = AiRepository();

  Future<void> analyzeNote(BuildContext context, String text) async {
    try {
      _aiIsLoading = true;
      notifyListeners();
      _aiProject = await _aiRepository.analyzeNote(text);
      _aiIsLoading = false;
      notifyListeners();
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 0.9,
              minChildSize: 0.6,
              builder: (context, scrollController) => TaskAiSuggestBottomSheet(
                text: text,
                controller: scrollController,
              ),
            );
          },
        );
      }
    } on FormatException catch (e) {
      _aiIsLoading = false;
      notifyListeners();
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> createTaskFromAI(
    BuildContext context,
    ProjectReq req,
    List<AiTaskModel> tasks,
  ) async {
    try {
      await _aiRepository.createTaskFromAi(
        tasks.where((e) => e.isSlected).toList(),
        req,
      );
      if (context.mounted) {
        DialogService.success(context, message: 'Tạo project thành công');
        context.read<ProjectProvider>().fetchProjectByArea('');
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  void setRecoring(String value) {
    _recording = value;
    notifyListeners();
  }

  void reset() {
    _recording = '';
    _aiIsLoading = false;
    _aiProject = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/models/ai_task_model.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/quick_note_model.dart';
import 'package:tasklyai/models/suggestion_model.dart';
import 'package:tasklyai/presentation/notes/note_ai_suggestion_screen.dart';
import 'package:tasklyai/presentation/project/ai_task_suggestion_screen.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';
import 'package:tasklyai/repository/ai_repository.dart';
import 'package:provider/provider.dart';

class AiProvider extends ChangeNotifier {
  final _aiRepository = AiRepository();

  bool _aiIsLoading = false;
  bool get aiIsLoading => _aiIsLoading;

  SuggestionsModel? _aiProject;
  SuggestionsModel? get aiProject => _aiProject;

  QuickNoteModel? _quickNoteModel;
  QuickNoteModel? get quickNoteModel => _quickNoteModel;

  /* =======================
   * TASK HELPERS
   * ======================= */

  List<AiTaskModel> get tasks => _aiProject?.aiTasks ?? [];

  int get selectedCount => tasks.where((e) => e.isSelected).length;

  int get highPriorityCount =>
      tasks.where((e) => e.isSelected && e.energyLevel == Priority.high).length;

  int get mediumPriorityCount => tasks
      .where((e) => e.isSelected && e.energyLevel == Priority.medium)
      .length;

  int get totalMinutes => tasks
      .where((e) => e.isSelected)
      .fold(0, (sum, e) => sum + e.estimatedTimeMinutes);

  /* =======================
   * STATE ACTIONS
   * ======================= */

  void toggleTask(AiTaskModel task) {
    task.isSelected = !task.isSelected;
    notifyListeners();
  }

  void selectAllTasks() {
    for (var t in tasks) {
      t.isSelected = true;
    }
    notifyListeners();
  }

  void clearAllTasks() {
    for (var t in tasks) {
      t.isSelected = false;
    }
    notifyListeners();
  }

  /* =======================
   * API
   * ======================= */

  Future<void> analyzeNote(
    BuildContext context,
    AreaModel areaModel,
    String text,
  ) async {
    try {
      _aiIsLoading = true;
      notifyListeners();

      _aiProject = await _aiRepository.analyzeNote(text);

      _aiIsLoading = false;
      notifyListeners();

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AiTaskSuggestionScreen(areaModel)),
        );
      }
    } catch (e) {
      _aiIsLoading = false;
      notifyListeners();
      if (context.mounted) {
        DialogService.error(context, message: 'Sử dụng AI không thành công');
      }
    }
  }

  Future<void> createTaskFromAI(BuildContext context, AreaModel req) async {
    try {
      if (_aiProject == null) {
        return;
      }
      _aiProject!.areaId = req.id;
      await _aiRepository.createTaskFromAi(aiProject!);

      if (context.mounted) {
        context.read<ProjectProvider>().fetchProjectByArea(req.id);
        DialogService.success(
          context,
          message: 'Tạo project thành công',
          onOk: () {
            Navigator.pop(context);
          },
        );
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    } finally {
      _aiProject = null;
      notifyListeners();
    }
  }

  Future<void> quickNoteFromAI(BuildContext context, String text) async {
    try {
      _aiIsLoading = true;
      notifyListeners();

      _quickNoteModel = await _aiRepository.quickNoteAI(text);

      _aiIsLoading = false;
      notifyListeners();
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return QuickNoteAIResultScreen();
            },
          ),
        );
      }
    } on FormatException catch (e) {
      _aiIsLoading = false;
      notifyListeners();
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    } finally {
      _aiProject = null;
      notifyListeners();
    }
  }
}

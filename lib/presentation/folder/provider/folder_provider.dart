import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/create_folder_req.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/repository/folder_repository.dart';

class FolderProvider extends ChangeNotifier {
  List<FolderModel> _folders = [];
  List<FolderModel> get folders => _folders;

  final FolderRepository _folderRepository = FolderRepository();

  Future<void> fetchFolder(String areaId) async {
    try {
      _folders = await _folderRepository.fetchFolder(areaId);
      notifyListeners();
    } on FormatException catch (_) {}
  }

  Future<void> createFolder(BuildContext context, CreateFolderReq req) async {
    try {
      await _folderRepository.createFolder(req);
      DialogService.success(
        context,
        message: 'Tạo folder thành công',
        onOk: () {
          fetchFolder(req.areaId);
          Navigator.pop(context);
        },
      );
    } on FormatException catch (e) {
      DialogService.error(context, message: e.message);
    }
  }
}

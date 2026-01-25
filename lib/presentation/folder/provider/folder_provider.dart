import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/create_folder_req.dart';
import 'package:tasklyai/data/requests/update_folder_req.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';
import 'package:tasklyai/repository/folder_repository.dart';

class FolderProvider extends ChangeNotifier {
  List<FolderModel> _folders = [];
  List<FolderModel> get folders => _folders;

  List<FolderModel> _allFolders = [];
  List<FolderModel> get allFolders => _allFolders;

  final FolderRepository _folderRepository = FolderRepository();

  Future<void> fetchAllFolder() async {
    try {
      _allFolders = await _folderRepository.fetchFolder(null);
      notifyListeners();
    } on FormatException catch (_) {}
  }

  Future<void> fetchFolder(String? areaId) async {
    try {
      _folders = await _folderRepository.fetchFolder(areaId);
      notifyListeners();
    } on FormatException catch (_) {}
  }

  Future<void> createFolder(BuildContext context, CreateFolderReq req) async {
    try {
      await _folderRepository.createFolder(req);
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Tạo folder thành công',
          onOk: () {
            fetchFolder(req.areaId);
            fetchAllFolder();
            Navigator.pop(context);
          },
        );
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> updateFolder(
    BuildContext context,
    FolderModel folder,
    UpdateFolderReq req,
  ) async {
    try {
      await _folderRepository.updateFolder(folder.id, req.toJson());
      folder.name = req.name;
      folder.description = req.description;
      folder.color = req.color;
      folder.icon = req.icon;
      final index = _folders.indexWhere((item) => item.id == folder.id);
      if (index != -1) {
        _folders[index] = folder;
      }
      notifyListeners();
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Update folder successfully',
          onOk: () {
            Navigator.pop(context, true);
          },
        );
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> protectFolder(
    String areaId,
    String folderId,
    String password,
  ) async {
    try {
      await _folderRepository.updateFolder(folderId, {
        "passwordHash": password,
      });
      fetchFolder(areaId);
      fetchAllFolder();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteFolder(BuildContext context, FolderModel folder) async {
    try {
      await _folderRepository.deleteFolder(folder.id);
      fetchFolder(folder.areaId);
      fetchAllFolder();

      if (context.mounted) {
        context.read<AreaProvider>().fetchArea();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Xóa folder thành công')));
        Navigator.pop(context);
      }
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> unlockFolder(BuildContext context, FolderModel folder) async {
    try {
      await _folderRepository.updateFolder(folder.id, {"passwordHash": null});
      fetchFolder(folder.areaId);
      fetchAllFolder();
    } on FormatException catch (_) {}
  }

  Future<bool> verifyFolder(String idFolder, String password) async {
    try {
      return await _folderRepository.verifyFolder(idFolder, password);
    } on FormatException catch (_) {
      return false;
    }
  }
}

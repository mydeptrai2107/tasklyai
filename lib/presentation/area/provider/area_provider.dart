import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/create_area_req.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/repository/area_repository.dart';

class AreaProvider extends ChangeNotifier {
  List<AreaModel> _areas = [];
  List<AreaModel> get areas => _areas;

  final AreaRepository areaRepository = AreaRepository();

  Future<void> fetchArea() async {
    try {
      _areas = await areaRepository.fetchArea();
      notifyListeners();
    } on FormatException catch (_) {}
  }

  Future<void> createArea(BuildContext context, CreateAreaReq req) async {
    try {
      await areaRepository.createArea(req);
      DialogService.success(
        context,
        message: 'Tạo area thành công',
        onOk: () {
          fetchArea();
          Navigator.pop(context);
        },
      );
    } on FormatException catch (e) {
      DialogService.error(context, message: e.message);
    }
  }

  Future<void> deleteArea(BuildContext context, String id) async {
    try {
      await areaRepository.deleteArea(id);
      fetchArea();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Xóa area thành công')));
        Navigator.pop(context);
      }
    } on FormatException catch (e) {
      DialogService.error(context, message: e.message);
    }
  }
}

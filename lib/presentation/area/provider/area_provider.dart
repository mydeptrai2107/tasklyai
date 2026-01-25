import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/create_area_req.dart';
import 'package:tasklyai/data/requests/update_area_req.dart';
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

  Future<void> updateArea(
    BuildContext context,
    AreaModel area,
    UpdateAreaReq req,
  ) async {
    try {
      await areaRepository.updateArea(area.id, req.toJson());
      area.name = req.name;
      area.description = req.description;
      area.color = req.color;
      area.icon = req.icon;
      final index = _areas.indexWhere((item) => item.id == area.id);
      if (index != -1) {
        _areas[index] = area;
      }
      notifyListeners();
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Update area successfully',
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
}

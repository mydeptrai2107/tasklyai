import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/category_model.dart';
import 'package:tasklyai/repository/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  final CategoryRepository _repository = CategoryRepository();

  CategoryProvider() {
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      _categories = await _repository.fetchCategory();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> createCategory(BuildContext context, CategoryModel cate) async {
    try {
      await _repository.createCategory(cate);
      if (context.mounted) {
        DialogService.success(context, message: 'Tạo category thành công');
        fetchCategory();
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }
}

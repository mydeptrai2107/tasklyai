import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/category_model.dart';

class CategoryRepository {
  final _dioClient = DioClient();

  Future<List<CategoryModel>> fetchCategory() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.category);
      return (res.data['data'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createCategory(CategoryModel category) async {
    try {
      await _dioClient.post(ApiEndpoint.category, data: category.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }
}

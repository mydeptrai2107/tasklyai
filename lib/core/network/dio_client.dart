import 'package:dio/dio.dart';
import 'package:tasklyai/core/configs/constant.dart';
import 'package:tasklyai/core/configs/local_storage.dart';

class DioClient {
  final Dio _dio;
  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'http://192.168.1.17:3000/api',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          String token = LocalStorage.getString(kToken);
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get(endpoint, queryParameters: params);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: {
            "Content-Type": data is FormData
                ? "multipart/form-data"
                : "application/json",
          },
        ),
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> patch(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.patch(endpoint, data: data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _dio.delete(endpoint, data: data, queryParameters: params);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Response _handleError(DioException e) {
    final errorMessage = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => 'Kết nối bị gián đoạn. Vui lòng thử lại.',
      DioExceptionType.badResponse => switch (e.response?.statusCode) {
        400 => 'Yêu cầu không hợp lệ',
        401 => 'Bạn không có quyền truy cập. Vui lòng đăng nhập lại.',
        403 => 'Bạn không có quyền thực hiện hành động này.',
        404 => 'Dữ liệu không tồn tại hoặc đã bị xóa.',
        500 => 'Lỗi máy chủ. Vui lòng thử lại sau.',
        _ => 'Lỗi không xác định. Vui lòng thử lại.',
      },
      DioExceptionType.cancel => 'Yêu cầu đã bị hủy.',
      DioExceptionType.unknown =>
        'Không thể kết nối đến máy chủ. Kiểm tra internet.',
      _ => 'Không thể kết nối đến máy chủ. Kiểm tra internet.',
    };

    throw FormatException(errorMessage);
  }
}

import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/notification_model.dart';

class NotificationRepository {
  final _dioClient = DioClient();

  Future<NotificationPage> fetchNotifications({
    bool? isRead,
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (isRead != null) 'isRead': isRead.toString(),
        if (type != null && type.isNotEmpty) 'type': type,
      };
      final res = await _dioClient.get(
        ApiEndpoint.notifications,
        params: params,
      );
      final items = (res.data['notifications'] as List<dynamic>? ?? [])
          .map((e) => NotificationModel.fromJson(e))
          .toList();
      final unreadCount = res.data['unreadCount'] ?? 0;
      return NotificationPage(
        notifications: items,
        unreadCount: unreadCount,
      );
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _dioClient.put(
        '${ApiEndpoint.notifications}/$notificationId/read',
      );
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dioClient.put('${ApiEndpoint.notifications}/read-all');
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _dioClient.delete('${ApiEndpoint.notifications}/$notificationId');
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteAllRead() async {
    try {
      await _dioClient.delete('${ApiEndpoint.notifications}/read');
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<int> fetchUnreadCount() async {
    try {
      final res = await _dioClient.get(
        '${ApiEndpoint.notifications}/unread-count',
      );
      return res.data['unreadCount'] ?? 0;
    } on FormatException catch (_) {
      rethrow;
    }
  }
}

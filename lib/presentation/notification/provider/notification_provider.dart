import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/notification_model.dart';
import 'package:tasklyai/repository/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository = NotificationRepository();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool? _isReadFilter;
  String? _typeFilter;

  Future<void> fetchNotifications({
    bool? isRead,
    String? type,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      _isReadFilter = isRead;
      _typeFilter = type;
      final page = await repository.fetchNotifications(
        isRead: isRead,
        type: type,
      );
      _notifications = page.notifications;
      _unreadCount = page.unreadCount;
    } on FormatException catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchNotifications(isRead: _isReadFilter, type: _typeFilter);
  }

  Future<void> markAsRead(BuildContext context, String id) async {
    try {
      await repository.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          type: _notifications[index].type,
          title: _notifications[index].title,
          message: _notifications[index].message,
          isRead: true,
          createdAt: _notifications[index].createdAt,
          readAt: DateTime.now(),
          dueDate: _notifications[index].dueDate,
          card: _notifications[index].card,
        );
        _unreadCount = (_unreadCount - 1).clamp(0, 1 << 30);
      }
      notifyListeners();
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> markAllAsRead(BuildContext context) async {
    try {
      await repository.markAllAsRead();
      _notifications = _notifications
          .map(
            (n) => NotificationModel(
              id: n.id,
              type: n.type,
              title: n.title,
              message: n.message,
              isRead: true,
              createdAt: n.createdAt,
              readAt: DateTime.now(),
              dueDate: n.dueDate,
              card: n.card,
            ),
          )
          .toList();
      _unreadCount = 0;
      notifyListeners();
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> deleteNotification(BuildContext context, String id) async {
    try {
      await repository.deleteNotification(id);
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> deleteAllRead(BuildContext context) async {
    try {
      await repository.deleteAllRead();
      _notifications = _notifications.where((n) => !n.isRead).toList();
      notifyListeners();
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await repository.fetchUnreadCount();
      notifyListeners();
    } on FormatException catch (_) {}
  }
}

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? dueDate;
  final NotificationCardInfo? card;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.readAt,
    required this.dueDate,
    required this.card,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final cardRaw = json['cardId'];
    return NotificationModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'info',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'])
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'])
          : null,
      card: cardRaw is Map<String, dynamic>
          ? NotificationCardInfo.fromJson(cardRaw)
          : null,
    );
  }
}

class NotificationCardInfo {
  final String title;
  final String? status;
  final String? energyLevel;

  NotificationCardInfo({
    required this.title,
    required this.status,
    required this.energyLevel,
  });

  factory NotificationCardInfo.fromJson(Map<String, dynamic> json) {
    return NotificationCardInfo(
      title: json['title'] ?? '',
      status: json['status'],
      energyLevel: json['energyLevel'],
    );
  }
}

class NotificationPage {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationPage({
    required this.notifications,
    required this.unreadCount,
  });
}

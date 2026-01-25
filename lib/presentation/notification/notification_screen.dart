import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/notification_model.dart';
import 'package:tasklyai/presentation/notification/provider/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _showUnreadOnly = false;
  String? _typeFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _topHeader(context),
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.notifications.isEmpty) {
                  return const Center(
                    child: Text('No notifications yet.'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = provider.notifications[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        context
                            .read<NotificationProvider>()
                            .deleteNotification(context, item.id);
                      },
                      child: _NotificationTile(
                        item,
                        onTap: () {
                          if (!item.isRead) {
                            context
                                .read<NotificationProvider>()
                                .markAsRead(context, item.id);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _topHeader(BuildContext context) {
    final unread = context.watch<NotificationProvider>().unreadCount;
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 12,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const BackButton(color: Colors.white),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              PopupMenuButton<_HeaderAction>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == _HeaderAction.markAllRead) {
                    context
                        .read<NotificationProvider>()
                        .markAllAsRead(context);
                  } else if (value == _HeaderAction.deleteRead) {
                    context
                        .read<NotificationProvider>()
                        .deleteAllRead(context);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _HeaderAction.markAllRead,
                    child: _MenuItem(
                      icon: Icons.done_all,
                      text: 'Mark all read',
                    ),
                  ),
                  PopupMenuItem(
                    value: _HeaderAction.deleteRead,
                    child: _MenuItem(
                      icon: Icons.delete_sweep_outlined,
                      text: 'Delete read',
                      isDanger: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: !_showUnreadOnly,
                onTap: () {
                  setState(() => _showUnreadOnly = false);
                  _fetch();
                },
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Unread ($unread)',
                isSelected: _showUnreadOnly,
                onTap: () {
                  setState(() => _showUnreadOnly = true);
                  _fetch();
                },
              ),
              const Spacer(),
              PopupMenuButton<String?>(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  setState(() => _typeFilter = value);
                  _fetch();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: null,
                    child: Text('All types'),
                  ),
                  PopupMenuItem(
                    value: 'due_soon',
                    child: Text('Due soon'),
                  ),
                  PopupMenuItem(
                    value: 'overdue',
                    child: Text('Overdue'),
                  ),
                  PopupMenuItem(
                    value: 'reminder',
                    child: Text('Reminder'),
                  ),
                ],
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _typeFilter == null
                            ? 'All types'
                            : _typeLabel(_typeFilter!),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _fetch() {
    context.read<NotificationProvider>().fetchNotifications(
          isRead: _showUnreadOnly ? false : null,
          type: _typeFilter,
        );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationTile(this.item, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle(item.type);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF7F6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead ? Colors.transparent : style.color.withAlpha(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: style.color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style.icon, color: style.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      _TypeBadge(label: _typeLabel(item.type), color: style.color),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Formatter.timeAgo(item.createdAt),
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withAlpha(40),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TypeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDanger;

  const _MenuItem({
    required this.icon,
    required this.text,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : Colors.black87;
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _TypeStyle {
  final IconData icon;
  final Color color;

  const _TypeStyle({required this.icon, required this.color});
}

_TypeStyle _typeStyle(String type) {
  switch (type) {
    case 'overdue':
      return _TypeStyle(icon: Icons.warning_amber_rounded, color: Colors.red);
    case 'reminder':
      return _TypeStyle(icon: Icons.notifications_active, color: Colors.orange);
    case 'due_soon':
    default:
      return _TypeStyle(icon: Icons.schedule, color: primaryColor);
  }
}

String _typeLabel(String type) {
  switch (type) {
    case 'overdue':
      return 'Overdue';
    case 'reminder':
      return 'Reminder';
    case 'due_soon':
    default:
      return 'Due soon';
  }
}

enum _HeaderAction { markAllRead, deleteRead }

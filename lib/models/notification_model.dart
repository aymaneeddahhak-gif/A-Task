import 'package:flutter/material.dart';

enum NotificationType {
  taskAchieved(
    icon: Icons.task_alt,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  upcomingTask(
    icon: Icons.send,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  routineSuggestion(
    icon: Icons.auto_awesome,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  bestDayInsight(
    icon: Icons.star,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  productivitySummary(
    icon: Icons.trending_up,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  securityLogin(
    icon: Icons.devices,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  taskFinished(
    icon: Icons.check_circle_outline,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  newTaskCreated(
    icon: Icons.add_circle_outline,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  deadlineWarning(
    icon: Icons.timer_outlined,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  ),
  reminder(
    icon: Icons.schedule,
    iconColor: Color(0xFF64748B),
    iconBgColor: Color(0xFFE2E8F0),
  );

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const NotificationType({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class AppNotificationItem {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final bool isRead;
  final NotificationType type;
  final String section;
  final int? taskId;
  final String? actionRoute;

  AppNotificationItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.timeAgo,
    this.isRead = false,
    required this.type,
    this.section = 'Today',
    this.taskId,
    this.actionRoute,
  });

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    String? timeAgo,
    bool? isRead,
    NotificationType? type,
    String? section,
    int? taskId,
    String? actionRoute,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeAgo: timeAgo ?? this.timeAgo,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      section: section ?? this.section,
      taskId: taskId ?? this.taskId,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}

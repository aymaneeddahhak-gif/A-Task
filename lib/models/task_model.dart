import 'package:intl/intl.dart';

class TaskModel {
  final int id;
  final String title;
  final String description;
  final String dateString;
  final String startTime;
  final String endTime;
  final String priority;
  final String status;
  final String project;
  final String tags;
  final bool hasMeeting;
  final String meetTitle;
  final bool isStarred;
  final int assigneeCount;
  final String timeSection;
  final bool isCompleted;
  final String colorTheme;
  final bool isFreeTime;
  final String routineType; // 'None', 'Day', 'Week', 'Month'

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.dateString = 'Today',
    this.startTime = '10:00 AM',
    this.endTime = '11:00 AM',
    this.priority = 'Medium',
    this.status = 'To Do',
    this.project = 'Daily Routine',
    this.tags = 'Routine,Focus',
    this.hasMeeting = false,
    this.meetTitle = 'Meet',
    this.isStarred = false,
    this.assigneeCount = 1,
    this.timeSection = 'Morning',
    this.isCompleted = false,
    this.colorTheme = 'blue',
    this.isFreeTime = false,
    this.routineType = 'None',
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    String? dateString,
    String? startTime,
    String? endTime,
    String? priority,
    String? status,
    String? project,
    String? tags,
    bool? hasMeeting,
    String? meetTitle,
    bool? isStarred,
    int? assigneeCount,
    String? timeSection,
    bool? isCompleted,
    String? colorTheme,
    bool? isFreeTime,
    String? routineType,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateString: dateString ?? this.dateString,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      project: project ?? this.project,
      tags: tags ?? this.tags,
      hasMeeting: hasMeeting ?? this.hasMeeting,
      meetTitle: meetTitle ?? this.meetTitle,
      isStarred: isStarred ?? this.isStarred,
      assigneeCount: assigneeCount ?? this.assigneeCount,
      timeSection: timeSection ?? this.timeSection,
      isCompleted: isCompleted ?? this.isCompleted,
      colorTheme: colorTheme ?? this.colorTheme,
      isFreeTime: isFreeTime ?? this.isFreeTime,
      routineType: routineType ?? this.routineType,
    );
  }

  List<String> get tagList {
    if (tags.trim().isEmpty) return [];
    return tags.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  String get cleanDuration {
    try {
      final format = DateFormat('hh:mm a');
      final start = format.parse(startTime);
      final end = format.parse(endTime);
      int diffMinutes = end.difference(start).inMinutes;
      if (diffMinutes <= 0) diffMinutes += 24 * 60;
      final hours = diffMinutes ~/ 60;
      final minutes = diffMinutes % 60;
      if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
      if (hours > 0) return '${hours}h';
      return '$minutes min';
    } catch (_) {
      return '30 min';
    }
  }

  MapEntry<double, String> get dynamicProgress {
    if (isCompleted || status.toLowerCase() == 'done') {
      return const MapEntry(1.0, '100% DONE');
    }

    // Multi-day date span support (e.g. "Oct 6 - Oct 10")
    if (dateString.contains(' - ')) {
      try {
        final parts = dateString.split(' - ').map((e) => e.trim()).toList();
        if (parts.length == 2) {
          final formats = [
            DateFormat('MMM d, yyyy'),
            DateFormat('MMM d'),
            DateFormat('yyyy-MM-dd'),
            DateFormat('EEE, MMM d'),
          ];
          DateTime? pStart;
          DateTime? pEnd;
          for (final fmt in formats) {
            pStart ??= tryParse(fmt, parts[0]);
            pEnd ??= tryParse(fmt, parts[1]);
          }
          if (pStart != null && pEnd != null) {
            final now = DateTime.now();
            if (now.isAfter(pEnd)) {
              return const MapEntry(0.85, '85% OVERDUE');
            } else if (now.isBefore(pStart)) {
              return const MapEntry(0.20, '20% SCHEDULED');
            } else {
              final total = pEnd.difference(pStart).inMilliseconds;
              final elapsed = now.difference(pStart).inMilliseconds;
              final fraction = (elapsed / (total > 0 ? total : 1)).clamp(0.15, 0.95);
              final pct = (fraction * 100).toInt();
              return MapEntry(fraction, '$pct% IN PROGRESS');
            }
          }
        }
      } catch (_) {}
    }

    // Intra-day time calculation
    if (startTime.isNotEmpty && endTime.isNotEmpty && startTime != endTime) {
      try {
        final format = DateFormat('hh:mm a');
        final start = format.parse(startTime);
        final end = format.parse(endTime);
        final now = DateTime.now();
        final nowMinutes = now.hour * 60 + now.minute;
        final startMinutes = start.hour * 60 + start.minute;
        var endMinutes = end.hour * 60 + end.minute;
        if (endMinutes <= startMinutes) endMinutes += 24 * 60;

        if (nowMinutes >= startMinutes && nowMinutes <= endMinutes) {
          final total = (endMinutes - startMinutes).toDouble();
          final elapsed = (nowMinutes - startMinutes).toDouble();
          final fraction = (elapsed / total).clamp(0.15, 0.95);
          final pct = (fraction * 100).toInt();
          return MapEntry(fraction, '$pct% ACTIVE NOW');
        } else if (nowMinutes > endMinutes) {
          return const MapEntry(0.85, '85% OVERDUE');
        } else {
          final fraction = (priority.toLowerCase() == 'high' || priority.toLowerCase() == 'urgent') ? 0.35 : 0.20;
          final pct = (fraction * 100).toInt();
          return MapEntry(fraction, '$pct% SCHEDULED');
        }
      } catch (_) {}
    }

    final fraction = (status.toLowerCase() == 'in progress') ? 0.50 : 0.25;
    final pct = (fraction * 100).toInt();
    return MapEntry(fraction, '$pct% IN PROGRESS');
  }

  static DateTime? tryParse(DateFormat fmt, String input) {
    try {
      return fmt.parse(input);
    } catch (_) {
      return null;
    }
  }
}

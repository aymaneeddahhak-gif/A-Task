import 'package:intl/intl.dart';

class TaskModel {
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final List<DateFormat> _multiDayFormats = [
    DateFormat('MMM d, yyyy'),
    DateFormat('MMM d'),
    DateFormat('yyyy-MM-dd'),
    DateFormat('EEE, MMM d'),
  ];

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

  // Pre-computed cached fields to avoid allocations & string parsing inside build()
  late final List<String> _cachedTagList;
  late final String _cachedCleanDuration;
  late final int? _cachedStartMinutes;
  late final int? _cachedEndMinutes;
  late final (DateTime, DateTime)? _cachedMultiDaySpan;

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
    String? timeSection,
    this.isCompleted = false,
    this.colorTheme = 'blue',
    this.isFreeTime = false,
    this.routineType = 'None',
  }) : timeSection = (timeSection != null && timeSection.trim().isNotEmpty)
            ? timeSection
            : inferTimeSection(startTime) {
    _cachedTagList = tags.trim().isEmpty
        ? const <String>[]
        : List<String>.unmodifiable(
            tags
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty),
          );

    final parsedStart = _parseTimeMinutes(startTime);
    final parsedEnd = _parseTimeMinutes(endTime);
    _cachedStartMinutes = parsedStart;
    if (parsedStart != null && parsedEnd != null) {
      int endM = parsedEnd;
      if (endM <= parsedStart) endM += 24 * 60;
      _cachedEndMinutes = endM;
      final diff = endM - parsedStart;
      final hours = diff ~/ 60;
      final minutes = diff % 60;
      if (hours > 0 && minutes > 0) {
        _cachedCleanDuration = '${hours}h ${minutes}m';
      } else if (hours > 0) {
        _cachedCleanDuration = '${hours}h';
      } else {
        _cachedCleanDuration = '$minutes min';
      }
    } else {
      _cachedEndMinutes = parsedEnd;
      _cachedCleanDuration = '30 min';
    }

    _cachedMultiDaySpan = _parseMultiDaySpan(dateString);
  }

  /// Automatically resolves 'Morning', 'Afternoon', or 'Evening' from a time string like '02:30 PM'.
  static String inferTimeSection(String timeStr) {
    final mins = _parseTimeMinutes(timeStr);
    if (mins == null) return 'Morning';
    final hour = (mins ~/ 60) % 24;
    if (hour >= 5 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 17) return 'Afternoon';
    return 'Evening';
  }

  static int? _parseTimeMinutes(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    try {
      final dt = _timeFormat.parse(trimmed);
      return dt.hour * 60 + dt.minute;
    } catch (_) {
      return null;
    }
  }

  static (DateTime, DateTime)? _parseMultiDaySpan(String dateStr) {
    if (!dateStr.contains(' - ')) return null;
    try {
      final parts = dateStr.split(' - ').map((e) => e.trim()).toList();
      if (parts.length != 2) return null;
      DateTime? pStart;
      DateTime? pEnd;
      for (final fmt in _multiDayFormats) {
        pStart ??= tryParse(fmt, parts[0]);
        pEnd ??= tryParse(fmt, parts[1]);
      }
      if (pStart != null && pEnd != null) {
        return (pStart, pEnd);
      }
    } catch (_) {}
    return null;
  }

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
    final effectiveStart = startTime ?? this.startTime;
    final effectiveTimeSection = timeSection ??
        (startTime != null ? inferTimeSection(effectiveStart) : this.timeSection);
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateString: dateString ?? this.dateString,
      startTime: effectiveStart,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      project: project ?? this.project,
      tags: tags ?? this.tags,
      hasMeeting: hasMeeting ?? this.hasMeeting,
      meetTitle: meetTitle ?? this.meetTitle,
      isStarred: isStarred ?? this.isStarred,
      assigneeCount: assigneeCount ?? this.assigneeCount,
      timeSection: effectiveTimeSection,
      isCompleted: isCompleted ?? this.isCompleted,
      colorTheme: colorTheme ?? this.colorTheme,
      isFreeTime: isFreeTime ?? this.isFreeTime,
      routineType: routineType ?? this.routineType,
    );
  }

  List<String> get tagList => _cachedTagList;

  String get cleanDuration => _cachedCleanDuration;

  int? get startMinutesOfDay => _cachedStartMinutes;

  int? get endMinutesOfDay => _cachedEndMinutes;

  /// Returns true if the current wall-clock time falls inside this task's start..end window.
  bool isCurrentlyActive([DateTime? nowOverride]) {
    if (isCompleted || status.toLowerCase() == 'done') return false;
    final startM = _cachedStartMinutes;
    final endM = _cachedEndMinutes;
    if (startM == null || endM == null) return false;
    final now = nowOverride ?? DateTime.now();
    final nowM = now.hour * 60 + now.minute;
    return nowM >= startM && nowM <= endM;
  }

  MapEntry<double, String> get dynamicProgress {
    if (isCompleted || status.toLowerCase() == 'done') {
      return const MapEntry(1.0, '100% DONE');
    }

    final now = DateTime.now();

    // Multi-day date span support (cached on construction)
    final span = _cachedMultiDaySpan;
    if (span != null) {
      final pStart = span.$1;
      final pEnd = span.$2;
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

    // Intra-day time calculation using pre-parsed cached minutes (zero DateFormat allocation!)
    final startMinutes = _cachedStartMinutes;
    final endMinutes = _cachedEndMinutes;
    if (startMinutes != null &&
        endMinutes != null &&
        startTime != endTime) {
      final nowMinutes = now.hour * 60 + now.minute;
      if (nowMinutes >= startMinutes && nowMinutes <= endMinutes) {
        final total = (endMinutes - startMinutes).toDouble();
        final elapsed = (nowMinutes - startMinutes).toDouble();
        final fraction = (elapsed / (total > 0 ? total : 1.0)).clamp(0.15, 0.95);
        final pct = (fraction * 100).toInt();
        return MapEntry(fraction, '$pct% ACTIVE NOW');
      } else if (nowMinutes > endMinutes) {
        return const MapEntry(0.85, '85% OVERDUE');
      } else {
        final pLower = priority.toLowerCase();
        final fraction = (pLower == 'high' || pLower == 'urgent') ? 0.35 : 0.20;
        final pct = (fraction * 100).toInt();
        return MapEntry(fraction, '$pct% SCHEDULED');
      }
    }

    final fraction = (status.toLowerCase() == 'in progress') ? 0.50 : 0.25;
    final pct = (fraction * 100).toInt();
    return MapEntry(fraction, '$pct% IN PROGRESS');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dateString': dateString,
        'startTime': startTime,
        'endTime': endTime,
        'priority': priority,
        'status': status,
        'project': project,
        'tags': tags,
        'hasMeeting': hasMeeting,
        'meetTitle': meetTitle,
        'isStarred': isStarred,
        'assigneeCount': assigneeCount,
        'timeSection': timeSection,
        'isCompleted': isCompleted,
        'colorTheme': colorTheme,
        'isFreeTime': isFreeTime,
        'routineType': routineType,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final startStr = (json['startTime'] as String?) ?? '10:00 AM';
    return TaskModel(
      id: (json['id'] as num?)?.toInt() ?? 1,
      title: (json['title'] as String?) ?? 'Untitled Task',
      description: (json['description'] as String?) ?? '',
      dateString: (json['dateString'] as String?) ?? 'Today',
      startTime: startStr,
      endTime: (json['endTime'] as String?) ?? '11:00 AM',
      priority: (json['priority'] as String?) ?? 'Medium',
      status: (json['status'] as String?) ?? 'To Do',
      project: (json['project'] as String?) ?? 'Daily Routine',
      tags: (json['tags'] as String?) ?? 'Routine,Focus',
      hasMeeting: (json['hasMeeting'] as bool?) ?? false,
      meetTitle: (json['meetTitle'] as String?) ?? 'Meet',
      isStarred: (json['isStarred'] as bool?) ?? false,
      assigneeCount: (json['assigneeCount'] as num?)?.toInt() ?? 1,
      timeSection: (json['timeSection'] as String?) ?? inferTimeSection(startStr),
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      colorTheme: (json['colorTheme'] as String?) ?? 'blue',
      isFreeTime: (json['isFreeTime'] as bool?) ?? false,
      routineType: (json['routineType'] as String?) ?? 'None',
    );
  }

  static DateTime? tryParse(DateFormat fmt, String input) {
    try {
      return fmt.parse(input);
    } catch (_) {
      return null;
    }
  }
}

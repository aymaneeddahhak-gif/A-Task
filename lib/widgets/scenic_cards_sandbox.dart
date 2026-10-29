import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/local_storage_service.dart';
import '../state/task_provider.dart';

// Cached base Poppins TextStyle to avoid repeated GoogleFonts registry lookups inside build()
final TextStyle _kPoppins = GoogleFonts.poppins();

TextStyle _poppins({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? letterSpacing,
  double? height,
  TextDecoration? decoration,
}) {
  return _kPoppins.copyWith(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
    decoration: decoration,
  );
}

enum ScenicSceneType {
  morningRun, // 1. Morning Run -> Lo-Fi Atmospheric Glow Vector (Top-Right)
  coffeeTime, // 2. Coffee Time -> Warm Editorial Flat Vector (First-Left)
  deepStudy, // 3. Deep Study -> First-Left (Day) OR First-Right (Dark/Night Time)
  nightRun, // 4. Night Run -> Warm Editorial Flat Vector (First-Left)
}

class ScenicTaskCardModel {
  static final DateFormat _timeFmt = DateFormat('hh:mm a');

  final String id;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String duration;
  final String routineHorizon; // 'Day', 'Week', 'Month'
  final String dateOrRecurrence;
  final String categoryTag;
  final String status; // 'Locked In', 'In Progress', 'Scheduled', 'Completed'
  final double progress;
  final bool isCompleted;
  final bool isStarred;
  // Auto-resolved by smart engine (user NEVER enters these manually)
  final ScenicSceneType autoScene;
  final String autoDegree;
  final String autoCondition;
  final Color accentColor;
  final Color softTintColor;

  // Cached parsed minutes for O(1) real-time progress computation
  late final int? _startMinutes;
  late final int? _endMinutes;

  ScenicTaskCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.routineHorizon,
    required this.dateOrRecurrence,
    required this.categoryTag,
    required this.status,
    required this.progress,
    this.isCompleted = false,
    this.isStarred = false,
    required this.autoScene,
    required this.autoDegree,
    required this.autoCondition,
    required this.accentColor,
    required this.softTintColor,
  }) {
    _startMinutes = _parseMins(startTime);
    final rawEnd = _parseMins(endTime);
    if (_startMinutes != null && rawEnd != null) {
      _endMinutes = rawEnd <= _startMinutes! ? rawEnd + 24 * 60 : rawEnd;
    } else {
      _endMinutes = rawEnd;
    }
  }

  static int? _parseMins(String input) {
    try {
      final dt = _timeFmt.parse(input.trim());
      return dt.hour * 60 + dt.minute;
    } catch (_) {
      return null;
    }
  }

  /// Computes real-time progress & status from current wall-clock time.
  (double, String) resolveLiveProgress(DateTime now) {
    if (isCompleted) return (1.0, '100% Done');
    final s = _startMinutes;
    final e = _endMinutes;
    if (s != null && e != null && e > s) {
      final nowM = now.hour * 60 + now.minute;
      if (nowM >= s && nowM <= e) {
        final frac = ((nowM - s) / (e - s)).clamp(0.15, 0.96);
        return (frac, '${(frac * 100).round()}% Active Now');
      }
    }
    return (progress, status);
  }

  ScenicTaskCardModel copyWith({
    bool? isCompleted,
    bool? isStarred,
    String? status,
    double? progress,
  }) {
    return ScenicTaskCardModel(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      routineHorizon: routineHorizon,
      dateOrRecurrence: dateOrRecurrence,
      categoryTag: categoryTag,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      isStarred: isStarred ?? this.isStarred,
      autoScene: autoScene,
      autoDegree: autoDegree,
      autoCondition: autoCondition,
      accentColor: accentColor,
      softTintColor: softTintColor,
    );
  }

  /// Resolves the exact flat-vector image asset path based on the scene
  /// and whether Dark/Night Time is active (for Deep Study).
  String resolveAssetPath({required bool isDarkTime}) {
    switch (autoScene) {
      case ScenicSceneType.morningRun:
        return 'assets/images/cards/morning_run_lofi.png';
      case ScenicSceneType.coffeeTime:
        return 'assets/images/cards/coffee_time_editorial.png';
      case ScenicSceneType.deepStudy:
        return isDarkTime
            ? 'assets/images/cards/deep_study_night.png'
            : 'assets/images/cards/deep_study_day.png';
      case ScenicSceneType.nightRun:
        return 'assets/images/cards/night_run_editorial.png';
    }
  }

  /// Automatically resolves the activity scene, weather temperature, and accent colors
  /// from the task title, category, and time — so the user NEVER enters weather manually.
  static ScenicTaskCardModel createAuto({
    required String id,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String duration,
    required String routineHorizon,
    required String dateOrRecurrence,
    required String categoryTag,
    String status = 'Locked In',
    double progress = 0.45,
    bool isCompleted = false,
    bool isStarred = false,
    ScenicSceneType? overrideScene,
  }) {
    final lower = '$title $categoryTag $description'.toLowerCase();
    final isPM = startTime.toUpperCase().contains('PM');

    ScenicSceneType scene;
    if (overrideScene != null) {
      scene = overrideScene;
    } else if (lower.contains('night') ||
        lower.contains('evening') ||
        (lower.contains('run') && isPM)) {
      scene = ScenicSceneType.nightRun;
    } else if (lower.contains('run') ||
        lower.contains('jog') ||
        lower.contains('walk') ||
        lower.contains('workout') ||
        lower.contains('cardio')) {
      scene = ScenicSceneType.morningRun;
    } else if (lower.contains('coffee') ||
        lower.contains('cafe') ||
        lower.contains('plan') ||
        lower.contains('tea') ||
        lower.contains('breakfast')) {
      scene = ScenicSceneType.coffeeTime;
    } else if (lower.contains('study') ||
        lower.contains('code') ||
        lower.contains('focus') ||
        lower.contains('read') ||
        lower.contains('deep') ||
        lower.contains('work')) {
      scene = ScenicSceneType.deepStudy;
    } else {
      if (routineHorizon == 'Week') {
        scene = ScenicSceneType.deepStudy;
      } else if (routineHorizon == 'Month') {
        scene = ScenicSceneType.nightRun;
      } else if (isPM) {
        scene = ScenicSceneType.nightRun;
      } else {
        scene = ScenicSceneType.coffeeTime;
      }
    }

    switch (scene) {
      case ScenicSceneType.morningRun:
        return ScenicTaskCardModel(
          id: id,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          routineHorizon: routineHorizon,
          dateOrRecurrence: dateOrRecurrence,
          categoryTag: categoryTag,
          status: status,
          progress: progress,
          isCompleted: isCompleted,
          isStarred: isStarred,
          autoScene: scene,
          autoDegree: '19°',
          autoCondition: 'Sunrise • Lo-Fi',
          accentColor: const Color(0xFFEA580C),
          softTintColor: const Color(0xFFFFF7ED),
        );
      case ScenicSceneType.coffeeTime:
        return ScenicTaskCardModel(
          id: id,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          routineHorizon: routineHorizon,
          dateOrRecurrence: dateOrRecurrence,
          categoryTag: categoryTag,
          status: status,
          progress: progress,
          isCompleted: isCompleted,
          isStarred: isStarred,
          autoScene: scene,
          autoDegree: '23°',
          autoCondition: 'Sunny • Café',
          accentColor: const Color(0xFFB45309),
          softTintColor: const Color(0xFFFFFBEB),
        );
      case ScenicSceneType.deepStudy:
        return ScenicTaskCardModel(
          id: id,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          routineHorizon: routineHorizon,
          dateOrRecurrence: dateOrRecurrence,
          categoryTag: categoryTag,
          status: status,
          progress: progress,
          isCompleted: isCompleted,
          isStarred: isStarred,
          autoScene: scene,
          autoDegree: '18°',
          autoCondition: 'Calm Focus',
          accentColor: const Color(0xFF0284C7),
          softTintColor: const Color(0xFFF0F9FF),
        );
      case ScenicSceneType.nightRun:
        return ScenicTaskCardModel(
          id: id,
          title: title,
          description: description,
          startTime: startTime,
          endTime: endTime,
          duration: duration,
          routineHorizon: routineHorizon,
          dateOrRecurrence: dateOrRecurrence,
          categoryTag: categoryTag,
          status: status,
          progress: progress,
          isCompleted: isCompleted,
          isStarred: isStarred,
          autoScene: scene,
          autoDegree: '12°',
          autoCondition: 'Clear Night',
          accentColor: const Color(0xFF312E81),
          softTintColor: const Color(0xFFEEF2FF),
        );
    }
  }
}

/// The 4 Signature Flat-Vector Task Cards selected by the user:
/// 1. Morning Run (Lo-Fi Atmospheric Glow Vector)
/// 2. Coffee Time & Daily Plan (First-Left Warm Editorial Flat Vector)
/// 3. Deep Study & Coding Focus (First-Left Day Window OR First-Right Night Desk Lamp)
/// 4. Night Run (First-Left Midnight Streetlamp Editorial Flat Vector)
final List<ScenicTaskCardModel> kInitialScenicTaskCards = [
  // 1. Morning Run (Lo-Fi Atmospheric Glow Vector)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_1',
    title: 'Morning 5km Park Run',
    description: 'Waterfront sunrise boardwalk pace + glowing headphones',
    startTime: '07:00 AM',
    endTime: '07:45 AM',
    duration: '45m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Every Day',
    categoryTag: 'Morning Run',
    status: 'Completed',
    progress: 1.0,
    isCompleted: true,
    isStarred: true,
    overrideScene: ScenicSceneType.morningRun,
  ),
  // 2. Coffee Time & Daily Plan (First-Left Warm Botanical Café)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_2',
    title: 'Coffee Time & Daily Plan',
    description: 'Morning espresso by the sunlit window & top 3 daily goals',
    startTime: '08:30 AM',
    endTime: '09:00 AM',
    duration: '30m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Every Day',
    categoryTag: 'Coffee Time',
    status: 'In Progress',
    progress: 0.70,
    isStarred: true,
    overrideScene: ScenicSceneType.coffeeTime,
  ),
  // 3. Deep Study & Coding Focus (First-Left Day OR First-Right Dark Time)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_3',
    title: 'Deep Study & Coding Focus',
    description: 'Headphones on — core architecture build & algorithms sprint',
    startTime: '10:00 AM',
    endTime: '12:00 PM',
    duration: '2h',
    routineHorizon: 'Week',
    dateOrRecurrence: 'Weekly • Mon–Fri',
    categoryTag: 'Deep Study',
    status: 'Locked In',
    progress: 0.55,
    isStarred: true,
    overrideScene: ScenicSceneType.deepStudy,
  ),
  // 4. Night Run (First-Left Midnight Streetlamp & Full Moon)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_4',
    title: 'Night Run & Decompress',
    description: 'Evening 5km run under city streetlamps & moonlight',
    startTime: '09:30 PM',
    endTime: '10:15 PM',
    duration: '45m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Every Night',
    categoryTag: 'Night Run',
    status: 'Scheduled',
    progress: 0.30,
    isStarred: true,
    overrideScene: ScenicSceneType.nightRun,
  ),
];

const List<Map<String, String>> kQuickTaskPresets = [
  {
    'title': 'Morning 5km Run',
    'desc': 'Sunrise boardwalk cardio + hydration before class/work',
    'time': '07:00 AM - 07:45 AM',
    'duration': '45m',
    'tag': 'Morning Run',
    'horizon': 'Day',
  },
  {
    'title': 'Coffee Time & Plan',
    'desc': 'Fresh brew by the sunlit plant window + top 3 goals',
    'time': '08:30 AM - 09:00 AM',
    'duration': '30m',
    'tag': 'Coffee Time',
    'horizon': 'Day',
  },
  {
    'title': 'Deep Study & Coding',
    'desc': 'Noise-canceling headphones + 2h uninterrupted focus',
    'time': '10:00 AM - 12:00 PM',
    'duration': '2h',
    'tag': 'Deep Study',
    'horizon': 'Week',
  },
  {
    'title': 'Night Run under Stars',
    'desc': 'Evening 45m run under the warm streetlamp glow',
    'time': '09:30 PM - 10:15 PM',
    'duration': '45m',
    'tag': 'Night Run',
    'horizon': 'Month',
  },
];

/// Interactive Sandbox Showcase featuring the 4 chosen Flat-Vector artworks
/// softly blended onto crisp white cards (without filling the whole card),
/// with a live "Background Image Clarity" slider, Day/Night Deep Study switcher,
/// GPU-optimized rendering, and real-time clock/provider synchronization.
class ScenicCardsSandboxShowcase extends StatefulWidget {
  final TaskProvider? provider;

  const ScenicCardsSandboxShowcase({super.key, this.provider});

  @override
  State<ScenicCardsSandboxShowcase> createState() =>
      _ScenicCardsSandboxShowcaseState();
}

class _ScenicCardsSandboxShowcaseState
    extends State<ScenicCardsSandboxShowcase> {
  static const String _storageKeySandboxSettings = 'atask_sandbox_settings_v1';
  static const List<String> _allCardAssets = [
    'assets/images/cards/morning_run_lofi.png',
    'assets/images/cards/coffee_time_editorial.png',
    'assets/images/cards/deep_study_day.png',
    'assets/images/cards/deep_study_night.png',
    'assets/images/cards/night_run_editorial.png',
  ];

  late List<ScenicTaskCardModel> _cards;
  double _imageClarity = 0.78;
  double _imageSpread = 0.60;
  double _curlSize = 34.0;
  late bool _isDarkTimeForStudy;
  bool _twoColumnGrid = false;
  String _selectedHorizon = 'All';
  bool _showAutoCreator = false;
  bool _didPrecacheAssets = false;
  DateTime _now = DateTime.now();
  Timer? _clockTimer;
  final TextEditingController _taskTitleController = TextEditingController();
  String _newTaskHorizon = 'Day';

  @override
  void initState() {
    super.initState();
    final hour = _now.hour;
    // Automatically default Deep Study to Dark Time during evening/night hours (6 PM - 6 AM)
    _isDarkTimeForStudy = hour >= 18 || hour < 6;
    _cards = List<ScenicTaskCardModel>.from(kInitialScenicTaskCards);
    _loadSandboxSettings();
    _syncLiveTasksFromProvider();

    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      final current = DateTime.now();
      if (current.minute != _now.minute) {
        setState(() => _now = current);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecacheAssets) {
      _didPrecacheAssets = true;
      for (final assetPath in _allCardAssets) {
        precacheImage(AssetImage(assetPath), context);
      }
    }
  }

  void _loadSandboxSettings() {
    try {
      final raw = LocalStorageService.getString(_storageKeySandboxSettings);
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw);
        if (map is Map<String, dynamic>) {
          _imageClarity =
              ((map['clarity'] as num?)?.toDouble() ?? _imageClarity).clamp(
                0.15,
                1.0,
              );
          _imageSpread =
              ((map['spread'] as num?)?.toDouble() ?? _imageSpread).clamp(
                0.42,
                0.78,
              );
          _curlSize = ((map['curl'] as num?)?.toDouble() ?? _curlSize).clamp(
            20.0,
            50.0,
          );
          if (map['darkStudy'] is bool) {
            _isDarkTimeForStudy = map['darkStudy'] as bool;
          }
        }
      }
    } catch (_) {}
  }

  void _saveSandboxSettings() {
    try {
      LocalStorageService.setString(
        _storageKeySandboxSettings,
        jsonEncode({
          'clarity': _imageClarity,
          'spread': _imageSpread,
          'curl': _curlSize,
          'darkStudy': _isDarkTimeForStudy,
        }),
      );
    } catch (_) {}
  }

  /// Syncs any real user-created tasks from TaskProvider into the Sandbox cards list.
  void _syncLiveTasksFromProvider() {
    final prov = widget.provider;
    if (prov == null || prov.tasks.isEmpty) return;
    final existingIds = _cards.map((c) => c.id).toSet();
    for (final TaskModel t in prov.tasks.reversed) {
      final syncId = 'prov_${t.id}';
      if (!existingIds.contains(syncId)) {
        final horizon =
            (t.routineType == 'Day' ||
                t.routineType == 'Week' ||
                t.routineType == 'Month')
            ? t.routineType
            : 'Day';
        final progressEntry = t.dynamicProgress;
        _cards.insert(
          0,
          ScenicTaskCardModel.createAuto(
            id: syncId,
            title: t.title,
            description: t.description.isNotEmpty
                ? t.description
                : '${t.project} • Live synced task',
            startTime: t.startTime,
            endTime: t.endTime,
            duration: t.cleanDuration,
            routineHorizon: horizon,
            dateOrRecurrence: t.dateString,
            categoryTag: t.project,
            status: t.isCompleted ? 'Completed' : t.status,
            progress: progressEntry.key,
            isCompleted: t.isCompleted,
            isStarred: t.isStarred,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _taskTitleController.dispose();
    super.dispose();
  }

  List<ScenicTaskCardModel> get _filteredCards {
    if (_selectedHorizon == 'All') return _cards;
    return _cards
        .where((c) => c.routineHorizon == _selectedHorizon)
        .toList();
  }

  void _toggleCardComplete(String id) {
    setState(() {
      _cards = _cards.map((c) {
        if (c.id == id) {
          final nextDone = !c.isCompleted;
          return c.copyWith(
            isCompleted: nextDone,
            status: nextDone ? 'Completed' : 'In Progress',
            progress: nextDone ? 1.0 : 0.55,
          );
        }
        return c;
      }).toList();
    });
    if (id.startsWith('prov_') && widget.provider != null) {
      final rawId = int.tryParse(id.substring(5));
      if (rawId != null) {
        widget.provider!.toggleTaskComplete(rawId);
      }
    }
  }

  void _toggleCardStar(String id) {
    setState(() {
      _cards = _cards.map((c) {
        if (c.id == id) {
          return c.copyWith(isStarred: !c.isStarred);
        }
        return c;
      }).toList();
    });
    if (id.startsWith('prov_') && widget.provider != null) {
      final rawId = int.tryParse(id.substring(5));
      if (rawId != null) {
        widget.provider!.toggleTaskStarred(rawId);
      }
    }
  }

  void _addAutoTaskFromPreset(Map<String, String> preset) {
    final parts = (preset['time'] ?? '09:00 AM - 10:00 AM').split(' - ');
    final horizon = preset['horizon'] ?? 'Day';
    final recurrence = horizon == 'Day'
        ? 'Daily • Every Day'
        : (horizon == 'Week' ? 'Weekly • Every Mon' : 'Monthly • Every 1st');

    final newCard = ScenicTaskCardModel.createAuto(
      id: 'auto_${DateTime.now().millisecondsSinceEpoch}',
      title: preset['title']!,
      description: preset['desc']!,
      startTime: parts.first,
      endTime: parts.length > 1 ? parts.last : '10:00 AM',
      duration: preset['duration'] ?? '45m',
      routineHorizon: horizon,
      dateOrRecurrence: recurrence,
      categoryTag: preset['tag'] ?? 'Routine',
      status: 'Locked In',
      progress: 0.40,
      isStarred: true,
    );

    setState(() {
      _cards.insert(0, newCard);
      _selectedHorizon = 'All';
    });
  }

  void _addCustomTaskAuto() {
    final title = _taskTitleController.text.trim();
    if (title.isEmpty) return;

    final nowFormatted = DateFormat('hh:mm a').format(_now);
    final endFormatted = DateFormat(
      'hh:mm a',
    ).format(_now.add(const Duration(minutes: 45)));

    final recurrence = _newTaskHorizon == 'Day'
        ? 'Daily • Every Day'
        : (_newTaskHorizon == 'Week'
              ? 'Weekly • Every ${DateFormat('EEE').format(_now)}'
              : 'Monthly • Every 1st');

    final newCard = ScenicTaskCardModel.createAuto(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description:
          'Auto-matched flat-vector artwork & live weather • $_newTaskHorizon Routine',
      startTime: nowFormatted,
      endTime: endFormatted,
      duration: '45m',
      routineHorizon: _newTaskHorizon,
      dateOrRecurrence: recurrence,
      categoryTag: '$_newTaskHorizon Routine',
      status: 'Active Now',
      progress: 0.35,
      isStarred: true,
    );

    setState(() {
      _cards.insert(0, newCard);
      _taskTitleController.clear();
      _showAutoCreator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCards;
    final liveClock = DateFormat('hh:mm a').format(_now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Sandbox Control Panel: Clarity Slider, Soft Spread Slider, Day/Night Study Switch & Filters
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Day/Dark Time Switch for Deep Study + Live Clock + Grid Toggle + Test Task
              Row(
                children: [
                  // Day vs Dark Time Toggle (Switches Deep Study between First-Left and First-Right)
                  GestureDetector(
                    onTap: () {
                      setState(
                        () => _isDarkTimeForStudy = !_isDarkTimeForStudy,
                      );
                      _saveSandboxSettings();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _isDarkTimeForStudy
                            ? const Color(0xFF1E1B4B)
                            : const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _isDarkTimeForStudy
                              ? const Color(0xFF4338CA)
                              : const Color(0xFF7DD3FC),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isDarkTimeForStudy
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            size: 13,
                            color: _isDarkTimeForStudy
                                ? const Color(0xFFFDE047)
                                : const Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _isDarkTimeForStudy
                                ? 'Study: Dark Time'
                                : 'Study: Day Time',
                            style: _poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _isDarkTimeForStudy
                                  ? Colors.white
                                  : const Color(0xFF0369A1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Live Real-Time Indicator Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          liveClock,
                          style: _poppins(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // 2x2 Grid vs Full Stack Toggle
                  GestureDetector(
                    onTap: () =>
                        setState(() => _twoColumnGrid = !_twoColumnGrid),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _twoColumnGrid
                                ? Icons.grid_view_rounded
                                : Icons.view_agenda_rounded,
                            size: 13,
                            color: const Color(0xFF0F172A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _twoColumnGrid ? '2x2 Grid' : 'Full Cards',
                            style: _poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showAutoCreator = !_showAutoCreator),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showAutoCreator ? Icons.close : Icons.add_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Test Task',
                            style: _poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // SLIDER 1: Background Image Clarity on White Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          size: 15,
                          color: Color(0xFF4F46E5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Background Image Clarity:',
                          style: _poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4.5,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7.5,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                              activeTrackColor: const Color(0xFF4F46E5),
                              inactiveTrackColor: const Color(0xFFE2E8F0),
                              thumbColor: const Color(0xFF4F46E5),
                            ),
                            child: Slider(
                              value: _imageClarity,
                              min: 0.15,
                              max: 1.0,
                              onChanged: (v) =>
                                  setState(() => _imageClarity = v),
                              onChangeEnd: (_) => _saveSandboxSettings(),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(_imageClarity * 100).round()}%',
                            style: _poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Quick Clarity Presets (Soft 40%, Balanced 75%, Crisp 100%)
                    Row(
                      children: [
                        Text(
                          'Quick Clarity:',
                          style: _poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildClarityPresetButton('Ultra Soft (40%)', 0.40),
                        const SizedBox(width: 6),
                        _buildClarityPresetButton('Soft Blend (75%)', 0.75),
                        const SizedBox(width: 6),
                        _buildClarityPresetButton('Full Crisp (100%)', 1.00),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // SLIDER 2: Image Soft Spread & Top-Left Curl Size
              Row(
                children: [
                  const Icon(
                    Icons.gradient_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Soft Image Width:',
                    style: _poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: const Color(0xFF0F172A),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFF0F172A),
                      ),
                      child: Slider(
                        value: _imageSpread,
                        min: 0.42,
                        max: 0.78,
                        onChanged: (v) => setState(() => _imageSpread = v),
                        onChangeEnd: (_) => _saveSandboxSettings(),
                      ),
                    ),
                  ),
                  Text(
                    '${(_imageSpread * 100).round()}%',
                    style: _poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Curl:',
                    style: _poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  SizedBox(
                    width: 75,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: const Color(0xFF0F172A),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFF0F172A),
                      ),
                      child: Slider(
                        value: _curlSize,
                        min: 20.0,
                        max: 50.0,
                        onChanged: (v) => setState(() => _curlSize = v),
                        onChangeEnd: (_) => _saveSandboxSettings(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Routine Horizon Filter Pills: All | Day | Week | Month
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHorizonChip(
                      'All',
                      'All 4 Concepts (${_cards.length})',
                    ),
                    const SizedBox(width: 6),
                    _buildHorizonChip('Day', '☀️ Day Routine'),
                    const SizedBox(width: 6),
                    _buildHorizonChip('Week', '📅 Week Routine'),
                    const SizedBox(width: 6),
                    _buildHorizonChip('Month', '🗓️ Month Routine'),
                  ],
                ),
              ),

              // Expandable Auto-Scene Task Tester
              if (_showAutoCreator) ...[
                const Divider(height: 18, color: Color(0xFFE2E8F0)),
                Text(
                  'Pick a task or type your own (Artwork & Weather are auto-assigned!):',
                  style: _poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: kQuickTaskPresets.map((preset) {
                    return GestureDetector(
                      onTap: () => _addAutoTaskFromPreset(preset),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              size: 13,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${preset['title']} (${preset['horizon']})',
                              style: _poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskTitleController,
                        style: _poppins(fontSize: 12),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Morning Run, Coffee Time, Deep Study, Night Run...',
                          hintStyle: _poppins(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: _newTaskHorizon,
                          style: _poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Day', child: Text('Day')),
                            DropdownMenuItem(
                              value: 'Week',
                              child: Text('Week'),
                            ),
                            DropdownMenuItem(
                              value: 'Month',
                              child: Text('Month'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _newTaskHorizon = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: _addCustomTaskAuto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: _poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Render the 4 Soft-Blended White Flat-Vector Task Cards (Each isolated in a RepaintBoundary)
        if (_twoColumnGrid)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.92,
            ),
            itemBuilder: (context, index) {
              final item = filtered[index];
              return RepaintBoundary(
                key: ValueKey('grid_${item.id}'),
                child: ScenicCurledTaskCard(
                  card: item,
                  now: _now,
                  imageClarity: _imageClarity,
                  imageSpread: _imageSpread,
                  curlSize: _curlSize,
                  isDarkTimeForStudy: _isDarkTimeForStudy,
                  compact: true,
                  onToggleComplete: () => _toggleCardComplete(item.id),
                  onToggleStar: () => _toggleCardStar(item.id),
                ),
              );
            },
          )
        else
          Column(
            children: filtered
                .map(
                  (item) => Padding(
                    key: ValueKey('list_${item.id}'),
                    padding: const EdgeInsets.only(bottom: 16),
                    child: RepaintBoundary(
                      child: SizedBox(
                        height: 196,
                        width: double.infinity,
                        child: ScenicCurledTaskCard(
                          card: item,
                          now: _now,
                          imageClarity: _imageClarity,
                          imageSpread: _imageSpread,
                          curlSize: _curlSize,
                          isDarkTimeForStudy: _isDarkTimeForStudy,
                          compact: false,
                          onToggleComplete: () => _toggleCardComplete(item.id),
                          onToggleStar: () => _toggleCardStar(item.id),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildClarityPresetButton(String label, double value) {
    final isSelected = (_imageClarity - value).abs() < 0.05;
    return GestureDetector(
      onTap: () {
        setState(() => _imageClarity = value);
        _saveSandboxSettings();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4F46E5)
                : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: _poppins(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizonChip(String key, String label) {
    final isSelected = _selectedHorizon == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedHorizon = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F172A)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: _poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

/// GPU-Optimized Crisp White Task Card with:
/// - 3D Top-Left Paper Corner Curl
/// - Softly feathered Flat-Vector Illustration on the right side (zero ShaderMask/Opacity saveLayer overhead!)
/// - Adjustable Background Image Clarity (`imageClarity`) & Soft Width (`imageSpread`)
/// - Real-Time Progress Line, Auto Weather Badge, Routine Horizon, and Interactive Check-Off
class ScenicCurledTaskCard extends StatelessWidget {
  final ScenicTaskCardModel card;
  final DateTime? now;
  final double imageClarity;
  final double imageSpread;
  final double curlSize;
  final bool isDarkTimeForStudy;
  final bool compact;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onToggleStar;

  const ScenicCurledTaskCard({
    super.key,
    required this.card,
    this.now,
    this.imageClarity = 0.78,
    this.imageSpread = 0.60,
    this.curlSize = 34.0,
    this.isDarkTimeForStudy = false,
    this.compact = false,
    this.onToggleComplete,
    this.onToggleStar,
  });

  Color _horizonBadgeColor(String horizon) {
    switch (horizon) {
      case 'Day':
        return const Color(0xFF0284C7);
      case 'Week':
        return const Color(0xFF7C3AED);
      case 'Month':
        return const Color(0xFFEA580C);
      default:
        return const Color(0xFF0F172A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double radius = compact ? 18.0 : 22.0;
    final double effectiveCurl = compact ? curlSize * 0.82 : curlSize;
    final String assetPath = card.resolveAssetPath(
      isDarkTime: isDarkTimeForStudy,
    );

    final String effectiveDegree =
        (card.autoScene == ScenicSceneType.deepStudy && isDarkTimeForStudy)
        ? '15°'
        : card.autoDegree;
    final String effectiveCondition =
        (card.autoScene == ScenicSceneType.deepStudy && isDarkTimeForStudy)
        ? 'Night Lamp • Focus'
        : card.autoCondition;

    final (liveProgress, liveStatus) = card.resolveLiveProgress(
      now ?? DateTime.now(),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth;
        final artworkWidth = cardW * imageSpread.clamp(0.40, 0.82);
        final bottomBarHeight = compact ? 38.0 : 46.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Soft ambient card shadow + lifted top-left peel shadow
            Positioned.fill(
              child: CustomPaint(
                painter: _CurledCardAmbientShadowPainter(
                  curlSize: effectiveCurl,
                  borderRadius: radius,
                ),
              ),
            ),

            // 2. Crisp White Card Body clipped at the top-left corner curl
            ClipPath(
              clipper: _TopLeftCornerCurlClipper(
                curlSize: effectiveCurl,
                borderRadius: radius,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    // A. Subtle atmospheric tint wash on the very right edge
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: bottomBarHeight - 2,
                      width: artworkWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              card.softTintColor.withValues(
                                alpha: imageClarity * 0.55,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // B. GPU-OPTIMIZED SOFT FLAT-VECTOR ILLUSTRATION ON THE RIGHT SIDE
                    // Uses direct Image color modulation + white gradient overlays instead of nested ShaderMask saveLayers!
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: bottomBarHeight,
                      width: artworkWidth,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            assetPath,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                            filterQuality: FilterQuality.medium,
                            color: Colors.white.withValues(
                              alpha: imageClarity.clamp(0.05, 1.0),
                            ),
                            colorBlendMode: BlendMode.modulate,
                          ),
                          // Horizontal soft feather into the white card on the left
                          const IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white,
                                    Color(0xBBFFFFFF),
                                    Color(0x33FFFFFF),
                                    Color(0x00FFFFFF),
                                  ],
                                  stops: [0.0, 0.22, 0.52, 0.85],
                                ),
                              ),
                            ),
                          ),
                          // Vertical soft feather at the bottom edge above the progress bar
                          const IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x00FFFFFF),
                                    Color(0x00FFFFFF),
                                    Colors.white,
                                  ],
                                  stops: [0.0, 0.78, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // C. Foreground Card Content (Left-Aligned on Crisp White Surface + Bottom Bar)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Upper Content Area (~74% height)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              compact ? 12 : 20,
                              compact
                                  ? math.max(14, effectiveCurl * 0.45)
                                  : math.max(16, effectiveCurl * 0.45),
                              compact ? 10 : 14,
                              compact ? 6 : 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Top Row: Auto Weather Pill (Left) + Routine Badge & Star (Right)
                                Row(
                                  children: [
                                    // Auto Weather & Activity Pill
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: compact ? 7 : 10,
                                        vertical: compact ? 2.5 : 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: card.softTintColor,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: card.accentColor.withValues(
                                            alpha: 0.20,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            effectiveDegree,
                                            style: _poppins(
                                              fontSize: compact ? 11 : 13,
                                              fontWeight: FontWeight.w800,
                                              color: card.accentColor,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            effectiveCondition,
                                            style: _poppins(
                                              fontSize: compact ? 9.5 : 11,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF334155),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    // Routine Horizon Badge (DAY / WEEK / MONTH)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: compact ? 6 : 9,
                                        vertical: compact ? 2 : 3.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.92,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.06,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        card.routineHorizon.toUpperCase(),
                                        style: _poppins(
                                          fontSize: compact ? 8.5 : 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: _horizonBadgeColor(
                                            card.routineHorizon,
                                          ),
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: onToggleStar,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.90,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.06,
                                              ),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          card.isStarred
                                              ? Icons.star_rounded
                                              : Icons.star_outline_rounded,
                                          size: compact ? 14 : 16,
                                          color: card.isStarred
                                              ? const Color(0xFFF59E0B)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Middle Block: Task Title & Short Description on Clean White Left Zone
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: compact ? 24 : cardW * 0.28,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        card.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: _poppins(
                                          fontSize: compact ? 13 : 17,
                                          fontWeight: FontWeight.w800,
                                          color: card.isCompleted
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF0F172A),
                                          decoration: card.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          height: 1.15,
                                        ),
                                      ),
                                      if (!compact &&
                                          card.description.isNotEmpty) ...[
                                        const SizedBox(height: 3),
                                        Text(
                                          card.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: _poppins(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF475569),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Bottom of Upper Zone: Duration Pill + Live Status Chip
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: compact ? 7 : 9,
                                        vertical: compact ? 2 : 3.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.schedule_rounded,
                                            size: compact ? 10 : 11.5,
                                            color: card.accentColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            card.duration,
                                            style: _poppins(
                                              fontSize: compact ? 9.5 : 10.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: compact ? 7 : 9,
                                        vertical: compact ? 2 : 3.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: card.isCompleted
                                            ? const Color(0xFFECFDF5)
                                            : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        liveStatus,
                                        style: _poppins(
                                          fontSize: compact ? 9 : 10,
                                          fontWeight: FontWeight.w700,
                                          color: card.isCompleted
                                              ? const Color(0xFF059669)
                                              : card.accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Sleek Real-Time Progress Line separating the soft visual zone and the bottom time bar
                        LinearProgressIndicator(
                          value: liveProgress,
                          minHeight: 3.0,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            card.isCompleted
                                ? const Color(0xFF10B981)
                                : card.accentColor.withValues(alpha: 0.75),
                          ),
                        ),

                        // Crisp White Bottom Bar: Check Circle + Start–End Time on Left, Recurrence on Right
                        Container(
                          height: compact ? 36 : 44,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: compact ? 10 : 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: onToggleComplete,
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        card.isCompleted
                                            ? Icons.check_circle_rounded
                                            : Icons
                                                  .radio_button_unchecked_rounded,
                                        size: compact ? 16 : 19,
                                        color: card.isCompleted
                                            ? const Color(0xFF10B981)
                                            : card.accentColor,
                                      ),
                                      SizedBox(width: compact ? 5 : 8),
                                      Flexible(
                                        child: Text(
                                          compact
                                              ? card.startTime
                                              : '${card.startTime} - ${card.endTime}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: _poppins(
                                            fontSize: compact ? 11.5 : 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1E293B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                card.dateOrRecurrence,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: _poppins(
                                  fontSize: compact ? 9.5 : 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. 3D Curled Paper Flap on the Top-Left Corner
            Positioned(
              top: 0,
              left: 0,
              width: effectiveCurl * 1.6,
              height: effectiveCurl * 1.6,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _TopLeftCornerCurlFlapPainter(
                    curlSize: effectiveCurl,
                    accentColor: card.accentColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Clips the card body so the top-left triangle is peeled away along the fold line.
class _TopLeftCornerCurlClipper extends CustomClipper<Path> {
  final double curlSize;
  final double borderRadius;

  _TopLeftCornerCurlClipper({
    required this.curlSize,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final c = curlSize.clamp(14.0, size.width * 0.45);
    final r = borderRadius;

    final path = Path();
    path.moveTo(c, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(size.width, size.height - r);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - r,
      size.height,
    );
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.lineTo(0, c);
    path.quadraticBezierTo(c * 0.46, c * 0.46, c, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TopLeftCornerCurlClipper oldClipper) {
    return oldClipper.curlSize != curlSize ||
        oldClipper.borderRadius != borderRadius;
  }
}

/// Paints the ambient card shadow plus the lifted corner shadow under the peeled top-left corner.
class _CurledCardAmbientShadowPainter extends CustomPainter {
  final double curlSize;
  final double borderRadius;

  _CurledCardAmbientShadowPainter({
    required this.curlSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = curlSize.clamp(14.0, size.width * 0.45);
    final r = borderRadius;

    final shadowPath = Path()
      ..moveTo(c, 2)
      ..lineTo(size.width - r, 2)
      ..quadraticBezierTo(size.width, 2, size.width, r + 2)
      ..lineTo(size.width, size.height - r)
      ..quadraticBezierTo(
        size.width,
        size.height + 3,
        size.width - r,
        size.height + 3,
      )
      ..lineTo(r, size.height + 3)
      ..quadraticBezierTo(0, size.height + 3, 0, size.height - r)
      ..lineTo(2, c)
      ..close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = const Color(0xFF0F172A).withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  @override
  bool shouldRepaint(covariant _CurledCardAmbientShadowPainter oldDelegate) {
    return oldDelegate.curlSize != curlSize;
  }
}

/// Paints the 3D curled paper flap on the top-left corner.
class _TopLeftCornerCurlFlapPainter extends CustomPainter {
  final double curlSize;
  final Color accentColor;

  _TopLeftCornerCurlFlapPainter({
    required this.curlSize,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = curlSize;

    final shadowPath = Path()
      ..moveTo(0, c)
      ..quadraticBezierTo(c * 0.46, c * 0.46, c, 0)
      ..quadraticBezierTo(c * 1.05, c * 0.68, c * 0.96, c * 0.96)
      ..quadraticBezierTo(c * 0.68, c * 1.05, 0, c)
      ..close();

    canvas.drawPath(
      shadowPath.shift(const Offset(2.5, 3.5)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.5),
    );

    final flapPath = Path()
      ..moveTo(0, c)
      ..quadraticBezierTo(c * 0.46, c * 0.46, c, 0)
      ..quadraticBezierTo(c * 0.94, c * 0.56, c * 0.88, c * 0.88)
      ..quadraticBezierTo(c * 0.56, c * 0.94, 0, c)
      ..close();

    final flapPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          const Color(0xFFF8FAFC),
          Color.lerp(const Color(0xFFE2E8F0), accentColor, 0.14)!,
          const Color(0xFFCBD5E1),
        ],
        stops: const [0.0, 0.38, 0.78, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, c, c));

    canvas.drawPath(flapPath, flapPaint);

    final spineHighlight = Path()
      ..moveTo(1, c - 1)
      ..quadraticBezierTo(c * 0.47, c * 0.47, c - 1, 1);
    canvas.drawPath(
      spineHighlight,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final innerEdge = Path()
      ..moveTo(c, 0)
      ..quadraticBezierTo(c * 0.94, c * 0.56, c * 0.88, c * 0.88)
      ..quadraticBezierTo(c * 0.56, c * 0.94, 0, c);
    canvas.drawPath(
      innerEdge,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant _TopLeftCornerCurlFlapPainter oldDelegate) {
    return oldDelegate.curlSize != curlSize ||
        oldDelegate.accentColor != accentColor;
  }
}

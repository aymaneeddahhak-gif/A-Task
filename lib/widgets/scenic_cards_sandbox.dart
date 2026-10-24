import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ScenicSceneType {
  morningRun, // 1. Cartoon person running in morning sun
  coffeeTime, // 2. Cartoon person enjoying steaming coffee & planning
  deepStudy, // 3. Cartoon student/worker coding with headphones & laptop
  workoutGym, // 4. Cartoon person lifting dumbbells / fitness on green hills
  eveningReading, // 5. Cartoon person reading an open book under a warm lamp
  nightRun, // 6. Cartoon person running at night under a glowing streetlamp
}

class ScenicTaskCardModel {
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
  final List<Color> autoSkyGradient;

  const ScenicTaskCardModel({
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
    required this.autoSkyGradient,
  });

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
      autoSkyGradient: autoSkyGradient,
    );
  }

  /// Automatically resolves the cartoon activity scene, weather temperature, and sky palette
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
    } else if (lower.contains('night run') ||
        lower.contains('evening run') ||
        (isPM && lower.contains('run')) ||
        lower.contains('night')) {
      scene = ScenicSceneType.nightRun;
    } else if (lower.contains('coffee') ||
        lower.contains('espresso') ||
        lower.contains('latte') ||
        lower.contains('breakfast') ||
        lower.contains('tea')) {
      scene = ScenicSceneType.coffeeTime;
    } else if (lower.contains('morning run') ||
        lower.contains('run') ||
        lower.contains('jog') ||
        lower.contains('cardio')) {
      scene = ScenicSceneType.morningRun;
    } else if (lower.contains('read') ||
        lower.contains('book') ||
        lower.contains('journal') ||
        lower.contains('month') ||
        lower.contains('budget')) {
      scene = ScenicSceneType.eveningReading;
    } else if (lower.contains('gym') ||
        lower.contains('workout') ||
        lower.contains('fitness') ||
        lower.contains('train') ||
        lower.contains('sport') ||
        lower.contains('stretch')) {
      scene = ScenicSceneType.workoutGym;
    } else {
      scene = ScenicSceneType.deepStudy;
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
          autoDegree: '23°',
          autoCondition: 'Sunny • Morning Run',
          autoSkyGradient: const [
            Color(0xFFFBC02D),
            Color(0xFFFDE047),
            Color(0xFFF59E0B),
          ],
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
          autoDegree: '21°',
          autoCondition: 'Warm • Coffee Break',
          autoSkyGradient: const [
            Color(0xFFF59E0B),
            Color(0xFFFBBF24),
            Color(0xFFD97706),
          ],
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
          autoCondition: 'Cloudy • Deep Focus',
          autoSkyGradient: const [
            Color(0xFF38BDF8),
            Color(0xFF7DD3FC),
            Color(0xFF60A5FA),
          ],
        );
      case ScenicSceneType.workoutGym:
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
          autoDegree: '16°',
          autoCondition: 'Breezy • Workout',
          autoSkyGradient: const [
            Color(0xFF84CC16),
            Color(0xFFA8CA7A),
            Color(0xFF65A30D),
          ],
        );
      case ScenicSceneType.eveningReading:
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
          autoDegree: '15°',
          autoCondition: 'Cozy • Reading',
          autoSkyGradient: const [
            Color(0xFF6366F1),
            Color(0xFF818CF8),
            Color(0xFFA5B4FC),
          ],
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
          autoCondition: 'Clear Night • Run',
          autoSkyGradient: const [
            Color(0xFF1E293B),
            Color(0xFF334155),
            Color(0xFF475569),
          ],
        );
    }
  }
}

/// Default Student & Worker Routine Tasks across Day, Week, and Month
/// featuring cartoon characters performing the exact task on every card!
final List<ScenicTaskCardModel> kInitialScenicTaskCards = [
  // 1. Morning Running (Cartoon Runner in Golden Sunrise)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_1',
    title: 'Morning 5km Park Run',
    description: 'Outdoor cardio pace along the sunrise trail + hydration',
    startTime: '07:00 AM',
    endTime: '07:45 AM',
    duration: '45m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Morning Run',
    status: 'Completed',
    progress: 1.0,
    isCompleted: true,
    isStarred: true,
    overrideScene: ScenicSceneType.morningRun,
  ),
  // 2. Coffee Time & Daily Plan (Cartoon Person with Steaming Coffee Cup)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_2',
    title: 'Coffee Time & Top 3 Goals',
    description: 'Enjoy morning espresso & plan today’s key priorities',
    startTime: '08:30 AM',
    endTime: '09:00 AM',
    duration: '30m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Coffee Time',
    status: 'Completed',
    progress: 1.0,
    isCompleted: true,
    isStarred: true,
    overrideScene: ScenicSceneType.coffeeTime,
  ),
  // 3. Deep Study & Coding Sprint (Cartoon Person with Headphones & Laptop)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_3',
    title: 'Deep Study & Coding Sprint',
    description: 'Core architecture build, lecture notes & algorithms practice',
    startTime: '09:30 AM',
    endTime: '11:30 AM',
    duration: '2h',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Deep Study',
    status: 'In Progress',
    progress: 0.65,
    isStarred: true,
    overrideScene: ScenicSceneType.deepStudy,
  ),
  // 4. Afternoon Workout & Fitness (Cartoon Athlete Lifting Dumbbells)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_4',
    title: 'Weekly Strength & Mobility',
    description: 'Upper-body dumbbell session & full-body stretching routine',
    startTime: '05:00 PM',
    endTime: '06:00 PM',
    duration: '1h',
    routineHorizon: 'Week',
    dateOrRecurrence: 'Weekly • Mon, Wed, Fri',
    categoryTag: 'Workout',
    status: 'Locked In',
    progress: 0.45,
    overrideScene: ScenicSceneType.workoutGym,
  ),
  // 5. Evening Reading & Monthly Review (Cartoon Person Reading Book by Lamp)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_5',
    title: 'Evening Reading & Monthly Plan',
    description: 'Read 20 pages & review monthly budget and career milestones',
    startTime: '08:30 PM',
    endTime: '09:30 PM',
    duration: '1h',
    routineHorizon: 'Month',
    dateOrRecurrence: 'Monthly • Every 1st',
    categoryTag: 'Reading & Review',
    status: 'Locked In',
    progress: 0.50,
    isStarred: true,
    overrideScene: ScenicSceneType.eveningReading,
  ),
  // 6. Night Running under Streetlamp (Cartoon Runner at Night)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_6',
    title: 'Night Run & Decompress',
    description: '3km evening jog under city streetlamps to clear the mind',
    startTime: '09:40 PM',
    endTime: '10:25 PM',
    duration: '45m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Night Run',
    status: 'Scheduled',
    progress: 0.25,
    overrideScene: ScenicSceneType.nightRun,
  ),
];

/// Quick-pick presets so the user can test how picking ONLY a task + routine horizon
/// automatically assigns the cartoon character scene, temperature, and weather condition.
const List<Map<String, String>> kQuickTaskPresets = [
  {
    'title': 'Morning 5km Run',
    'desc': 'Outdoor sunrise run + hydration before class/work',
    'time': '07:00 AM - 07:45 AM',
    'duration': '45m',
    'tag': 'Morning Run',
    'horizon': 'Day',
  },
  {
    'title': 'Coffee Time & Plan',
    'desc': 'Fresh espresso + review top 3 priorities for today',
    'time': '08:30 AM - 09:00 AM',
    'duration': '30m',
    'tag': 'Coffee Time',
    'horizon': 'Day',
  },
  {
    'title': 'Deep Coding & Study',
    'desc': 'Headphones on — 2h focused sprint on main project',
    'time': '10:00 AM - 12:00 PM',
    'duration': '2h',
    'tag': 'Deep Study',
    'horizon': 'Week',
  },
  {
    'title': 'Gym & Dumbbell Workout',
    'desc': 'Strength training & mobility session',
    'time': '05:30 PM - 06:30 PM',
    'duration': '1h',
    'tag': 'Workout',
    'horizon': 'Week',
  },
  {
    'title': 'Night Run under Stars',
    'desc': 'Evening 3km run along the lit park path',
    'time': '08:30 PM - 09:15 PM',
    'duration': '45m',
    'tag': 'Night Run',
    'horizon': 'Day',
  },
  {
    'title': 'Read 20 Pages & Budget',
    'desc': 'Cozy evening book reading & monthly goal check-in',
    'time': '09:30 PM - 10:15 PM',
    'duration': '45m',
    'tag': 'Reading',
    'horizon': 'Month',
  },
];

/// Interactive Sandbox showcase combining `designcard.png` flat-vector style
/// with Cartoon Character Task Scenes, 3D Top-Left Corner Curl, and real task details.
class ScenicCardsSandboxShowcase extends StatefulWidget {
  const ScenicCardsSandboxShowcase({super.key});

  @override
  State<ScenicCardsSandboxShowcase> createState() =>
      _ScenicCardsSandboxShowcaseState();
}

class _ScenicCardsSandboxShowcaseState
    extends State<ScenicCardsSandboxShowcase> {
  late List<ScenicTaskCardModel> _cards;
  double _curlSize = 36.0;
  bool _twoColumnGrid = false;
  bool _showCartoonCharacters = true;
  String _selectedHorizon = 'All'; // 'All', 'Day', 'Week', 'Month'
  bool _showAutoCreator = false;
  final TextEditingController _taskTitleController = TextEditingController();
  String _newTaskHorizon = 'Day';
  final String _newTaskTimeSlot = '07:30 AM - 08:15 AM';

  @override
  void initState() {
    super.initState();
    _cards = List<ScenicTaskCardModel>.from(kInitialScenicTaskCards);
  }

  @override
  void dispose() {
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
      progress: 0.35,
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

    final parts = _newTaskTimeSlot.split(' - ');
    final recurrence = _newTaskHorizon == 'Day'
        ? 'Daily • Every Day'
        : (_newTaskHorizon == 'Week'
            ? 'Weekly • Every Mon'
            : 'Monthly • Every 1st');

    final newCard = ScenicTaskCardModel.createAuto(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: 'Auto-matched cartoon scene & weather • $_newTaskHorizon Routine',
      startTime: parts.first,
      endTime: parts.length > 1 ? parts.last : '09:00 AM',
      duration: '45m',
      routineHorizon: _newTaskHorizon,
      dateOrRecurrence: recurrence,
      categoryTag: '$_newTaskHorizon Routine',
      status: 'Locked In',
      progress: 0.30,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Control & Routine Horizon Bar
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
              // Top Row: Cartoon Mode Badge + Grid/Full Toggle + Test Task Button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(
                      () => _showCartoonCharacters = !_showCartoonCharacters,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _showCartoonCharacters
                            ? const Color(0xFFFEF3C7)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _showCartoonCharacters
                              ? const Color(0xFFFCD34D)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showCartoonCharacters
                                ? Icons.directions_run_rounded
                                : Icons.landscape_rounded,
                            size: 13,
                            color: _showCartoonCharacters
                                ? const Color(0xFFB45309)
                                : const Color(0xFF475569),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _showCartoonCharacters
                                ? 'CARTOON TASK ART'
                                : 'CLASSIC SCENIC ART',
                            style: GoogleFonts.poppins(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: _showCartoonCharacters
                                  ? const Color(0xFFB45309)
                                  : const Color(0xFF475569),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 2x3 Grid vs Full Detailed Cards
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
                            _twoColumnGrid ? '2x3 Grid' : 'Full Detail',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Test Auto-Task Creator toggle
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
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Test Task',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
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

              // Routine Horizon Filter Pills: All | Day | Week | Month
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHorizonChip('All', 'All Routines (${_cards.length})'),
                    const SizedBox(width: 6),
                    _buildHorizonChip('Day', '☀️ Day Routine'),
                    const SizedBox(width: 6),
                    _buildHorizonChip('Week', '📅 Week Routine'),
                    const SizedBox(width: 6),
                    _buildHorizonChip('Month', '🗓️ Month Routine'),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Top-Left Corner Curl Slider
              Row(
                children: [
                  const Icon(
                    Icons.filter_none_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Top-Left Corner Curl:',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                        activeTrackColor: const Color(0xFF0F172A),
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFF0F172A),
                      ),
                      child: Slider(
                        value: _curlSize,
                        min: 22.0,
                        max: 54.0,
                        onChanged: (v) => setState(() => _curlSize = v),
                      ),
                    ),
                  ),
                  Text(
                    '${_curlSize.round()}px',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              // Expandable Auto-Scene Task Tester
              if (_showAutoCreator) ...[
                const Divider(height: 18, color: Color(0xFFE2E8F0)),
                Text(
                  'Pick a task or type your own (Cartoon Scene & Weather are auto-assigned!):',
                  style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
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
                        style: GoogleFonts.poppins(fontSize: 12),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Morning Run, Coffee Time, Night Run...',
                          hintStyle: GoogleFonts.poppins(
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
                          style: GoogleFonts.poppins(
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
                        style: GoogleFonts.poppins(
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

        // 2. Render either 2x3 Compact Grid or Full Detailed Combined Cards
        if (_twoColumnGrid)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final item = filtered[index];
              return ScenicCurledTaskCard(
                card: item,
                curlSize: _curlSize,
                compact: true,
                showCartoonCharacter: _showCartoonCharacters,
                onToggleComplete: () => _toggleCardComplete(item.id),
                onToggleStar: () => _toggleCardStar(item.id),
              );
            },
          )
        else
          Column(
            children: filtered
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 224,
                      width: double.infinity,
                      child: ScenicCurledTaskCard(
                        card: item,
                        curlSize: _curlSize + 4,
                        compact: false,
                        showCartoonCharacter: _showCartoonCharacters,
                        onToggleComplete: () => _toggleCardComplete(item.id),
                        onToggleStar: () => _toggleCardStar(item.id),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
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
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

/// Combined Scenic Curled Task Card (`designcard.png` + Cartoon Character Task Art + Real Task Details)
class ScenicCurledTaskCard extends StatelessWidget {
  final ScenicTaskCardModel card;
  final double curlSize;
  final bool compact;
  final bool showCartoonCharacter;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onToggleStar;

  const ScenicCurledTaskCard({
    super.key,
    required this.card,
    this.curlSize = 36.0,
    this.compact = false,
    this.showCartoonCharacter = true,
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
    final double radius = compact ? 16.0 : 20.0;
    final double effectiveCurl = compact ? curlSize * 0.82 : curlSize;

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

        // 2. Main card body clipped at the top-left corner where the paper curls over
        ClipPath(
          clipper: _TopLeftCornerCurlClipper(
            curlSize: effectiveCurl,
            borderRadius: radius,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Column(
              children: [
                // Top Scenic Illustration Area (~73% height)
                Expanded(
                  flex: 73,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Custom Scenic Vector Artwork with Cartoon Person performing the Task
                      CustomPaint(
                        painter: _ScenicIllustrationPainter(
                          scene: card.autoScene,
                          skyGradient: card.autoSkyGradient,
                          showCartoonCharacter: showCartoonCharacter,
                        ),
                      ),

                      // Subtle left-side readability gradient for task text
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.20),
                                Colors.black.withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Top-Right Status Badge + Routine Horizon + Star Button
                      Positioned(
                        top: compact ? 8 : 12,
                        right: compact ? 8 : 14,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: compact ? 6 : 9,
                                vertical: compact ? 2 : 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${card.routineHorizon.toUpperCase()} ROUTINE',
                                style: GoogleFonts.poppins(
                                  fontSize: compact ? 8.5 : 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: _horizonBadgeColor(
                                    card.routineHorizon,
                                  ),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            if (!compact) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: card.isCompleted
                                      ? const Color(0xFF10B981)
                                      : Colors.black.withValues(alpha: 0.28),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  card.isCompleted ? 'Completed' : card.status,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: onToggleStar,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  card.isStarred
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: compact ? 14 : 16,
                                  color: card.isStarred
                                      ? const Color(0xFFFDE047)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Top-Left Auto Weather (`23° Sunny`) + Real Task Title + Description + Chips
                      Positioned(
                        left: compact ? 12 : 20,
                        top: compact
                            ? math.max(18, effectiveCurl * 0.56)
                            : math.max(22, effectiveCurl * 0.55),
                        right: compact ? 10 : 115,
                        bottom: compact ? 8 : 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      card.autoDegree,
                                      style: GoogleFonts.poppins(
                                        fontSize: compact ? 21 : 27,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.0,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.18,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        card.autoCondition,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: compact ? 10 : 12.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withValues(
                                            alpha: 0.95,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: compact ? 3 : 5),
                                Text(
                                  card.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: compact ? 12.5 : 16.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    decoration: card.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.white,
                                    height: 1.15,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.22,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!compact &&
                                    card.description.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    card.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.90,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Frosted Glass Pills: Duration (`⏱ 45m`) + Category (`Morning Run`)
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compact ? 7 : 9,
                                    vertical: compact ? 2 : 3.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.24),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.schedule_rounded,
                                        size: compact ? 10 : 11.5,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        card.duration,
                                        style: GoogleFonts.poppins(
                                          fontSize: compact ? 9 : 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: compact ? 7 : 9,
                                      vertical: compact ? 2 : 3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.22,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      card.categoryTag,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: compact ? 9 : 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Sleek Progress Line at the bottom edge of the scenic banner
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: LinearProgressIndicator(
                          value: card.progress,
                          minHeight: 3.5,
                          backgroundColor: Colors.black.withValues(alpha: 0.14),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            card.isCompleted
                                ? const Color(0xFF10B981)
                                : Colors.white.withValues(alpha: 0.90),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Crisp White Bar (~27% height): Check Circle + Time on Left, Recurrence/Date on Right
                Expanded(
                  flex: 27,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 10 : 16,
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
                                      : Icons.radio_button_unchecked_rounded,
                                  size: compact ? 16 : 19,
                                  color: card.isCompleted
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF64748B),
                                ),
                                SizedBox(width: compact ? 5 : 8),
                                Flexible(
                                  child: Text(
                                    compact
                                        ? card.startTime
                                        : '${card.startTime} - ${card.endTime}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: compact ? 12.5 : 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF334155),
                                      letterSpacing: 0.1,
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
                          style: GoogleFonts.poppins(
                            fontSize: compact ? 9.5 : 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                accentColor: card.autoSkyGradient.first,
              ),
            ),
          ),
        ),
      ],
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
        ..color = const Color(0xFF0F172A).withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
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
        ..color = Colors.black.withValues(alpha: 0.24)
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
          Color.lerp(const Color(0xFFE2E8F0), accentColor, 0.12)!,
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
        ..color = Colors.white.withValues(alpha: 0.92)
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
        ..color = Colors.white.withValues(alpha: 0.75)
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

/// Custom flat-vector painter in the exact style of `designcard.png` that draws:
/// - The layered scenic hills, sun/moon/clouds/trees
/// - A stylized flat-vector CARTOON PERSON performing the exact task on the right side!
class _ScenicIllustrationPainter extends CustomPainter {
  final ScenicSceneType scene;
  final List<Color> skyGradient;
  final bool showCartoonCharacter;

  _ScenicIllustrationPainter({
    required this.scene,
    required this.skyGradient,
    this.showCartoonCharacter = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: skyGradient,
        ).createShader(rect),
    );

    switch (scene) {
      case ScenicSceneType.morningRun:
        _paintMorningRunScene(canvas, size);
        break;
      case ScenicSceneType.coffeeTime:
        _paintCoffeeTimeScene(canvas, size);
        break;
      case ScenicSceneType.deepStudy:
        _paintDeepStudyScene(canvas, size);
        break;
      case ScenicSceneType.workoutGym:
        _paintWorkoutGymScene(canvas, size);
        break;
      case ScenicSceneType.eveningReading:
        _paintEveningReadingScene(canvas, size);
        break;
      case ScenicSceneType.nightRun:
        _paintNightRunScene(canvas, size);
        break;
    }
  }

  /// 1. MORNING RUN: Golden sunrise hills + flat-vector cartoon runner in dynamic stride
  void _paintMorningRunScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Concentric glowing morning sun
    final sunCenter = Offset(w * 0.84, h * 0.26);
    canvas.drawCircle(
      sunCenter,
      w * 0.16,
      Paint()..color = Colors.white.withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      sunCenter,
      w * 0.10,
      Paint()..color = Colors.white.withValues(alpha: 0.30),
    );
    canvas.drawCircle(
      sunCenter,
      w * 0.055,
      Paint()..color = const Color(0xFFFFFBEB),
    );

    // Distant golden hill
    final backDune = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.28, h * 0.56, w * 0.62, h * 0.66)
      ..quadraticBezierTo(w * 0.84, h * 0.72, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backDune, Paint()..color = const Color(0xFFF59E0B));

    // Mid warm amber hill
    final midDune = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.36, h * 0.68, w * 0.72, h * 0.74)
      ..quadraticBezierTo(w * 0.90, h * 0.77, w, h * 0.70)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midDune, Paint()..color = const Color(0xFFD97706));

    // Foreground running path ridge
    final frontDune = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.45, h * 0.76, w, h * 0.83)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontDune, Paint()..color = const Color(0xFFB45309));

    if (showCartoonCharacter) {
      _drawCartoonRunner(
        canvas,
        anchor: Offset(w * 0.76, h * 0.78),
        scale: h * 0.0052,
        shirtColor: const Color(0xFF78350F),
        shortsColor: const Color(0xFF451A03),
        skinColor: const Color(0xFFFDE68A),
        accentColor: Colors.white,
      );
    }
  }

  /// Helper: Draws a stylized flat-vector cartoon person running in full stride
  void _drawCartoonRunner(
    Canvas canvas, {
    required Offset anchor,
    required double scale,
    required Color shirtColor,
    required Color shortsColor,
    required Color skinColor,
    required Color accentColor,
  }) {
    final s = scale;
    final cx = anchor.dx;
    final cy = anchor.dy; // Ground contact level

    // Soft ground shadow under runner
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + 4 * s),
        width: 44 * s,
        height: 7 * s,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );

    final limbPaint = Paint()
      ..color = skinColor
      ..strokeWidth = 5.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Back leg (kicking back)
    final backLeg = Path()
      ..moveTo(cx - 2 * s, cy - 30 * s)
      ..lineTo(cx - 14 * s, cy - 16 * s)
      ..lineTo(cx - 25 * s, cy - 20 * s);
    canvas.drawPath(backLeg, limbPaint);

    // Front leg (striding forward)
    final frontLeg = Path()
      ..moveTo(cx + 3 * s, cy - 30 * s)
      ..lineTo(cx + 16 * s, cy - 16 * s)
      ..lineTo(cx + 12 * s, cy - 2 * s);
    canvas.drawPath(frontLeg, limbPaint);

    // Crisp white running shoes
    final shoePaint = Paint()..color = accentColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + 15 * s, cy - 1 * s),
          width: 11 * s,
          height: 5 * s,
        ),
        Radius.circular(3 * s),
      ),
      shoePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - 26 * s, cy - 18 * s),
          width: 10 * s,
          height: 5 * s,
        ),
        Radius.circular(3 * s),
      ),
      shoePaint,
    );

    // Running shorts
    final shortsPath = Path()
      ..moveTo(cx - 8 * s, cy - 36 * s)
      ..lineTo(cx + 8 * s, cy - 35 * s)
      ..lineTo(cx + 12 * s, cy - 24 * s)
      ..lineTo(cx - 11 * s, cy - 25 * s)
      ..close();
    canvas.drawPath(shortsPath, Paint()..color = shortsColor);

    // Back arm (swinging back)
    final backArm = Path()
      ..moveTo(cx, cy - 52 * s)
      ..lineTo(cx - 14 * s, cy - 44 * s)
      ..lineTo(cx - 8 * s, cy - 35 * s);
    canvas.drawPath(backArm, limbPaint..strokeWidth = 4.8 * s);

    // Torso (athletic shirt leaning slightly forward)
    final torsoPath = Path()
      ..moveTo(cx - 6 * s, cy - 56 * s)
      ..lineTo(cx + 9 * s, cy - 55 * s)
      ..lineTo(cx + 7 * s, cy - 34 * s)
      ..lineTo(cx - 8 * s, cy - 35 * s)
      ..close();
    canvas.drawPath(torsoPath, Paint()..color = shirtColor);

    // Front arm (pumping forward)
    final frontArm = Path()
      ..moveTo(cx + 5 * s, cy - 52 * s)
      ..lineTo(cx + 15 * s, cy - 42 * s)
      ..lineTo(cx + 23 * s, cy - 50 * s);
    canvas.drawPath(frontArm, limbPaint);

    // Head
    final headCenter = Offset(cx + 5 * s, cy - 66 * s);
    canvas.drawCircle(headCenter, 8.5 * s, Paint()..color = skinColor);

    // Stylized hair / cap
    final hairPath = Path()
      ..addArc(
        Rect.fromCircle(center: headCenter, radius: 9 * s),
        math.pi * 0.95,
        math.pi * 1.15,
      );
    canvas.drawPath(hairPath, Paint()..color = shortsColor);

    // Sporty headband + trailing ties
    final bandPaint = Paint()
      ..color = accentColor
      ..strokeWidth = 2.6 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(headCenter.dx - 8 * s, headCenter.dy - 2 * s),
      Offset(headCenter.dx + 8 * s, headCenter.dy - 2 * s),
      bandPaint,
    );
    canvas.drawLine(
      Offset(headCenter.dx - 8 * s, headCenter.dy - 2 * s),
      Offset(headCenter.dx - 16 * s, headCenter.dy),
      bandPaint,
    );

    // Motion wind lines behind runner
    final windPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1.6 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - 34 * s, cy - 52 * s),
      Offset(cx - 20 * s, cy - 52 * s),
      windPaint,
    );
    canvas.drawLine(
      Offset(cx - 38 * s, cy - 40 * s),
      Offset(cx - 24 * s, cy - 40 * s),
      windPaint,
    );
  }

  /// 2. COFFEE TIME: Warm amber hills + flat-vector cartoon person enjoying steaming coffee
  void _paintCoffeeTimeScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Warm morning sun
    canvas.drawCircle(
      Offset(w * 0.62, h * 0.24),
      w * 0.09,
      Paint()..color = Colors.white.withValues(alpha: 0.22),
    );
    canvas.drawCircle(
      Offset(w * 0.62, h * 0.24),
      w * 0.05,
      Paint()..color = const Color(0xFFFFFBEB),
    );

    // Layered warm latte/terracotta hills
    final backHill = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.34, h * 0.58, w * 0.72, h * 0.68)
      ..quadraticBezierTo(w * 0.88, h * 0.72, w, h * 0.65)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = const Color(0xFFD97706));

    final frontHill = Path()
      ..moveTo(0, h * 0.84)
      ..quadraticBezierTo(w * 0.45, h * 0.72, w, h * 0.80)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF92400E));

    if (showCartoonCharacter) {
      final s = h * 0.0052;
      final cx = w * 0.77;
      final cy = h * 0.82;

      // Cartoon character sitting/standing with a steaming coffee mug
      // Head
      final headCenter = Offset(cx - 6 * s, cy - 58 * s);
      canvas.drawCircle(
        headCenter,
        9.5 * s,
        Paint()..color = const Color(0xFFFDE68A),
      );
      // Cozy hair
      canvas.drawArc(
        Rect.fromCircle(center: headCenter, radius: 10 * s),
        math.pi * 0.9,
        math.pi * 1.25,
        true,
        Paint()..color = const Color(0xFF451A03),
      );

      // Cozy sweater torso
      final torso = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - 6 * s, cy - 30 * s),
          width: 24 * s,
          height: 34 * s,
        ),
        Radius.circular(10 * s),
      );
      canvas.drawRRect(torso, Paint()..color = const Color(0xFF78350F));

      // Arm raised holding the coffee cup
      final armPaint = Paint()
        ..color = const Color(0xFFFDE68A)
        ..strokeWidth = 5.2 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final armPath = Path()
        ..moveTo(cx - 2 * s, cy - 40 * s)
        ..lineTo(cx + 10 * s, cy - 34 * s)
        ..lineTo(cx + 18 * s, cy - 45 * s);
      canvas.drawPath(armPath, armPaint);

      // Iconic White Coffee Mug + Handle
      final mugCenter = Offset(cx + 22 * s, cy - 48 * s);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: mugCenter, width: 13 * s, height: 15 * s),
          Radius.circular(3 * s),
        ),
        Paint()..color = Colors.white,
      );
      // Mug handle
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(mugCenter.dx + 6.5 * s, mugCenter.dy),
          width: 7 * s,
          height: 9 * s,
        ),
        -math.pi / 2,
        math.pi,
        false,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2 * s,
      );

      // Rising white steam curls above coffee mug
      final steamPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * s
        ..strokeCap = StrokeCap.round;
      for (int i = -1; i <= 1; i += 2) {
        final sx = mugCenter.dx + i * 3.0 * s;
        final sy = mugCenter.dy - 10 * s;
        final steam = Path()
          ..moveTo(sx, sy)
          ..quadraticBezierTo(sx - 3 * s, sy - 6 * s, sx + 1 * s, sy - 11 * s)
          ..quadraticBezierTo(sx + 4 * s, sy - 16 * s, sx, sy - 21 * s);
        canvas.drawPath(steam, steamPaint);
      }
    }
  }

  /// 3. DEEP STUDY & CODING: Sky-blue mountains + cartoon person with headphones & laptop
  void _paintDeepStudyScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft clouds
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.60);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.62, h * 0.25),
          width: w * 0.16,
          height: h * 0.03,
        ),
        const Radius.circular(20),
      ),
      cloudPaint,
    );

    // Layered sky-blue mountains
    final farMountain = Path()
      ..moveTo(0, h * 0.75)
      ..lineTo(w * 0.24, h * 0.52)
      ..lineTo(w * 0.52, h * 0.70)
      ..lineTo(w * 0.78, h * 0.48)
      ..lineTo(w, h * 0.64)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farMountain, Paint()..color = const Color(0xFF60A5FA));

    final frontHill = Path()
      ..moveTo(0, h * 0.86)
      ..quadraticBezierTo(w * 0.45, h * 0.74, w, h * 0.82)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF2563EB));

    if (showCartoonCharacter) {
      final s = h * 0.0052;
      final cx = w * 0.78;
      final cy = h * 0.84;

      // Cartoon student/developer with headphones & open laptop
      final headCenter = Offset(cx - 10 * s, cy - 56 * s);
      canvas.drawCircle(
        headCenter,
        9 * s,
        Paint()..color = const Color(0xFFE0F2FE),
      );

      // Over-ear wireless headphones arc + earcups
      canvas.drawArc(
        Rect.fromCircle(center: headCenter, radius: 10.5 * s),
        math.pi * 1.05,
        math.pi * 0.9,
        false,
        Paint()
          ..color = const Color(0xFF1E3A8A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.8 * s,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(headCenter.dx - 2 * s, headCenter.dy + 1 * s),
            width: 5 * s,
            height: 8 * s,
          ),
          Radius.circular(2.5 * s),
        ),
        Paint()..color = Colors.white,
      );

      // Torso leaning slightly toward laptop
      final torso = Path()
        ..moveTo(cx - 20 * s, cy - 44 * s)
        ..lineTo(cx - 2 * s, cy - 44 * s)
        ..lineTo(cx + 2 * s, cy - 16 * s)
        ..lineTo(cx - 22 * s, cy - 16 * s)
        ..close();
      canvas.drawPath(torso, Paint()..color = const Color(0xFF1E3A8A));

      // Arm reaching to keyboard
      canvas.drawLine(
        Offset(cx - 6 * s, cy - 36 * s),
        Offset(cx + 12 * s, cy - 24 * s),
        Paint()
          ..color = const Color(0xFFE0F2FE)
          ..strokeWidth = 5 * s
          ..strokeCap = StrokeCap.round,
      );

      // Glowing Open Laptop on right
      final laptopBase = Offset(cx + 8 * s, cy - 22 * s);
      // Soft screen glow cone
      final glowPath = Path()
        ..moveTo(laptopBase.dx + 16 * s, laptopBase.dy)
        ..lineTo(laptopBase.dx + 22 * s, laptopBase.dy - 22 * s)
        ..lineTo(headCenter.dx + 4 * s, headCenter.dy - 6 * s)
        ..lineTo(laptopBase.dx, laptopBase.dy)
        ..close();
      canvas.drawPath(
        glowPath,
        Paint()..color = Colors.white.withValues(alpha: 0.22),
      );

      // Laptop keyboard base + angled lid
      final laptopPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 3.2 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final laptopPath = Path()
        ..moveTo(laptopBase.dx, laptopBase.dy)
        ..lineTo(laptopBase.dx + 16 * s, laptopBase.dy)
        ..lineTo(laptopBase.dx + 22 * s, laptopBase.dy - 20 * s);
      canvas.drawPath(laptopPath, laptopPaint);
    }
  }

  /// 4. WORKOUT / GYM: Meadow green hills + cartoon athlete lifting dumbbells overhead
  void _paintWorkoutGymScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final backHill = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.35, h * 0.54, w * 0.75, h * 0.66)
      ..quadraticBezierTo(w * 0.90, h * 0.70, w, h * 0.63)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = const Color(0xFF82B352));

    final frontHill = Path()
      ..moveTo(0, h * 0.84)
      ..quadraticBezierTo(w * 0.48, h * 0.72, w, h * 0.80)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF4D7C2B));

    if (showCartoonCharacter) {
      final s = h * 0.0052;
      final cx = w * 0.78;
      final cy = h * 0.80;

      // Cartoon athlete pressing a barbell/dumbbells overhead
      // Legs planted strong
      final legPaint = Paint()
        ..color = const Color(0xFF1E293B)
        ..strokeWidth = 5.5 * s
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(cx - 5 * s, cy - 26 * s),
        Offset(cx - 10 * s, cy),
        legPaint,
      );
      canvas.drawLine(
        Offset(cx + 5 * s, cy - 26 * s),
        Offset(cx + 10 * s, cy),
        legPaint,
      );

      // Athletic tank torso
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, cy - 38 * s),
            width: 18 * s,
            height: 26 * s,
          ),
          Radius.circular(6 * s),
        ),
        Paint()..color = const Color(0xFFECFCCB),
      );

      // Head
      canvas.drawCircle(
        Offset(cx, cy - 58 * s),
        8 * s,
        Paint()..color = const Color(0xFFFEF08A),
      );

      // Both arms raised pressing dumbbells overhead
      final armPaint = Paint()
        ..color = const Color(0xFFFEF08A)
        ..strokeWidth = 4.6 * s
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final arms = Path()
        ..moveTo(cx - 8 * s, cy - 48 * s)
        ..lineTo(cx - 16 * s, cy - 60 * s)
        ..lineTo(cx - 14 * s, cy - 74 * s)
        ..moveTo(cx + 8 * s, cy - 48 * s)
        ..lineTo(cx + 16 * s, cy - 60 * s)
        ..lineTo(cx + 14 * s, cy - 74 * s);
      canvas.drawPath(arms, armPaint);

      // Overhead Barbell / Dumbbells
      canvas.drawLine(
        Offset(cx - 24 * s, cy - 74 * s),
        Offset(cx + 24 * s, cy - 74 * s),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2.6 * s,
      );
      final platePaint = Paint()..color = const Color(0xFF1E293B);
      for (final px in [-21.0, -17.0, 17.0, 21.0]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx + px * s, cy - 74 * s),
              width: 3.2 * s,
              height: 12 * s,
            ),
            Radius.circular(1.5 * s),
          ),
          platePaint,
        );
      }
    }
  }

  /// 5. EVENING READING: Lavender twilight + cartoon person reading a book by a glowing lamp
  void _paintEveningReadingScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Twinkling stars
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    for (final pt in [
      Offset(w * 0.54, h * 0.18),
      Offset(w * 0.68, h * 0.14),
      Offset(w * 0.86, h * 0.20),
      Offset(w * 0.62, h * 0.32),
    ]) {
      canvas.drawCircle(pt, 1.8, starPaint);
    }

    final backHill = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.38, h * 0.60, w * 0.76, h * 0.68)
      ..quadraticBezierTo(w * 0.90, h * 0.72, w, h * 0.65)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = const Color(0xFF6366F1));

    final frontHill = Path()
      ..moveTo(0, h * 0.84)
      ..quadraticBezierTo(w * 0.50, h * 0.74, w, h * 0.82)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF4338CA));

    if (showCartoonCharacter) {
      final s = h * 0.0052;
      final cx = w * 0.76;
      final cy = h * 0.82;

      // Standing Floor Lamp on the right casting a warm golden light cone
      final lampX = cx + 22 * s;
      final lightCone = Path()
        ..moveTo(lampX - 4 * s, cy - 68 * s)
        ..lineTo(lampX + 4 * s, cy - 68 * s)
        ..lineTo(cx + 30 * s, cy)
        ..lineTo(cx - 24 * s, cy)
        ..close();
      canvas.drawPath(
        lightCone,
        Paint()..color = const Color(0xFFFEF08A).withValues(alpha: 0.22),
      );

      // Lamp post & shade
      canvas.drawLine(
        Offset(lampX, cy),
        Offset(lampX, cy - 68 * s),
        Paint()
          ..color = const Color(0xFFE0E7FF)
          ..strokeWidth = 2.2 * s,
      );
      final shadePath = Path()
        ..moveTo(lampX - 8 * s, cy - 64 * s)
        ..lineTo(lampX - 4 * s, cy - 74 * s)
        ..lineTo(lampX + 4 * s, cy - 74 * s)
        ..lineTo(lampX + 8 * s, cy - 64 * s)
        ..close();
      canvas.drawPath(shadePath, Paint()..color = const Color(0xFFFDE047));

      // Cartoon person sitting & reading an open book
      final headCenter = Offset(cx - 6 * s, cy - 48 * s);
      canvas.drawCircle(
        headCenter,
        8.5 * s,
        Paint()..color = const Color(0xFFE0E7FF),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx - 6 * s, cy - 24 * s),
            width: 20 * s,
            height: 28 * s,
          ),
          Radius.circular(8 * s),
        ),
        Paint()..color = const Color(0xFF312E81),
      );

      // Open white book held in front
      final bookPath = Path()
        ..moveTo(cx + 2 * s, cy - 34 * s)
        ..lineTo(cx + 14 * s, cy - 38 * s)
        ..lineTo(cx + 14 * s, cy - 22 * s)
        ..lineTo(cx + 2 * s, cy - 18 * s)
        ..close();
      canvas.drawPath(bookPath, Paint()..color = Colors.white);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx + 6 * s, cy - 28 * s),
            width: 12 * s,
            height: 14 * s,
          ),
          Radius.circular(2 * s),
        ),
        Paint()..color = const Color(0xFFFEF08A),
      );
    }
  }

  /// 6. NIGHT RUN: Slate-indigo night sky + glowing streetlamp + cartoon runner at night
  void _paintNightRunScene(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Crescent Moon & Stars
    final moonCenter = Offset(w * 0.60, h * 0.22);
    canvas.drawCircle(
      moonCenter,
      w * 0.045,
      Paint()..color = const Color(0xFFFEF08A),
    );
    canvas.drawCircle(
      Offset(moonCenter.dx + w * 0.018, moonCenter.dy - w * 0.01),
      w * 0.04,
      Paint()..color = skyGradient.first,
    );

    // Distant night hills
    final mountains = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.28, h * 0.52, w * 0.58, h * 0.64)
      ..quadraticBezierTo(w * 0.82, h * 0.54, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF1E293B));

    // Foreground night running path
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.74, w, h * 0.26),
      Paint()..color = const Color(0xFF0F172A),
    );

    if (showCartoonCharacter) {
      final s = h * 0.0048;
      final lampX = w * 0.86;
      final groundY = h * 0.82;

      // Warm golden streetlamp light cone illuminating the night runner
      final conePath = Path()
        ..moveTo(lampX - 10 * s, groundY - 82 * s)
        ..lineTo(lampX - 2 * s, groundY - 82 * s)
        ..lineTo(w * 0.96, groundY + 6 * s)
        ..lineTo(w * 0.60, groundY + 6 * s)
        ..close();
      canvas.drawPath(
        conePath,
        Paint()..color = const Color(0xFFFDE047).withValues(alpha: 0.18),
      );

      // Streetlamp pole & glowing lantern head
      final polePaint = Paint()
        ..color = const Color(0xFF94A3B8)
        ..strokeWidth = 2.4 * s
        ..style = PaintingStyle.stroke;
      final polePath = Path()
        ..moveTo(lampX, groundY)
        ..lineTo(lampX, groundY - 76 * s)
        ..quadraticBezierTo(
          lampX,
          groundY - 84 * s,
          lampX - 8 * s,
          groundY - 84 * s,
        );
      canvas.drawPath(polePath, polePaint);
      canvas.drawCircle(
        Offset(lampX - 8 * s, groundY - 82 * s),
        4.5 * s,
        Paint()..color = const Color(0xFFFEF08A),
      );

      // Cartoon night runner under the streetlamp glow
      _drawCartoonRunner(
        canvas,
        anchor: Offset(w * 0.74, groundY),
        scale: s,
        shirtColor: const Color(0xFF38BDF8),
        shortsColor: const Color(0xFF0284C7),
        skinColor: const Color(0xFFFEF08A),
        accentColor: Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenicIllustrationPainter oldDelegate) {
    return oldDelegate.scene != scene ||
        oldDelegate.showCartoonCharacter != showCartoonCharacter;
  }
}

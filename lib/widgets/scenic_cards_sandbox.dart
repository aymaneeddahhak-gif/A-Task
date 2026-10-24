import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ScenicSceneType {
  sunnyDesert, // Morning Run / Coffee Time / Morning Ignition
  cloudyMountain, // Deep Study / Coding / Morning Focus
  windyWindmill, // Team Sync / Lecture / Afternoon Sprint
  fogLighthouse, // Research / Architecture / Outdoor Walk
  snowCabin, // Cozy Reading / Evening Study / Monthly Review
  rainyBoat, // Night Run / Evening Reflection / Wind-Down
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
  final String status; // 'Locked In', 'In Progress', 'Scheduled', 'Done'
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

  /// Automatically resolves the weather temperature, condition, and scenic illustration
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
        lower.contains('sleep') ||
        lower.contains('reflect') ||
        lower.contains('journal') ||
        (isPM && (lower.contains('run') || lower.contains('night')))) {
      scene = ScenicSceneType.rainyBoat;
    } else if (lower.contains('read') ||
        lower.contains('book') ||
        lower.contains('cabin') ||
        lower.contains('month') ||
        lower.contains('budget')) {
      scene = ScenicSceneType.snowCabin;
    } else if (lower.contains('morning run') ||
        lower.contains('coffee') ||
        lower.contains('breakfast') ||
        lower.contains('sun')) {
      scene = ScenicSceneType.sunnyDesert;
    } else if (lower.contains('study') ||
        lower.contains('code') ||
        lower.contains('coding') ||
        lower.contains('deep')) {
      scene = ScenicSceneType.cloudyMountain;
    } else if (lower.contains('sync') ||
        lower.contains('meet') ||
        lower.contains('class') ||
        lower.contains('lecture') ||
        lower.contains('sprint')) {
      scene = ScenicSceneType.windyWindmill;
    } else {
      scene = ScenicSceneType.fogLighthouse;
    }

    switch (scene) {
      case ScenicSceneType.sunnyDesert:
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
          autoCondition: 'Sunny',
          autoSkyGradient: const [
            Color(0xFFFBC02D),
            Color(0xFFFDE047),
            Color(0xFFF59E0B),
          ],
        );
      case ScenicSceneType.cloudyMountain:
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
          autoCondition: 'Cloudy',
          autoSkyGradient: const [
            Color(0xFF7DD3FC),
            Color(0xFFBAE6FD),
            Color(0xFF93C5FD),
          ],
        );
      case ScenicSceneType.windyWindmill:
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
          autoDegree: '14°',
          autoCondition: 'Windy',
          autoSkyGradient: const [
            Color(0xFFA8CA7A),
            Color(0xFFCDE4A4),
            Color(0xFFB5D686),
          ],
        );
      case ScenicSceneType.fogLighthouse:
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
          autoDegree: '20°',
          autoCondition: 'Fog',
          autoSkyGradient: const [
            Color(0xFF94A8BE),
            Color(0xFFCBD9E6),
            Color(0xFFDCE6F0),
          ],
        );
      case ScenicSceneType.snowCabin:
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
          autoDegree: '-3°',
          autoCondition: 'Snow',
          autoSkyGradient: const [
            Color(0xFF818CF8),
            Color(0xFFA5B4FC),
            Color(0xFFC7D2FE),
          ],
        );
      case ScenicSceneType.rainyBoat:
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
          autoCondition: 'Rainy',
          autoSkyGradient: const [
            Color(0xFF475569),
            Color(0xFF64748B),
            Color(0xFF4E5E76),
          ],
        );
    }
  }
}

/// Default Student & Worker Routine Tasks across Day, Week, and Month
/// (All 6 scenic cards + extra real-life presets, with auto-assigned weather & scenes)
final List<ScenicTaskCardModel> kInitialScenicTaskCards = [
  // 1. Morning Run / Coffee Ignition (Sunny Desert / Sunrise Camp)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_1',
    title: 'Morning Run & Coffee Time',
    description: '5km outdoor park run followed by espresso & top 3 daily goals',
    startTime: '07:30 AM',
    endTime: '08:30 AM',
    duration: '1h',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Morning Run • Coffee',
    status: 'Completed',
    progress: 1.0,
    isCompleted: true,
    isStarred: true,
    overrideScene: ScenicSceneType.sunnyDesert,
  ),
  // 2. Deep Study / Coding Sprint (Cloudy Mountain Birches)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_2',
    title: 'Deep Study & Coding Sprint',
    description: 'Core architecture module, algorithms practice & zero distractions',
    startTime: '09:30 AM',
    endTime: '11:30 AM',
    duration: '2h',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Deep Focus',
    status: 'In Progress',
    progress: 0.65,
    isStarred: true,
    overrideScene: ScenicSceneType.cloudyMountain,
  ),
  // 3. Afternoon Lecture / Team Sync (Windy Meadow Windmill)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_3',
    title: 'Weekly Sprint Sync & Class',
    description: 'Review weekly deliverables, campus lab notes & team roadmap',
    startTime: '02:10 PM',
    endTime: '03:10 PM',
    duration: '1h',
    routineHorizon: 'Week',
    dateOrRecurrence: 'Weekly • Every Mon',
    categoryTag: 'Weekly Sync',
    status: 'Locked In',
    progress: 0.40,
    overrideScene: ScenicSceneType.windyWindmill,
  ),
  // 4. Late Afternoon Architecture / Walk (Foggy Coastal Lighthouse)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_4',
    title: 'Afternoon Walk & Research',
    description: '30m coastal fresh-air walk & system design documentation review',
    startTime: '04:15 PM',
    endTime: '05:00 PM',
    duration: '45m',
    routineHorizon: 'Week',
    dateOrRecurrence: 'Weekly • Wed & Fri',
    categoryTag: 'Recharge',
    status: 'Scheduled',
    progress: 0.25,
    overrideScene: ScenicSceneType.fogLighthouse,
  ),
  // 5. Evening Reading / Monthly Budget Review (Snowy Cozy Lit Cabin)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_5',
    title: 'Monthly Budget & Reading',
    description: 'Track monthly savings, bills checklist & read 20 pages before bed',
    startTime: '08:30 PM',
    endTime: '09:30 PM',
    duration: '1h',
    routineHorizon: 'Month',
    dateOrRecurrence: 'Monthly • Every 1st',
    categoryTag: 'Monthly Growth',
    status: 'Locked In',
    progress: 0.50,
    isStarred: true,
    overrideScene: ScenicSceneType.snowCabin,
  ),
  // 6. Night Running & Reflection Log (Rainy Indigo Lake & Glowing Lanterns)
  ScenicTaskCardModel.createAuto(
    id: 'scenic_6',
    title: 'Night Run & Evening Journal',
    description: '3km evening jog under city lights, stretching & gratitude log',
    startTime: '09:40 PM',
    endTime: '10:25 PM',
    duration: '45m',
    routineHorizon: 'Day',
    dateOrRecurrence: 'Daily • Mon.Mar 26',
    categoryTag: 'Night Run',
    status: 'Scheduled',
    progress: 0.20,
    overrideScene: ScenicSceneType.rainyBoat,
  ),
];

/// Quick-pick presets so the user can test how picking ONLY a task + routine horizon
/// automatically assigns the temperature, weather condition, and scenic illustration.
const List<Map<String, String>> kQuickTaskPresets = [
  {
    'title': 'Morning 5km Run',
    'desc': 'Outdoor cardio pace + hydration before work/class',
    'time': '07:00 AM - 07:45 AM',
    'duration': '45m',
    'tag': 'Morning Run',
    'horizon': 'Day',
  },
  {
    'title': 'Coffee Time & Plan',
    'desc': 'Fresh brew + review top 3 priorities for today',
    'time': '08:30 AM - 08:50 AM',
    'duration': '20m',
    'tag': 'Coffee Time',
    'horizon': 'Day',
  },
  {
    'title': 'Night Run & Stretch',
    'desc': 'Evening 3km run to decompress after study/work',
    'time': '08:15 PM - 09:00 PM',
    'duration': '45m',
    'tag': 'Night Run',
    'horizon': 'Day',
  },
  {
    'title': 'Weekly Study & Sprint',
    'desc': 'Organize Monday–Friday lectures, exams & project tasks',
    'time': '10:00 AM - 11:30 AM',
    'duration': '1h 30m',
    'tag': 'Weekly Plan',
    'horizon': 'Week',
  },
  {
    'title': 'Monthly Budget & Goals',
    'desc': 'Review monthly expenses, savings & portfolio milestones',
    'time': '07:00 PM - 08:00 PM',
    'duration': '1h',
    'tag': 'Monthly Review',
    'horizon': 'Month',
  },
];

/// Interactive Sandbox showcase combining `designcard.png` + real A-Task `TaskCard`
/// with 100% automatic weather/scene matching and Day / Week / Month routine filters.
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
  bool _twoColumnGrid = false; // Default to full detailed task cards so all real task details shine
  String _selectedHorizon = 'All'; // 'All', 'Day', 'Week', 'Month'
  bool _showAutoCreator = false;
  final TextEditingController _taskTitleController = TextEditingController();
  String _newTaskHorizon = 'Day';
  String _newTaskTimeSlot = '07:30 AM - 08:15 AM';

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
      description: 'Auto-matched scene & weather • $_newTaskHorizon Routine',
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
              // Top Row: Badge + Layout Toggle + Auto-Create Task Button
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
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
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 12,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AUTO WEATHER & SCENE',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF047857),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
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

              // Expandable Auto-Scene Task Tester (User ONLY picks task & horizon; Weather & Scene are 100% automatic)
              if (_showAutoCreator) ...[
                const Divider(height: 18, color: Color(0xFFE2E8F0)),
                Text(
                  'Pick a quick task or type your own (Weather & Scene are auto-assigned!):',
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

/// Combined Scenic Curled Task Card (`designcard.png` + Real App `TaskCard` details)
/// featuring:
/// - 3D Top-Left Corner Paper Curl
/// - Auto-assigned Weather Degree & Condition (`23° Sunny`, etc.)
/// - Real Task Title, Description, Routine Horizon Badge (`DAY`/`WEEK`/`MONTH`), Duration & Status
/// - Sleek Progress Bar along the horizon seam
/// - Crisp White Footer with interactive Check Circle, Start–End Time, and Date/Recurrence
class ScenicCurledTaskCard extends StatelessWidget {
  final ScenicTaskCardModel card;
  final double curlSize;
  final bool compact;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onToggleStar;

  const ScenicCurledTaskCard({
    super.key,
    required this.card,
    this.curlSize = 36.0,
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
                      // Custom Scenic Vector Artwork
                      CustomPaint(
                        painter: _ScenicIllustrationPainter(
                          scene: card.autoScene,
                          skyGradient: card.autoSkyGradient,
                        ),
                      ),

                      // Subtle dark readability scrim on the left side for task text
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.18),
                                Colors.black.withValues(alpha: 0.04),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.58, 1.0],
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
                            // Routine Horizon Pill (DAY / WEEK / MONTH)
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
                        right: compact ? 10 : 95,
                        bottom: compact ? 8 : 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Weather + Task Title Block
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Auto Weather Row (`23° Sunny`)
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
                                          fontSize: compact ? 10.5 : 13,
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
                                // REAL TASK TITLE
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

                            // Frosted Glass Pills: Duration (`⏱ 1h`) + Category (`Morning Run`)
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
                        // Left: Interactive Check Circle + Start–End Time
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
                        // Right: Recurrence / Date (`Daily • Mon.Mar 26`)
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

    // 1. Cast shadow projected onto the card below the curled triangle
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

    // 2. The 3D curled paper flap itself
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

    // 3. Bright specular highlight along the curved paper fold spine
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

    // 4. Crisp subtle edge border on the curled flap underside
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

/// Custom vector painter that renders the 6 scenic illustrations from `designcard.png`.
class _ScenicIllustrationPainter extends CustomPainter {
  final ScenicSceneType scene;
  final List<Color> skyGradient;

  _ScenicIllustrationPainter({
    required this.scene,
    required this.skyGradient,
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
      case ScenicSceneType.sunnyDesert:
        _paintSunnyDesert(canvas, size);
        break;
      case ScenicSceneType.cloudyMountain:
        _paintCloudyMountain(canvas, size);
        break;
      case ScenicSceneType.windyWindmill:
        _paintWindyWindmill(canvas, size);
        break;
      case ScenicSceneType.fogLighthouse:
        _paintFogLighthouse(canvas, size);
        break;
      case ScenicSceneType.snowCabin:
        _paintSnowCabin(canvas, size);
        break;
      case ScenicSceneType.rainyBoat:
        _paintRainyBoat(canvas, size);
        break;
    }
  }

  void _paintSunnyDesert(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sunCenter = Offset(w * 0.82, h * 0.25);
    canvas.drawCircle(
      sunCenter,
      w * 0.18,
      Paint()..color = Colors.white.withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      sunCenter,
      w * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.30),
    );
    canvas.drawCircle(
      sunCenter,
      w * 0.065,
      Paint()..color = const Color(0xFFFFFBEB),
    );

    final backDune = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.28, h * 0.56, w * 0.62, h * 0.66)
      ..quadraticBezierTo(w * 0.84, h * 0.72, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backDune, Paint()..color = const Color(0xFFF59E0B));

    final midDune = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.36, h * 0.68, w * 0.72, h * 0.74)
      ..quadraticBezierTo(w * 0.90, h * 0.77, w, h * 0.71)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midDune, Paint()..color = const Color(0xFFD97706));

    final frontDune = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.45, h * 0.77, w, h * 0.84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontDune, Paint()..color = const Color(0xFFB45309));

    final tentBaseY = h * 0.75;
    final tentCenterX = w * 0.68;
    final tentW = w * 0.20;
    final tentH = h * 0.17;

    final tentBody = Path()
      ..moveTo(tentCenterX - tentW * 0.5, tentBaseY)
      ..lineTo(tentCenterX - tentW * 0.08, tentBaseY - tentH)
      ..lineTo(tentCenterX + tentW * 0.52, tentBaseY - tentH * 0.06)
      ..close();
    canvas.drawPath(tentBody, Paint()..color = const Color(0xFFFBBF24));

    final tentFront = Path()
      ..moveTo(tentCenterX - tentW * 0.5, tentBaseY)
      ..lineTo(tentCenterX - tentW * 0.08, tentBaseY - tentH)
      ..lineTo(tentCenterX + tentW * 0.06, tentBaseY)
      ..close();
    canvas.drawPath(tentFront, Paint()..color = const Color(0xFF92400E));

    final tentDoor = Path()
      ..moveTo(tentCenterX - tentW * 0.28, tentBaseY)
      ..lineTo(tentCenterX - tentW * 0.08, tentBaseY - tentH * 0.75)
      ..lineTo(tentCenterX - tentW * 0.02, tentBaseY)
      ..close();
    canvas.drawPath(tentDoor, Paint()..color = const Color(0xFF451A03));
  }

  void _paintCloudyMountain(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sunCenter = Offset(w * 0.65, h * 0.25);
    canvas.drawCircle(
      sunCenter,
      w * 0.055,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );

    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.72, h * 0.28),
          width: w * 0.18,
          height: h * 0.032,
        ),
        const Radius.circular(20),
      ),
      cloudPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.56, h * 0.36),
          width: w * 0.15,
          height: h * 0.026,
        ),
        const Radius.circular(20),
      ),
      cloudPaint,
    );

    final farMountain = Path()
      ..moveTo(0, h * 0.75)
      ..lineTo(w * 0.24, h * 0.52)
      ..lineTo(w * 0.52, h * 0.70)
      ..lineTo(w * 0.78, h * 0.48)
      ..lineTo(w, h * 0.64)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farMountain, Paint()..color = const Color(0xFF7DD3FC));

    final midMountain = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.32, h * 0.62, w * 0.68, h * 0.74)
      ..quadraticBezierTo(w * 0.86, h * 0.80, w, h * 0.72)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midMountain, Paint()..color = const Color(0xFF60A5FA));

    final frontHill = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.45, h * 0.76, w, h * 0.85)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF3B82F6));

    _drawBirchTrunk(canvas, w * 0.79, h, w * 0.024);
    _drawBirchTrunk(canvas, w * 0.89, h, w * 0.018);
  }

  void _drawBirchTrunk(Canvas canvas, double x, double h, double trunkW) {
    final trunkPaint = Paint()..color = const Color(0xFFE0F2FE);
    canvas.drawRect(Rect.fromLTWH(x, 0, trunkW, h), trunkPaint);

    final branchPaint = Paint()
      ..color = const Color(0xFFE0F2FE)
      ..strokeWidth = trunkW * 0.45
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(x, h * 0.32),
      Offset(x - trunkW * 2.2, h * 0.24),
      branchPaint,
    );
    canvas.drawLine(
      Offset(x + trunkW, h * 0.48),
      Offset(x + trunkW * 2.8, h * 0.40),
      branchPaint,
    );

    final barkPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.55)
      ..strokeWidth = 1.4;
    for (final ratio in [0.22, 0.38, 0.55, 0.70, 0.82]) {
      canvas.drawLine(
        Offset(x + 1, h * ratio),
        Offset(x + trunkW * 0.65, h * ratio),
        barkPaint,
      );
    }
  }

  void _paintWindyWindmill(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final backHill = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.35, h * 0.54, w * 0.75, h * 0.66)
      ..quadraticBezierTo(w * 0.90, h * 0.70, w, h * 0.63)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = const Color(0xFF9BC56D));

    final midHill = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.42, h * 0.66, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midHill, Paint()..color = const Color(0xFF82B352));

    final frontHill = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.48, h * 0.77, w, h * 0.86)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF689B3B));

    _drawPineTree(
      canvas,
      Offset(w * 0.56, h * 0.74),
      w * 0.036,
      h * 0.08,
      const Color(0xFF4D7C2B),
    );

    final millX = w * 0.80;
    final millBaseY = h * 0.78;
    final millW = w * 0.12;
    final millH = h * 0.34;

    final towerPath = Path()
      ..moveTo(millX - millW * 0.48, millBaseY)
      ..lineTo(millX - millW * 0.28, millBaseY - millH)
      ..lineTo(millX + millW * 0.28, millBaseY - millH)
      ..lineTo(millX + millW * 0.48, millBaseY)
      ..close();
    canvas.drawPath(towerPath, Paint()..color = const Color(0xFF558B2F));

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(millX, millBaseY - millH),
        width: millW * 0.62,
        height: millH * 0.32,
      ),
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xFF33691E),
    );

    final hub = Offset(millX, millBaseY - millH * 0.92);
    final bladeLen = w * 0.18;
    final bladePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final angle = (math.pi / 4) + i * (math.pi / 2);
      final tip = Offset(
        hub.dx + math.cos(angle) * bladeLen,
        hub.dy + math.sin(angle) * bladeLen,
      );
      canvas.drawLine(hub, tip, bladePaint);

      final perp = angle + math.pi / 2;
      final sailW = w * 0.028;
      final p1 = Offset(
        hub.dx + math.cos(angle) * (bladeLen * 0.22),
        hub.dy + math.sin(angle) * (bladeLen * 0.22),
      );
      final p2 = tip;
      final p3 = Offset(
        tip.dx + math.cos(perp) * sailW,
        tip.dy + math.sin(perp) * sailW,
      );
      final p4 = Offset(
        p1.dx + math.cos(perp) * sailW,
        p1.dy + math.sin(perp) * sailW,
      );
      final sailPath = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy)
        ..lineTo(p4.dx, p4.dy)
        ..close();
      canvas.drawPath(
        sailPath,
        Paint()..color = Colors.white.withValues(alpha: 0.72),
      );
      canvas.drawPath(sailPath, bladePaint..strokeWidth = 1.0);
    }
    canvas.drawCircle(hub, 2.5, Paint()..color = const Color(0xFF33691E));
  }

  void _drawPineTree(
    Canvas canvas,
    Offset baseCenter,
    double width,
    double height,
    Color color,
  ) {
    final path = Path()
      ..moveTo(baseCenter.dx, baseCenter.dy - height)
      ..lineTo(baseCenter.dx - width / 2, baseCenter.dy)
      ..lineTo(baseCenter.dx + width / 2, baseCenter.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _paintFogLighthouse(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(
      Offset(w * 0.64, h * 0.30),
      w * 0.045,
      Paint()..color = Colors.white.withValues(alpha: 0.90),
    );

    _drawBird(canvas, Offset(w * 0.54, h * 0.40), w * 0.028);
    _drawBird(canvas, Offset(w * 0.61, h * 0.46), w * 0.022);

    final farMist = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.35, h * 0.60, w * 0.72, h * 0.68)
      ..quadraticBezierTo(w * 0.88, h * 0.72, w, h * 0.66)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farMist, Paint()..color = const Color(0xFFB0C1D4));

    final midMist = Path()
      ..moveTo(0, h * 0.82)
      ..quadraticBezierTo(w * 0.45, h * 0.70, w, h * 0.77)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midMist, Paint()..color = const Color(0xFF8FA6BE));

    final frontCliff = Path()
      ..moveTo(0, h * 0.90)
      ..quadraticBezierTo(w * 0.52, h * 0.78, w, h * 0.84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontCliff, Paint()..color = const Color(0xFF728CA8));

    final lhX = w * 0.82;
    final lhBaseY = h * 0.82;
    final lhW = w * 0.10;
    final lhH = h * 0.42;

    final towerPath = Path()
      ..moveTo(lhX - lhW * 0.48, lhBaseY)
      ..lineTo(lhX - lhW * 0.30, lhBaseY - lhH)
      ..lineTo(lhX + lhW * 0.30, lhBaseY - lhH)
      ..lineTo(lhX + lhW * 0.48, lhBaseY)
      ..close();

    canvas.save();
    canvas.clipPath(towerPath);
    canvas.drawPath(towerPath, Paint()..color = Colors.white);
    final stripePaint = Paint()..color = const Color(0xFF526D88);
    canvas.drawRect(
      Rect.fromLTWH(lhX - lhW, lhBaseY - lhH * 0.82, lhW * 2, lhH * 0.22),
      stripePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(lhX - lhW, lhBaseY - lhH * 0.38, lhW * 2, lhH * 0.22),
      stripePaint,
    );
    canvas.restore();

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(lhX, lhBaseY - lhH - lhH * 0.08),
        width: lhW * 0.48,
        height: lhH * 0.14,
      ),
      Paint()..color = const Color(0xFFFEF08A),
    );

    final roofPath = Path()
      ..moveTo(lhX - lhW * 0.36, lhBaseY - lhH - lhH * 0.15)
      ..lineTo(lhX, lhBaseY - lhH - lhH * 0.28)
      ..lineTo(lhX + lhW * 0.36, lhBaseY - lhH - lhH * 0.15)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = const Color(0xFF3E566E));
  }

  void _drawBird(Canvas canvas, Offset center, double span) {
    final path = Path()
      ..moveTo(center.dx - span, center.dy)
      ..quadraticBezierTo(
        center.dx - span * 0.4,
        center.dy - span * 0.5,
        center.dx,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx + span * 0.4,
        center.dy - span * 0.5,
        center.dx + span,
        center.dy,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintSnowCabin(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    final flakes = [
      Offset(w * 0.52, h * 0.18),
      Offset(w * 0.66, h * 0.14),
      Offset(w * 0.82, h * 0.22),
      Offset(w * 0.58, h * 0.34),
      Offset(w * 0.74, h * 0.32),
      Offset(w * 0.88, h * 0.40),
    ];
    for (int i = 0; i < flakes.length; i++) {
      canvas.drawCircle(flakes[i], i.isEven ? 2.2 : 1.5, snowPaint);
    }

    final backSnow = Path()
      ..moveTo(0, h * 0.70)
      ..quadraticBezierTo(w * 0.38, h * 0.58, w * 0.76, h * 0.68)
      ..quadraticBezierTo(w * 0.90, h * 0.72, w, h * 0.65)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backSnow, Paint()..color = const Color(0xFFC7D2FE));

    final midSnow = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.45, h * 0.68, w, h * 0.76)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midSnow, Paint()..color = const Color(0xFFDDE4FF));

    final frontSnow = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.50, h * 0.78, w, h * 0.86)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontSnow, Paint()..color = const Color(0xFFEEF2FF));

    final cabX = w * 0.77;
    final cabBaseY = h * 0.80;
    final cabW = w * 0.22;
    final cabH = h * 0.16;

    canvas.drawRect(
      Rect.fromLTWH(cabX - cabW / 2, cabBaseY - cabH, cabW, cabH),
      Paint()..color = const Color(0xFF6366F1),
    );

    final gablePath = Path()
      ..moveTo(cabX - cabW / 2, cabBaseY - cabH)
      ..lineTo(cabX, cabBaseY - cabH * 1.65)
      ..lineTo(cabX + cabW / 2, cabBaseY - cabH)
      ..close();
    canvas.drawPath(gablePath, Paint()..color = const Color(0xFF4F46E5));

    final snowRoof = Path()
      ..moveTo(cabX - cabW * 0.58, cabBaseY - cabH * 0.94)
      ..lineTo(cabX, cabBaseY - cabH * 1.72)
      ..lineTo(cabX + cabW * 0.58, cabBaseY - cabH * 0.94);
    canvas.drawPath(
      snowRoof,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final winPaint = Paint()..color = const Color(0xFFFDE047);
    final winW = cabW * 0.20;
    final winH = cabH * 0.42;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cabX - cabW * 0.18, cabBaseY - cabH * 0.48),
          width: winW,
          height: winH,
        ),
        const Radius.circular(2),
      ),
      winPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cabX + cabW * 0.18, cabBaseY - cabH * 0.48),
          width: winW,
          height: winH,
        ),
        const Radius.circular(2),
      ),
      winPaint,
    );
  }

  void _paintRainyBoat(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final mountains = Path()
      ..moveTo(0, h * 0.65)
      ..quadraticBezierTo(w * 0.25, h * 0.48, w * 0.55, h * 0.60)
      ..quadraticBezierTo(w * 0.80, h * 0.50, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF334155));

    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.62, w, h * 0.38),
      Paint()..color = const Color(0xFF3B495E),
    );

    final rainPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    final rainSeeds = [
      Offset(w * 0.52, h * 0.16),
      Offset(w * 0.62, h * 0.24),
      Offset(w * 0.74, h * 0.14),
      Offset(w * 0.84, h * 0.26),
      Offset(w * 0.68, h * 0.42),
    ];
    for (final pt in rainSeeds) {
      canvas.drawLine(pt, Offset(pt.dx - 5, pt.dy + 12), rainPaint);
    }

    _drawFloatingLantern(canvas, Offset(w * 0.48, h * 0.78), w * 0.022);
    _drawFloatingLantern(canvas, Offset(w * 0.60, h * 0.86), w * 0.028);

    final boatX = w * 0.82;
    final boatY = h * 0.77;
    final boatW = w * 0.26;
    final boatH = h * 0.09;

    final hullPath = Path()
      ..moveTo(boatX - boatW * 0.52, boatY - boatH * 0.4)
      ..lineTo(boatX + boatW * 0.52, boatY - boatH * 0.4)
      ..quadraticBezierTo(
        boatX + boatW * 0.38,
        boatY + boatH * 0.6,
        boatX,
        boatY + boatH * 0.6,
      )
      ..quadraticBezierTo(
        boatX - boatW * 0.38,
        boatY + boatH * 0.6,
        boatX - boatW * 0.52,
        boatY - boatH * 0.4,
      )
      ..close();
    canvas.drawPath(hullPath, Paint()..color = const Color(0xFF1E293B));

    _drawFloatingLantern(
      canvas,
      Offset(boatX - boatW * 0.12, boatY - boatH * 0.55),
      w * 0.026,
    );
  }

  void _drawFloatingLantern(Canvas canvas, Offset pos, double size) {
    canvas.drawCircle(
      pos,
      size * 2.2,
      Paint()
        ..color = const Color(0xFFFACC15).withValues(alpha: 0.24)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(pos.dx, pos.dy + size * 0.9),
        width: size * 1.6,
        height: size * 0.35,
      ),
      Paint()..color = const Color(0xFFFDE047).withValues(alpha: 0.45),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: size, height: size * 1.15),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFEF08A),
    );
  }

  @override
  bool shouldRepaint(covariant _ScenicIllustrationPainter oldDelegate) {
    return oldDelegate.scene != scene;
  }
}

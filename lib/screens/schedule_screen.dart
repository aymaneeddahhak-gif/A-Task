import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../state/task_provider.dart';
import '../widgets/task_card.dart';

class ScheduleScreen extends StatefulWidget {
  final TaskProvider provider;

  const ScheduleScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static final DateFormat _shortDayFmt = DateFormat('EEE');
  static final DateFormat _dayNumFmt = DateFormat('d');
  static final DateFormat _fullDayFmt = DateFormat('EEE, MMM d');
  static final DateFormat _monthNameFmt = DateFormat('MMMM d');

  int _selectedDayIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = const ['All', 'Work', 'Personal', 'Fitness'];

  /// Generates the real-time current week (Monday..Sunday) anchored to live DateTime.now().
  List<Map<String, String>> _buildLiveDaysList(DateTime now) {
    final todayMidnight = DateTime(now.year, now.month, now.day);
    // weekday: 1 = Monday .. 7 = Sunday
    final monday = todayMidnight.subtract(Duration(days: todayMidnight.weekday - 1));

    final List<Map<String, String>> days = [
      {
        'day': 'All',
        'num': '0',
        'full': 'All Scheduled Plans (${_fullDayFmt.format(todayMidnight)})',
        'monthDay': '',
        'isToday': 'false',
      },
    ];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final isToday = date.year == todayMidnight.year &&
          date.month == todayMidnight.month &&
          date.day == todayMidnight.day;
      days.add({
        'day': _shortDayFmt.format(date),
        'num': _dayNumFmt.format(date),
        'full': isToday
            ? 'Today • ${_fullDayFmt.format(date)}'
            : _fullDayFmt.format(date),
        'monthDay': _monthNameFmt.format(date).toLowerCase(),
        'shortFull': _fullDayFmt.format(date).toLowerCase(),
        'isToday': isToday ? 'true' : 'false',
      });
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final now = widget.provider.now;
    final daysList = _buildLiveDaysList(now);
    final allTasks = widget.provider.allTasks;

    // Filter by selected day (Index 0 = 'All', Index 1..7 = specific day of current week)
    final selectedDay = daysList[_selectedDayIndex];
    final dayFiltered = _selectedDayIndex == 0
        ? allTasks
        : allTasks.where((t) {
            final dStr = t.dateString.toLowerCase();
            if (dStr.contains('daily') || dStr.contains('every day')) {
              return true;
            }
            final targetDay = selectedDay['day']!.toLowerCase();
            final targetNum = selectedDay['num']!;
            final targetShortFull = selectedDay['shortFull'] ?? '';
            final targetMonthDay = selectedDay['monthDay'] ?? '';
            final isTodayCol = selectedDay['isToday'] == 'true';

            if (isTodayCol && dStr.contains('today')) return true;
            if (dStr.contains(targetDay)) return true;
            if (targetShortFull.isNotEmpty && dStr.contains(targetShortFull)) {
              return true;
            }
            if (targetMonthDay.isNotEmpty && dStr.contains(targetMonthDay)) {
              return true;
            }
            if (RegExp('\\b$targetNum\\b').hasMatch(dStr)) return true;
            return false;
          }).toList();

    // Filter by category
    final categoryFiltered = dayFiltered.filterCategory(_selectedCategory);

    // Single-pass partition into Morning, Afternoon, Evening, and Other
    final List<TaskModel> morningTasks = [];
    final List<TaskModel> afternoonTasks = [];
    final List<TaskModel> eveningTasks = [];
    final List<TaskModel> remainingTasks = [];

    for (final t in categoryFiltered) {
      final sec = t.timeSection.toLowerCase();
      if (sec == 'morning') {
        morningTasks.add(t);
      } else if (sec == 'afternoon') {
        afternoonTasks.add(t);
      } else if (sec == 'evening') {
        eveningTasks.add(t);
      } else {
        remainingTasks.add(t);
      }
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // 1. Header Bar: Back Button, Live Date Pill, Add +, More ...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => widget.provider.setSelectedTab(0),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEFECE6)),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),

              // Active Real-Time Date Pill
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFEFECE6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          selectedDay['full']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Actions: Add + More
              Row(
                children: [
                  GestureDetector(
                    onTap: () => widget.provider.openAddTask(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFF191A20),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEFECE6)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.more_horiz,
                        size: 18,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // 2. Title Row: "Task Schedule" + Live Clock & Refresh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Schedule',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Live ${widget.provider.liveClockString} • ${widget.provider.liveTemperatureDisplay} ${widget.provider.liveWeatherCondition}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.sync_rounded,
                  color: Color(0xFF64748B),
                ),
                tooltip: 'Refresh Timeline',
                onPressed: () {
                  widget.provider.resetToThisWeekRoutine();
                  widget.provider.showToast('Timeline synchronized!');
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 3. Real-Time Days Strip (All, Mon..Sun of current week)
          SizedBox(
            height: 68,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: daysList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final d = daysList[index];
                final isSel = _selectedDayIndex == index;
                final isToday = d['isToday'] == 'true';
                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 52,
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF191A20) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSel
                            ? const Color(0xFF191A20)
                            : (isToday
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFFEFECE6)),
                        width: isToday && !isSel ? 1.5 : 1.0,
                      ),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          d['day']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSel
                                ? Colors.white70
                                : (isToday
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF8E8E93)),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          d['num'] == '0' ? '•' : d['num']!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isSel
                                ? Colors.white
                                : const Color(0xFF1B1B1F),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 4. Category Filter Chips (All, Work, Personal, Fitness)
          Row(
            children: _categories.map((cat) {
              final isSel = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF191A20) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSel
                          ? const Color(0xFF191A20)
                          : const Color(0xFFEFECE6),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSel ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // 5. Grouped Time Sections
          if (morningTasks.isNotEmpty) ...[
            _buildSectionHeader(
              'Morning Focus',
              Icons.wb_sunny_outlined,
              morningTasks.length,
              const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 10),
            ...morningTasks.map(
              (t) => RepaintBoundary(
                key: ValueKey('sched_m_${t.id}'),
                child: TaskCard(
                  task: t,
                  onTap: () => widget.provider.openTaskDetail(t),
                  onToggleComplete: () =>
                      widget.provider.toggleTaskComplete(t.id),
                  onToggleStarred: () =>
                      widget.provider.toggleTaskStarred(t.id),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (afternoonTasks.isNotEmpty) ...[
            _buildSectionHeader(
              'Afternoon Build',
              Icons.wb_sunny_rounded,
              afternoonTasks.length,
              const Color(0xFFEA580C),
            ),
            const SizedBox(height: 10),
            ...afternoonTasks.map(
              (t) => RepaintBoundary(
                key: ValueKey('sched_a_${t.id}'),
                child: TaskCard(
                  task: t,
                  onTap: () => widget.provider.openTaskDetail(t),
                  onToggleComplete: () =>
                      widget.provider.toggleTaskComplete(t.id),
                  onToggleStarred: () =>
                      widget.provider.toggleTaskStarred(t.id),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (eveningTasks.isNotEmpty) ...[
            _buildSectionHeader(
              'Evening Wrap-Up',
              Icons.nightlight_round,
              eveningTasks.length,
              const Color(0xFF7C3AED),
            ),
            const SizedBox(height: 10),
            ...eveningTasks.map(
              (t) => RepaintBoundary(
                key: ValueKey('sched_e_${t.id}'),
                child: TaskCard(
                  task: t,
                  onTap: () => widget.provider.openTaskDetail(t),
                  onToggleComplete: () =>
                      widget.provider.toggleTaskComplete(t.id),
                  onToggleStarred: () =>
                      widget.provider.toggleTaskStarred(t.id),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (remainingTasks.isNotEmpty) ...[
            _buildSectionHeader(
              'Other Scheduled Tasks',
              Icons.schedule,
              remainingTasks.length,
              const Color(0xFF0284C7),
            ),
            const SizedBox(height: 10),
            ...remainingTasks.map(
              (t) => RepaintBoundary(
                key: ValueKey('sched_o_${t.id}'),
                child: TaskCard(
                  task: t,
                  onTap: () => widget.provider.openTaskDetail(t),
                  onToggleComplete: () =>
                      widget.provider.toggleTaskComplete(t.id),
                  onToggleStarred: () =>
                      widget.provider.toggleTaskStarred(t.id),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (categoryFiltered.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_note_rounded,
                      size: 26,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No tasks scheduled for ${selectedDay['full']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'You have a clean schedule. Tap + to add a focus task for this date.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => widget.provider.openAddTask(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF191A20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Add Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    int count,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }
}

extension CategoryFilter on List<TaskModel> {
  List<TaskModel> filterCategory(String cat) {
    if (cat == 'All') return this;
    if (cat == 'Work') {
      return where(
        (t) =>
            t.tags.toLowerCase().contains('work') ||
            t.tags.toLowerCase().contains('code') ||
            t.project.toLowerCase().contains('engineering'),
      ).toList();
    }
    if (cat == 'Personal') {
      return where(
        (t) =>
            t.tags.toLowerCase().contains('personal') ||
            t.tags.toLowerCase().contains('routine') ||
            t.isFreeTime,
      ).toList();
    }
    if (cat == 'Fitness') {
      return where(
        (t) =>
            t.tags.toLowerCase().contains('wellness') ||
            t.tags.toLowerCase().contains('fitness'),
      ).toList();
    }
    return this;
  }
}

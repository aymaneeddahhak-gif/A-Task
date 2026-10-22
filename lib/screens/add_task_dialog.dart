import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../state/task_provider.dart';

class TaskImportanceOption {
  final String priorityKey;
  final String colorThemeKey;
  final String title;
  final String shortBadge;
  final String description;
  final Color dotColor;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color accentColor;
  final List<Color> gradientColors;
  final Color pillTextColor;
  final IconData icon;
  final Color badgeIconColor;
  final Color shadowColor;

  const TaskImportanceOption({
    required this.priorityKey,
    required this.colorThemeKey,
    required this.title,
    required this.shortBadge,
    required this.description,
    required this.dotColor,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.accentColor,
    required this.gradientColors,
    required this.pillTextColor,
    required this.icon,
    required this.badgeIconColor,
    required this.shadowColor,
  });
}

final List<TaskImportanceOption> taskImportanceOptions = [
  const TaskImportanceOption(
    priorityKey: 'Urgent',
    colorThemeKey: 'red',
    title: 'Urgent',
    shortBadge: 'Critical',
    description: 'Critical deadline • Immediate emergency action',
    dotColor: Color(0xFFEF4444),
    cardBg: Color(0xFFFEF2F2),
    borderColor: Color(0xFFFECACA),
    textColor: Color(0xFFDC2626),
    accentColor: Color(0xFFDC2626),
    gradientColors: [Color(0xFFFB7185), Color(0xFFE11D48)],
    pillTextColor: Colors.white,
    icon: Icons.flash_on,
    badgeIconColor: Color(0xFFE11D48),
    shadowColor: Color(0x60E11D48),
  ),
  const TaskImportanceOption(
    priorityKey: 'High',
    colorThemeKey: 'peach',
    title: 'Important',
    shortBadge: 'High Priority',
    description: 'High priority • Needs attention today',
    dotColor: Color(0xFFEA580C),
    cardBg: Color(0xFFFFF7ED),
    borderColor: Color(0xFFFED7AA),
    textColor: Color(0xFFC2410C),
    accentColor: Color(0xFFEA580C),
    gradientColors: [Color(0xFFFDBA74), Color(0xFFEA580C)],
    pillTextColor: Colors.white,
    icon: Icons.star,
    badgeIconColor: Color(0xFFEA580C),
    shadowColor: Color(0x55EA580C),
  ),
  const TaskImportanceOption(
    priorityKey: 'Medium',
    colorThemeKey: 'blue',
    title: 'Normal',
    shortBadge: 'Routine',
    description: 'Routine task • Standard daily timeline',
    dotColor: Color(0xFF0284C7),
    cardBg: Color(0xFFF0F9FF),
    borderColor: Color(0xFFBAE6FD),
    textColor: Color(0xFF0369A1),
    accentColor: Color(0xFF0284C7),
    gradientColors: [Color(0xFF93C5FD), Color(0xFF3B82F6)],
    pillTextColor: Colors.white,
    icon: Icons.check_circle_outline,
    badgeIconColor: Color(0xFF2563EB),
    shadowColor: Color(0x503B82F6),
  ),
  const TaskImportanceOption(
    priorityKey: 'Low',
    colorThemeKey: 'mint',
    title: 'Low Priority',
    shortBadge: 'When Free',
    description: 'Flexible timing • Do whenever you have free time',
    dotColor: Color(0xFF059669),
    cardBg: Color(0xFFECFDF5),
    borderColor: Color(0xFFA7F3D0),
    textColor: Color(0xFF047857),
    accentColor: Color(0xFF059669),
    gradientColors: [Color(0xFF5EEAD4), Color(0xFF0D9488)],
    pillTextColor: Colors.white,
    icon: Icons.arrow_downward,
    badgeIconColor: Color(0xFF0F766E),
    shadowColor: Color(0x500D9488),
  ),
  const TaskImportanceOption(
    priorityKey: 'Routine',
    colorThemeKey: 'lavender',
    title: 'Daily Routine',
    shortBadge: 'Habit',
    description: 'Daily habit & personal wellness routine',
    dotColor: Color(0xFF7C3AED),
    cardBg: Color(0xFFF5F3FF),
    borderColor: Color(0xFFDDD6FE),
    textColor: Color(0xFF6D28D9),
    accentColor: Color(0xFF7C3AED),
    gradientColors: [Color(0xFFDDD6FE), Color(0xFFA78BFA)],
    pillTextColor: Color(0xFF3B0764),
    icon: Icons.favorite,
    badgeIconColor: Color(0xFF7C3AED),
    shadowColor: Color(0x457C3AED),
  ),
];

class AddTaskDialog extends StatefulWidget {
  final TaskProvider provider;

  const AddTaskDialog({Key? key, required this.provider}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _configMode = 'Single Task'; // Single Task, Day, Week, Month
  String _selectedWeekday = 'Monday';
  String _selectedMonthDay = '1st';
  String _startDate = 'Today';
  String _endDate = 'Today';
  String _startTime = '10:00 AM';
  String _endTime = '11:30 AM';
  String _selectedPriority = 'Medium';
  String _selectedColorTheme = 'blue';
  String _selectedProject = 'Personal';
  bool _isImportanceOpen = false;
  bool _hasMeeting = false;

  final List<String> _tags = ['Personal', 'Daily'];
  final List<String> _suggestedTags = [
    'Urgent', 'Daily', 'Errands', 'Shopping', 'Bills', 'Health', 'Workout', 'Home', 'Family', 'Meeting', 'Quick'
  ];

  final List<String> _projectsList = [
    'Personal',
    'Work & Career',
    'Home & Chores',
    'Shopping & Groceries',
    'Health & Fitness',
    'Finance & Bills',
    'Study & Reading',
    'Family & Friends',
  ];

  void _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final formatted = DateFormat('MMM d, yyyy').format(picked);
      setState(() {
        if (isStart) {
          _startDate = formatted;
          if (_endDate == 'Today') _endDate = formatted;
        } else {
          _endDate = formatted;
        }
      });
    }
  }

  void _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formatted = DateFormat('hh:mm a').format(dt);
      setState(() {
        if (isStart) {
          _startTime = formatted;
        } else {
          _endTime = formatted;
        }
      });
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      widget.provider.showToast(
        'Please enter a task title',
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFEF4444),
      );
      return;
    }

    String finalDate;
    String routineType = 'None';
    if (_configMode == 'Day') {
      finalDate = 'Daily • Every Day';
      routineType = 'Day';
    } else if (_configMode == 'Week') {
      finalDate = 'Weekly • Every $_selectedWeekday';
      routineType = 'Week';
    } else if (_configMode == 'Month') {
      finalDate = 'Monthly • Every $_selectedMonthDay';
      routineType = 'Month';
    } else {
      finalDate = _startDate;
      routineType = 'None';
    }

    widget.provider.createTask(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      date: finalDate,
      startTime: _startTime,
      endTime: _endTime,
      priority: _selectedPriority,
      project: _selectedProject,
      tags: _tags.join(', '),
      colorTheme: _selectedColorTheme,
      hasMeeting: _hasMeeting,
      routineType: routineType,
    );

    widget.provider.closeAddTask();
  }

  @override
  Widget build(BuildContext context) {
    final activeOpt = taskImportanceOptions.firstWhere(
      (opt) => opt.priorityKey == _selectedPriority,
      orElse: () => taskImportanceOptions[2],
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // 1. Top Header: Close Button (X), Mode Title, Save Checkmark Button (✓)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => widget.provider.closeAddTask(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF8FAFC),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.close, size: 18, color: Color(0xFF1E293B)),
                  ),
                ),
                Text(
                  _configMode == 'Single Task'
                      ? 'New Task'
                      : _configMode == 'Day'
                          ? 'Daily Routine'
                          : _configMode == 'Week'
                              ? 'Weekly Routine'
                              : 'Monthly Routine',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E293B),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: const Icon(Icons.check, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2. Mode Selector: Task | Day | Week | Month (Match Day removed, routine options added)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  {'label': 'Task', 'mode': 'Single Task'},
                  {'label': 'Day', 'mode': 'Day'},
                  {'label': 'Week', 'mode': 'Week'},
                  {'label': 'Month', 'mode': 'Month'},
                ].map((item) {
                  final isSel = _configMode == item['mode'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _configMode = item['mode']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          item['label']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            color: isSel ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Scrollable Form Content
            Expanded(
              child: ListView(
                children: [
                  // Task Title Field
                  const Text(
                    'Task Title',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Buy groceries, Pay electricity bill, Workout...',
                        hintStyle: TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Task Importance & Soft Gradient Pill Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Task Importance',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        _isImportanceOpen ? 'Tap card below' : activeOpt.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: activeOpt.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Soft Floating Gradient Pill Trigger
                  GestureDetector(
                    onTap: () => setState(() => _isImportanceOpen = !_isImportanceOpen),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: activeOpt.gradientColors),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: activeOpt.shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(activeOpt.icon, size: 16, color: activeOpt.badgeIconColor),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              activeOpt.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: activeOpt.pillTextColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              activeOpt.shortBadge,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: activeOpt.pillTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            _isImportanceOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: activeOpt.pillTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expandable Importance Selection List
                  if (_isImportanceOpen) ...[
                    const SizedBox(height: 10),
                    Column(
                      children: taskImportanceOptions.map((opt) {
                        final isSel = opt.priorityKey == _selectedPriority;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriority = opt.priorityKey;
                              _selectedColorTheme = opt.colorThemeKey;
                              _isImportanceOpen = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: opt.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSel ? opt.accentColor : opt.borderColor,
                                width: isSel ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: opt.accentColor.withOpacity(0.15),
                                  ),
                                  child: Icon(opt.icon, size: 16, color: opt.accentColor),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        opt.title,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: opt.textColor,
                                        ),
                                      ),
                                      Text(
                                        opt.description,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: opt.textColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSel)
                                  Icon(Icons.check_circle, size: 18, color: opt.accentColor),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 18),

                  // Project Category Dropdown
                  const Text(
                    'Project / Category',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProject,
                        isExpanded: true,
                        items: _projectsList.map((p) {
                          return DropdownMenuItem<String>(
                            value: p,
                            child: Text(
                              p,
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedProject = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Schedule & Recurrence Section: Matches the specific date & time of each option
                  if (_configMode == 'Single Task') ...[
                    // Single Task: Date + Time Row
                    Row(
                      children: [
                        // Date Picker
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => _pickDate(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _startDate,
                                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Time Picker
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time Window',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => _pickTime(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 14, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '$_startTime - $_endTime',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else if (_configMode == 'Day') ...[
                    // Daily Routine: Recurrence info + Daily Time Window
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.repeat, size: 18, color: Color(0xFF16A34A)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Routine • Every Day',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'This task will recur automatically every single day.',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF166534)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Time Window',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _pickTime(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, size: 16, color: Color(0xFF16A34A)),
                                const SizedBox(width: 10),
                                Text(
                                  '$_startTime - $_endTime',
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const Spacer(),
                                const Text(
                                  'Change Time',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (_configMode == 'Week') ...[
                    // Weekly Routine: Day of week selection + Weekly Time Window
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weekly Recurrence Day',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              'Every $_selectedWeekday',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                            final fullName = {
                              'Mon': 'Monday',
                              'Tue': 'Tuesday',
                              'Wed': 'Wednesday',
                              'Thu': 'Thursday',
                              'Fri': 'Friday',
                              'Sat': 'Saturday',
                              'Sun': 'Sunday',
                            }[day]!;
                            final isSel = _selectedWeekday == fullName;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedWeekday = fullName),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSel ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    day,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                      color: isSel ? Colors.white : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Weekly Time Window',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _pickTime(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, size: 16, color: Color(0xFF4F46E5)),
                                const SizedBox(width: 10),
                                Text(
                                  '$_startTime - $_endTime',
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const Spacer(),
                                const Text(
                                  'Change Time',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Monthly Routine: Day of month selection + Monthly Time Window
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Monthly Recurrence Date',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              'Every $_selectedMonthDay',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: ['1st', '5th', '10th', '15th', '20th', 'Last Day'].map((mDay) {
                            final isSel = _selectedMonthDay == mDay;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedMonthDay = mDay),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSel ? const Color(0xFFD97706) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    mDay,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                      color: isSel ? Colors.white : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Monthly Time Window',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _pickTime(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, size: 16, color: Color(0xFFD97706)),
                                const SizedBox(width: 10),
                                Text(
                                  '$_startTime - $_endTime',
                                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const Spacer(),
                                const Text(
                                  'Change Time',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),

                  // Suggested Tags Chips
                  const Text(
                    'Tags',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _suggestedTags.map((tag) {
                      final isSelected = _tags.contains(tag);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _tags.remove(tag);
                            } else {
                              _tags.add(tag);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Video Meeting Switch
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.videocam_outlined, size: 18, color: Color(0xFF0284C7)),
                            SizedBox(width: 8),
                            Text(
                              'Includes Video Meeting',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                            ),
                          ],
                        ),
                        Switch(
                          value: _hasMeeting,
                          activeColor: const Color(0xFF0284C7),
                          onChanged: (val) => setState(() => _hasMeeting = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes & Description
                  const Text(
                    'Description / Notes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _descController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'Additional sprint details or checklist notes...',
                        hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 4. Large Create Task Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Task',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

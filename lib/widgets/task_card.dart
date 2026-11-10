import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'quilted_task_card.dart';

export 'quilted_task_card.dart';

class TaskCardTheme {
  final Color cardBg;
  final Color chipBg;
  final Color cardBorder;
  final Color accentColor;
  final Color statusDotColor;
  final Color statusPillText;
  final String defaultStatus;

  const TaskCardTheme({
    required this.cardBg,
    required this.chipBg,
    required this.cardBorder,
    required this.accentColor,
    required this.statusDotColor,
    required this.statusPillText,
    required this.defaultStatus,
  });

  static const TaskCardTheme _red = TaskCardTheme(
    cardBg: Color(0xFFFAFAF9),
    chipBg: Color(0xFFFEE2E2),
    cardBorder: Color(0xFFFECACA),
    accentColor: Color(0xFFDC2626),
    statusDotColor: Color(0xFFDC2626),
    statusPillText: Color(0xFF991B1B),
    defaultStatus: 'Urgent',
  );

  static const TaskCardTheme _peach = TaskCardTheme(
    cardBg: Color(0xFFFAFAF9),
    chipBg: Color(0xFFFFEDD5),
    cardBorder: Color(0xFFFED7AA),
    accentColor: Color(0xFFEA580C),
    statusDotColor: Color(0xFFEA580C),
    statusPillText: Color(0xFF9A3412),
    defaultStatus: 'Important',
  );

  static const TaskCardTheme _purple = TaskCardTheme(
    cardBg: Color(0xFFFAFAF9),
    chipBg: Color(0xFFF3E8FF),
    cardBorder: Color(0xFFE9D5FF),
    accentColor: Color(0xFF7C3AED),
    statusDotColor: Color(0xFF7C3AED),
    statusPillText: Color(0xFF6B21A8),
    defaultStatus: 'Routine',
  );

  static const TaskCardTheme _mint = TaskCardTheme(
    cardBg: Color(0xFFFAFAF9),
    chipBg: Color(0xFFD8FBB5),
    cardBorder: Color(0xFFBEF264),
    accentColor: Color(0xFF16A34A),
    statusDotColor: Color(0xFF16A34A),
    statusPillText: Color(0xFF14532D),
    defaultStatus: 'Low Priority',
  );

  static const TaskCardTheme _pink = TaskCardTheme(
    cardBg: Color(0xFFFAFAF9),
    chipBg: Color(0xFFFCE7F3),
    cardBorder: Color(0xFFFBCFE8),
    accentColor: Color(0xFFDB2777),
    statusDotColor: Color(0xFFDB2777),
    statusPillText: Color(0xFF9D174D),
    defaultStatus: 'Creative',
  );

  static const TaskCardTheme _blue = TaskCardTheme(
    cardBg: Color(0xFFFAFAF9),
    chipBg: Color(0xFFE0F2FE),
    cardBorder: Color(0xFFBAE6FD),
    accentColor: Color(0xFF0284C7),
    statusDotColor: Color(0xFF0284C7),
    statusPillText: Color(0xFF075985),
    defaultStatus: 'Normal',
  );

  static TaskCardTheme forTheme(String themeKey) {
    switch (themeKey.toLowerCase().trim()) {
      case 'red':
        return _red;
      case 'peach':
      case 'orange':
        return _peach;
      case 'lavender':
      case 'purple':
        return _purple;
      case 'mint':
      case 'green':
        return _mint;
      case 'pink':
        return _pink;
      case 'blue':
      default:
        return _blue;
    }
  }
}

/// Production Quilted Task Card with 3D Origami Lifted Corner, Triaxial Mosaic & Sunset Runner Vector Canvas
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onToggleStarred;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    required this.onToggleStarred,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: QuiltedTaskCardReal(
        task: task,
        width: null, // Fluidly adapts up to 630px
        onTap: onTap,
        onToggleComplete: onToggleComplete,
        onStarToggle: onToggleStarred,
        initialStarred: task.isStarred,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/task_model.dart';

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
    cardBg: Color(0xFFFFECEC),
    chipBg: Color(0xFFFED7D7),
    cardBorder: Color(0xFFFCA5A5),
    accentColor: Color(0xFFE11D48),
    statusDotColor: Color(0xFFE11D48),
    statusPillText: Color(0xFFBE123C),
    defaultStatus: 'Urgent',
  );

  static const TaskCardTheme _peach = TaskCardTheme(
    cardBg: Color(0xFFFFF1E8),
    chipBg: Color(0xFFFFE0D0),
    cardBorder: Color(0xFFFDBA74),
    accentColor: Color(0xFFEA580C),
    statusDotColor: Color(0xFFEA580C),
    statusPillText: Color(0xFFC2410C),
    defaultStatus: 'Important',
  );

  static const TaskCardTheme _purple = TaskCardTheme(
    cardBg: Color(0xFFF5F0FF),
    chipBg: Color(0xFFEAE0FD),
    cardBorder: Color(0xFFC4B5FD),
    accentColor: Color(0xFF7C3AED),
    statusDotColor: Color(0xFF7C3AED),
    statusPillText: Color(0xFF6D28D9),
    defaultStatus: 'Routine',
  );

  static const TaskCardTheme _mint = TaskCardTheme(
    cardBg: Color(0xFFE6FAF6),
    chipBg: Color(0xFFCCFBF1),
    cardBorder: Color(0xFF5EEAD4),
    accentColor: Color(0xFF059669),
    statusDotColor: Color(0xFF059669),
    statusPillText: Color(0xFF047857),
    defaultStatus: 'Low Priority',
  );

  static const TaskCardTheme _pink = TaskCardTheme(
    cardBg: Color(0xFFFDF2F8),
    chipBg: Color(0xFFFCE7F3),
    cardBorder: Color(0xFFF9A8D4),
    accentColor: Color(0xFFDB2777),
    statusDotColor: Color(0xFFDB2777),
    statusPillText: Color(0xFFBE185D),
    defaultStatus: 'Creative',
  );

  static const TaskCardTheme _blue = TaskCardTheme(
    cardBg: Color(0xFFEBF5FF),
    chipBg: Color(0xFFD6EBFF),
    cardBorder: Color(0xFF93C5FD),
    accentColor: Color(0xFF0284C7),
    statusDotColor: Color(0xFF0284C7),
    statusPillText: Color(0xFF0369A1),
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
    final theme = TaskCardTheme.forTheme(task.colorTheme);
    final progressData = task.dynamicProgress;
    final progressFraction = progressData.key;
    final progressLabel = progressData.value;

    final statusLabel = task.isCompleted
        ? 'Completed'
        : (task.status.isNotEmpty && task.status != 'To Do'
            ? task.status
            : (task.priority.toLowerCase() == 'high' ? 'Locked In' : theme.defaultStatus));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: theme.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.cardBorder.withOpacity(0.7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Row: Duration Pill (Left) & Status Pill + Star (Right)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Clean Duration Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule, size: 12, color: theme.accentColor),
                        const SizedBox(width: 5),
                        Text(
                          task.cleanDuration,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Pill & Star
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: task.isCompleted ? const Color(0xFF047857) : theme.statusPillText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onToggleStarred,
                        child: Icon(
                          task.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 20,
                          color: task.isStarred ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Main Card Content: Title, Description, Tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with completion strike-through
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: task.isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      height: 1.25,
                    ),
                  ),

                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF334155),
                        height: 1.35,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Tag Chips Row (Darker pastel chips)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...task.tagList.take(3).map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.chipBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.chipBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF1E293B)),
                            const SizedBox(width: 5),
                            Text(
                              task.dateString.isNotEmpty ? task.dateString : 'Today',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (task.project.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.chipBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                task.hasMeeting ? Icons.videocam_outlined : Icons.folder_outlined,
                                size: 12,
                                color: const Color(0xFF1E293B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                task.project,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F172A),
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

            // 3. Card Footer: DYNAMIC PROGRESS LINE ON EVERY TASK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.isCompleted ? 'TASK COMPLETED' : 'TASK PROGRESS',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                      Text(
                        progressLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: task.isCompleted ? const Color(0xFF047857) : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      minHeight: 6,
                      backgroundColor: theme.chipBg,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.isCompleted ? const Color(0xFF10B981) : theme.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 4. Bottom Row: Task Time + Duration + Avatar Stack
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onToggleComplete,
                        child: Icon(
                          task.isCompleted ? Icons.check_circle : Icons.schedule,
                          size: 16,
                          color: task.isCompleted ? const Color(0xFF10B981) : theme.accentColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${task.startTime} - ${task.endTime}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),

                  // Avatar Stack
                  _buildAvatarStack(task.assigneeCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(int count) {
    final colors = [
      const Color(0xFF0284C7),
      const Color(0xFF7C3AED),
      const Color(0xFFEA580C),
      const Color(0xFF10B981),
    ];
    return SizedBox(
      height: 24,
      width: 24.0 + (count.clamp(1, 3) - 1) * 14.0,
      child: Stack(
        children: List.generate(count.clamp(1, 3), (index) {
          return Positioned(
            left: index * 14.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[index % colors.length],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

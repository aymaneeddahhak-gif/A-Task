import 'dart:math' as math;
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

/// Modern Vector Task Card
/// Implemented according to user specifications:
/// - Container: 36px rounded corners, Color(0xFFFAFAF9), soft 36px ambient shadow.
/// - Vector Artwork: 'assets/images/cards/morningrun.jpg' covering the right ~60%
///   with X: +90px, Y: -54px focal shift and 94° feathered alpha fade mask into card body.
/// - Header: Lime pill badge ('Color(0xFFD8FBB5)') + circular white action buttons.
/// - Typography: 23px SemiBold title, 15px description (#555A62).
/// - Footer: Elevated white pill action button with start-end times and completion indicator.
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

  String _resolveTaskImage(TaskModel task) {
    // Currently loads 'assets/images/cards/morningrun.jpg', ready to resolve
    // coffee, work, study, etc. as the user provides additional images.
    final lowerTitle = task.title.toLowerCase();
    final lowerTags = task.tags.toLowerCase();

    if (lowerTitle.contains('coffee') || lowerTags.contains('coffee')) {
      return 'assets/images/cards/morningrun.jpg';
    }
    if (lowerTitle.contains('study') || lowerTitle.contains('coding') || lowerTags.contains('study')) {
      return 'assets/images/cards/morningrun.jpg';
    }
    if (lowerTitle.contains('night') || lowerTitle.contains('evening')) {
      return 'assets/images/cards/morningrun.jpg';
    }
    return 'assets/images/cards/morningrun.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final theme = TaskCardTheme.forTheme(task.colorTheme);
    final progressData = task.dynamicProgress;
    final progressFraction = progressData.key;
    final progressLabel = progressData.value;
    final imageAsset = _resolveTaskImage(task);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth;
        // Scale proportional to standard 630px canvas so offset translates seamlessly
        final scale = (cardW / 630.0).clamp(0.60, 1.10);
        final offsetX = 90.0 * scale;
        final offsetY = -54.0 * scale;
        final artworkWidth = cardW * 0.60;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAF9),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: const Color(0xFFE7E5E4),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 36,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. RIGHT VISUAL SLOT: Vector illustration with user parameters
              // Covers right 60% with X: +90px, Y: -54px translation
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: artworkWidth,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Artwork translated by +90px X, -54px Y
                      Transform.translate(
                        offset: Offset(offsetX, offsetY),
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),

                      // Alpha Fade Mask: 94° horizontal fade progressively dissolving
                      // the left side of the artwork into card background from 0% to 50% width
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0xFFFAFAF9),
                                const Color(0xFFFAFAF9).withOpacity(0.95),
                                const Color(0xFFFAFAF9).withOpacity(0.40),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.18, 0.45, 0.70],
                            ),
                          ),
                        ),
                      ),

                      // Bottom feather so artwork blends smoothly above bottom action button
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                const Color(0xFFFAFAF9).withOpacity(0.70),
                                const Color(0xFFFAFAF9),
                              ],
                              stops: const [0.0, 0.65, 0.88, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. FOREGROUND CARD CONTENT: Header, Text, Chips, Progress & Action
              Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Badge (Left) & Circular Action Buttons (Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Pill Badge (matching 4x Pro style)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8FBB5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                task.cleanDuration.isNotEmpty ? task.cleanDuration : '4x Pro',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1C1917),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            if (task.routineType != 'None') ...[
                              const SizedBox(width: 8),
                              _buildRoutinePill(task.routineType),
                            ],
                          ],
                        ),

                        // Right: Circular Action Buttons (Star & Complete Toggle)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Star Circle Button
                            InkWell(
                              onTap: onToggleStarred,
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  task.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                                  size: 19,
                                  color: task.isStarred ? const Color(0xFFF59E0B) : const Color(0xFF1C1917),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Complete Circle Toggle Button
                            InkWell(
                              onTap: onToggleComplete,
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: task.isCompleted ? const Color(0xFFD8FBB5) : Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  task.isCompleted ? Icons.check_rounded : Icons.check_circle_outline_rounded,
                                  size: 18,
                                  color: task.isCompleted ? const Color(0xFF166534) : const Color(0xFF1C1917),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Title & Description (Left column constrained so text never overlaps artwork focal point)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: math.max(180, cardW * 0.60),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                              color: task.isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF1C1917),
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              task.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.45,
                                color: Color(0xFF555A62),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meta Chips: Category Tag, Date, Project
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: math.max(200, cardW * 0.68),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...task.tagList.take(2).map((tag) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1C1917),
                                  ),
                                ),
                              )),
                          if (task.project.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.hasMeeting ? Icons.videocam_outlined : Icons.folder_outlined,
                                    size: 12,
                                    color: const Color(0xFF555A62),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    task.project,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1C1917),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Progress Line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.isCompleted ? 'TASK COMPLETED' : 'TASK PROGRESS',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF78716C),
                          ),
                        ),
                        Text(
                          progressLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: task.isCompleted ? const Color(0xFF166534) : const Color(0xFF1C1917),
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
                        backgroundColor: const Color(0xFFE7E5E4),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          task.isCompleted ? const Color(0xFF16A34A) : theme.accentColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Bottom Elevated Pill Action Button (matching Upgrade Plan style from user code)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1C1917),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 16, color: Color(0xFF1C1917)),
                                const SizedBox(width: 8),
                                Text(
                                  '${task.startTime} - ${task.endTime}',
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1C1917),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  task.isCompleted ? 'Completed' : 'View Details',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: task.isCompleted ? const Color(0xFF166534) : const Color(0xFF555A62),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 16),
                              ],
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
        );
      },
    );
  }

  Widget _buildRoutinePill(String routineType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        '$routineType Routine',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1917),
        ),
      ),
    );
  }
}

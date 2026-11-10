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

/// Scenic Tactile Curled Task Card (100% 1-to-1 match with user reference)
/// Features:
/// - Physical 3D curled top-left paper corner with cast shadow & highlight spine.
/// - Left side origami parallelogram paper mosaic with subtle golden creases.
/// - Right side full scenic vector runner artwork (morningrun.jpg) smoothly blended.
/// - Top header pills: [⏱ 1h] (left of curl) and [In Progress] (right).
/// - Bold title, short subtitle, and dual rows of clean white capsule chips.
/// - Sleek obsidian-to-rose gradient progress bar with [TASK PROGRESS] & [% COMPLETED].
/// - Bottom capsule pills: [⏱ Start - End Time] and [⚡ Routine Horizon].
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

  static const double _curlSize = 34.0;
  static const double _borderRadius = 28.0;

  @override
  Widget build(BuildContext context) {
    final progressData = task.dynamicProgress;
    final progressFraction = progressData.key;
    final progressPercent = (progressFraction * 100).round();

    final statusLabel = task.isCompleted
        ? 'Completed'
        : (task.status.isNotEmpty && task.status != 'To Do'
            ? task.status
            : (task.priority.toLowerCase() == 'high' ? 'Locked In' : 'In Progress'));

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth;
        final isNarrow = cardW < 360;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Soft Ambient Card Shadow + Lifted Peel Shadow
              Positioned.fill(
                child: CustomPaint(
                  painter: _CurledCardAmbientShadowPainter(
                    curlSize: _curlSize,
                    borderRadius: _borderRadius,
                  ),
                ),
              ),

              // 2. Clipped Card Body (Corner cut at fold line)
              ClipPath(
                clipper: _TopLeftCornerCurlClipper(
                  curlSize: _curlSize,
                  borderRadius: _borderRadius,
                ),
                child: GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_borderRadius),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // A. Composite Card Background (Mosaic Tiles + Runner Illustration)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            child: Image.asset(
                              'assets/images/cards/card_composite_bg.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                        ),

                        // B. Foreground Card Content Layout
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            isNarrow ? 14 : 20,
                            16,
                            isNarrow ? 14 : 20,
                            16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top Header Row: [ ⏱ Duration ] (Left) & [ Status Pill ] + [ Star ] (Right)
                              Row(
                                children: [
                                  // Left pill beside the 3D paper curl
                                  Container(
                                    margin: const EdgeInsets.only(left: 36),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.schedule_rounded,
                                          size: 13,
                                          color: Color(0xFFE11D48),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.cleanDuration.isNotEmpty ? task.cleanDuration : '1h',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),

                                  // Right: Status Pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: task.isCompleted
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFFBE185D),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  // Star Action Button
                                  GestureDetector(
                                    onTap: onToggleStarred,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        task.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                                        size: 16,
                                        color: task.isStarred ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Title & Subtitle (Left column constrained for perfect framing)
                              Padding(
                                padding: EdgeInsets.only(right: isNarrow ? 20 : cardW * 0.35),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      task.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isNarrow ? 17 : 20,
                                        fontWeight: FontWeight.w800,
                                        color: task.isCompleted
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF0F172A),
                                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      task.description.isNotEmpty
                                          ? task.description
                                          : 'Steady outdoor pace along the hillside path with warm sunset breeze.',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Tag Chips: Row 1
                              Padding(
                                padding: EdgeInsets.only(right: isNarrow ? 10 : cardW * 0.35),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    if (task.tagList.isNotEmpty)
                                      ...task.tagList.take(3).map((tag) => _buildPillChip(tag))
                                    else ...[
                                      _buildPillChip('Running'),
                                      _buildPillChip('Sunset Pace'),
                                      _buildPillChip('Endurance'),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Tag Chips: Row 2 (Date & Project/Category)
                              Padding(
                                padding: EdgeInsets.only(right: isNarrow ? 10 : cardW * 0.35),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _buildPillChip(
                                      task.dateString.isNotEmpty ? task.dateString : 'Today',
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                    _buildPillChip(
                                      task.project.isNotEmpty ? task.project : 'Outdoor Run',
                                      icon: Icons.folder_outlined,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Task Progress Bar Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'TASK PROGRESS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.92),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '$progressPercent% COMPLETED',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: task.isCompleted
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),

                              // Sleek Obsidian-to-Rose Gradient Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Container(
                                  height: 5.5,
                                  width: double.infinity,
                                  color: const Color(0xFFE2E8F0),
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: progressFraction.clamp(0.03, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1E1B2E), // Dark obsidian
                                            Color(0xFF831843), // Deep berry
                                            Color(0xFFE11D48), // Vibrant rose
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Bottom Row: [ ⏱ Time ] (Left) & [ ⚡ Routine ] (Right)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left Time Pill (Tap to toggle complete)
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: onToggleComplete,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isNarrow ? 9 : 13,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.04),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              task.isCompleted
                                                  ? Icons.check_circle_rounded
                                                  : Icons.schedule_rounded,
                                              size: 14,
                                              color: task.isCompleted
                                                  ? const Color(0xFF16A34A)
                                                  : const Color(0xFFE11D48),
                                            ),
                                            const SizedBox(width: 5),
                                            Flexible(
                                              child: Text(
                                                '${task.startTime} - ${task.endTime}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF0F172A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Right Category / Routine Pill
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isNarrow ? 9 : 13,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3E8FF),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: const Color(0xFFE9D5FF), width: 0.8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.bolt_rounded,
                                          size: 14,
                                          color: Color(0xFF9333EA),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.routineType != 'None'
                                              ? '${task.routineType} Routine'
                                              : (task.tagList.isNotEmpty ? task.tagList.first : 'Afternoon Run'),
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF7E22CE),
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
                      ],
                    ),
                  ),
                ),
              ),

              // 3. 3D Curled Paper Flap on Top-Left Corner
              Positioned(
                top: 0,
                left: 0,
                width: _curlSize * 1.6,
                height: _curlSize * 1.6,
                child: const IgnorePointer(
                  child: CustomPaint(
                    painter: _TopLeftCornerCurlFlapPainter(
                      curlSize: _curlSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPillChip(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: const Color(0xFF64748B)),
            const SizedBox(width: 4.5),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clips the card body along the diagonal fold line of the top-left curl
class _TopLeftCornerCurlClipper extends CustomClipper<Path> {
  final double curlSize;
  final double borderRadius;

  const _TopLeftCornerCurlClipper({
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
    path.quadraticBezierTo(size.width, size.height, size.width - r, size.height);
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.lineTo(0, c);
    path.quadraticBezierTo(c * 0.46, c * 0.46, c, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TopLeftCornerCurlClipper oldClipper) {
    return oldClipper.curlSize != curlSize || oldClipper.borderRadius != borderRadius;
  }
}

/// Paints the ambient card shadow plus the shadow underneath the curled top-left corner
class _CurledCardAmbientShadowPainter extends CustomPainter {
  final double curlSize;
  final double borderRadius;

  const _CurledCardAmbientShadowPainter({
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
      ..quadraticBezierTo(size.width, size.height + 3, size.width - r, size.height + 3)
      ..lineTo(r, size.height + 3)
      ..quadraticBezierTo(0, size.height + 3, 0, size.height - r)
      ..lineTo(2, c)
      ..close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = const Color(0xFF0F172A).withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  @override
  bool shouldRepaint(covariant _CurledCardAmbientShadowPainter oldDelegate) {
    return oldDelegate.curlSize != curlSize;
  }
}

/// Paints the physical 3D paper curl flap on the top-left corner
class _TopLeftCornerCurlFlapPainter extends CustomPainter {
  final double curlSize;

  const _TopLeftCornerCurlFlapPainter({
    required this.curlSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = curlSize;

    // Drop shadow cast by the lifted paper flap onto the desk
    final shadowPath = Path()
      ..moveTo(0, c)
      ..quadraticBezierTo(c * 0.46, c * 0.46, c, 0)
      ..quadraticBezierTo(c * 1.05, c * 0.68, c * 0.96, c * 0.96)
      ..quadraticBezierTo(c * 0.68, c * 1.05, 0, c)
      ..close();

    canvas.drawPath(
      shadowPath.shift(const Offset(2.5, 3.5)),
      Paint()
        ..color = Colors.black.withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.5),
    );

    // Folded paper face
    final flapPath = Path()
      ..moveTo(0, c)
      ..quadraticBezierTo(c * 0.46, c * 0.46, c, 0)
      ..quadraticBezierTo(c * 0.94, c * 0.56, c * 0.88, c * 0.88)
      ..quadraticBezierTo(c * 0.56, c * 0.94, 0, c)
      ..close();

    final flapPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Color(0xFFF8FAFC),
          Color(0xFFE2E8F0),
          Color(0xFFCBD5E1),
        ],
        stops: [0.0, 0.38, 0.78, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, c, c));

    canvas.drawPath(flapPath, flapPaint);

    // Spine highlight along the crease line
    final spineHighlight = Path()
      ..moveTo(1, c - 1)
      ..quadraticBezierTo(c * 0.47, c * 0.47, c - 1, 1);
    canvas.drawPath(
      spineHighlight,
      Paint()
        ..color = Colors.white.withOpacity(0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Subtle edge definition
    final innerEdge = Path()
      ..moveTo(c, 0)
      ..quadraticBezierTo(c * 0.94, c * 0.56, c * 0.88, c * 0.88)
      ..quadraticBezierTo(c * 0.56, c * 0.94, 0, c);
    canvas.drawPath(
      innerEdge,
      Paint()
        ..color = Colors.white.withOpacity(0.80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant _TopLeftCornerCurlFlapPainter oldDelegate) {
    return oldDelegate.curlSize != curlSize;
  }
}

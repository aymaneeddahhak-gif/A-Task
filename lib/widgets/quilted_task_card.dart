// ==============================================================================
// FLUTTER QUILTED TASK CARD (Production Ready - Self Contained)
// Settings: Concept: afternoon-run | Curl Turn: inside | Curl Style: origami-lifted | Curl Shadow: deep | Curl Shadow Intensity: 100% | Curl Shadow Size: 22px | Move Vector Image: 90,-54 | Paper Clarity: 65% | Shadow & Lift: 100% | 3-Paper Curl: 100% | Card Curl Size: 86px | Vector Size: 100% | Vector Opacity: 100%
//
// HOW TO USE IN ANY FLUTTER APP:
// 1. Copy this entire file and paste it into your Flutter project (e.g., lib/quilted_task_card.dart or lib/main.dart).
// 2. Add QuiltedTaskCardReal() inside any Container, Column, or Scaffold body.
// 3. ZERO ASSET DEPENDENCIES: All paper craft mosaic, 3D origami curl, and sunset runner art
//    are drawn using pure Flutter CustomPainter & Canvas vector graphics.
// ==============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/task_model.dart';

void main() {
  runApp(const CardPreviewApp());
}

/// Standalone Preview Scaffold to test or run directly
class CardPreviewApp extends StatelessWidget {
  const CardPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quilted Task Card',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        fontFamily: 'sans-serif',
      ),
      home: const Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: QuiltedTaskCardReal(),
          ),
        ),
      ),
    );
  }
}

/// Compatibility alias for normal variant
class QuiltedTaskCardNormal extends StatelessWidget {
  final double? width;
  final VoidCallback? onStarToggle;
  const QuiltedTaskCardNormal({super.key, this.width, this.onStarToggle});

  @override
  Widget build(BuildContext context) => QuiltedTaskCardReal(width: width, onStarToggle: onStarToggle);
}

/// Compatibility alias for 3D variant
class QuiltedTaskCard3D extends StatelessWidget {
  final double? width;
  final VoidCallback? onStarToggle;
  const QuiltedTaskCard3D({super.key, this.width, this.onStarToggle});

  @override
  Widget build(BuildContext context) => QuiltedTaskCardReal(width: width, onStarToggle: onStarToggle);
}

/// Main Quilted Task Card Widget with 3D Lifted Origami Corner & Triaxial Mosaic
class QuiltedTaskCardReal extends StatefulWidget {
  final TaskModel? task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final double? width;
  final double cornerCurlSize;
  final String curlStyle;
  final String curlDirection;
  final String curlShadowStyle;
  final double curlShadowIntensity;
  final double curlShadowSize;
  final Offset vectorOffset;
  final double patternOpacity;
  final double paperShadowPct;
  final double threePaperCurlPct;
  final double vectorScale;
  final double vectorOpacity;
  final bool initialStarred;
  final VoidCallback? onStarToggle;

  const QuiltedTaskCardReal({
    super.key,
    this.task,
    this.onTap,
    this.onToggleComplete,
    this.width = 630,
    this.cornerCurlSize = 86.0,
    this.curlStyle = 'origami-lifted',
    this.curlDirection = 'inside',
    this.curlShadowStyle = 'deep',
    this.curlShadowIntensity = 1.00,
    this.curlShadowSize = 22.0,
    this.vectorOffset = const Offset(90.0, -54.0),
    this.patternOpacity = 0.65,
    this.paperShadowPct = 1.00,
    this.threePaperCurlPct = 1.00,
    this.vectorScale = 1.00,
    this.vectorOpacity = 1.00,
    this.initialStarred = false,
    this.onStarToggle,
  });

  @override
  State<QuiltedTaskCardReal> createState() => _QuiltedTaskCardRealState();
}

class _QuiltedTaskCardRealState extends State<QuiltedTaskCardReal> {
  late bool isStarred;

  @override
  void initState() {
    super.initState();
    isStarred = widget.task?.isStarred ?? widget.initialStarred;
  }

  @override
  void didUpdateWidget(covariant QuiltedTaskCardReal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.task != null && widget.task!.isStarred != isStarred) {
      isStarred = widget.task!.isStarred;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double cardRadius = 32.0;

    final isCompleted = widget.task?.isCompleted == true;
    final durationStr = (widget.task != null && widget.task!.cleanDuration.isNotEmpty)
        ? widget.task!.cleanDuration
        : '1h';

    final statusStr = isCompleted
        ? 'Completed'
        : (widget.task != null && widget.task!.status.isNotEmpty && widget.task!.status != 'To Do'
            ? widget.task!.status
            : 'In Progress');
    final statusColor = isCompleted ? const Color(0xFF16A34A) : const Color(0xFFBE185D);
    final statusBorderColor = isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFCE7F3);

    final titleStr = (widget.task != null && widget.task!.title.isNotEmpty)
        ? widget.task!.title
        : 'Afternoon Sunset Tempo Run';

    final descStr = (widget.task != null && widget.task!.description.isNotEmpty)
        ? widget.task!.description
        : 'Steady outdoor pace along the hillside path with warm sunset breeze.';

    final tagList = (widget.task != null && widget.task!.tagList.isNotEmpty)
        ? widget.task!.tagList.take(3).toList()
        : const ['Running', 'Sunset Pace', 'Endurance'];

    final dateStr = (widget.task != null && widget.task!.dateString.isNotEmpty)
        ? widget.task!.dateString
        : 'Today';

    final projectStr = (widget.task != null && widget.task!.project.isNotEmpty)
        ? widget.task!.project
        : 'Outdoor Run';

    final progressFrac = widget.task?.dynamicProgress.key ?? 0.78;
    final progressPct = (progressFrac * 100).round();
    final progressLabel = widget.task != null ? '$progressPct% COMPLETED' : '78% COMPLETED';
    final barFactor = progressFrac.clamp(0.05, 1.0);

    final timeRangeStr = (widget.task != null && widget.task!.startTime.isNotEmpty)
        ? '${widget.task!.startTime} - ${widget.task!.endTime}'
        : '05:30 PM - 06:30 PM';

    final categoryStr = (widget.task != null && widget.task!.routineType.isNotEmpty && widget.task!.routineType != 'None')
        ? widget.task!.routineType
        : (widget.task != null && widget.task!.project.isNotEmpty ? widget.task!.project : 'Afternoon Run');

    return LayoutBuilder(
      builder: (context, constraints) {
        final double parentMaxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 630.0;
        final double effectiveWidth = widget.width ?? parentMaxWidth;
        final double cardWidth = effectiveWidth.clamp(280.0, 630.0);
        final bool isMobile = cardWidth < 460;

        // Dynamic text and vector boundaries ensuring the illustration stays on the right
        final double textColumnWidth = cardWidth * (isMobile ? 0.60 : 0.64);
        final double vectorArtWidth = cardWidth * (isMobile ? 0.58 : 0.52);

        return Center(
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF9), // Warm Ivory paper base
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x180F172A),
                    blurRadius: 32,
                    offset: Offset(0, 16),
                  ),
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cardRadius),
                child: ClipPath(
                  clipper: CornerCutClipper(widget.cornerCurlSize),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 1. Triaxial Parallelogram Paper Mosaic (Left half of the card)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: TriaxialMosaicPaperPainter(
                            opacity: widget.patternOpacity,
                            shadowIntensity: widget.paperShadowPct,
                            bottomPaperCurl: widget.threePaperCurlPct,
                          ),
                        ),
                      ),

                      // 2. Right-Docked Sunset Runner Art (with ShaderMask left fade)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: vectorArtWidth * widget.vectorScale,
                        child: Opacity(
                          opacity: widget.vectorOpacity.clamp(0.0, 1.0),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Color(0x22000000),
                                  Colors.black,
                                  Colors.black,
                                ],
                                stops: [0.0, 0.28, 0.58, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: CustomPaint(
                              painter: SunsetRunnerVectorPainter(),
                            ),
                          ),
                        ),
                      ),

                      // 3. Foreground Task Card Content
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 18.0 : 26.0,
                          isMobile ? 18.0 : 24.0,
                          isMobile ? 18.0 : 26.0,
                          isMobile ? 18.0 : 22.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top Header Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left: Duration Pill (padded right to clear the 86px corner fold)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: math.max(48.0, widget.cornerCurlSize * 0.76),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.96),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                      boxShadow: const [
                                        BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1.5)),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFFE11D48)),
                                        const SizedBox(width: 5),
                                        Text(
                                          durationStr,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Right: Status Badge & Star Button
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: widget.onToggleComplete,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.96),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: statusBorderColor),
                                          boxShadow: const [
                                            BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1.5)),
                                          ],
                                        ),
                                        child: Text(
                                          statusStr,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() => isStarred = !isStarred);
                                        widget.onStarToggle?.call();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5.5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.96),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                          boxShadow: const [
                                            BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
                                          ],
                                        ),
                                        child: Icon(
                                          isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                                          size: 15,
                                          color: isStarred ? const Color(0xFFEAB308) : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: isMobile ? 14 : 18),

                            // Title & Description (Constrained to left column so it NEVER hits the art!)
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: textColumnWidth),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    titleStr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.4,
                                      height: 1.25,
                                      color: isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    descStr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: isMobile ? 12.5 : 13.5,
                                      height: 1.4,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 12 : 16),

                                  // Tag Chips Row 1
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 5,
                                    children: tagList.map((tag) => _buildPillTag(tag, isMobile)).toList(),
                                  ),
                                  const SizedBox(height: 6),

                                  // Tag Chips Row 2
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 5,
                                    children: [
                                      _buildIconTag(Icons.calendar_today_rounded, dateStr, isMobile),
                                      _buildIconTag(Icons.folder_outlined, projectStr, isMobile),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isMobile ? 16 : 20),

                            // Task Progress Bar Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'TASK PROGRESS',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  progressLabel,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 7,
                                width: double.infinity,
                                color: const Color(0xFFE2E8F0),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: barFactor,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF0F172A), Color(0xFFBE185D), Color(0xFFE11D48)],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isMobile ? 16 : 20),

                            // Bottom Footer Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 15, color: Color(0xFFE11D48)),
                                    const SizedBox(width: 5),
                                    Text(
                                      timeRangeStr,
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3E8FF),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFFE9D5FF)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.bolt_rounded, size: 13, color: Color(0xFF7E22CE)),
                                      const SizedBox(width: 3.5),
                                      Text(
                                        categoryStr,
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 12,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6B21A8),
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

                      // 4. 3D Lifted Origami Corner Curl (86px, Top-Left)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                          width: widget.cornerCurlSize,
                          height: widget.cornerCurlSize,
                          child: CustomPaint(
                            painter: OrigamiLiftedCornerPainter(
                              shadowIntensity: widget.curlShadowIntensity,
                              shadowSize: widget.curlShadowSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPillTag(String text, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12, vertical: isMobile ? 3.5 : 4.5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildIconTag(IconData icon, String text, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 12, vertical: isMobile ? 3.5 : 4.5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isMobile ? 12 : 13, color: const Color(0xFF64748B)),
          const SizedBox(width: 4.5),
          Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cuts off the top-left corner diagonally so the corner cavity behind the origami flap is transparent
class CornerCutClipper extends CustomClipper<Path> {
  final double cornerSize;
  const CornerCutClipper(this.cornerSize);

  @override
  Path getClip(Size size) {
    final cut = cornerSize * 0.80;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant CornerCutClipper oldClipper) =>
      oldClipper.cornerSize != cornerSize;
}

/// CustomPainter for the 3D Lifted Origami Corner Fold (86px, Spring-Back Bevel)
class OrigamiLiftedCornerPainter extends CustomPainter {
  final double shadowIntensity;
  final double shadowSize;

  const OrigamiLiftedCornerPainter({
    this.shadowIntensity = 1.0,
    this.shadowSize = 22.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final double fold = s * 0.80;

    // A. Deep Under-Crease Ambient Shadow (peel cavity)
    final cavityShadowPath = Path()
      ..moveTo(0, fold)
      ..lineTo(fold, 0)
      ..lineTo(fold + shadowSize * 0.6, shadowSize * 0.3)
      ..lineTo(shadowSize * 0.3, fold + shadowSize * 0.6)
      ..close();

    final cavityPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withOpacity(0.38 * shadowIntensity),
          Colors.black.withOpacity(0.18 * shadowIntensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, fold + shadowSize, fold + shadowSize));
    canvas.drawPath(cavityShadowPath, cavityPaint);

    // B. Projected Cast Drop Shadow cast across the card canvas
    final castShadowPath = Path()
      ..moveTo(0, fold)
      ..lineTo(fold, 0)
      ..quadraticBezierTo(fold * 0.95, fold * 0.35, fold * 0.62, fold * 0.62)
      ..quadraticBezierTo(fold * 0.35, fold * 0.95, 0, fold)
      ..close();

    canvas.drawPath(
      castShadowPath.shift(Offset(shadowSize * 0.35, shadowSize * 0.45)),
      Paint()
        ..color = Colors.black.withOpacity(0.24 * shadowIntensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowSize * 0.55),
    );

    // C. The Lifted Origami Triangle (Paper fold face)
    final flapPath = Path()
      ..moveTo(0, fold)
      ..lineTo(fold, 0)
      ..quadraticBezierTo(fold * 0.78, fold * 0.32, fold * 0.54, fold * 0.54)
      ..quadraticBezierTo(fold * 0.32, fold * 0.78, 0, fold)
      ..close();

    // 3D paper bevel gradient: Crisp white peak rolling down into pearl gray crease
    final flapGradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF), // Highlight crest
          Color(0xFFFBFBFB),
          Color(0xFFF1F5F9), // Slate-100 midtone
          Color(0xFFE2E8F0), // Slate-200 fold depth
          Color(0xFFCBD5E1), // Slate-300 crease edge
        ],
        stops: [0.0, 0.22, 0.55, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, fold, fold));
    canvas.drawPath(flapPath, flapGradient);

    // D. Origami Crease Spine Highlight (Subtle razor-sharp rim line)
    final spinePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8FAFC),
          Color(0x99CBD5E1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, fold, fold))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35;

    final spinePath = Path()
      ..moveTo(1, fold - 1)
      ..lineTo(fold - 1, 1);
    canvas.drawPath(spinePath, spinePaint);

    // E. Outer Lifted Rim Edge Highlight
    final rimPaint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final rimPath = Path()
      ..moveTo(fold, 0)
      ..quadraticBezierTo(fold * 0.78, fold * 0.32, fold * 0.54, fold * 0.54)
      ..quadraticBezierTo(fold * 0.32, fold * 0.78, 0, fold);
    canvas.drawPath(rimPath, rimPaint);
  }

  @override
  bool shouldRepaint(covariant OrigamiLiftedCornerPainter oldDelegate) =>
      oldDelegate.shadowIntensity != shadowIntensity ||
      oldDelegate.shadowSize != shadowSize;
}

/// CustomPainter for the Left-Side Triaxial Isometric Parallelogram Paper Craft Mosaic
class TriaxialMosaicPaperPainter extends CustomPainter {
  final double opacity;
  final double shadowIntensity;
  final double bottomPaperCurl;

  const TriaxialMosaicPaperPainter({
    this.opacity = 0.65,
    this.shadowIntensity = 1.0,
    this.bottomPaperCurl = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.0) return;

    canvas.save();
    // Confine mosaic exclusively to the left ~58% with smooth alpha falloff
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * 0.62, size.height));

    final basePaint = Paint()..color = const Color(0xFFF8FAFC).withOpacity(opacity);
    final shadowPaint = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.04 * shadowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final creasePaint = Paint()
      ..color = const Color(0xFFCBD5E1).withOpacity(0.35 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final goldCreasePaint = Paint()
      ..color = const Color(0xFFE2C9A5).withOpacity(0.28 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    final double step = 64.0;
    final double skew = step * 0.52;

    for (double y = -step; y < size.height + step * 2; y += step * 0.92) {
      for (double x = -step; x < size.width * 0.65; x += step * 1.4) {
        final path = Path()
          ..moveTo(x + skew, y)
          ..lineTo(x + step + skew, y)
          ..lineTo(x + step, y + step * 0.88)
          ..lineTo(x, y + step * 0.88)
          ..close();

        // Drop shadow for lifted paper depth
        canvas.drawPath(path.shift(const Offset(1.2, 1.8)), shadowPaint);
        // Face of the paper tile
        canvas.drawPath(path, basePaint);
        // Subtle crease line
        canvas.drawPath(path, ((x ~/ step) % 2 == 0) ? goldCreasePaint : creasePaint);
      }
    }

    // Secondary subtle tactile bottom curl strip (Paper Curl Effect)
    if (bottomPaperCurl > 0.1) {
      final curlShadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.06 * bottomPaperCurl)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      final double curlW = size.width * 0.32;
      final double curlH = 14.0;
      final double curlY = size.height * 0.58;

      final curlRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(18, curlY, curlW, curlH),
        const Radius.circular(6),
      );
      canvas.drawRRect(curlRect.inflate(2), curlShadowPaint);

      final curlPaperPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFDF8F0), Color(0xFFEBE0D0)],
        ).createShader(Rect.fromLTWH(18, curlY, curlW, curlH));
      canvas.drawRRect(curlRect, curlPaperPaint);

      final curlRimPaint = Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(curlRect, curlRimPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TriaxialMosaicPaperPainter oldDelegate) =>
      oldDelegate.opacity != opacity ||
      oldDelegate.shadowIntensity != shadowIntensity ||
      oldDelegate.bottomPaperCurl != bottomPaperCurl;
}

/// CustomPainter for the Afternoon Sunset Runner Illustration (Zero Asset Dependencies)
class SunsetRunnerVectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Sunset Glow Sphere
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDBA74).withOpacity(0.65),
          const Color(0xFFFED7AA).withOpacity(0.35),
          const Color(0xFFFED7AA).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.65, h * 0.35), radius: w * 0.45));
    canvas.drawCircle(Offset(w * 0.65, h * 0.35), w * 0.45, sunPaint);

    // Warm Hill Slope
    final hillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFED7AA), Color(0xFFE2E8F0)],
      ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));

    final hillPath = Path()
      ..moveTo(0, h * 0.75)
      ..quadraticBezierTo(w * 0.4, h * 0.65, w, h * 0.85)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    // Running Figure Silhouette (Head, Torso, Limbs)
    final bodyPaint = Paint()..color = const Color(0xFF334155);
    final runnerX = w * 0.52;
    final runnerY = h * 0.42;

    // Head
    canvas.drawCircle(Offset(runnerX + 26, runnerY - 26), 9.0, bodyPaint);

    // Torso (Shirt in purple/blue)
    final shirtPaint = Paint()..color = const Color(0xFF6366F1);
    final torsoPath = Path()
      ..moveTo(runnerX + 22, runnerY - 14)
      ..lineTo(runnerX + 32, runnerY - 14)
      ..lineTo(runnerX + 26, runnerY + 16)
      ..lineTo(runnerX + 16, runnerY + 16)
      ..close();
    canvas.drawPath(torsoPath, shirtPaint);

    // Shorts
    final shortsPaint = Paint()..color = const Color(0xFF1E293B);
    final shortsPath = Path()
      ..moveTo(runnerX + 16, runnerY + 16)
      ..lineTo(runnerX + 26, runnerY + 16)
      ..lineTo(runnerX + 28, runnerY + 28)
      ..lineTo(runnerX + 12, runnerY + 28)
      ..close();
    canvas.drawPath(shortsPath, shortsPaint);

    // Legs & Arms
    final limbPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Forward bent leg
    canvas.drawLine(Offset(runnerX + 24, runnerY + 28), Offset(runnerX + 38, runnerY + 48), limbPaint);
    canvas.drawLine(Offset(runnerX + 38, runnerY + 48), Offset(runnerX + 44, runnerY + 68), limbPaint);

    // Backward trailing leg
    canvas.drawLine(Offset(runnerX + 14, runnerY + 28), Offset(runnerX - 2, runnerY + 42), limbPaint);
    canvas.drawLine(Offset(runnerX - 2, runnerY + 42), Offset(runnerX - 16, runnerY + 54), limbPaint);

    // Forward arm
    canvas.drawLine(Offset(runnerX + 28, runnerY - 6), Offset(runnerX + 44, runnerY + 2), limbPaint);
    canvas.drawLine(Offset(runnerX + 44, runnerY + 2), Offset(runnerX + 38, runnerY + 14), limbPaint);

    // Backward arm
    canvas.drawLine(Offset(runnerX + 18, runnerY - 6), Offset(runnerX + 6, runnerY + 6), limbPaint);
    canvas.drawLine(Offset(runnerX + 6, runnerY + 6), Offset(runnerX + 12, runnerY + 18), limbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

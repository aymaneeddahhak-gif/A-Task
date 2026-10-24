import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Analytical Line Graph Card inspired directly by `sanbox/graph.png`
/// Features multi-color Bézier gradient line, active month badge (632 at Jun),
/// total metric (1,930), and filter pills (All, Active, Enrolled).
class AnalyticsGraphCard extends StatefulWidget {
  final bool isNight;
  final VoidCallback? onUpgradeTap;

  const AnalyticsGraphCard({
    Key? key,
    this.isNight = false,
    this.onUpgradeTap,
  }) : super(key: key);

  @override
  State<AnalyticsGraphCard> createState() => _AnalyticsGraphCardState();
}

class _AnalyticsGraphCardState extends State<AnalyticsGraphCard> {
  int _selectedFilterIndex = 2; // 0: All, 1: Active, 2: Enrolled (matches sanbox/graph.png)
  int _hoveredMonthIndex = 5; // 5 = Jun (active by default with 632 badge)

  final List<String> _filters = ['All', 'Active', 'Enrolled'];
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];

  // Data values corresponding to each month for dynamic responsiveness
  final Map<int, int> _monthValues = {
    0: 210,
    1: 295,
    2: 440,
    3: 420,
    4: 490,
    5: 632, // Jun reference badge in sanbox/graph.png
    6: 580,
  };

  @override
  Widget build(BuildContext context) {
    final isNight = widget.isNight;
    final cardBg = isNight ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isNight ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final textDark = isNight ? Colors.white : const Color(0xFF0F172A);
    final textMuted = isNight ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isNight ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Section: Filters + Subtitle on Left, Metric on Right
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Column: Filter Pills + "Members" / "Activity Analytics"
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Segment Container
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: isNight ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_filters.length, (idx) {
                            final isSel = _selectedFilterIndex == idx;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedFilterIndex = idx),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? (isNight ? const Color(0xFF334155) : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
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
                                  _filters[idx],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? textDark : textMuted,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Title & Subtitle
                      Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Manage, total course members\nand their progress',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Column: Big Number 1,930 + "Total Members"
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '1,930',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: textDark,
                        letterSpacing: -0.8,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Members',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // 2. Interactive Bézier Curve Canvas with 632 Jun Badge
          SizedBox(
            height: 140,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final badgeX = (w * 0.74).clamp(0.0, w - 60.0);
                final currentValue = _monthValues[_hoveredMonthIndex] ?? 632;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Custom Painted Gradient Curve & Pastel Shading
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BezierGraphPainter(
                          isNight: isNight,
                          hoveredIndex: _hoveredMonthIndex,
                        ),
                      ),
                    ),

                    // Floating Jun 632 Badge
                    Positioned(
                      left: badgeX - 18,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A), // Jet black badge matching reference
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.28),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '$currentValue',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3. Month Axis (Jan, Feb, Mar, Apr, May, Jun [highlighted], Jul)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_months.length, (idx) {
                final isJun = idx == _hoveredMonthIndex;
                return GestureDetector(
                  onTap: () => setState(() => _hoveredMonthIndex = idx),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isJun ? 10 : 4,
                      vertical: isJun ? 4 : 2,
                    ),
                    decoration: BoxDecoration(
                      color: isJun
                          ? (isNight ? const Color(0xFF334155) : Colors.white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isJun
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      _months[idx],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isJun ? FontWeight.w800 : FontWeight.w500,
                        color: isJun ? textDark : textMuted,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _BezierGraphPainter extends CustomPainter {
  final bool isNight;
  final int hoveredIndex;

  _BezierGraphPainter({required this.isNight, required this.hoveredIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Define curve control points normalized to match sanbox/graph.png
    // Starts at Jan, gentle rise, bumps at Mar with red dot, dips at May, peaks at Jun, turns slightly up at Jul
    final points = [
      Offset(0.0, h * 0.72),
      Offset(w * 0.08, h * 0.73),
      Offset(w * 0.20, h * 0.68),
      Offset(w * 0.26, h * 0.71),
      Offset(w * 0.32, h * 0.62),
      Offset(w * 0.44, h * 0.58), // Mar red marker point
      Offset(w * 0.52, h * 0.58),
      Offset(w * 0.60, h * 0.62),
      Offset(w * 0.68, h * 0.52),
      Offset(w * 0.74, h * 0.45), // Jun peak under badge
      Offset(w * 0.82, h * 0.54),
      Offset(w * 0.92, h * 0.50),
      Offset(w * 1.00, h * 0.42),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    // 1. Pastel Glowing Gradient Fill under the curve
    final fillPath = Path.from(path);
    fillPath.lineTo(w, h);
    fillPath.lineTo(0, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, h * 0.3),
        Offset(0, h),
        [
          (isNight ? const Color(0xFFE11D48) : const Color(0xFFFDA4AF)).withOpacity(0.32),
          (isNight ? const Color(0xFFA855F7) : const Color(0xFFE9D5FF)).withOpacity(0.20),
          (isNight ? const Color(0xFF3B82F6) : const Color(0xFFBFDBFE)).withOpacity(0.08),
          Colors.transparent,
        ],
        [0.0, 0.4, 0.75, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // 2. Vertical guide line at Jun (w * 0.74)
    final junX = w * 0.74;
    final junY = h * 0.45;
    final guidePaint = Paint()
      ..color = isNight ? Colors.white70 : const Color(0xFF0F172A)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(junX, 36), Offset(junX, h - 6), guidePaint);

    // 3. Multi-stop Gradient Stroke
    // Goes from salmon/red -> crimson -> purple -> sky blue (matching sanbox/graph.png)
    final strokePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(w, 0),
        [
          const Color(0xFFF87171), // Coral
          const Color(0xFFE11D48), // Rose
          const Color(0xFFC026D3), // Magenta / Purple
          const Color(0xFF818CF8), // Periwinkle
          const Color(0xFF3B82F6), // Sky Blue
        ],
        [0.0, 0.35, 0.65, 0.85, 1.0],
      )
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, strokePaint);

    // 4. Red/Coral Dot Marker at Mar (w * 0.44)
    final marX = w * 0.44;
    final marY = h * 0.58;

    // Outer glow
    canvas.drawCircle(
      Offset(marX, marY),
      7,
      Paint()..color = const Color(0xFFE11D48).withOpacity(0.22),
    );
    // Inner red dot
    canvas.drawCircle(
      Offset(marX, marY),
      4.5,
      Paint()..color = const Color(0xFFE11D48),
    );
    // Center white specular glint
    canvas.drawCircle(
      Offset(marX - 1, marY - 1),
      1.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _BezierGraphPainter oldDelegate) {
    return oldDelegate.isNight != isNight || oldDelegate.hoveredIndex != hoveredIndex;
  }
}

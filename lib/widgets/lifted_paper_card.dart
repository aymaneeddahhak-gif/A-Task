import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Real tactile lifted-paper task card matching `sanbox/card.png`.
/// Features golden-amber header, cream paper body, checklist items,
/// floating '+' button, and a physical 3D curled/lifted upper-left paper edge.
class LiftedPaperTaskCard extends StatefulWidget {
  final double liftIntensity; // 0.0 to 1.0 (default ~0.65 for realistic paper lift)
  final bool showLiftSlider;
  final VoidCallback? onAddTask;

  const LiftedPaperTaskCard({
    Key? key,
    this.liftIntensity = 0.70,
    this.showLiftSlider = false,
    this.onAddTask,
  }) : super(key: key);

  @override
  State<LiftedPaperTaskCard> createState() => _LiftedPaperTaskCardState();
}

class _LiftedPaperTaskCardState extends State<LiftedPaperTaskCard> with SingleTickerProviderStateMixin {
  late double _lift;
  late AnimationController _curlAnimController;

  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Update portfolio website.', 'isDone': true},
    {'title': 'Reply to client feedback.', 'isDone': true},
    {'title': 'Schedule X posts.', 'isDone': true},
    {'title': 'Export assets for dev handoff.', 'isDone': false},
    {'title': 'Boost top-performing post.', 'isDone': false},
  ];

  @override
  void initState() {
    super.initState();
    _lift = widget.liftIntensity;
    _curlAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      lowerBound: 0.2,
      upperBound: 1.0,
      value: widget.liftIntensity,
    );
  }

  @override
  void dispose() {
    _curlAnimController.dispose();
    super.dispose();
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['isDone'] = !_tasks[index]['isDone'];
    });
  }

  void _tapLiftedCorner() {
    // Subtle bounce when tapping the lifted corner of paper
    if (_curlAnimController.value > 0.8) {
      _curlAnimController.animateTo(0.5, curve: Curves.easeInOut);
    } else {
      _curlAnimController.animateTo(0.95, curve: Curves.easeOutBack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curlAnimController,
      builder: (context, _) {
        final liftVal = _curlAnimController.value;

        // Shadow offset and blur scale dynamically with the lift intensity
        final shadowOffsetX = -10.0 * liftVal;
        final shadowOffsetY = -8.0 * liftVal;
        final shadowBlur = 22.0 * liftVal + 6.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The Realistic 3D Lifted Paper Card Stack
            Center(
              child: SizedBox(
                width: 320,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Ambient Desk Shadow beneath the lifted upper-left paper edge
                    Positioned(
                      top: 4,
                      left: 4,
                      right: 4,
                      bottom: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            // Base ambient drop shadow
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                            // Asymmetrical lifted paper corner shadow (casting out towards top-left)
                            BoxShadow(
                              color: const Color(0xFF1E293B).withOpacity(0.24 * liftVal),
                              blurRadius: shadowBlur,
                              spreadRadius: 2.0 * liftVal,
                              offset: Offset(shadowOffsetX, shadowOffsetY),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. Physical Lifted Paper with 3D Perspective Matrix
                    Transform(
                      alignment: Alignment.bottomRight, // anchors at bottom right, lifting top-left
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0016) // 3D perspective depth
                        ..rotateZ(-0.022 * liftVal) // slight paper tilt
                        ..rotateX(0.038 * liftVal) // peeling upwards from desk
                        ..translate(shadowOffsetX * 0.4, shadowOffsetY * 0.4, 18.0 * liftVal),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Header: Golden Amber Gradient (#FBBF24 -> #F59E0B)
                                    _buildGoldenHeader(),

                                    // Body: Cream Paper (#FFFDF7) with checklist
                                    _buildCreamPaperBody(),
                                  ],
                                ),

                                // Upper-Left Paper Curl Shading & Highlight Layer
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  width: 90,
                                  height: 90,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _tapLiftedCorner,
                                    child: CustomPaint(
                                      painter: _PaperCurlShadingPainter(liftVal: liftVal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (widget.showLiftSlider) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.layers_outlined, size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  const Text(
                    'Paper Lift Intensity:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 140,
                    child: Slider(
                      value: _curlAnimController.value,
                      min: 0.1,
                      max: 1.0,
                      activeColor: const Color(0xFFF59E0B),
                      onChanged: (val) {
                        _curlAnimController.value = val;
                      },
                    ),
                  ),
                  Text(
                    '${(_curlAnimController.value * 100).round()}%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGoldenHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 22, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDC338), // Warm radiant gold
            Color(0xFFF59E0B), // Deep amber
            Color(0xFFF9A825), // Marigold
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: "Reminders" & "14:17"
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Reminders',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF261904),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '14:17',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF573B08),
                ),
              ),
            ],
          ),

          // Right: Frosted "Done" Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.0,
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF261904),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreamPaperBody() {
    return Container(
      width: double.infinity,
      transform: Matrix4.translationValues(0.0, -10.0, 0.0), // Curving over the amber header
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8), // Cream tactile paper
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title: "Tasks for Today"
              const Text(
                'Tasks for Today',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E24),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 18),

              // Checklist Items
              ...List.generate(_tasks.length, (index) {
                final item = _tasks[index];
                final isDone = item['isDone'] as bool;
                final text = item['title'] as String;

                return GestureDetector(
                  onTap: () => _toggleTask(index),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Checkbox Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? const Color(0xFF1E1E24) : Colors.transparent,
                            border: Border.all(
                              color: isDone ? const Color(0xFF1E1E24) : const Color(0xFFCBD5E1),
                              width: 1.5,
                            ),
                          ),
                          child: isDone
                              ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        // Task Description Text
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                              color: isDone ? const Color(0xFF1E1E24) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 14),
            ],
          ),

          // Floating Circular '+' Button at bottom right
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: widget.onAddTask,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: Color(0xFF1E1E24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter creating the subtle paper curl specular highlight & soft crease on the top-left corner
class _PaperCurlShadingPainter extends CustomPainter {
  final double liftVal;

  _PaperCurlShadingPainter({required this.liftVal});

  @override
  void paint(Canvas canvas, Size size) {
    if (liftVal < 0.1) return;

    // Soft corner gradient highlight simulating light hitting the curled flap
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.35 * liftVal),
          Colors.white.withOpacity(0.10 * liftVal),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(rect);

    // Diagonal curl crease shadow
    final creasePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.06 * liftVal),
          Colors.transparent,
        ],
        stops: const [0.4, 0.65, 0.9],
      ).createShader(rect);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, highlightPaint);
    canvas.drawPath(path, creasePaint);
  }

  @override
  bool shouldRepaint(covariant _PaperCurlShadingPainter oldDelegate) {
    return oldDelegate.liftVal != liftVal;
  }
}

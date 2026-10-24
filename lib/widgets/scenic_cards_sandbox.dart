import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ScenicSceneType {
  sunnyDesert,
  cloudyMountain,
  windyWindmill,
  fogLighthouse,
  snowCabin,
  rainyBoat,
}

class ScenicCardData {
  final ScenicSceneType scene;
  final String degree;
  final String condition;
  final String location;
  final String taskTitle;
  final String time;
  final String date;
  final List<Color> skyGradient;

  const ScenicCardData({
    required this.scene,
    required this.degree,
    required this.condition,
    required this.location,
    required this.taskTitle,
    required this.time,
    required this.date,
    required this.skyGradient,
  });
}

const List<ScenicCardData> kScenicCards = [
  ScenicCardData(
    scene: ScenicSceneType.sunnyDesert,
    degree: '23°',
    condition: 'Sunny',
    location: 'Beijing',
    taskTitle: 'Morning Strategy & Review',
    time: '09:30',
    date: 'Mon.Mar 26',
    skyGradient: [Color(0xFFFBC02D), Color(0xFFFDE047), Color(0xFFF59E0B)],
  ),
  ScenicCardData(
    scene: ScenicSceneType.cloudyMountain,
    degree: '18°',
    condition: 'Cloudy',
    location: 'Beijing',
    taskTitle: 'Product Design Sync',
    time: '14:10',
    date: 'Mon.Mar 26',
    skyGradient: [Color(0xFF7DD3FC), Color(0xFFBAE6FD), Color(0xFF93C5FD)],
  ),
  ScenicCardData(
    scene: ScenicSceneType.windyWindmill,
    degree: '14°',
    condition: 'Windy',
    location: 'Beijing',
    taskTitle: 'Frontend Sprint Focus',
    time: '16:15',
    date: 'Mon.Mar 26',
    skyGradient: [Color(0xFFA8CA7A), Color(0xFFCDE4A4), Color(0xFFB5D686)],
  ),
  ScenicCardData(
    scene: ScenicSceneType.fogLighthouse,
    degree: '20°',
    condition: 'Fog',
    location: 'Beijing',
    taskTitle: 'Architecture Deep Dive',
    time: '10:20',
    date: 'Mon.Mar 26',
    skyGradient: [Color(0xFF94A8BE), Color(0xFFCBD9E6), Color(0xFFDCE6F0)],
  ),
  ScenicCardData(
    scene: ScenicSceneType.snowCabin,
    degree: '-3°',
    condition: 'Snow',
    location: 'Beijing',
    taskTitle: 'Release Notes & QA',
    time: '11:30',
    date: 'Fri.Dec 15',
    skyGradient: [Color(0xFF818CF8), Color(0xFFA5B4FC), Color(0xFFC7D2FE)],
  ),
  ScenicCardData(
    scene: ScenicSceneType.rainyBoat,
    degree: '12°',
    condition: 'Rainy',
    location: 'Beijing',
    taskTitle: 'Evening Reflection Log',
    time: '19:40',
    date: 'Mon.Mar 26',
    skyGradient: [Color(0xFF475569), Color(0xFF64748B), Color(0xFF4E5E76)],
  ),
];

/// Interactive Sandbox showcase of all 6 cards from `designcard.png`
/// featuring a realistic 3D top-left corner curl on every card.
class ScenicCardsSandboxShowcase extends StatefulWidget {
  const ScenicCardsSandboxShowcase({super.key});

  @override
  State<ScenicCardsSandboxShowcase> createState() =>
      _ScenicCardsSandboxShowcaseState();
}

class _ScenicCardsSandboxShowcaseState
    extends State<ScenicCardsSandboxShowcase> {
  double _curlSize = 36.0;
  bool _twoColumnGrid = true;
  bool _showTaskLabels = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Controls Card
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '6 SCENIC CARDS • TOP-LEFT CURL',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB45309),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Layout toggle (2x3 Grid vs 1-Column Large)
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
                            size: 14,
                            color: const Color(0xFF0F172A),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _twoColumnGrid ? '2x3 Grid' : 'Large Stack',
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
                  // Label mode toggle
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showTaskLabels = !_showTaskLabels),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _showTaskLabels
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _showTaskLabels ? 'Task Mode' : 'Exact Image',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _showTaskLabels
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Curl Slider
              Row(
                children: [
                  const Icon(
                    Icons.filter_none_rounded,
                    size: 15,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Top-Left Corner Curl:',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
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
                        min: 20.0,
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
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Grid or Stack of all 6 Scenic Curled Cards
        if (_twoColumnGrid)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kScenicCards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.96,
            ),
            itemBuilder: (context, index) {
              return ScenicCurledCard(
                data: kScenicCards[index],
                curlSize: _curlSize,
                compact: true,
                showTaskSubtitle: _showTaskLabels,
              );
            },
          )
        else
          Column(
            children: kScenicCards
                .map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 215,
                      width: double.infinity,
                      child: ScenicCurledCard(
                        data: card,
                        curlSize: _curlSize + 6,
                        compact: false,
                        showTaskSubtitle: _showTaskLabels,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

/// Individual Scenic Card from `designcard.png` with a realistic 3D curled
/// upper-left corner, vector landscape illustration, and crisp white footer bar.
class ScenicCurledCard extends StatelessWidget {
  final ScenicCardData data;
  final double curlSize;
  final bool compact;
  final bool showTaskSubtitle;

  const ScenicCurledCard({
    super.key,
    required this.data,
    this.curlSize = 36.0,
    this.compact = false,
    this.showTaskSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = compact ? 16.0 : 20.0;
    final double effectiveCurl = compact ? curlSize * 0.85 : curlSize;

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
                  flex: 74,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Custom Scenic Vector Artwork
                      CustomPaint(
                        painter: _ScenicIllustrationPainter(
                          scene: data.scene,
                          skyGradient: data.skyGradient,
                        ),
                      ),

                      // Top-Left Degree, Condition & Location Text
                      // Positioned gracefully accounting for the top-left corner curl
                      Positioned(
                        left: compact ? 14 : 22,
                        top: compact
                            ? math.max(14, effectiveCurl * 0.52)
                            : math.max(18, effectiveCurl * 0.55),
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  data.degree,
                                  style: GoogleFonts.poppins(
                                    fontSize: compact ? 26 : 34,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.05,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.14,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    data.condition,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: compact ? 12 : 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(
                                        alpha: 0.95,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(
                              showTaskSubtitle ? data.taskTitle : data.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: compact ? 10 : 12.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom White Bar (~26% height): Time on left, Date on right
                Expanded(
                  flex: 26,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 12 : 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.time,
                          style: GoogleFonts.poppins(
                            fontSize: compact ? 15 : 19,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          data.date,
                          style: GoogleFonts.poppins(
                            fontSize: compact ? 10 : 12.5,
                            fontWeight: FontWeight.w400,
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
                accentColor: data.skyGradient.first,
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
    // Start at top edge after the curl fold
    path.moveTo(c, 0);
    // Top-right rounded corner
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    // Bottom-right rounded corner
    path.lineTo(size.width, size.height - r);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - r,
      size.height,
    );
    // Bottom-left rounded corner
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    // Left edge up to the curl fold
    path.lineTo(0, c);
    // Diagonal fold line from (0, c) to (c, 0) with a slight inward curve
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

/// Paints the 3D curled paper flap on the top-left corner, including:
/// 1. The cast shadow on the card surface beneath the curled flap.
/// 2. The rolled back-side of the paper with cylindrical specular highlight & gradient.
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
    // Anchored at (0, c) and (c, 0), with its peeled corner tip curling down-right to (c*0.88, c*0.88)
    final flapPath = Path()
      ..moveTo(0, c)
      // Crease / fold spine curving gently
      ..quadraticBezierTo(c * 0.46, c * 0.46, c, 0)
      // Top-right curled edge sweeps down to the folded corner tip
      ..quadraticBezierTo(c * 0.94, c * 0.56, c * 0.88, c * 0.88)
      // Left curled edge sweeps back to (0, c)
      ..quadraticBezierTo(c * 0.56, c * 0.94, 0, c)
      ..close();

    // Cylindrical paper gradient simulating light hitting the curved underside of the paper
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

    // Base Sky Gradient
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

  /// 1. Top-Left Card: 23° Sunny — Golden desert dunes, concentric sun, camping tent
  void _paintSunnyDesert(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Concentric glowing sun at top-right
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

    // Distant soft amber dune
    final backDune = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.28, h * 0.56, w * 0.62, h * 0.66)
      ..quadraticBezierTo(w * 0.84, h * 0.72, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backDune, Paint()..color = const Color(0xFFF59E0B));

    // Mid warm orange dune
    final midDune = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.36, h * 0.68, w * 0.72, h * 0.74)
      ..quadraticBezierTo(w * 0.90, h * 0.77, w, h * 0.71)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midDune, Paint()..color = const Color(0xFFD97706));

    // Foreground rich golden-brown desert floor
    final frontDune = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.45, h * 0.77, w, h * 0.84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontDune, Paint()..color = const Color(0xFFB45309));

    // Camping Tent on the right-center dune
    final tentBaseY = h * 0.75;
    final tentCenterX = w * 0.65;
    final tentW = w * 0.22;
    final tentH = h * 0.17;

    // Tent main body (warm golden yellow-orange side)
    final tentBody = Path()
      ..moveTo(tentCenterX - tentW * 0.5, tentBaseY)
      ..lineTo(tentCenterX - tentW * 0.08, tentBaseY - tentH)
      ..lineTo(tentCenterX + tentW * 0.52, tentBaseY - tentH * 0.06)
      ..close();
    canvas.drawPath(tentBody, Paint()..color = const Color(0xFFFBBF24));

    // Tent dark brown front entrance triangle
    final tentFront = Path()
      ..moveTo(tentCenterX - tentW * 0.5, tentBaseY)
      ..lineTo(tentCenterX - tentW * 0.08, tentBaseY - tentH)
      ..lineTo(tentCenterX + tentW * 0.06, tentBaseY)
      ..close();
    canvas.drawPath(tentFront, Paint()..color = const Color(0xFF92400E));

    // Inner dark doorway slit
    final tentDoor = Path()
      ..moveTo(tentCenterX - tentW * 0.28, tentBaseY)
      ..lineTo(tentCenterX - tentW * 0.08, tentBaseY - tentH * 0.75)
      ..lineTo(tentCenterX - tentW * 0.02, tentBaseY)
      ..close();
    canvas.drawPath(tentDoor, Paint()..color = const Color(0xFF451A03));

    // Small desert stones
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.40, h * 0.78),
        width: w * 0.04,
        height: h * 0.022,
      ),
      Paint()..color = const Color(0xFF78350F),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.86, h * 0.82),
        width: w * 0.03,
        height: h * 0.018,
      ),
      Paint()..color = const Color(0xFF78350F),
    );
  }

  /// 2. Top-Right Card: 18° Cloudy — Sky blue mountains, sun & cloud, tall birch tree trunks
  void _paintCloudyMountain(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Glowing white sun on upper right
    final sunCenter = Offset(w * 0.65, h * 0.25);
    canvas.drawCircle(
      sunCenter,
      w * 0.055,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );

    // Soft horizontal cloud wisps near sun
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

    // Distant pale blue mountain range
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

    // Mid cornflower-blue mountain slope
    final midMountain = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.32, h * 0.62, w * 0.68, h * 0.74)
      ..quadraticBezierTo(w * 0.86, h * 0.80, w, h * 0.72)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midMountain, Paint()..color = const Color(0xFF60A5FA));

    // Foreground deeper blue ridge
    final frontHill = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.45, h * 0.76, w, h * 0.85)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF3B82F6));

    // Two tall vertical stylized birch trees on the right (matching designcard.png)
    _drawBirchTrunk(canvas, w * 0.77, h, w * 0.026);
    _drawBirchTrunk(canvas, w * 0.88, h, w * 0.020);
  }

  void _drawBirchTrunk(Canvas canvas, double x, double h, double trunkW) {
    final trunkPaint = Paint()..color = const Color(0xFFE0F2FE);
    canvas.drawRect(Rect.fromLTWH(x, 0, trunkW, h), trunkPaint);

    // Small side branches
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

    // Subtle bark horizontal markings
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

  /// 3. Middle-Left Card: 14° Windy — Rolling green hills, pine trees & Dutch windmill
  void _paintWindyWindmill(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Distant soft green hill
    final backHill = Path()
      ..moveTo(0, h * 0.68)
      ..quadraticBezierTo(w * 0.35, h * 0.54, w * 0.75, h * 0.66)
      ..quadraticBezierTo(w * 0.90, h * 0.70, w, h * 0.63)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backHill, Paint()..color = const Color(0xFF9BC56D));

    // Mid meadow hill
    final midHill = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.42, h * 0.66, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midHill, Paint()..color = const Color(0xFF82B352));

    // Foreground rich olive-green hill
    final frontHill = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.48, h * 0.77, w, h * 0.86)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF689B3B));

    // Small pine trees scattered on hills
    _drawPineTree(
      canvas,
      Offset(w * 0.22, h * 0.76),
      w * 0.04,
      h * 0.09,
      const Color(0xFF4D7C2B),
    );
    _drawPineTree(
      canvas,
      Offset(w * 0.30, h * 0.79),
      w * 0.032,
      h * 0.07,
      const Color(0xFF5C8D36),
    );
    _drawPineTree(
      canvas,
      Offset(w * 0.56, h * 0.74),
      w * 0.036,
      h * 0.08,
      const Color(0xFF4D7C2B),
    );

    // Classic Dutch Windmill on the right
    final millX = w * 0.77;
    final millBaseY = h * 0.78;
    final millW = w * 0.14;
    final millH = h * 0.34;

    // Windmill tower body
    final towerPath = Path()
      ..moveTo(millX - millW * 0.48, millBaseY)
      ..lineTo(millX - millW * 0.28, millBaseY - millH)
      ..lineTo(millX + millW * 0.28, millBaseY - millH)
      ..lineTo(millX + millW * 0.48, millBaseY)
      ..close();
    canvas.drawPath(towerPath, Paint()..color = const Color(0xFF558B2F));

    // Windmill dark olive dome cap
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

    // Small white window on tower
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(millX, millBaseY - millH * 0.55),
        width: millW * 0.18,
        height: millH * 0.14,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // 4 White Windmill Sails (rotated at 45°)
    final hub = Offset(millX, millBaseY - millH * 0.92);
    final bladeLen = w * 0.21;
    final bladePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final angle = (math.pi / 4) + i * (math.pi / 2);
      final tip = Offset(
        hub.dx + math.cos(angle) * bladeLen,
        hub.dy + math.sin(angle) * bladeLen,
      );
      canvas.drawLine(hub, tip, bladePaint);

      // Rectangular lattice sail alongside the spoke
      final perp = angle + math.pi / 2;
      final sailW = w * 0.032;
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

  /// 4. Middle-Right Card: 20° Fog — Misty hills, sun, birds & striped lighthouse
  void _paintFogLighthouse(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft white sun in misty sky
    canvas.drawCircle(
      Offset(w * 0.62, h * 0.30),
      w * 0.048,
      Paint()..color = Colors.white.withValues(alpha: 0.90),
    );

    // Two flying birds (seagull silhouettes)
    _drawBird(canvas, Offset(w * 0.48, h * 0.42), w * 0.032);
    _drawBird(canvas, Offset(w * 0.56, h * 0.48), w * 0.024);

    // Distant misty slate hill
    final farMist = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.35, h * 0.60, w * 0.72, h * 0.68)
      ..quadraticBezierTo(w * 0.88, h * 0.72, w, h * 0.66)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farMist, Paint()..color = const Color(0xFFB0C1D4));

    // Mid coastal wave/hill
    final midMist = Path()
      ..moveTo(0, h * 0.82)
      ..quadraticBezierTo(w * 0.45, h * 0.70, w, h * 0.77)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midMist, Paint()..color = const Color(0xFF8FA6BE));

    // Foreground slate-blue cliff
    final frontCliff = Path()
      ..moveTo(0, h * 0.90)
      ..quadraticBezierTo(w * 0.52, h * 0.78, w, h * 0.84)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontCliff, Paint()..color = const Color(0xFF728CA8));

    // Striped Lighthouse on right cliff
    final lhX = w * 0.80;
    final lhBaseY = h * 0.82;
    final lhW = w * 0.11;
    final lhH = h * 0.42;

    final towerPath = Path()
      ..moveTo(lhX - lhW * 0.48, lhBaseY)
      ..lineTo(lhX - lhW * 0.30, lhBaseY - lhH)
      ..lineTo(lhX + lhW * 0.30, lhBaseY - lhH)
      ..lineTo(lhX + lhW * 0.48, lhBaseY)
      ..close();

    canvas.save();
    canvas.clipPath(towerPath);
    // White lighthouse base
    canvas.drawPath(towerPath, Paint()..color = Colors.white);
    // Slate horizontal stripes
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

    // Gallery deck bar
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(lhX, lhBaseY - lhH),
        width: lhW * 0.82,
        height: 3.0,
      ),
      Paint()..color = const Color(0xFF3E566E),
    );

    // Lantern room (warm glowing light inside)
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(lhX, lhBaseY - lhH - lhH * 0.08),
        width: lhW * 0.48,
        height: lhH * 0.14,
      ),
      Paint()..color = const Color(0xFFFEF08A),
    );

    // Pointed cupola roof
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

  /// 5. Bottom-Left Card: -3° Snow — Lavender snowdrifts, snowflakes & cozy lit cabin
  void _paintSnowCabin(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Falling white snowflakes in sky
    final snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    final flakes = [
      Offset(w * 0.48, h * 0.18),
      Offset(w * 0.64, h * 0.14),
      Offset(w * 0.82, h * 0.22),
      Offset(w * 0.55, h * 0.34),
      Offset(w * 0.74, h * 0.32),
      Offset(w * 0.36, h * 0.44),
      Offset(w * 0.88, h * 0.40),
    ];
    for (int i = 0; i < flakes.length; i++) {
      canvas.drawCircle(flakes[i], i.isEven ? 2.2 : 1.5, snowPaint);
    }

    // Distant soft lavender snow slope
    final backSnow = Path()
      ..moveTo(0, h * 0.70)
      ..quadraticBezierTo(w * 0.38, h * 0.58, w * 0.76, h * 0.68)
      ..quadraticBezierTo(w * 0.90, h * 0.72, w, h * 0.65)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(backSnow, Paint()..color = const Color(0xFFC7D2FE));

    // Mid snowdrift
    final midSnow = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.45, h * 0.68, w, h * 0.76)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midSnow, Paint()..color = const Color(0xFFDDE4FF));

    // Foreground crisp white-lavender snow blanket
    final frontSnow = Path()
      ..moveTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.50, h * 0.78, w, h * 0.86)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontSnow, Paint()..color = const Color(0xFFEEF2FF));

    // Snow-laden pine trees on the left/center
    _drawPineTree(
      canvas,
      Offset(w * 0.25, h * 0.77),
      w * 0.048,
      h * 0.11,
      const Color(0xFF6366F1),
    );
    _drawPineTree(
      canvas,
      Offset(w * 0.34, h * 0.80),
      w * 0.036,
      h * 0.08,
      const Color(0xFF818CF8),
    );

    // Cozy Winter Cabin on the right
    final cabX = w * 0.74;
    final cabBaseY = h * 0.80;
    final cabW = w * 0.24;
    final cabH = h * 0.16;

    // Cabin purple wall
    canvas.drawRect(
      Rect.fromLTWH(cabX - cabW / 2, cabBaseY - cabH, cabW, cabH),
      Paint()..color = const Color(0xFF6366F1),
    );

    // Cabin pitched gable wall
    final gablePath = Path()
      ..moveTo(cabX - cabW / 2, cabBaseY - cabH)
      ..lineTo(cabX, cabBaseY - cabH * 1.65)
      ..lineTo(cabX + cabW / 2, cabBaseY - cabH)
      ..close();
    canvas.drawPath(gablePath, Paint()..color = const Color(0xFF4F46E5));

    // Thick white snow-covered roof overhang
    final snowRoof = Path()
      ..moveTo(cabX - cabW * 0.58, cabBaseY - cabH * 0.94)
      ..lineTo(cabX, cabBaseY - cabH * 1.72)
      ..lineTo(cabX + cabW * 0.58, cabBaseY - cabH * 0.94)
      ..close();
    canvas.drawPath(
      snowRoof,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Two warm glowing yellow windows
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

  /// 6. Bottom-Right Card: 12° Rainy — Slate lake, rain streaks, boat & glowing lanterns
  void _paintRainyBoat(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Distant dark mountain range
    final mountains = Path()
      ..moveTo(0, h * 0.65)
      ..quadraticBezierTo(w * 0.25, h * 0.48, w * 0.55, h * 0.60)
      ..quadraticBezierTo(w * 0.80, h * 0.50, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mountains, Paint()..color = const Color(0xFF334155));

    // Calm dark lake water surface in foreground (bottom 38%)
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.62, w, h * 0.38),
      Paint()..color = const Color(0xFF3B495E),
    );

    // Diagonal rain streaks across the sky
    final rainPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    final rainSeeds = [
      Offset(w * 0.46, h * 0.16),
      Offset(w * 0.58, h * 0.24),
      Offset(w * 0.72, h * 0.14),
      Offset(w * 0.84, h * 0.26),
      Offset(w * 0.64, h * 0.42),
      Offset(w * 0.36, h * 0.48),
    ];
    for (final pt in rainSeeds) {
      canvas.drawLine(pt, Offset(pt.dx - 5, pt.dy + 12), rainPaint);
    }

    // 3 Floating Yellow Paper Lanterns on the water
    _drawFloatingLantern(canvas, Offset(w * 0.22, h * 0.80), w * 0.028);
    _drawFloatingLantern(canvas, Offset(w * 0.45, h * 0.74), w * 0.022);
    _drawFloatingLantern(canvas, Offset(w * 0.56, h * 0.86), w * 0.032);

    // Wooden/slate rowboat on the right side of the lake
    final boatX = w * 0.82;
    final boatY = h * 0.77;
    final boatW = w * 0.28;
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

    // Glowing lantern sitting inside the boat
    _drawFloatingLantern(
      canvas,
      Offset(boatX - boatW * 0.12, boatY - boatH * 0.55),
      w * 0.030,
    );
  }

  void _drawFloatingLantern(Canvas canvas, Offset pos, double size) {
    // Soft golden ambient glow
    canvas.drawCircle(
      pos,
      size * 2.2,
      Paint()
        ..color = const Color(0xFFFACC15).withValues(alpha: 0.24)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Warm water reflection line below
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(pos.dx, pos.dy + size * 0.9),
        width: size * 1.6,
        height: size * 0.35,
      ),
      Paint()..color = const Color(0xFFFDE047).withValues(alpha: 0.45),
    );
    // Lantern core
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

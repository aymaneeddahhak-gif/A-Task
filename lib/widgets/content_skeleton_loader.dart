import 'package:flutter/material.dart';

/// Sweeping shimmer gradient inspired by Uiverse.io by mrhyddenn
/// Replicated for Facebook-style full-page content skeleton loading.
class ContentSkeletonLoader extends StatefulWidget {
  final bool isNight;
  final Widget child;

  const ContentSkeletonLoader({
    Key? key,
    this.isNight = false,
    required this.child,
  }) : super(key: key);

  static LinearGradient of(BuildContext context) {
    final _InheritedShimmerGradient? inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedShimmerGradient>();
    return inherited?.gradient ?? _defaultGradient(false, 0.0);
  }

  static LinearGradient _defaultGradient(bool isNight, double animVal) {
    final double offset = -1.5 + (animVal * 3.0);
    if (isNight) {
      return LinearGradient(
        begin: Alignment(offset, -0.3),
        end: Alignment(offset + 1.8, 0.3),
        colors: const [
          Color(0xFF1E293B),
          Color(0xFF334155),
          Color(0xFF475569),
          Color(0xFF334155),
          Color(0xFF1E293B),
        ],
        stops: const [0.20, 0.38, 0.40, 0.45, 0.60],
      );
    }
    return LinearGradient(
      begin: Alignment(offset, -0.3),
      end: Alignment(offset + 1.8, 0.3),
      colors: const [
        Color(0xFFE5E5E5),
        Color(0xFFF0F0F0),
        Color(0xFFF6F6F6),
        Color(0xFFF0F0F0),
        Color(0xFFE5E5E5),
      ],
      stops: const [0.20, 0.38, 0.40, 0.45, 0.60],
    );
  }

  @override
  State<ContentSkeletonLoader> createState() => _ContentSkeletonLoaderState();
}

class _ContentSkeletonLoaderState extends State<ContentSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, _) {
        final gradient = ContentSkeletonLoader._defaultGradient(
          widget.isNight,
          _animCtrl.value,
        );
        return _InheritedShimmerGradient(
          gradient: gradient,
          child: widget.child,
        );
      },
    );
  }
}

class _InheritedShimmerGradient extends InheritedWidget {
  final LinearGradient gradient;

  const _InheritedShimmerGradient({
    Key? key,
    required this.gradient,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedShimmerGradient oldWidget) {
    return oldWidget.gradient != gradient;
  }
}

/// A single skeleton wireframe piece (bar, pill, circle, card)
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  const SkeletonBox({
    Key? key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.margin,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = ContentSkeletonLoader.of(context);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
        gradient: gradient,
      ),
      child: child,
    );
  }
}

/// Facebook-style content skeleton wireframe matching the exact layout of HomeScreen
class HomeScreenSkeleton extends StatelessWidget {
  final bool isNight;
  final Color? backgroundColor;

  const HomeScreenSkeleton({
    Key? key,
    this.isNight = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ??
        (isNight ? const Color(0xFF0F172A) : const Color(0xFFF2F7FC));
    final cardBorderCol = isNight ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return ContentSkeletonLoader(
      isNight: isNight,
      child: Container(
        color: bg,
        child: SafeArea(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // 1. Top Header: User avatar + Greeting text + Atmosphere & Bell circles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Avatar circle (46x46)
                      const SkeletonBox(
                        width: 46,
                        height: 46,
                        shape: BoxShape.circle,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Mode label skeleton (No "Good"!)
                          SkeletonBox(width: 64, height: 12, borderRadius: 6),
                          SizedBox(height: 6),
                          // "AYMANE" name skeleton
                          SkeletonBox(width: 100, height: 18, borderRadius: 6),
                        ],
                      ),
                    ],
                  ),
                  // Notification bell circle (40x40)
                  const SkeletonBox(width: 40, height: 40, shape: BoxShape.circle),
                ],
              ),

              const SizedBox(height: 14),

              // Animated 4-Mode Selector Dock skeleton (Auto • Morning • Afternoon • Night)
              const SkeletonBox(width: double.infinity, height: 38, borderRadius: 20),

              const SizedBox(height: 18),

              // 2. Headline: "Let's Make\nToday Productive"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 130, height: 20, borderRadius: 6),
                  SizedBox(height: 6),
                  SkeletonBox(width: 175, height: 20, borderRadius: 6),
                ],
              ),

              const SizedBox(height: 14),

              // 3. Today Progress Card Skeleton (height ~146)
              Container(
                height: 146,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isNight ? const Color(0xFF1E293B).withOpacity(0.8) : Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: cardBorderCol.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isNight ? 0.2 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Mini pill + Daily progress text + 3 stat lines
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SkeletonBox(width: 86, height: 18, borderRadius: 12),
                        const SkeletonBox(width: 120, height: 16, borderRadius: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SkeletonBox(width: 100, height: 10, borderRadius: 4),
                            SizedBox(height: 5),
                            SkeletonBox(width: 90, height: 10, borderRadius: 4),
                            SizedBox(height: 5),
                            SkeletonBox(width: 95, height: 10, borderRadius: 4),
                          ],
                        ),
                      ],
                    ),

                    // Right: Circular progress ring wireframe
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: isNight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBorderCol.withOpacity(0.4), width: 6),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SkeletonBox(width: 38, height: 14, borderRadius: 4),
                            SizedBox(height: 4),
                            SkeletonBox(width: 48, height: 8, borderRadius: 3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Section Header: "Plans & Tasks" + Filter Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SkeletonBox(width: 130, height: 20, borderRadius: 6),
                  SkeletonBox(width: 44, height: 44, borderRadius: 10),
                ],
              ),

              const SizedBox(height: 12),

              // 5. Filter Pills Row (All, To Do, In Progress, In Review, Done)
              Row(
                children: const [
                  SkeletonBox(width: 52, height: 38, borderRadius: 19),
                  SizedBox(width: 8),
                  SkeletonBox(width: 68, height: 38, borderRadius: 19),
                  SizedBox(width: 8),
                  SkeletonBox(width: 96, height: 38, borderRadius: 19),
                  SizedBox(width: 8),
                  SkeletonBox(width: 84, height: 38, borderRadius: 19),
                  SizedBox(width: 8),
                  SkeletonBox(width: 58, height: 38, borderRadius: 19),
                ],
              ),

              const SizedBox(height: 12),

              // Random Task pill skeleton under Filter Pills Row
              const Align(
                alignment: Alignment.centerLeft,
                child: SkeletonBox(width: 104, height: 32, borderRadius: 12),
              ),

              const SizedBox(height: 16),

              // 6. Task Card Wireframes (3 wireframe cards like Facebook feed items)
              _buildTaskCardSkeleton(isNight, cardBorderCol),
              const SizedBox(height: 10),
              _buildTaskCardSkeleton(isNight, cardBorderCol),
              const SizedBox(height: 10),
              _buildTaskCardSkeleton(isNight, cardBorderCol),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTaskCardSkeleton(bool isNight, Color borderCol) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNight ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderCol.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isNight ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left accent stripe
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isNight ? const Color(0xFF38BDF8).withOpacity(0.4) : const Color(0xFF60A5FA).withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 14),

          // Middle: Title + Time/Project lines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SkeletonBox(width: 160, height: 14, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonBox(width: 110, height: 11, borderRadius: 4),
              ],
            ),
          ),

          // Right: Pill tag + Circular checkbox
          Row(
            children: const [
              SkeletonBox(width: 54, height: 22, borderRadius: 11),
              SizedBox(width: 10),
              SkeletonBox(width: 24, height: 24, shape: BoxShape.circle),
            ],
          ),
        ],
      ),
    );
  }
}

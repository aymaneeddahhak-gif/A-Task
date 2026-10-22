import 'package:flutter/material.dart';

/// Loading shimmer card replicated from Uiverse.io by mrhyddenn
/// Features a circle skeleton on the left and title + description skeleton on the right
/// with an animated sweeping gradient.
class ShimmerLoadingCard extends StatefulWidget {
  final double width;
  final double height;

  const ShimmerLoadingCard({
    Key? key,
    this.width = 190,
    this.height = 90,
  }) : super(key: key);

  @override
  State<ShimmerLoadingCard> createState() => _ShimmerLoadingCardState();
}

class _ShimmerLoadingCardState extends State<ShimmerLoadingCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LinearGradient _buildShimmerGradient(double animVal) {
    // Simulates background-size: 200% 100% and animation: load89234 2s infinite
    final double offset = -1.5 + (animVal * 3.0);
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final gradient = _buildShimmerGradient(_controller.value);

        return Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 25,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // card_load: 68x68 circular skeleton
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradient,
                ),
              ),

              const SizedBox(width: 10),

              // Right Column: Title + Description
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // card_load_extreme_title: 10px high rounded bar
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: gradient,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // card_load_extreme_descripion: 46px high rounded box
                    Container(
                      width: double.infinity,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: gradient,
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
}

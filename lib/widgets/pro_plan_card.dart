import 'package:flutter/material.dart';

/// Pro Plan Subscription Modal Card matching `sanbox/plan.png`.
/// Features frosted translucent container, neon lime `4x Pro` pill badge,
/// circular `✕` close button, "Upgrade To Pro" headline, feature highlights,
/// and "Upgrade Plan →" button.
class ProPlanCard extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onUpgrade;
  final bool isModal;

  const ProPlanCard({
    Key? key,
    this.onClose,
    this.onUpgrade,
    this.isModal = false,
  }) : super(key: key);

  @override
  State<ProPlanCard> createState() => _ProPlanCardState();
}

class _ProPlanCardState extends State<ProPlanCard> {
  final List<String> _features = [
    'Autonomous AI Chatbot Task Creation & CRUD',
    'Real-time Atmospheric Themes & Lighting',
    'Deep Work Focus & Velocity Bézier Analytics',
    'Voice & Audio Prompt Task Dictation',
    'Unlimited Escalation Rules & Priority Sync',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          // Soft frosted translucent card matching sanbox/plan.png
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF6F8F3), // Translucent pale mint-cream
              Color(0xFFEEF3EA),
              Color(0xFFE8EFE5),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Row: "4x Pro" Lime Badge + Close '✕' Circle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Neon Lime "4x Pro" Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7FA65), // Neon lime matching sanbox/plan.png
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD7FA65).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '4x Pro',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF142407),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),

                // White Circular Close Button
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Headline: "Upgrade To Pro"
            const Text(
              'Upgrade To Pro',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 8),

            // 3. Subtitle Description
            const Text(
              'Unlock Automations And\nUnlimited Escalation Rules.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
                height: 1.38,
              ),
            ),

            const SizedBox(height: 16),

            // 4. Feature Highlights List (Provided More Features After Upgrading)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.45),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 1,
                ),
              ),
              child: Column(
                children: _features.map((feat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 15,
                          color: Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feat,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 5. White Rounded Pill CTA Button: "Upgrade Plan →"
            GestureDetector(
              onTap: widget.onUpgrade,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Upgrade Plan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Color(0xFF111827),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

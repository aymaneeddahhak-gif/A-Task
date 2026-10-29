import 'package:flutter/material.dart';
import '../state/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/circular_progress_ring.dart';
import '../widgets/task_card.dart';
import '../widgets/content_skeleton_loader.dart';
import '../widgets/lifted_paper_card.dart';
import '../widgets/analytics_graph_card.dart';
import '../widgets/pro_plan_card.dart';
import '../widgets/scenic_cards_sandbox.dart';

class DesignSandboxScreen extends StatefulWidget {
  final TaskProvider provider;

  const DesignSandboxScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<DesignSandboxScreen> createState() => _DesignSandboxScreenState();
}

class _DesignSandboxScreenState extends State<DesignSandboxScreen> {
  int _selectedTab = 0; // 0: Sandbox Showcase, 1: Lifted Paper Card, 2: Analytics Graph, 3: Pro Plan, 4: 3D Mascot, 5: Header Lab, 6: Skeleton Lab
  int _atmosphereIndex = 0; // 0: Morning (Light Blue), 1: Afternoon (Warm Orange), 2: Night (Dark with Stars)
  double _fadeSpread = 0.55; // How far the color touches the middle
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final canvasBg = _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = _isDarkMode ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final textSecondary = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderCol = _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: canvasBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: textPrimary, size: 20),
                            onPressed: () => widget.provider.closeDesignSandbox(),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Design Sandbox',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'STUDIO',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Isolated prototype studio • New Sandbox Designs',
                                style: TextStyle(fontSize: 11, color: textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Dark / Light Toggle
                      Row(
                        children: [
                          Text(
                            _isDarkMode ? 'Dark' : 'Light',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textSecondary),
                          ),
                          const SizedBox(width: 6),
                          Switch(
                            value: _isDarkMode,
                            activeColor: const Color(0xFF6366F1),
                            onChanged: (val) => setState(() => _isDarkMode = val),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Mode Tabs with Smooth Horizontal Scrolling
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTabButton(0, 'Scenic Cards', borderCol, icon: Icons.landscape_rounded),
                        const SizedBox(width: 6),
                        _buildTabButton(1, 'All Showcase', borderCol, icon: Icons.auto_awesome_rounded),
                        const SizedBox(width: 6),
                        _buildTabButton(2, 'Paper Card', borderCol, icon: Icons.note_alt_outlined),
                        const SizedBox(width: 6),
                        _buildTabButton(3, 'Analytics', borderCol, icon: Icons.show_chart_rounded),
                        const SizedBox(width: 6),
                        _buildTabButton(4, 'Pro Plan', borderCol, icon: Icons.verified_outlined),
                        const SizedBox(width: 6),
                        _buildTabButton(5, '3D Mascot', borderCol, icon: Icons.smart_toy_rounded),
                        const SizedBox(width: 6),
                        _buildTabButton(6, 'Header Lab', borderCol, icon: Icons.wb_twilight_rounded),
                        const SizedBox(width: 6),
                        _buildTabButton(7, 'Skeleton', borderCol, icon: Icons.view_quilt_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_selectedTab == 0) ...[
                    // Tab 0: Dedicated 6 Scenic Cards with Top-Left Corner Curl (designcard.png)
                    _buildSectionTitle(
                      title: 'Scenic Illustrated Cards (Top-Left Curl)',
                      subtitle: 'All 6 scenic cards from designcard.png with realistic 3D top-left corner paper curl.',
                      icon: Icons.landscape_rounded,
                      badgeText: 'designcard.png',
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 14),
                    ScenicCardsSandboxShowcase(provider: widget.provider),
                  ] else if (_selectedTab == 1) ...[
                    // Tab 1: All New Sandbox Designs Showcase (Scenic Cards, Lifted Paper Card, Analytics Graph, Pro Plan, Mascot)
                    _buildSandboxShowcase(cardBg, textPrimary, textSecondary, borderCol),
                  ] else if (_selectedTab == 2) ...[
                    // Tab 2: Dedicated Lifted Paper Card Deep Dive
                    _buildLiftedPaperDeepDive(cardBg, textPrimary, textSecondary, borderCol),
                  ] else if (_selectedTab == 3) ...[
                    // Tab 3: Dedicated Analytical Bézier Graph Lab
                    _buildAnalyticsGraphLab(cardBg, textPrimary, textSecondary, borderCol),
                  ] else if (_selectedTab == 4) ...[
                    // Tab 4: Dedicated Pro Plan Subscription Lab
                    _buildProPlanLab(cardBg, textPrimary, textSecondary, borderCol),
                  ] else if (_selectedTab == 5) ...[
                    // Tab 5: 3D Chatbot Mascot Showcase
                    _buildMascotShowcase(cardBg, textPrimary, textSecondary, borderCol),
                  ] else if (_selectedTab == 6) ...[
                    // Tab 6: Atmospheric Header Lab
                    _buildAtmosphericHeaderLab(cardBg, textPrimary, textSecondary, borderCol),
                  ] else ...[
                    // Tab 7: Facebook-Style Content Skeleton Lab
                    _buildSkeletonLab(cardBg, textPrimary, textSecondary, borderCol),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title, Color borderCol, {IconData? icon}) {
    final isSel = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSel
              ? const Color(0xFF4F46E5)
              : (_isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSel ? const Color(0xFF4338CA) : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSel
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSel ? Colors.white : (_isDarkMode ? Colors.white70 : const Color(0xFF64748B)),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                color: isSel ? Colors.white : (_isDarkMode ? Colors.white70 : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 0: ALL NEW SANDBOX DESIGNS SHOWCASE
  // ==========================================
  Widget _buildSandboxShowcase(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Studio Intro Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isDarkMode
                  ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                  : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isDarkMode ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.palette_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sandbox Design Studio',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _isDarkMode ? Colors.white : const Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Lifted paper card • Bézier curve graph • Pro plan • 3D mascot',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA),
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

        const SizedBox(height: 28),

        // Section 0: All 6 Scenic Illustrated Cards with Top-Left Corner Curl (designcard.png)
        _buildSectionTitle(
          title: '1. Scenic Illustrated Cards (Top-Left Curl)',
          subtitle: 'All 6 scenic cards from designcard.png with 3D curled top-left corner.',
          icon: Icons.landscape_rounded,
          badgeText: 'designcard.png',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 14),
        ScenicCardsSandboxShowcase(provider: widget.provider),

        const SizedBox(height: 36),

        // Section 1: Tactile Lifted Paper Task Card (sanbox/card.png)
        _buildSectionTitle(
          title: '2. Tactile Lifted Paper Task Card',
          subtitle: 'Upper-left corner lifted with physical ambient drop shadow & curled edge shading.',
          icon: Icons.note_alt_outlined,
          badgeText: 'card.png',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 14),
        LiftedPaperTaskCard(
          liftIntensity: 0.70,
          showLiftSlider: true,
          onAddTask: () => widget.provider.openAddTask(),
        ),

        const SizedBox(height: 36),

        // Section 2: Analytical Bézier Line Graph Card (sanbox/graph.png)
        _buildSectionTitle(
          title: '2. Analytical Line Graph Card',
          subtitle: 'Multi-stop gradient Bézier curve, active 632 Jun badge & total focus metrics.',
          icon: Icons.show_chart_rounded,
          badgeText: 'graph.png',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 14),
        AnalyticsGraphCard(isNight: _isDarkMode),

        const SizedBox(height: 36),

        // Section 3: Frosted Pro Subscription Plan Card (sanbox/plan.png)
        _buildSectionTitle(
          title: '3. Pro Subscription Upgrade Card',
          subtitle: 'Frosted container with 4x Pro lime badge, close button & escalation perks.',
          icon: Icons.verified_outlined,
          badgeText: 'plan.png',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 14),
        ProPlanCard(
          isModal: false,
          onClose: () => widget.provider.showToast('Subscription card closed'),
          onUpgrade: () => widget.provider.showToast(
            'Upgraded to Pro! ⚡ Unlimited AI CRUD active',
            icon: Icons.stars_rounded,
            color: const Color(0xFF10B981),
          ),
        ),

        const SizedBox(height: 36),

        // Section 4: 3D Chatbot Companion Mascot (sanbox/chatbotmascot.jpg)
        _buildSectionTitle(
          title: '4. 3D AI Assistant Mascot Companion',
          subtitle: 'Avatar with goggles, headset, blue puffer jacket, holographic HUD & flying drone.',
          icon: Icons.smart_toy_rounded,
          badgeText: 'chatbotmascot.jpg',
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(height: 14),
        _buildMascotCard(cardBg, textPrimary, textSecondary, borderCol),
      ],
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeText,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF6366F1)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _isDarkMode ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 1: DEDICATED LIFTED PAPER CARD LAB
  // ==========================================
  Widget _buildLiftedPaperDeepDive(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Tactile Lifted Paper Playground',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Interactive physics: adjust peel intensity or tap upper-left corner to bounce the fold.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 24),
        LiftedPaperTaskCard(
          liftIntensity: 0.75,
          showLiftSlider: true,
          onAddTask: () => widget.provider.openAddTask(),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: DEDICATED ANALYTICAL GRAPH LAB
  // ==========================================
  Widget _buildAnalyticsGraphLab(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Bézier Velocity Graph',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Live interactive curve: click any month (Jan-Jul) to inspect velocity metrics and tooltip.',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 20),
        AnalyticsGraphCard(isNight: _isDarkMode),
      ],
    );
  }

  // ==========================================
  // TAB 3: DEDICATED PRO PLAN LAB
  // ==========================================
  Widget _buildProPlanLab(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Pro Subscription Modal',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Full-feature frosted card offering advanced AI planning, 4x atmospheric themes & escalations.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 24),
        ProPlanCard(
          isModal: false,
          onClose: () => widget.provider.showToast('Subscription dismissed'),
          onUpgrade: () => widget.provider.showToast(
            'Pro Plan Activated! ✨',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 4: 3D CHATBOT MASCOT SHOWCASE
  // ==========================================
  Widget _buildMascotShowcase(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3D AI Assistant & Drone Companion',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Active mascot powering the AI Chatbot assistant in tab 3 (replaces previous monster chatbot).',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
        const SizedBox(height: 20),
        _buildMascotCard(cardBg, textPrimary, textSecondary, borderCol),
      ],
    );
  }

  Widget _buildMascotCard(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderCol, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mascot Image with Rounded Corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'assets/images/chatbot_mascot.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1E293B),
                  child: const Center(
                    child: Icon(Icons.smart_toy_rounded, size: 48, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AI Task Agent Companion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Active Mascot',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Equipped with 3D goggles, headset microphone, holographic HUD, and an autonomous flying drone companion.',
                  style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.35),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.provider.setSelectedTab(2); // Jump directly to Chatbot screen!
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Open AI Assistant Chatbot'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 0: ATMOSPHERIC HEADER LAB
  // ==========================================
  Widget _buildAtmosphericHeaderLab(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    final modeNames = ['🌅 Morning (Light Blue)', '☀️ Afternoon (Warm Sunset)', '🌙 Night (Dark + Stars)'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lab Overview Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Time-of-Day Atmosphere Lab',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SANDBOX ONLY',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Light blue for Morning, warm orange for Afternoon, and dark with stars for Night. Gradient softly touches the middle and fades above the percentage card.',
                style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.35),
              ),

              const SizedBox(height: 14),

              // Interactive Selector Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(3, (i) {
                  final isSel = _atmosphereIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _atmosphereIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSel
                            ? (i == 0
                                ? const Color(0xFF0284C7)
                                : (i == 1 ? const Color(0xFFEA580C) : const Color(0xFF1E1B4B)))
                            : (_isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSel
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        modeNames[i],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                          color: isSel ? Colors.white : textPrimary,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 14),

              // Gradient Spread Slider
              Row(
                children: [
                  Text('Atmosphere Spread:', style: TextStyle(fontSize: 11.5, color: textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: _fadeSpread,
                      min: 0.35,
                      max: 0.85,
                      activeColor: _atmosphereIndex == 0
                          ? const Color(0xFF0284C7)
                          : (_atmosphereIndex == 1 ? const Color(0xFFEA580C) : const Color(0xFF6366F1)),
                      onChanged: (val) => setState(() => _fadeSpread = val),
                    ),
                  ),
                  Text('${(_fadeSpread * 100).toInt()}%', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: textPrimary)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Live Simulated Mobile Phone Frame with Atmosphere Header
        const Text(
          'Live Preview Above Percentage Card',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        _buildAtmospherePreviewCard(_atmosphereIndex, _fadeSpread),

        const SizedBox(height: 28),

        // Comparison of all 3 Atmospheric States Side-by-Side
        const Text(
          'All 3 Time-of-Day Variations Comparison',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),

        _buildMiniComparisonCard(0, '🌅 Morning Atmosphere (Light Blue)'),
        const SizedBox(height: 12),
        _buildMiniComparisonCard(1, '☀️ Afternoon Atmosphere (Warm Sunset Glow)'),
        const SizedBox(height: 12),
        _buildMiniComparisonCard(2, '🌙 Night Atmosphere (Dark with Stars ✨)'),
      ],
    );
  }

  Widget _buildAtmospherePreviewCard(int mode, double spread) {
    // Mode configuration
    final bool isNight = mode == 2;
    final bool isAfternoon = mode == 1;

    final String greeting = isNight ? 'Night' : (isAfternoon ? 'Afternoon' : 'Morning');
    final Color greetingColor = isNight
        ? const Color(0xFF94A3B8)
        : (isAfternoon ? const Color(0xFFB45309) : const Color(0xFF475569));
    final Color nameColor = isNight ? Colors.white : const Color(0xFF1B1B1F);
    final Color headlineColor = isNight ? Colors.white : const Color(0xFF1B1B1F);

    // Dynamic Atmosphere Gradients
    final List<Color> gradientColors;
    if (mode == 0) {
      // Light Blue Morning
      gradientColors = [
        const Color(0xFFD6EEFF),
        const Color(0xFFE8F4FE),
        const Color(0xFFF3F9FD).withOpacity(0.6),
        const Color(0xFFFAF8F5).withOpacity(0.0),
      ];
    } else if (mode == 1) {
      // Rich Warm Sunset Afternoon
      gradientColors = [
        const Color(0xFFFF6433), // Radiant Sunset Coral-Orange
        const Color(0xFFFFA040), // Warm Golden Amber
        const Color(0xFFFFCC88).withOpacity(0.85), // Sunset Peach Glow
        const Color(0xFFFFF2DC).withOpacity(0.55), // Warm Soft Cream
        const Color(0xFFFAF8F5).withOpacity(0.0), // Fades out smoothly touching the middle!
      ];
    } else {
      // Deep Midnight Dark Blue with Stars
      gradientColors = [
        const Color(0xFF0F172A),
        const Color(0xFF1E293B),
        const Color(0xFF1E293B).withOpacity(0.7),
        const Color(0xFFFAF8F5).withOpacity(0.0),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE2E8F0),
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Atmosphere Gradient Layer (touches the middle and fades above percentage card!)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors,
                  stops: mode == 1
                      ? [0.0, spread * 0.35, spread * 0.65, spread * 0.9, 1.0]
                      : [0.0, spread * 0.5, spread * 0.85, 1.0],
                ),
              ),
            ),
          ),

          // 2. Night Sky Stars Decor (Only in Night Mode)
          if (isNight) ...[
            Positioned(
              top: 18,
              right: 86,
              child: Text('✦', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
            ),
            Positioned(
              top: 42,
              right: 140,
              child: Text('★', style: TextStyle(color: const Color(0xFFFDE047).withOpacity(0.75), fontSize: 10)),
            ),
            Positioned(
              top: 54,
              left: 170,
              child: Text('✧', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
            ),
            Positioned(
              top: 26,
              left: 130,
              child: Text('·', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Positioned(
              top: 72,
              right: 56,
              child: Text('✧', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9)),
            ),
            Positioned(
              top: 20,
              right: 32,
              child: Text('🌙', style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.9))),
            ),
          ],

          // 3. Morning Sun Flare Decor (Only in Morning Mode)
          if (mode == 0)
            Positioned(
              top: -20,
              right: 20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFBAE6FD).withOpacity(0.35),
                ),
              ),
            ),

          // 4. Afternoon Radiant Sunset Decor (Only in Afternoon Mode)
          if (mode == 1) ...[
            // Glowing Setting Sun Orb
            Positioned(
              top: -8,
              right: 22,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFBF42).withOpacity(0.95), // Golden Sun Core
                      const Color(0xFFFF6D3B).withOpacity(0.65), // Sunset Corona
                      const Color(0xFFFA5A00).withOpacity(0.0), // Soft Ambient Dissolve
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A00).withOpacity(0.40),
                      blurRadius: 32,
                      spreadRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            // Soft Golden-Hour Horizon Cloud
            Positioned(
              top: 52,
              right: 6,
              child: Container(
                width: 76,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9E3D).withOpacity(0.25),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],

          // 5. Header Content (Exact screenshot recreation!)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Greeting + Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Avatar + Greeting
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E293B),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Transform.scale(
                                scale: widget.provider.avatarScale,
                                alignment: Alignment(widget.provider.avatarOffsetX, widget.provider.avatarOffsetY),
                                child: Image.asset(
                                  'assets/images/profile.png',
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Text('AD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: greetingColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              widget.provider.userName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: nameColor,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right: Routine/Docs Button + Notification Bell
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isNight ? const Color(0xFF334155) : const Color(0xFF191A20),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.description_outlined, size: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isNight ? const Color(0xFF1E293B) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: isNight ? const Color(0xFF475569) : const Color(0xFFEFECE6)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                size: 19,
                                color: isNight ? Colors.white : const Color(0xFF191A20),
                              ),
                              Positioned(
                                top: 9,
                                right: 9,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Headline: Decreased size for balance + "Random Task" pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Let\'s Make\nToday Productive',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: headlineColor,
                        height: 1.15,
                      ),
                    ),

                    // Random Task Button (White Pill with Bolt icon)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isNight ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isNight ? const Color(0xFF475569) : const Color(0xFFEFECE6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt, size: 15, color: Color(0xFF2563EB)),
                          const SizedBox(width: 4),
                          Text(
                            'Random Task',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isNight ? Colors.white : const Color(0xFF1B1B1F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Top part of the Percentage Card (Showing the transition!)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2FB3E), // Signature Neon Lime
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'ONGOING TASKS',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '92%',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF141414),
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '4 of 6 completed',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),

                      // Progress Ring
                      const CircularProgressRing(
                        progress: 0.92,
                        size: 64,
                        strokeWidth: 7,
                        progressColor: Color(0xFF141414),
                        backgroundColor: Color(0xFFD4FA37),
                        centerChild: Icon(Icons.arrow_outward_rounded, size: 24, color: Color(0xFF141414)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniComparisonCard(int mode, String title) {
    final bool isNight = mode == 2;
    final bool isAfternoon = mode == 1;

    final List<Color> gradientColors;
    if (mode == 0) {
      gradientColors = [const Color(0xFFD6EEFF), const Color(0xFFE8F4FE), const Color(0xFFFAF8F5)];
    } else if (mode == 1) {
      gradientColors = [
        const Color(0xFFFF6433),
        const Color(0xFFFFA040),
        const Color(0xFFFFDEB8),
        const Color(0xFFFAF8F5),
      ];
    } else {
      gradientColors = [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFFFAF8F5)];
    }

    final String greeting = isNight ? 'Night' : (isAfternoon ? 'Afternoon' : 'Morning');
    final Color textColor = isNight ? Colors.white : const Color(0xFF1B1B1F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                mode == 0 ? '🌅' : (mode == 1 ? '☀️' : '🌙'),
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '$greeting, AYMANE • Let\'s Make Today Productive',
                    style: TextStyle(
                      fontSize: 11,
                      color: isNight ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => setState(() => _atmosphereIndex = mode),
            style: ElevatedButton.styleFrom(
              backgroundColor: isNight ? const Color(0xFF6366F1) : const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: WEBSITE STYLE
  // ==========================================
  Widget _buildWebsiteHeroCard(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderCol),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '⚡ PROTOTYPE STUDIO',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
              const Icon(Icons.auto_awesome, color: Color(0xFF4F46E5), size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Website-Style Layout Engine',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Prototype web interfaces, landing cards, and micro-interactions with real live state.',
            style: TextStyle(fontSize: 13, color: textSecondary, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.layers_outlined, color: Color(0xFF4F46E5), size: 22),
                const SizedBox(height: 10),
                Text('Modular Components', style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text('Instant hot re-render', style: TextStyle(color: textSecondary, fontSize: 11.5)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.speed_rounded, color: Color(0xFF10B981), size: 22),
                const SizedBox(height: 10),
                Text('Fast Feedback', style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text('Spring motion tokens', style: TextStyle(color: textSecondary, fontSize: 11.5)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: LIVE CANVAS
  // ==========================================
  Widget _buildLiveCanvas(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color Tokens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildColorPill('Charcoal', const Color(0xFF191A20)),
            _buildColorPill('Spring Green', const Color(0xFF75CE17)),
            _buildColorPill('Blue Accent', const Color(0xFF0284C7)),
            _buildColorPill('Orange Accent', const Color(0xFFFA5A00)),
            _buildColorPill('Purple Accent', const Color(0xFF7C3AED)),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPill(String name, Color col) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // ==========================================
  // TAB 4: SKELETON LAB (Facebook-style Wireframe)
  // ==========================================
  Widget _buildSkeletonLab(Color cardBg, Color textPrimary, Color textSecondary, Color borderCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Facebook-Style Content Skeleton',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.provider.simulateReload(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Test on Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Matches each actual page component (Avatar, Headline, Sprint card, Filter pills, Task wireframes) with 2s sweeping shimmer.',
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Live Skeleton Frame
        Container(
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderCol, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: HomeScreenSkeleton(
            isNight: _isDarkMode,
            backgroundColor: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF2F7FC),
          ),
        ),
      ],
    );
  }
}

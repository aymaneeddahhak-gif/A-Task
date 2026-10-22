import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../state/task_provider.dart';
import '../widgets/circular_progress_ring.dart';
import '../widgets/task_card.dart';
import '../widgets/content_skeleton_loader.dart';

class HomeScreen extends StatelessWidget {
  final TaskProvider provider;

  const HomeScreen({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 0. Check if Facebook-style content skeleton is currently loading
    if (provider.isLoadingContent) {
      return HomeScreenSkeleton(
        isNight: provider.activeAtmosphereIndex == 2,
        backgroundColor: provider.softAtmosphereColor,
      );
    }

    final tasks = provider.filteredTasks;
    final total = provider.totalTasksCount;
    final completed = provider.completedTasksCount;
    final pending = provider.pendingTasksCount;
    final progress = provider.overallProgressFraction;
    final unreadNotifs = provider.unreadNotificationCount;

    // Active Atmosphere Settings
    final mode = provider.activeAtmosphereIndex; // 0 = Morning, 1 = Afternoon, 2 = Night
    final isNight = mode == 2;
    final isAfternoon = mode == 1;
    final Color softDownColor = provider.softAtmosphereColor;

    final String greetingText = isNight
        ? 'Good Night'
        : (isAfternoon ? 'Good Afternoon' : 'Good Morning');
    final Color greetingColor = isNight
        ? const Color(0xFF94A3B8)
        : (isAfternoon ? const Color(0xFFB45309) : const Color(0xFF475569));
    final Color nameColor = isNight ? Colors.white : const Color(0xFF1B1B1F);
    final Color headlineColor = isNight ? Colors.white : const Color(0xFF1B1B1F);

    // 85% Atmosphere Spread Gradients:
    // The main vibrant atmospheric color stays fixed at the top and dissolves into the soft down-page color!
    final List<Color> gradientColors;
    if (mode == 0) {
      // Light Blue Morning: sky blue fading smoothly into soft morning mist
      gradientColors = [
        const Color(0xFFBAE6FD),
        const Color(0xFFD6EEFF),
        const Color(0xFFE8F4FE),
        softDownColor,
      ];
    } else if (mode == 1) {
      // Warm Sunset Afternoon: rich sunset amber & orange fading into soft warm glow
      gradientColors = [
        const Color(0xFFFF6433),
        const Color(0xFFFFA040),
        const Color(0xFFFFCC88).withOpacity(0.85),
        const Color(0xFFFFF0DC).withOpacity(0.65),
        softDownColor,
      ];
    } else {
      // Deep Midnight Dark Blue with Stars fading into soft midnight dark
      gradientColors = [
        const Color(0xFF0B1021),
        const Color(0xFF0F172A),
        const Color(0xFF1B254B).withOpacity(0.85),
        softDownColor,
      ];
    }

    final stops = mode == 1
        ? const [0.0, 0.85 * 0.35, 0.85 * 0.65, 0.85 * 0.9, 1.0]
        : const [0.0, 0.85 * 0.5, 0.85 * 0.85, 1.0];

    return Stack(
      children: [
        // 0. Base Screen Fill: The mode softly touches the whole lower page!
        Positioned.fill(
          child: Container(
            color: softDownColor,
          ),
        ),

        // 1. Atmosphere Gradient Background: Main color stays FIXED at the top!
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 275,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
                stops: stops,
              ),
            ),
          ),
        ),

        // 2. Night Sky Stars Decor (Only in Night Mode)
        if (isNight) ...[
          Positioned(
            top: 22,
            right: 88,
            child: Text('✦', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
          ),
          Positioned(
            top: 48,
            right: 140,
            child: Text('★', style: TextStyle(color: const Color(0xFFFDE047).withOpacity(0.75), fontSize: 10)),
          ),
          Positioned(
            top: 60,
            left: 170,
            child: Text('✧', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
          ),
          Positioned(
            top: 30,
            left: 130,
            child: Text('·', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            top: 76,
            right: 56,
            child: Text('✧', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9)),
          ),
          Positioned(
            top: 24,
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
                    const Color(0xFFFFBF42).withOpacity(0.95),
                    const Color(0xFFFF6D3B).withOpacity(0.65),
                    const Color(0xFFFA5A00).withOpacity(0.0),
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

        // 5. Scrollable Screen Content
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // 1. Top Header Bar: User Avatar, AYMANE greeting, Atmosphere Mode Chooser & Notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Avatar + "Good Morning AYMANE"
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => provider.setSelectedTab(3),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E293B),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Transform.scale(
                                scale: provider.avatarScale,
                                alignment: Alignment(provider.avatarOffsetX, provider.avatarOffsetY),
                                child: Image.asset(
                                  'assets/images/profile.png',
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    'profile.png',
                                    width: 46,
                                    height: 46,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.network(
                                      'profile.png',
                                      width: 46,
                                      height: 46,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Text(
                                          'AD',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                            greetingText,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: greetingColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            provider.userName, // "AYMANE"
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

                  // Right: Atmosphere Mode Chooser + Notification bell
                  Row(
                    children: [
                      // Atmosphere Mode Chooser Button (Replaces documentation button on top right!)
                      GestureDetector(
                        onTap: () => _showAtmosphereModeBottomSheet(context, provider),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isNight ? const Color(0xFF334155) : const Color(0xFF191A20),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isNight ? const Color(0xFF475569) : Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                _getAtmosphereIcon(provider.atmosphereMode, mode),
                                size: 19,
                                color: _getAtmosphereIconColor(provider.atmosphereMode, mode),
                              ),
                              if (provider.atmosphereMode == 'auto')
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF38BDF8),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Notification Bell (Frosted White circle with Red Dot)
                      GestureDetector(
                        onTap: () => provider.openNotifications(),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isNight ? const Color(0xFF1E293B) : Colors.white.withOpacity(0.95),
                            shape: BoxShape.circle,
                            border: Border.all(color: isNight ? const Color(0xFF475569) : const Color(0xFFEFECE6)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                size: 20,
                                color: isNight ? Colors.white : const Color(0xFF191A20),
                              ),
                              if (unreadNotifs > 0)
                                Positioned(
                                  top: 10,
                                  right: 10,
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
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 2. Bold Headline: "Let's Make\nToday Productive"
              Text(
                'Let\'s Make\nToday Productive',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: headlineColor,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 14),

              // 3. TodayProgressCard (Fresh Pastel Spring Green Gradient)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDCF8A7), Color(0xFFCEF193)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFE5FAC0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF669E1C).withOpacity(0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Mini Pill: ⚡ Daily Sprint
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.bolt, size: 13, color: Color(0xFF2C4C18)),
                          SizedBox(width: 4),
                          Text(
                            'Daily Sprint',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF233D14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Main Stats Row & Progress Ring
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Stats breakdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Daily\nProgress',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF142410),
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildStatRow(Icons.format_list_bulleted, 'Total Tasks', '$total'),
                            const SizedBox(height: 6),
                            _buildStatRow(Icons.check_circle_outline, 'Completed', '$completed'),
                            const SizedBox(height: 6),
                            _buildStatRow(Icons.hourglass_empty, 'In Progress', '$pending'),
                          ],
                        ),

                        // Right: Circular Progress Ring with Inner Disk
                        Container(
                          width: 102,
                          height: 102,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircularProgressRing(
                              progress: progress,
                              size: 88,
                              strokeWidth: 8,
                              progressColor: const Color(0xFF75CE17),
                              backgroundColor: const Color(0xFFC7EC87),
                              centerChild: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${(progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF142410),
                                    ),
                                  ),
                                  Text(
                                    '$completed of $total',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C4C18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Section Header: "Plans & Tasks" + Filter button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Plans & Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1F),
                    ),
                  ),

                  // Filter button (Square with rounded corners)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      size: 20,
                      color: Color(0xFF191A20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 5. Filter Pills Row: All, To Do, In Progress, In Review, Done with Counts
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatusPill('All', provider.allCount),
                    const SizedBox(width: 8),
                    _buildStatusPill('To Do', provider.todoCount),
                    const SizedBox(width: 8),
                    _buildStatusPill('In Progress', provider.inProgressCount),
                    const SizedBox(width: 8),
                    _buildStatusPill('In Review', provider.inReviewCount),
                    const SizedBox(width: 8),
                    _buildStatusPill('Done', provider.doneCount),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Random Task Button placed under the All - To Do - In Progress row
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => provider.openRandomTask(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEFECE6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bolt,
                          size: 15,
                          color: isAfternoon
                              ? const Color(0xFFEA580C)
                              : const Color(0xFF578EF5),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Random Task',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191A20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 6. Tasks List with Dynamic Progress Line
              if (tasks.isEmpty)
                _buildFreshEmptyState(context, provider)
              else
                ...tasks.map(
                  (task) => TaskCard(
                    task: task,
                    onTap: () => provider.openTaskDetail(task),
                    onToggleComplete: () => provider.toggleTaskComplete(task.id),
                    onToggleStarred: () => provider.toggleTaskStarred(task.id),
                  ),
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getAtmosphereIcon(String modeSetting, int activeIndex) {
    if (modeSetting == 'auto') {
      return Icons.hdr_auto_rounded;
    }
    if (activeIndex == 0) return Icons.wb_sunny_rounded;
    if (activeIndex == 1) return Icons.wb_twilight_rounded;
    return Icons.nightlight_round;
  }

  Color _getAtmosphereIconColor(String modeSetting, int activeIndex) {
    if (modeSetting == 'auto') {
      return const Color(0xFF38BDF8);
    }
    if (activeIndex == 0) return const Color(0xFF38BDF8);
    if (activeIndex == 1) return const Color(0xFFF97316);
    return const Color(0xFFFDE047);
  }

  void _showAtmosphereModeBottomSheet(BuildContext context, TaskProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag pill
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Atmosphere & Lighting',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '85% Spread',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose how the ambient sky gradient adapts above your tasks:',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),

              // Option 1: Auto Mode
              _buildAtmosphereOptionTile(
                ctx,
                provider,
                id: 'auto',
                emoji: '🔄',
                title: 'Auto (Real-time Clock)',
                subtitle: 'Syncs automatically: Morning, Sunset, or Night',
                isSelected: provider.atmosphereMode == 'auto',
              ),
              const SizedBox(height: 8),

              // Option 2: Morning
              _buildAtmosphereOptionTile(
                ctx,
                provider,
                id: 'morning',
                emoji: '🌅',
                title: 'Good Morning',
                subtitle: 'Soft sky-blue atmosphere with gentle sun flare',
                isSelected: provider.atmosphereMode == 'morning',
              ),
              const SizedBox(height: 8),

              // Option 3: Afternoon (Warm Sunset)
              _buildAtmosphereOptionTile(
                ctx,
                provider,
                id: 'afternoon',
                emoji: '☀️',
                title: 'Good Afternoon (Warm Sunset)',
                subtitle: 'Rich golden amber & sunset coral glow',
                isSelected: provider.atmosphereMode == 'afternoon',
              ),
              const SizedBox(height: 8),

              // Option 4: Night
              _buildAtmosphereOptionTile(
                ctx,
                provider,
                id: 'night',
                emoji: '🌙',
                title: 'Good Night',
                subtitle: 'Midnight dark blue sky with shimmering stars ✨',
                isSelected: provider.atmosphereMode == 'night',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAtmosphereOptionTile(
    BuildContext ctx,
    TaskProvider provider, {
    required String id,
    required String emoji,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        provider.setAtmosphereMode(id);
        Navigator.pop(ctx);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF0F172A), size: 20)
            else
              const Icon(Icons.circle_outlined, color: Color(0xFFCBD5E1), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF2C4C18)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF2C4C18),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF142410),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFreshEmptyState(BuildContext context, TaskProvider provider) {
    final isTotalZero = provider.totalTasksCount == 0;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Professional Minimalist Icon
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF1F5F9),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 26,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // Clean, Professional Title: "No tasks set here yet"
          Text(
            isTotalZero ? 'No tasks set here yet' : 'No ${provider.statusFilter} tasks',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),

          // Clean, Professional Subtitle
          Text(
            isTotalZero
                ? 'Tap "+ New" below to schedule your first task.'
                : 'There are no tasks with "${provider.statusFilter}" status.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),

          GestureDetector(
            onTap: () {
              if (isTotalZero) {
                provider.openAddTask();
              } else {
                provider.setStatusFilter('All');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF191A20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isTotalZero ? Icons.add : Icons.refresh,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isTotalZero ? '+ New Task' : 'Show All Tasks',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String filterName, int count) {
    final isSelected = provider.statusFilter == filterName;

    return GestureDetector(
      onTap: () => provider.setStatusFilter(filterName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF191A20) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF191A20) : const Color(0xFFEFECE6),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(
              filterName,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF6B6E77),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

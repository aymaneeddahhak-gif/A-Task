import 'package:flutter/material.dart';
import '../state/task_provider.dart';
import '../widgets/circular_progress_ring.dart';
import '../widgets/task_card.dart';
import '../widgets/content_skeleton_loader.dart';

class HomeScreen extends StatefulWidget {
  final TaskProvider provider;

  const HomeScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
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

    // Top-Left Greeting Text (Always shows Good Morning / Good Afternoon / Good Evening for all modes!)
    final String greetingLabel;
    if (mode == 0) {
      greetingLabel = 'Good Morning';
    } else if (mode == 1) {
      greetingLabel = 'Good Afternoon';
    } else {
      greetingLabel = 'Good Evening';
    }
    // Dark crisp text in daylight modes, crisp white in night mode
    final Color greetingTextColor = isNight ? Colors.white : const Color(0xFF0F172A);
    final Color nameColor = isNight ? Colors.white : const Color(0xFF0F172A);
    final Color headlineColor = isNight ? Colors.white : const Color(0xFF0F172A);

    // 85% Atmosphere Spread Gradients:
    // The main vibrant atmospheric color stays fixed at the top and dissolves into the soft down-page color!
    final List<Color> gradientColors;
    if (mode == 0) {
      // Sunny Morning Sky: crisp sky blue blended with warm golden morning sunshine
      gradientColors = [
        const Color(0xFF93C5FD),
        const Color(0xFFBAE6FD),
        const Color(0xFFFEF08A).withOpacity(0.65),
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

    final stops = (mode == 0 || mode == 1)
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

        // 3. Morning Warm Sunshine & Sun Orb Decor (Only in Morning Mode)
        if (mode == 0) ...[
          Positioned(
            top: -10,
            right: 20,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFDE047).withOpacity(0.95),
                    const Color(0xFFFBBF24).withOpacity(0.65),
                    const Color(0xFFBAE6FD).withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFACC15).withOpacity(0.45),
                    blurRadius: 34,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 48,
            right: 8,
            child: Container(
              width: 72,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.45),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFDE047).withOpacity(0.30),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],

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
              // 1. Top Header Bar: Left (User Avatar + Good Morning/Afternoon/Evening + AYMANE)
              //                    Right (Scrollable Mode Switch Button + Notification Bell)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Avatar + Greeting ("Good Morning" / "Good Afternoon" / "Good Evening") + Name ("AYMANE")
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => provider.setSelectedTab(3),
                          child: Container(
                            width: 44,
                            height: 44,
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
                                width: 44,
                                height: 44,
                                child: Transform.scale(
                                  scale: provider.avatarScale,
                                  alignment: Alignment(provider.avatarOffsetX, provider.avatarOffsetY),
                                  child: Image.asset(
                                    'assets/images/profile.png',
                                    width: 44,
                                    height: 44,
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
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greetingLabel, // "Good Morning", "Good Afternoon", "Good Evening"
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: greetingTextColor, // Solid dark #0F172A in daylight, white in night
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                provider.userName, // "AYMANE"
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: nameColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Right: Mode Switch Button (Auto • Morning • Afternoon • Night) BESIDE Notification Bell
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAtmosphereModeSelector(provider, isNight),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => provider.openNotifications(),
                        child: Container(
                          width: 40,
                          height: 40,
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

              // Random Task Button (Clean single button with task sign)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => provider.openRandomTask('None'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 16,
                          color: isAfternoon
                              ? const Color(0xFFEA580C)
                              : const Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Quick Task',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
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
                  (task) => RepaintBoundary(
                    key: ValueKey('home_task_${task.id}'),
                    child: TaskCard(
                      task: task,
                      onTap: () => provider.openTaskDetail(task),
                      onToggleComplete: () => provider.toggleTaskComplete(task.id),
                      onToggleStarred: () => provider.toggleTaskStarred(task.id),
                    ),
                  ),
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAtmosphereModeSelector(TaskProvider provider, bool isNight) {
    final currentMode = provider.atmosphereMode;
    final String currentTitle;
    final IconData currentIcon;
    final Color currentIconColor;

    switch (currentMode) {
      case 'morning':
        currentTitle = 'Morning';
        currentIcon = Icons.wb_sunny_rounded;
        currentIconColor = const Color(0xFFF59E0B);
        break;
      case 'afternoon':
        currentTitle = 'Afternoon';
        currentIcon = Icons.wb_twilight_rounded;
        currentIconColor = const Color(0xFFF97316);
        break;
      case 'night':
        currentTitle = 'Night';
        currentIcon = Icons.nightlight_round;
        currentIconColor = const Color(0xFFFDE047);
        break;
      default:
        currentTitle = 'Auto';
        currentIcon = Icons.brightness_auto_rounded;
        currentIconColor = const Color(0xFF38BDF8);
        break;
    }

    // Dropdown Mode Switcher placed strictly BESIDE the Notification Bell!
    // Shows all 4 modes vertically on click for easy laptop mouse testing,
    // and keeps the active mode name ONLY on this button without compressing the greeting.
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: isNight ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isNight ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
            ),
          ),
          elevation: 10,
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: 'Switch Atmosphere Mode',
        offset: const Offset(0, 44),
        onSelected: (val) => provider.setAtmosphereMode(val),
        itemBuilder: (ctx) => [
          _buildPopupItem(
            value: 'auto',
            label: 'Auto (Time-based)',
            icon: Icons.brightness_auto_rounded,
            iconColor: const Color(0xFF0284C7),
            isSelected: currentMode == 'auto',
            isNight: isNight,
          ),
          _buildPopupItem(
            value: 'morning',
            label: 'Morning Mode',
            icon: Icons.wb_sunny_rounded,
            iconColor: const Color(0xFFF59E0B),
            isSelected: currentMode == 'morning',
            isNight: isNight,
          ),
          _buildPopupItem(
            value: 'afternoon',
            label: 'Afternoon Mode',
            icon: Icons.wb_twilight_rounded,
            iconColor: const Color(0xFFEA580C),
            isSelected: currentMode == 'afternoon',
            isNight: isNight,
          ),
          _buildPopupItem(
            value: 'night',
            label: 'Night Mode',
            icon: Icons.nightlight_round,
            iconColor: const Color(0xFFEAB308),
            isSelected: currentMode == 'night',
            isNight: isNight,
          ),
        ],
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: isNight
                ? const Color(0xFF1E293B).withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isNight ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isNight ? 0.2 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentIcon, size: 15, color: currentIconColor),
              const SizedBox(width: 5),
              Text(
                currentTitle, // "Auto", "Morning", "Afternoon", "Night" placed ONLY on this button!
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isNight ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: isNight ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem({
    required String value,
    required String label,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required bool isNight,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 42,
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isNight ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_rounded,
              size: 16,
              color: isNight ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
            ),
        ],
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
                ? 'Tap "+ New Task" below to schedule your first task.'
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
                    isTotalZero ? 'New Task' : 'Show All Tasks',
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
    final provider = widget.provider;
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

import 'package:flutter/material.dart';
import 'state/task_provider.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_dialog.dart';
import 'screens/add_task_dialog.dart';
import 'screens/task_detail_dialog.dart';
import 'screens/random_task_dialog.dart';
import 'screens/design_sandbox_screen.dart';
import 'widgets/content_skeleton_loader.dart';

void main() {
  runApp(const TaskPlannerFlutterApp());
}

class TaskPlannerFlutterApp extends StatelessWidget {
  const TaskPlannerFlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A-Task • Personal Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainTabContainer(),
    );
  }
}

class MainTabContainer extends StatefulWidget {
  const MainTabContainer({Key? key}) : super(key: key);

  @override
  State<MainTabContainer> createState() => _MainTabContainerState();
}

class _MainTabContainerState extends State<MainTabContainer> {
  late final TaskProvider _provider;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _provider = TaskProvider();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If screen is wider than 640px (Desktop / Laptop / Tablet), place app in its original fixed mobile shape!
        final isDesktop = constraints.maxWidth > 640;

        // Dynamic phone dimension calculation: fits cleanly inside browser viewport height so page NEVER overflows/scrolls!
        final availableHeight = constraints.maxHeight;
        final double phoneHeight = (availableHeight - 56.0).clamp(500.0, 840.0);
        final double phoneWidth = (phoneHeight * (418.0 / 840.0)).clamp(360.0, 420.0);

        final mode = _provider.activeAtmosphereIndex;
        final softBg = _provider.softAtmosphereColor;
        final isNight = mode == 2;

        Widget appContent = AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _showSplash
              ? AppSplashScreen(
                  key: const ValueKey('splash'),
                  isNight: isNight,
                  backgroundColor: softBg,
                )
              : AnimatedBuilder(
                  key: const ValueKey('main_app'),
                  animation: _provider,
                  builder: (context, _) {
                    final currentSoftBg = _provider.softAtmosphereColor;
                    final currentIsNight = _provider.activeAtmosphereIndex == 2;
                    final showBottomNav = _provider.selectedTab <= 4;

                    return Stack(
                      children: [
                        // Main Scaffold with Floating Pill Dock Navigation
                        Scaffold(
                          backgroundColor: currentSoftBg,
                          body: _buildCurrentScreen(_provider.selectedTab),
                          bottomNavigationBar: showBottomNav
                              ? AppBottomNavBar(
                                  selectedIndex: _provider.selectedTab,
                                  onTabSelected: (index) => _provider.setSelectedTab(index),
                                  onAddClick: () => _provider.openAddTask(),
                                  isNight: currentIsNight,
                                )
                              : null,
                        ),

                        // Modal Overlays
                        if (_provider.isNotificationsOpen)
                          NotificationsDialog(provider: _provider),

                        if (_provider.isAddTaskOpen)
                          AddTaskDialog(provider: _provider),

                        if (_provider.selectedTaskForDetail != null)
                          TaskDetailDialog(
                            task: _provider.selectedTaskForDetail!,
                            provider: _provider,
                          ),

                        if (_provider.candidateRandomTask != null)
                          RandomTaskDialog(provider: _provider),

                        // In-App Toast Notification (strictly inside the device phone shape!)
                        if (_provider.activeToastMessage != null)
                          Positioned(
                            top: 46,
                            left: 18,
                            right: 18,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF191A20),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: const Color(0xFF334155), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _provider.activeToastIcon ?? Icons.check_circle_rounded,
                                      size: 18,
                                      color: _provider.activeToastColor ?? const Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _provider.activeToastMessage!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        );

        // On mobile devices (phones), fill the entire screen naturally
        if (!isDesktop) {
          return ScaffoldMessenger(child: appContent);
        }

        // On Desktop / Wide browsers, FIXED screen (NO scrolling up or down!). Only the phone app screen scrolls!
        // Phone device shape is placed in the EXACT MIDDLE of the screen!
        // Left side empty space contains: LIVE DEMO, A-Task, tagline, Created by.
        return Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Side Empty Space: Big LIVE DEMO + Brand info + Portfolio footer
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 48.0, right: 24.0),
                        child: _buildLeftSideBranding(),
                      ),
                    ),
                  ),

                  // Middle: Smartphone Mockup (Exactly centered in viewport!)
                  _buildRealisticPhoneFrame(appContent, phoneHeight, phoneWidth),

                  // Right Side Empty Space: Equal width to Left Side, perfectly centering the phone!
                  const Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeftSideBranding() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Big "LIVE DEMO" text above all text (dot removed)
          const Text(
            'LIVE DEMO',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Color(0xFF0F172A),
              height: 1.0,
            ),
          ),

          const SizedBox(height: 24),

          // 2. App name "A-Task" (image removed)
          const Text(
            'A-Task',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          // 3. Subtitle / Tagline
          const Text(
            'A task planner app  •  Make today more productive',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 36),

          // 4. Portfolio-Style Minimalist Footer: "Created by" + mascot + logosultion
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Created by',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 14),
              // Mascot
              Image.asset(
                'assets/images/mascot.png',
                height: 48,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(
                  'mascot.png',
                  height: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text('⚡', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              // Logosolution
              Image.asset(
                'assets/images/logosultion.png',
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Image.asset(
                  'logosultion.png',
                  height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/logo.png',
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text('Logosolution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealisticPhoneFrame(Widget appContent, double phoneHeight, [double phoneWidth = 420.0]) {

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Main Phone Chassis
          Container(
            width: phoneWidth,
            height: phoneHeight,
            decoration: BoxDecoration(
              color: _provider.softAtmosphereColor,
              borderRadius: BorderRadius.circular(44),
              border: Border.all(color: const Color(0xFF151722), width: 5.0),
              boxShadow: const [
                // Signature Neo-Shadow matching portfolio
                BoxShadow(
                  color: Color(0xFFD1DADA),
                  offset: Offset(8, 8),
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
                // Soft Realistic Ambient Phone Drop Shadow
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 24),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // App Inside Screen with safe padding matching the Dynamic Island & Home indicator
                Positioned.fill(
                  child: Builder(
                    builder: (ctx) {
                      final mq = MediaQuery.of(ctx);
                      return MediaQuery(
                        data: mq.copyWith(
                          padding: const EdgeInsets.only(top: 36, bottom: 16),
                          viewPadding: const EdgeInsets.only(top: 36, bottom: 16),
                        ),
                        child: ScaffoldMessenger(
                          child: appContent,
                        ),
                      );
                    },
                  ),
                ),

                // Top Speaker Slit in bezel area
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 46,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF232733),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Top Dynamic Island Notch with realistic camera lens dot
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 114,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C0E14),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Camera Sensor Dot
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E2638),
                            border: Border.all(color: const Color(0xFF0F1522), width: 1.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Ambient Light / FaceID Sensor Dot
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF181F2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Home Indicator Bar (Realistic iOS/Android gesture pill)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Physical Right Side Button: Power / Lock key
          Positioned(
            right: -8,
            top: phoneHeight > 250 ? 110 : 70,
            child: Container(
              width: 5.5,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Physical Left Side Buttons: Mute Switch & Volume Rocker Keys
          Positioned(
            left: -8,
            top: phoneHeight > 250 ? 80 : 50,
            child: Container(
              width: 5.5,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            left: -8,
            top: phoneHeight > 250 ? 122 : 90,
            child: Container(
              width: 5.5,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            left: -8,
            top: phoneHeight > 250 ? 180 : 148,
            child: Container(
              width: 5.5,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return HomeScreen(provider: _provider);
      case 1:
        return ScheduleScreen(provider: _provider);
      case 2:
        return ChatbotScreen(provider: _provider);
      case 3:
        return ProfileScreen(provider: _provider);
      case 4:
        return DesignSandboxScreen(provider: _provider);
      default:
        return HomeScreen(provider: _provider);
    }
  }
}

class AppSplashScreen extends StatefulWidget {
  final bool isNight;
  final Color? backgroundColor;

  const AppSplashScreen({
    Key? key,
    this.isNight = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isNight;
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC));

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 3D App Icon with smooth entrance & depth shadow
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.22),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/icon3D.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.task_alt_rounded, size: 52, color: Color(0xFF2563EB)),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // App Title: A-Task
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A-',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const Text(
                    'Task',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Tagline
              Text(
                'Personal Planner & Routines',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 32),

              // Sleek Loading Progress Indicator
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

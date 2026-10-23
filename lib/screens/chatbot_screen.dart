import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/task_provider.dart';

class ChatbotScreen extends StatefulWidget {
  final TaskProvider provider;

  const ChatbotScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  bool _isChatOpen = false;
  int _activeSegmentIndex = 0; // 0: Create, 1: Templates
  final TextEditingController _promptController = TextEditingController();
  bool _isRecordingAudio = false;
  int _surpriseIndex = 0;

  final List<String> _surprisePrompts = [
    'Design an interactive 3D particle hero animation for portfolio',
    'Build an automated task reminder routine for 9 AM sprint',
    'Create a minimalist dark mode dashboard with live telemetry',
    'Schedule daily deep work focus blocks with 10m refresh breaks',
    'Generate weekly productivity audit and milestone retrospective',
    'Optimize Flutter Web rendering pipelines & canvas cache',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _cycleSurprisePrompt() {
    setState(() {
      _promptController.text = _surprisePrompts[_surpriseIndex % _surprisePrompts.length];
      _surpriseIndex++;
    });
  }

  void _toggleAudioRecording() {
    setState(() {
      _isRecordingAudio = !_isRecordingAudio;
      if (_isRecordingAudio) {
        widget.provider.showToast(
          'Listening... Speak your task prompt',
          icon: Icons.mic_rounded,
          color: const Color(0xFF3B82F6),
        );
      } else {
        if (_promptController.text.isEmpty) {
          _promptController.text = 'Audio note: Schedule architecture review & sprint plan';
        }
        widget.provider.showToast(
          'Voice captured successfully',
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF10B981),
        );
      }
    });
  }

  void _submitPrompt() {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;

    widget.provider.showToast(
      'Task blueprint generated from prompt!',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF3B82F6),
    );
    _promptController.clear();
    setState(() {
      _isRecordingAudio = false;
    });
  }

  void _openChatView() {
    setState(() {
      _isChatOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF67B0FF),
            Color(0xFF539DF8),
            Color(0xFF458EF0),
            Color(0xFF3D85E8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Sunbeam Rays
          Positioned.fill(
            child: CustomPaint(
              painter: _SunbeamPainter(),
            ),
          ),

          // Main View Switcher: Left Screen (Showcase) vs Right Screen (Creation / Chat)
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 86.0), // Space for floating bottom nav bar
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final isLeft = child.key == const ValueKey('left_screen');
                  final offsetAnimation = Tween<Offset>(
                    begin: isLeft ? const Offset(-0.06, 0) : const Offset(0.06, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
                child: _isChatOpen
                    ? _buildRightScreen(key: const ValueKey('right_screen'))
                    : _buildLeftScreen(key: const ValueKey('left_screen')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // LEFT SCREEN: Inspiration Card & Creature
  // ==========================================
  Widget _buildLeftScreen({Key? key}) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 16,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Top App Bar
                  Row(
                    children: [
                      // User Avatar
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_rounded,
                              color: Color(0xFF1E293B),
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Notification Bell Button
                      _buildCircularHeaderButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () => widget.provider.openNotifications(),
                      ),

                      const SizedBox(width: 10),

                      // Search Button
                      _buildCircularHeaderButton(
                        icon: Icons.search_rounded,
                        onTap: () => _openChatView(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Main Hero Card with 3D monster
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Under-card layered shadow shelf
                        Container(
                          width: double.infinity,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        // Main Blue Card Container (Exact gradient matching monster image)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF1785FE),
                                Color(0xFF2890FE),
                                Color(0xFF4FA9FE),
                                Color(0xFF76C7FE),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F56C7).withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Card Top Header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                                child: Row(
                                  children: [
                                    // Creator Avatar
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/profile.png',
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.face_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Card Title & Subtitle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Hyperspace Garb...',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          Text(
                                            '@Velvet Virus',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.85),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Top Right Actions
                                    _buildFrostedCardIcon(
                                      icon: Icons.remove_red_eye_outlined,
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFrostedCardIcon(
                                      icon: Icons.more_vert_rounded,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),

                              // Card Center: Furry Creature (Clickable to transition to screen 2!)
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _openChatView(),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/chatbot_monster.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/images/mascot.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Card Bottom: Dashed stats capsule with interactive Chat Button on the right
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.55),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildCardStatItem(
                                        icon: Icons.sports_esports_rounded,
                                        label: '31K',
                                      ),
                                      _buildCardStatItem(
                                        icon: Icons.reply_rounded,
                                        label: '143',
                                      ),
                                      _buildCardStatItem(
                                        icon: Icons.favorite_rounded,
                                        label: '585',
                                      ),
                                      // Chat Button: clicking opens the right creation/chat screen!
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => _openChatView(),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.35),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.chat_bubble_outline_rounded,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '141',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w700,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // RIGHT SCREEN: Create Your Game / Task UI
  // ==========================================
  Widget _buildRightScreen({Key? key}) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 16,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header: Back button + Title
                  Row(
                    children: [
                      // Circular Back Button
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isChatOpen = false;
                          });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),

                      // Centered Title
                      Expanded(
                        child: Center(
                          child: Text(
                            'Create your game',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),

                      // Placeholder for symmetric center alignment
                      const SizedBox(width: 38),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Pill Tab Switcher: "Rocket Create" vs "Box Templates"
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left Pill: Create (Active by default)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeSegmentIndex = 0;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: _activeSegmentIndex == 0
                                    ? const LinearGradient(
                                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: _activeSegmentIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF1D4ED8).withOpacity(0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rocket_launch_rounded,
                                      size: 15,
                                      color: _activeSegmentIndex == 0
                                          ? Colors.white
                                          : const Color(0xFF475569),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Create',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: _activeSegmentIndex == 0
                                            ? Colors.white
                                            : const Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Right Pill: Templates
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeSegmentIndex = 1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: _activeSegmentIndex == 1
                                    ? const LinearGradient(
                                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: _activeSegmentIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF1D4ED8).withOpacity(0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 15,
                                      color: _activeSegmentIndex == 1
                                          ? Colors.white
                                          : const Color(0xFF475569),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Templates',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: _activeSegmentIndex == 1
                                            ? Colors.white
                                            : const Color(0xFF475569),
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

                  const SizedBox(height: 14),

                  // Main White Input Card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Text Input Area
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: TextField(
                              controller: _promptController,
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                                height: 1.4,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Describe what game you want to build...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _submitPrompt(),
                            ),
                          ),

                          // Center Magic Sparkle with radial aura
                          Expanded(
                            child: Center(
                              child: _isRecordingAudio
                                  ? _buildAudioWaveformIndicator()
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Subtle radiant glow
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                const Color(0xFF60A5FA).withOpacity(0.35),
                                                const Color(0xFF93C5FD).withOpacity(0.08),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                        // 4-point magic sparkle icon
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.auto_awesome,
                                              size: 32,
                                              color: Color(0xFF60A5FA),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          // Card Bottom Bar: "+ Surprise me" and Send/Mic Button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Row(
                              children: [
                                // Surprise Me Pill Button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _cycleSurprisePrompt,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
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
                                      children: const [
                                        Icon(
                                          Icons.auto_awesome,
                                          size: 14,
                                          color: Color(0xFF0F172A),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Surprise me',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // Audio Microphone Button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _toggleAudioRecording,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: _isRecordingAudio
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _isRecordingAudio
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _isRecordingAudio ? Icons.mic_off_rounded : Icons.mic_rounded,
                                        size: 18,
                                        color: _isRecordingAudio
                                            ? Colors.white
                                            : const Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                ),

                                // Circular Blue Send Button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _submitPrompt,
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF1D4ED8).withOpacity(0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.near_me_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bottom Quick Action Dock: 4 Tiles (Photos, Videos, Sounds, Meme)
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionTile(
                          icon: Icons.photo_library_outlined,
                          label: 'Photos',
                          onTap: () {
                            widget.provider.showToast(
                              'Photo attachment selected',
                              icon: Icons.photo_rounded,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickActionTile(
                          icon: Icons.videocam_outlined,
                          label: 'Videos',
                          onTap: () {
                            widget.provider.showToast(
                              'Video note selected',
                              icon: Icons.videocam_rounded,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickActionTile(
                          icon: Icons.graphic_eq_rounded,
                          label: 'Sounds',
                          onTap: () {
                            widget.provider.showToast(
                              'Ambient sound loaded',
                              icon: Icons.graphic_eq_rounded,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickActionTile(
                          icon: Icons.sentiment_satisfied_alt_rounded,
                          label: 'Meme',
                          onTap: () {
                            widget.provider.showToast(
                              'Task inspiration meme active!',
                              icon: Icons.sentiment_satisfied_alt_rounded,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioWaveformIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic_rounded, color: Color(0xFF2563EB), size: 20),
          const SizedBox(width: 10),
          const Text(
            'Listening... Speak your task',
            style: TextStyle(
              color: Color(0xFF1D4ED8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          // Animated wave dots
          SizedBox(
            width: 32,
            height: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 3.5,
                  height: 8.0 + (index % 3) * 4.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularHeaderButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }

  Widget _buildFrostedCardIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCardStatItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 15),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF334155),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// Sunbeam Painter for radiant celestial rays
// ==========================================
class _SunbeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width * 0.5, -20);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.09)
      ..style = PaintingStyle.fill;

    const int rayCount = 18;
    final double rayAngle = (math.pi) / rayCount;
    final double reach = size.height * 2.2;

    for (int i = 0; i < rayCount; i++) {
      if (i % 2 == 0) {
        final double a1 = i * rayAngle;
        final double a2 = (i + 1) * rayAngle;

        final path = Path()
          ..moveTo(origin.dx, origin.dy)
          ..lineTo(origin.dx + reach * math.cos(a1), origin.dy + reach * math.sin(a1))
          ..lineTo(origin.dx + reach * math.cos(a2), origin.dy + reach * math.sin(a2))
          ..close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

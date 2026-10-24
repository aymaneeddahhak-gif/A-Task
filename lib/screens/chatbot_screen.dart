import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/task_provider.dart';
import '../models/task_model.dart';

class ChatbotScreen extends StatefulWidget {
  final TaskProvider provider;

  const ChatbotScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  bool _isChatOpen = false;
  int _activeSegmentIndex = 0; // 0: Create, 1: Manage (CRUD)
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isRecordingAudio = false;
  int _surpriseIndex = 0;
  TaskModel? _lastCreatedTask;
  String? _lastActionFeedback;

  final List<String> _surprisePrompts = [
    'Design an interactive 3D particle hero animation for portfolio',
    'Build an automated task reminder routine for 9 AM sprint',
    'Create a minimalist dark mode dashboard with live telemetry',
    'Schedule daily deep work focus blocks with 10m refresh breaks',
    'Audit database queries and optimize response latency',
    'Prepare sprint review presentation and retrospective checklist',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    _searchController.dispose();
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
          'Listening... Speak your task command (e.g. "Create task UI sprint")',
          icon: Icons.mic_rounded,
          color: const Color(0xFF3B82F6),
        );
      } else {
        if (_promptController.text.isEmpty) {
          _promptController.text = 'Schedule architecture review & sprint plan';
        }
        widget.provider.showToast(
          'Voice captured: ready to create!',
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF10B981),
        );
      }
    });
  }

  // ==========================================================
  // FULL CRUD ENGINE: Create, Read, Update, Delete for Tasks
  // ==========================================================
  void _handlePromptAction([String? customPrompt]) {
    final raw = (customPrompt ?? _promptController.text).trim();
    if (raw.isEmpty) return;

    final lower = raw.toLowerCase();

    // 1. DELETE COMMAND: "delete <title/id>" or "remove <title/id>"
    if (lower.startsWith('delete ') || lower.startsWith('remove ')) {
      final query = raw.substring(raw.indexOf(' ') + 1).trim();
      final match = _findTaskByQuery(query);
      if (match != null) {
        final title = match.title;
        widget.provider.deleteTask(match.id);
        setState(() {
          _lastCreatedTask = null;
          _lastActionFeedback = 'Deleted task: "$title"';
          _isRecordingAudio = false;
        });
        widget.provider.showToast(
          'Deleted "$title"',
          icon: Icons.delete_outline_rounded,
          color: const Color(0xFFEF4444),
        );
        _promptController.clear();
        return;
      }
    }

    // 2. COMPLETE / UPDATE STATUS COMMAND: "complete <title>" or "done <title>"
    if (lower.startsWith('complete ') || lower.startsWith('done ') || lower.startsWith('finish ')) {
      final query = raw.substring(raw.indexOf(' ') + 1).trim();
      final match = _findTaskByQuery(query);
      if (match != null) {
        if (!match.isCompleted) {
          widget.provider.toggleTaskComplete(match.id);
        }
        setState(() {
          _lastActionFeedback = 'Marked completed: "${match.title}"';
          _isRecordingAudio = false;
        });
        widget.provider.showToast(
          'Completed "${match.title}"',
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF10B981),
        );
        _promptController.clear();
        return;
      }
    }

    // 3. READ / LIST COMMAND: "list", "show tasks", "tasks"
    if (lower == 'list' || lower == 'show tasks' || lower == 'tasks' || lower == 'view tasks') {
      setState(() {
        _activeSegmentIndex = 1; // switch to Manage Tasks list
        _lastActionFeedback = 'Displaying all ${widget.provider.tasks.length} tasks';
        _isRecordingAudio = false;
      });
      _promptController.clear();
      return;
    }

    // 4. CREATE TASK COMMAND: "create <title>", "add <title>", or natural text
    String taskTitle = raw;
    if (lower.startsWith('create task:') || lower.startsWith('create task ') || lower.startsWith('create ')) {
      taskTitle = raw.substring(raw.indexOf(' ') + 1).trim();
      if (taskTitle.startsWith(':')) taskTitle = taskTitle.substring(1).trim();
    } else if (lower.startsWith('add task:') || lower.startsWith('add task ') || lower.startsWith('add ')) {
      taskTitle = raw.substring(raw.indexOf(' ') + 1).trim();
      if (taskTitle.startsWith(':')) taskTitle = taskTitle.substring(1).trim();
    }

    // Determine priority from text
    String priority = 'Medium';
    if (lower.contains('urgent') || lower.contains('priority high') || lower.contains('high priority')) {
      priority = 'High';
      taskTitle = taskTitle.replaceAll(RegExp(r'(priority high|urgent|high priority)', caseSensitive: false), '').trim();
    } else if (lower.contains('priority low') || lower.contains('low priority')) {
      priority = 'Low';
      taskTitle = taskTitle.replaceAll(RegExp(r'(priority low|low priority)', caseSensitive: false), '').trim();
    }

    if (taskTitle.isEmpty) taskTitle = 'AI Productivity Sprint';

    widget.provider.createTask(
      title: taskTitle,
      priority: priority,
      project: 'AI Assistant',
      date: 'Today',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      colorTheme: priority == 'High' ? 'purple' : 'blue',
    );

    final created = widget.provider.tasks.first;
    setState(() {
      _lastCreatedTask = created;
      _lastActionFeedback = 'Created: "${created.title}" ($priority Priority)';
      _isRecordingAudio = false;
    });

    widget.provider.showToast(
      'Task created in schedule!',
      icon: Icons.check_circle_rounded,
      color: const Color(0xFF10B981),
    );
    _promptController.clear();
  }

  TaskModel? _findTaskByQuery(String query) {
    final lower = query.toLowerCase();
    for (final task in widget.provider.tasks) {
      if (task.title.toLowerCase().contains(lower) || task.id.toString() == query) {
        return task;
      }
    }
    return null;
  }

  void _cycleTaskPriority(TaskModel task) {
    String nextPriority;
    switch (task.priority) {
      case 'High':
        nextPriority = 'Low';
        break;
      case 'Low':
        nextPriority = 'Medium';
        break;
      default:
        nextPriority = 'High';
        break;
    }
    final updated = task.copyWith(priority: nextPriority);
    widget.provider.updateTask(updated);
    if (_lastCreatedTask?.id == task.id) {
      setState(() {
        _lastCreatedTask = updated;
      });
    }
    widget.provider.showToast(
      'Priority set to $nextPriority',
      icon: Icons.flag_rounded,
      color: const Color(0xFF3B82F6),
    );
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

          // Main View Switcher: Left Screen (Showcase) vs Right Screen (Create & CRUD Manager)
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
    final totalTasks = widget.provider.tasks.length;
    final doneTasks = widget.provider.tasks.where((t) => t.isCompleted).length;

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

                      // Search / Quick Create Button
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

                        // Main Blue Card Container
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
                                      onTap: () {
                                        setState(() {
                                          _activeSegmentIndex = 1;
                                          _isChatOpen = true;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFrostedCardIcon(
                                      icon: Icons.more_vert_rounded,
                                      onTap: () => _openChatView(),
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
                                        icon: Icons.task_alt_rounded,
                                        label: '$totalTasks Tasks',
                                      ),
                                      _buildCardStatItem(
                                        icon: Icons.check_circle_outline_rounded,
                                        label: '$doneTasks Done',
                                      ),
                                      _buildCardStatItem(
                                        icon: Icons.favorite_rounded,
                                        label: '585',
                                      ),
                                      // Chat Button: clicking opens the right creation/CRUD screen!
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
  // RIGHT SCREEN: Create & CRUD Manager UI
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

                  // Pill Tab Switcher: "Rocket Create" vs "Box Templates / Manage"
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

                        // Right Pill: Templates / Manage Tasks (READ, UPDATE, DELETE)
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

                  // Main White Content Card
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
                      child: _activeSegmentIndex == 0
                          ? _buildCreateTaskCardContent()
                          : _buildManageTasksCRUDContent(),
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
                            _handlePromptAction('Create task: Photo assets sprint high priority');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickActionTile(
                          icon: Icons.videocam_outlined,
                          label: 'Videos',
                          onTap: () {
                            _toggleAudioRecording();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickActionTile(
                          icon: Icons.graphic_eq_rounded,
                          label: 'Sounds',
                          onTap: () {
                            setState(() {
                              _activeSegmentIndex = 1; // View all tasks
                            });
                            widget.provider.showToast(
                              'Viewing all ${widget.provider.tasks.length} tasks',
                              icon: Icons.list_alt_rounded,
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
                            _cycleSurprisePrompt();
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

  // ==========================================
  // TAB 0: CREATE TASK CONTENT
  // ==========================================
  Widget _buildCreateTaskCardContent() {
    return Column(
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
            onSubmitted: (val) => _handlePromptAction(val),
          ),
        ),

        // Center Area: Sparkle or newly created task feedback
        Expanded(
          child: Center(
            child: _isRecordingAudio
                ? _buildAudioWaveformIndicator()
                : _lastCreatedTask != null
                    ? _buildCreatedTaskPreviewCard(_lastCreatedTask!)
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

        // Action feedback message
        if (_lastActionFeedback != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              _lastActionFeedback!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Card Bottom Bar: "+ Surprise me" and Send/Mic Button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
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

              // Circular Blue Send Button -> Creates Task!
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handlePromptAction(),
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
    );
  }

  // ==========================================
  // TAB 1: MANAGE TASKS (READ, UPDATE, DELETE)
  // ==========================================
  Widget _buildManageTasksCRUDContent() {
    final tasks = widget.provider.tasks;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Count & Quick Add button
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Manager (CRUD)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${tasks.where((t) => t.isCompleted).length}/${tasks.length} Completed',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Quick Add Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _activeSegmentIndex = 0;
                  });
                  _promptController.text = 'New Sprint Task';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_rounded, size: 14, color: Color(0xFF2563EB)),
                      SizedBox(width: 4),
                      Text(
                        'New',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          const SizedBox(height: 8),

          // Scrollable List of Tasks
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.task_rounded, size: 36, color: Color(0xFFCBD5E1)),
                        const SizedBox(height: 8),
                        const Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _activeSegmentIndex = 0;
                            });
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Create with AI'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildCrudTaskTile(task);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Single Task Item with Interactive CRUD controls
  Widget _buildCrudTaskTile(TaskModel task) {
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = const Color(0xFFEF4444);
        break;
      case 'Low':
        priorityColor = const Color(0xFF64748B);
        break;
      default:
        priorityColor = const Color(0xFFF59E0B);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: task.isCompleted ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? const Color(0xFFE2E8F0) : const Color(0xFFE2E8F0),
        ),
        boxShadow: task.isCompleted
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        children: [
          // UPDATE: Complete Checkbox
          GestureDetector(
            onTap: () {
              widget.provider.toggleTaskComplete(task.id);
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: task.isCompleted ? const Color(0xFF10B981) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 8),

          // Title & Time (READ)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: task.isCompleted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.startTime} • ${task.project}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // UPDATE: Priority Badge (Tap to cycle priority!)
          GestureDetector(
            onTap: () => _cycleTaskPriority(task),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.priority,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: priorityColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // UPDATE: Star Toggle
          GestureDetector(
            onTap: () {
              widget.provider.toggleTaskStarred(task.id);
            },
            child: Icon(
              task.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 18,
              color: task.isStarred ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
            ),
          ),

          const SizedBox(width: 6),

          // DELETE: Trash Button
          GestureDetector(
            onTap: () {
              final title = task.title;
              widget.provider.deleteTask(task.id);
              widget.provider.showToast(
                'Deleted "$title"',
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
              );
            },
            child: const Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  // Newly Created Task Preview Card inside Tab 0
  Widget _buildCreatedTaskPreviewCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'Task Created Successfully!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                ),
              ),
              const Spacer(),
              // Delete shortcut
              GestureDetector(
                onTap: () {
                  widget.provider.deleteTask(task.id);
                  setState(() {
                    _lastCreatedTask = null;
                  });
                  widget.provider.showToast('Task removed', icon: Icons.delete_outline);
                },
                child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _cycleTaskPriority(task),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    task.priority,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _activeSegmentIndex = 1;
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Manage All Tasks →',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
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
            'Listening... Speak task name',
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

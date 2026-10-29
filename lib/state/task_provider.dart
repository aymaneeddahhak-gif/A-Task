import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../models/notification_model.dart';
import '../models/user_profile_model.dart';
import '../services/local_storage_service.dart';

class TaskProvider extends ChangeNotifier {
  static const String _storageKeyTasks = 'atask_persisted_tasks_v1';
  static const String _storageKeyPrefs = 'atask_persisted_prefs_v1';
  static final DateFormat _clockFormat = DateFormat('hh:mm a');
  static final DateFormat _fullDateFormat = DateFormat('EEE, MMM d');

  List<TaskModel> _tasks = [];
  String _timeFilterScope = 'Daily Sprint';
  String _statusFilter = 'All'; // 'All', 'To Do', 'In Progress', 'In Review', 'Done'

  // Cached single-pass metrics & filtered task list for O(1) reads during build()
  List<TaskModel> _cachedFilteredTasks = const [];
  int _todoCount = 0;
  int _inProgressCount = 0;
  int _inReviewCount = 0;
  int _doneCount = 0;
  int _totalTasksCount = 0;
  int _completedTasksCount = 0;
  int _pendingTasksCount = 0;
  double _overallProgressFraction = 0.0;

  // Live real-time clock state
  DateTime _now = DateTime.now();
  Timer? _liveTicker;
  final List<AppNotificationItem> _liveEventNotifications = [];
  final Set<int> _autoActivatedTaskIds = {};

  // Tab mapping: 0 = Home, 1 = Tasks/Schedule, 2 = AI Bot, 3 = Profile
  int _selectedTab = 0;
  bool _isNotificationsOpen = false;
  bool _isPushNotificationsEnabled = true;
  bool _isAddTaskOpen = false;
  TaskModel? _selectedTaskForDetail;
  bool _isTaskDetailInEditMode = false;
  bool _isDesignSandboxOpen = false;

  final Set<String> _readNotificationIds = {};
  final Set<String> _dismissedNotificationIds = {};

  List<RoutineItem> _routines = [];

  // Profile fields matching preview 1:1
  String _profileImage = 'assets/images/profile.png';
  String _userName = 'AYMANE';
  String _userEmail = 'ayman.dahhak.cr7@gmail.com';
  String _userPhone = '+212 6 23 45 67 89';
  String _userRole = 'Software Engineer & Mobile Architect';
  String _userLocation = 'Casablanca, Morocco';
  String _userBio =
      'Senior UI/UX & Mobile Architect passionate about clean motion design, Flutter engineering, and AI-driven workflows.';
  String _userPortfolio = 'https://aymanedahhak.com';
  String _userGithub = 'https://github.com/aymane';
  String _selectedLanguage = 'English (US)';
  String _selectedCurrency = 'USD (\$)';
  String _selectedTheme = 'Light Theme';
  String _accentColorName = 'Signature Orange';
  bool _biometricEnabled = true;
  bool _autoLockEnabled = true;
  bool _twoFactorEnabled = false;
  bool _isGoogleConnected = true;
  String _googleAccountEmail = 'ayman.dahhak.cr7@gmail.com';
  bool _isLoggedIn = true;
  String _currentPassword = 'password123';
  double _avatarScale = 1.35;
  double _avatarOffsetX = 0.0;
  double _avatarOffsetY = -0.15;

  // Atmosphere Mode: 'auto', 'morning', 'afternoon', 'night'
  String _atmosphereMode = 'auto';
  double _atmosphereSpread = 0.85;

  List<UserDevice> _devices = [
    UserDevice(
      deviceName: 'Google Pixel 9 Pro',
      location: 'Casablanca, MA',
      lastActive: 'Active Now',
      isCurrentDevice: true,
    ),
    UserDevice(
      deviceName: 'MacBook Pro 16"',
      location: 'Casablanca, MA',
      lastActive: '2 hours ago',
      isCurrentDevice: false,
    ),
    UserDevice(
      deviceName: 'iPad Air 5th Gen',
      location: 'Home Office',
      lastActive: 'Yesterday at 8:45 PM',
      isCurrentDevice: false,
    ),
  ];

  TaskProvider() {
    _initializeDefaultData();
    _loadFromStorage();
    _recomputeMetrics();
    _startLiveClockTicker();
  }

  void _startLiveClockTicker() {
    _liveTicker?.cancel();
    _liveTicker = Timer.periodic(const Duration(seconds: 30), (_) {
      final current = DateTime.now();
      final minuteChanged =
          current.minute != _now.minute || current.hour != _now.hour;
      _now = current;
      bool tasksChanged = _syncRealTimeTaskStatuses(current);
      if (minuteChanged || tasksChanged) {
        if (tasksChanged) {
          _recomputeMetrics();
          _saveTasksToStorage();
        }
        notifyListeners();
      }
    });
  }

  /// Automatically transitions 'To Do' tasks into 'In Progress' when their live time window starts.
  bool _syncRealTimeTaskStatuses(DateTime current) {
    bool mutated = false;
    for (int i = 0; i < _tasks.length; i++) {
      final t = _tasks[i];
      if (!t.isCompleted &&
          (t.status == 'To Do' || t.status.isEmpty) &&
          t.isCurrentlyActive(current)) {
        final updated = t.copyWith(status: 'In Progress');
        _tasks[i] = updated;
        mutated = true;
        if (!_autoActivatedTaskIds.contains(t.id)) {
          _autoActivatedTaskIds.add(t.id);
          _pushLiveNotification(
            id: 'live_active_${t.id}',
            title: 'Active Now: ${t.title}',
            description: '${t.startTime} - ${t.endTime} · ${t.project}',
            type: NotificationType.upcomingTask,
          );
        }
      }
    }
    return mutated;
  }

  void _pushLiveNotification({
    required String id,
    required String title,
    required String description,
    required NotificationType type,
  }) {
    final stamp = 'Today at ${_clockFormat.format(DateTime.now())}';
    _liveEventNotifications.removeWhere((n) => n.id == id);
    _liveEventNotifications.insert(
      0,
      AppNotificationItem(
        id: id,
        title: title,
        description: description,
        timeAgo: stamp,
        isRead: false,
        type: type,
        section: 'Today',
      ),
    );
    if (_liveEventNotifications.length > 15) {
      _liveEventNotifications.removeLast();
    }
  }

  void _loadFromStorage() {
    try {
      final rawTasks = LocalStorageService.getString(_storageKeyTasks);
      if (rawTasks != null && rawTasks.isNotEmpty) {
        final decoded = jsonDecode(rawTasks);
        if (decoded is List) {
          _tasks = decoded
              .whereType<Map<String, dynamic>>()
              .map(TaskModel.fromJson)
              .toList();
        }
      }
      final rawPrefs = LocalStorageService.getString(_storageKeyPrefs);
      if (rawPrefs != null && rawPrefs.isNotEmpty) {
        final map = jsonDecode(rawPrefs);
        if (map is Map<String, dynamic>) {
          _atmosphereMode = (map['atmosphereMode'] as String?) ?? _atmosphereMode;
          _userName = (map['userName'] as String?) ?? _userName;
          _userRole = (map['userRole'] as String?) ?? _userRole;
          _userLocation = (map['userLocation'] as String?) ?? _userLocation;
          final readIds = map['readNotifs'];
          if (readIds is List) {
            _readNotificationIds.addAll(readIds.whereType<String>());
          }
          final dismissedIds = map['dismissedNotifs'];
          if (dismissedIds is List) {
            _dismissedNotificationIds.addAll(dismissedIds.whereType<String>());
          }
        }
      }
    } catch (_) {}
  }

  void _saveTasksToStorage() {
    try {
      final encoded = jsonEncode(_tasks.map((t) => t.toJson()).toList());
      LocalStorageService.setString(_storageKeyTasks, encoded);
    } catch (_) {}
  }

  void _savePrefsToStorage() {
    try {
      final encoded = jsonEncode({
        'atmosphereMode': _atmosphereMode,
        'userName': _userName,
        'userRole': _userRole,
        'userLocation': _userLocation,
        'readNotifs': _readNotificationIds.toList(),
        'dismissedNotifs': _dismissedNotificationIds.toList(),
      });
      LocalStorageService.setString(_storageKeyPrefs, encoded);
    } catch (_) {}
  }

  /// Single-pass O(N) computation of all task counters and filtered task lists.
  void _recomputeMetrics() {
    int todo = 0;
    int inProg = 0;
    int inRev = 0;
    int done = 0;
    int totalNonFree = 0;
    int completedNonFree = 0;
    final List<TaskModel> filtered = [];

    for (final t in _tasks) {
      final bool isDone = t.isCompleted || t.status == 'Done' || t.status.toLowerCase() == 'done';
      final bool isTodo = !isDone && (t.status == 'To Do' || t.status.isEmpty);
      final bool isInProg = !isDone && t.status == 'In Progress';
      final bool isInRev = !isDone && t.status == 'In Review';

      if (isDone) {
        done++;
      } else if (isTodo) {
        todo++;
      } else if (isInProg) {
        inProg++;
      } else if (isInRev) {
        inRev++;
      }

      if (!t.isFreeTime) {
        totalNonFree++;
        if (isDone) completedNonFree++;
      }

      if (_statusFilter == 'All') {
        filtered.add(t);
      } else if (_statusFilter == 'To Do' && isTodo) {
        filtered.add(t);
      } else if (_statusFilter == 'In Progress' && isInProg) {
        filtered.add(t);
      } else if (_statusFilter == 'In Review' && isInRev) {
        filtered.add(t);
      } else if (_statusFilter == 'Done' && isDone) {
        filtered.add(t);
      }
    }

    _todoCount = todo;
    _inProgressCount = inProg;
    _inReviewCount = inRev;
    _doneCount = done;
    _totalTasksCount = totalNonFree;
    _completedTasksCount = completedNonFree;
    _pendingTasksCount = (totalNonFree - completedNonFree).clamp(0, 999);
    _overallProgressFraction = totalNonFree > 0
        ? (completedNonFree / totalNonFree).clamp(0.0, 1.0)
        : 0.0;
    _cachedFilteredTasks = List<TaskModel>.unmodifiable(filtered);
  }

  @override
  void dispose() {
    _liveTicker?.cancel();
    super.dispose();
  }

  // Real-time Date/Time & Weather Getters
  DateTime get now => _now;
  String get liveClockString => _clockFormat.format(_now);
  String get liveDateLabel => _fullDateFormat.format(_now);

  /// Realistic diurnal temperature based on the user's current local hour.
  int get liveTemperatureCelsius {
    final h = _now.hour + (_now.minute / 60.0);
    // Smooth diurnal curve peaking around 14:30 (24°C) and dipping around 05:00 (14°C)
    final radians = ((h - 5.0) / 24.0) * 2 * pi;
    final temp = 19.0 - 5.0 * cos(radians);
    return temp.round();
  }

  String get liveTemperatureDisplay => '$liveTemperatureCelsius°';

  String get liveWeatherCondition {
    final h = _now.hour;
    if (h >= 5 && h < 9) return 'Fresh Dawn';
    if (h >= 9 && h < 12) return 'Sunny Morning';
    if (h >= 12 && h < 16) return 'Clear Sky';
    if (h >= 16 && h < 19) return 'Golden Hour';
    if (h >= 19 && h < 22) return 'Cool Evening';
    return 'Clear Night';
  }

  // Getters
  List<TaskModel> get allTasks => _tasks;
  List<TaskModel> get tasks => _tasks;
  String get timeFilterScope => _timeFilterScope;
  String get statusFilter => _statusFilter;
  int get selectedTab => _selectedTab;
  bool get isNotificationsOpen => _isNotificationsOpen;
  bool get isPushNotificationsEnabled => _isPushNotificationsEnabled;
  bool get isAddTaskOpen => _isAddTaskOpen;
  TaskModel? get selectedTaskForDetail => _selectedTaskForDetail;
  bool get isTaskDetailInEditMode => _isTaskDetailInEditMode;
  bool get isDesignSandboxOpen => _isDesignSandboxOpen;
  TaskModel? _candidateRandomTask;
  TaskModel? get candidateRandomTask => _candidateRandomTask;
  List<RoutineItem> get routines => _routines;
  List<UserDevice> get devices => _devices;

  // Atmosphere Mode Getters & Helpers
  String get atmosphereMode => _atmosphereMode;
  double get atmosphereSpread => _atmosphereSpread;

  // 0: Morning, 1: Afternoon, 2: Night
  int get activeAtmosphereIndex {
    if (_atmosphereMode == 'morning') return 0;
    if (_atmosphereMode == 'afternoon') return 1;
    if (_atmosphereMode == 'night') return 2;
    // Auto based on live local hour
    final hour = _now.hour;
    if (hour >= 5 && hour < 12) {
      return 0; // Morning (5am - 11:59am)
    } else if (hour >= 12 && hour < 19) {
      return 1; // Afternoon / Sunset (12pm - 6:59pm)
    } else {
      return 2; // Night (7pm - 4:59am)
    }
  }

  void setAtmosphereMode(String mode) {
    if (_atmosphereMode == mode) return;
    _atmosphereMode = mode;
    _savePrefsToStorage();
    notifyListeners();
  }

  void cycleAtmosphereMode() {
    if (_atmosphereMode == 'auto') {
      _atmosphereMode = 'morning';
    } else if (_atmosphereMode == 'morning') {
      _atmosphereMode = 'afternoon';
    } else if (_atmosphereMode == 'afternoon') {
      _atmosphereMode = 'night';
    } else {
      _atmosphereMode = 'auto';
    }
    _savePrefsToStorage();
    notifyListeners();
  }

  void openRandomTask() {
    _candidateRandomTask = generateRandomTaskCandidate();
    notifyListeners();
  }

  void closeRandomTask() {
    _candidateRandomTask = null;
    notifyListeners();
  }

  void rerollRandomTask([String? routineType]) {
    final type = routineType ?? _candidateRandomTask?.routineType ?? 'None';
    _candidateRandomTask = generateRandomTaskCandidate(routineType: type);
    notifyListeners();
  }

  void updateRandomTaskCandidate(TaskModel updated) {
    _candidateRandomTask = updated;
    notifyListeners();
  }

  void confirmRandomTask() {
    if (_candidateRandomTask != null) {
      final task = _candidateRandomTask!;
      addCandidateTask(task);
      _candidateRandomTask = null;
      showToast('Task added to schedule!', icon: Icons.check_circle_rounded);
      notifyListeners();
    }
  }

  // Profile Getters
  String get profileImage => _profileImage;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userRole => _userRole;
  String get userLocation => _userLocation;
  String get userBio => _userBio;
  String get userPortfolio => _userPortfolio;
  String get userGithub => _userGithub;
  String get selectedLanguage => _selectedLanguage;
  String get selectedCurrency => _selectedCurrency;
  String get selectedTheme => _selectedTheme;
  String get accentColorName => _accentColorName;
  bool get biometricEnabled => _biometricEnabled;
  bool get autoLockEnabled => _autoLockEnabled;
  bool get twoFactorEnabled => _twoFactorEnabled;
  bool get isGoogleConnected => _isGoogleConnected;
  String get googleAccountEmail => _googleAccountEmail;
  bool get isLoggedIn => _isLoggedIn;
  double get avatarScale => _avatarScale;
  double get avatarOffsetX => _avatarOffsetX;
  double get avatarOffsetY => _avatarOffsetY;

  void updateAvatarFraming(double scale, double dx, double dy) {
    _avatarScale = scale.clamp(1.0, 3.5);
    _avatarOffsetX = dx.clamp(-1.0, 1.0);
    _avatarOffsetY = dy.clamp(-1.0, 1.0);
    notifyListeners();
  }

  bool verifyPassword(String pass) =>
      pass == _currentPassword || pass == 'password123';

  bool changePassword(String oldPass, String newPass) {
    if (verifyPassword(oldPass) && newPass.length >= 6) {
      _currentPassword = newPass;
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? location,
    String? bio,
    String? portfolio,
    String? github,
    String? profileImage,
  }) {
    if (name != null && name.isNotEmpty) _userName = name;
    if (email != null && email.isNotEmpty) _userEmail = email;
    if (phone != null) _userPhone = phone;
    if (role != null) _userRole = role;
    if (location != null) _userLocation = location;
    if (bio != null) _userBio = bio;
    if (portfolio != null) _userPortfolio = portfolio;
    if (github != null) _userGithub = github;
    if (profileImage != null) _profileImage = profileImage;
    _savePrefsToStorage();
    notifyListeners();
  }

  void connectGoogle(String email) {
    _isGoogleConnected = true;
    _googleAccountEmail = email;
    _userEmail = email;
    notifyListeners();
  }

  void disconnectGoogle() {
    _isGoogleConnected = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isGoogleConnected = false;
    notifyListeners();
  }

  void login({String? email, String? name}) {
    _isLoggedIn = true;
    if (email != null) _userEmail = email;
    if (name != null) _userName = name;
    notifyListeners();
  }

  void setSelectedLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void setSelectedCurrency(String curr) {
    _selectedCurrency = curr;
    notifyListeners();
  }

  void setSelectedTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void toggleBiometrics() {
    _biometricEnabled = !_biometricEnabled;
    notifyListeners();
  }

  void toggleAutoLock() {
    _autoLockEnabled = !_autoLockEnabled;
    notifyListeners();
  }

  void toggleTwoFactor() {
    _twoFactorEnabled = !_twoFactorEnabled;
    notifyListeners();
  }

  void removeDevice(int index) {
    if (index >= 0 && index < _devices.length) {
      _devices.removeAt(index);
      notifyListeners();
    }
  }

  // O(1) Cached Getters for Filtered Tasks & Counts
  List<TaskModel> get filteredTasks => _cachedFilteredTasks;
  int get allCount => _tasks.length;
  int get todoCount => _todoCount;
  int get inProgressCount => _inProgressCount;
  int get inReviewCount => _inReviewCount;
  int get doneCount => _doneCount;
  int get totalTasksCount => _totalTasksCount;
  int get completedTasksCount => _completedTasksCount;
  int get pendingTasksCount => _pendingTasksCount;
  double get overallProgressFraction => _overallProgressFraction;

  // Real-Time + System Notifications (Strictly excluding any "Tomorrow" concepts)
  List<AppNotificationItem> get notifications {
    final List<AppNotificationItem> list = [
      ..._liveEventNotifications.map(
        (n) => AppNotificationItem(
          id: n.id,
          title: n.title,
          description: n.description,
          timeAgo: n.timeAgo,
          isRead: _readNotificationIds.contains(n.id),
          type: n.type,
          section: n.section,
        ),
      ),
      AppNotificationItem(
        id: 'notif_1',
        title: 'Task Achieved: Design System Review',
        description: 'Completed on schedule · Great job!',
        timeAgo: 'Today at 09:30 AM',
        isRead: _readNotificationIds.contains('notif_1'),
        type: NotificationType.taskAchieved,
        section: 'Today',
      ),
      AppNotificationItem(
        id: 'notif_2',
        title: 'Upcoming: Deep Work Focus Sprint',
        description: 'Starts at 11:30 AM · High priority',
        timeAgo: 'Today at 11:30 AM',
        isRead: _readNotificationIds.contains('notif_2'),
        type: NotificationType.upcomingTask,
        section: 'Today',
      ),
      AppNotificationItem(
        id: 'notif_3',
        title: 'Routine Suggestion: Peak Focus Block',
        description: 'Optimal time for architecture design blocks.',
        timeAgo: 'Today at 02:00 PM',
        isRead: _readNotificationIds.contains('notif_3'),
        type: NotificationType.routineSuggestion,
        section: 'Today',
      ),
      AppNotificationItem(
        id: 'notif_4',
        title:
            'Weekly Sprint: ${(_overallProgressFraction * 100).round()}% Live Progress',
        description: _totalTasksCount > 0
            ? 'You completed $_completedTasksCount of $_totalTasksCount scheduled tasks.'
            : 'You completed 12 tasks this week. Keep up the high productivity!',
        timeAgo: 'This week',
        isRead: _readNotificationIds.contains('notif_4'),
        type: NotificationType.bestDayInsight,
        section: 'This Week',
      ),
      AppNotificationItem(
        id: 'notif_5',
        title: 'Productivity Summary: High Performance',
        description: 'All core routines synchronized in real time.',
        timeAgo: 'This week',
        isRead: _readNotificationIds.contains('notif_5'),
        type: NotificationType.productivitySummary,
        section: 'This Week',
      ),
      AppNotificationItem(
        id: 'notif_6',
        title: 'Login detected: Pixel 9 Pro',
        description: 'Profile session verified and synchronized.',
        timeAgo: 'Active session',
        isRead: _readNotificationIds.contains('notif_6'),
        type: NotificationType.securityLogin,
        section: 'Security',
      ),
    ];

    return list
        .where((n) => !_dismissedNotificationIds.contains(n.id))
        .where(
          (n) =>
              !n.section.toLowerCase().contains('tomorrow') &&
              !n.title.toLowerCase().contains('tomorrow'),
        )
        .toList();
  }

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;

  void setSelectedTab(int index) {
    if (_selectedTab == index) return;
    _selectedTab = index;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    if (_statusFilter == filter) return;
    _statusFilter = filter;
    _recomputeMetrics();
    notifyListeners();
  }

  void setTimeFilterScope(String scope) {
    if (_timeFilterScope == scope) return;
    _timeFilterScope = scope;
    notifyListeners();
  }

  void toggleTaskComplete(int taskId) {
    TaskModel? toggledTask;
    _tasks = _tasks.map((task) {
      if (task.id == taskId) {
        final newCompleted = !task.isCompleted;
        final updated = task.copyWith(
          isCompleted: newCompleted,
          status: newCompleted ? 'Done' : 'In Progress',
        );
        toggledTask = updated;
        return updated;
      }
      return task;
    }).toList();

    if (toggledTask != null && toggledTask!.isCompleted) {
      _pushLiveNotification(
        id: 'notif_done_${toggledTask!.id}_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Task Achieved: ${toggledTask!.title}',
        description:
            'Completed at ${_clockFormat.format(DateTime.now())} · ${toggledTask!.project}',
        type: NotificationType.taskAchieved,
      );
    }

    if (_selectedTaskForDetail != null &&
        _selectedTaskForDetail!.id == taskId) {
      _selectedTaskForDetail = _tasks.firstWhere((t) => t.id == taskId);
    }
    _recomputeMetrics();
    _saveTasksToStorage();
    notifyListeners();
  }

  void toggleTaskStarred(int taskId) {
    _tasks = _tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isStarred: !task.isStarred);
      }
      return task;
    }).toList();
    if (_selectedTaskForDetail != null &&
        _selectedTaskForDetail!.id == taskId) {
      _selectedTaskForDetail = _tasks.firstWhere((t) => t.id == taskId);
    }
    _recomputeMetrics();
    _saveTasksToStorage();
    notifyListeners();
  }

  void deleteTask(int taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    if (_selectedTaskForDetail?.id == taskId) {
      _selectedTaskForDetail = null;
    }
    _recomputeMetrics();
    _saveTasksToStorage();
    notifyListeners();
  }

  void createTask({
    required String title,
    String description = '',
    String date = 'Today',
    String startTime = '10:00 AM',
    String endTime = '11:00 AM',
    String priority = 'Medium',
    String project = 'Daily Routine',
    String tags = 'Routine',
    bool hasMeeting = false,
    String colorTheme = 'blue',
    String routineType = 'None',
  }) {
    final nextId =
        (_tasks.isNotEmpty
            ? _tasks.map((e) => e.id).reduce((a, b) => a > b ? a : b)
            : 0) +
        1;
    final inferredSection = TaskModel.inferTimeSection(startTime);
    final tempTask = TaskModel(
      id: nextId,
      title: title,
      description: description,
      dateString: date,
      startTime: startTime,
      endTime: endTime,
      priority: priority,
      project: project,
      tags: tags,
      hasMeeting: hasMeeting,
      colorTheme: colorTheme,
      timeSection: inferredSection,
      status: 'To Do',
      isCompleted: false,
      routineType: routineType,
    );
    final initialStatus = tempTask.isCurrentlyActive(_now)
        ? 'In Progress'
        : 'To Do';
    final newTask = tempTask.copyWith(status: initialStatus);

    _tasks.insert(0, newTask);
    _pushLiveNotification(
      id: 'notif_created_$nextId',
      title: 'Scheduled: $title',
      description: '$startTime - $endTime ($inferredSection) · $project',
      type: NotificationType.upcomingTask,
    );
    _recomputeMetrics();
    _saveTasksToStorage();
    showToast(
      routineType != 'None'
          ? '$routineType routine created!'
          : 'Task created successfully!',
      icon: Icons.check_circle_rounded,
    );
    notifyListeners();
  }

  void updateTask(TaskModel updated) {
    final resolved = updated.copyWith(
      timeSection: TaskModel.inferTimeSection(updated.startTime),
    );
    _tasks = _tasks.map((t) => t.id == resolved.id ? resolved : t).toList();
    if (_selectedTaskForDetail?.id == resolved.id) {
      _selectedTaskForDetail = resolved;
    }
    _recomputeMetrics();
    _saveTasksToStorage();
    notifyListeners();
  }

  // General Random Task Generator (General everyday productivity & routine options: Day, Week, Month)
  TaskModel generateRandomTaskCandidate({String routineType = 'None'}) {
    final randomTitles = [
      'Deep Focus & High-Impact Work',
      'Clear Email Inbox & Messages',
      'Daily Workout & Stretching',
      'Plan Tomorrow\'s Top 3 Goals',
      'Review Weekly Budget & Expenses',
      'Declutter Desk & Workspace',
      'Read 15 Pages of a Book',
      '30-Min Outdoor Walk & Hydrate',
      'Sort Desktop & Downloads Folder',
      'Healthy Meal Prep & Nutrition',
      'Call Family or Check In on Friend',
      'Backup Important Files & Notes',
      'Evening Reflection & Journaling',
      'Mindful Breathing & Reset Break',
      'Organize Weekly Project Checklist',
    ];
    final randomDescriptions = [
      'Uninterrupted focus session to make steady, meaningful progress.',
      'Process unread communication and reach zero unread messages.',
      'Recharge physical energy with movement and mobility exercises.',
      'Identify key outcomes and schedule them for tomorrow.',
      'Keep track of essential expenses, upcoming bills, and financial goals.',
      'Clean up physical and digital surfaces to foster clarity.',
      'Cultivate consistent reading habits and expand personal knowledge.',
      'Step outside into fresh air and natural daylight to refresh the mind.',
      'Organize digital assets, receipts, and project assets neatly.',
      'Dedicate quiet time to mental relaxation, balance, and gratitude.',
    ];
    final randomProjects = [
      'Personal',
      'Daily Routine',
      'Productivity',
      'Health & Fitness',
      'Finance',
      'Home & Life',
    ];
    final randomThemes = ['blue', 'peach', 'mint', 'purple', 'pink'];
    final rand = Random();

    final nextId =
        (_tasks.isNotEmpty
            ? _tasks.map((e) => e.id).reduce((a, b) => a > b ? a : b)
            : 0) +
        1;
    final hour = rand.nextInt(11) + 8; // 8 AM to 6 PM (covers Morning, Afternoon, Evening)
    final startHourStr = hour > 12
        ? '${(hour - 12).toString().padLeft(2, '0')}:00 PM'
        : '${hour.toString().padLeft(2, '0')}:00 ${hour == 12 ? 'PM' : 'AM'}';
    final endH = hour + 1;
    final endHourStr = endH > 12
        ? '${(endH - 12).toString().padLeft(2, '0')}:00 PM'
        : '${endH.toString().padLeft(2, '0')}:00 ${endH >= 12 ? 'PM' : 'AM'}';

    String dateStr;
    String tagStr;
    String projectStr;

    if (routineType == 'Day') {
      dateStr = 'Daily • Every Day';
      tagStr = 'Daily,Routine,Wellness';
      projectStr = 'Daily Routine';
    } else if (routineType == 'Week') {
      dateStr = 'Weekly • Every ${DateFormat('EEE').format(_now)}';
      tagStr = 'Weekly,Routine,Goals';
      projectStr = 'Weekly Routine';
    } else if (routineType == 'Month') {
      dateStr = 'Monthly • Every ${DateFormat('d').format(_now)}th';
      tagStr = 'Monthly,Routine,Review';
      projectStr = 'Monthly Routine';
    } else {
      dateStr = 'Today';
      tagStr = 'General,Focus';
      projectStr = randomProjects[rand.nextInt(randomProjects.length)];
    }

    return TaskModel(
      id: nextId,
      title: randomTitles[rand.nextInt(randomTitles.length)],
      description: randomDescriptions[rand.nextInt(randomDescriptions.length)],
      dateString: dateStr,
      startTime: startHourStr,
      endTime: endHourStr,
      priority: rand.nextBool() ? 'High' : 'Medium',
      project: projectStr,
      tags: tagStr,
      colorTheme: randomThemes[rand.nextInt(randomThemes.length)],
      timeSection: TaskModel.inferTimeSection(startHourStr),
      status: 'In Progress',
      isCompleted: false,
      assigneeCount: rand.nextInt(3) + 1,
      routineType: routineType,
    );
  }

  void addCandidateTask(TaskModel task) {
    _tasks.insert(0, task);
    _pushLiveNotification(
      id: 'notif_added_${task.id}',
      title: 'Added to Schedule: ${task.title}',
      description: '${task.startTime} - ${task.endTime} · ${task.project}',
      type: NotificationType.upcomingTask,
    );
    _recomputeMetrics();
    _saveTasksToStorage();
    notifyListeners();
  }

  // Random task generator matching Android bolt action
  void applyRandomTask() {
    final newTask = generateRandomTaskCandidate();
    addCandidateTask(newTask);
  }

  // Dialog Controls
  void openNotifications() {
    _isNotificationsOpen = true;
    notifyListeners();
  }

  void closeNotifications() {
    _isNotificationsOpen = false;
    notifyListeners();
  }

  void openAddTask() {
    _isAddTaskOpen = true;
    notifyListeners();
  }

  void closeAddTask() {
    _isAddTaskOpen = false;
    notifyListeners();
  }

  void openTaskDetail(TaskModel task, {bool editMode = false}) {
    _selectedTaskForDetail = task;
    _isTaskDetailInEditMode = editMode;
    notifyListeners();
  }

  void closeTaskDetail() {
    _selectedTaskForDetail = null;
    _isTaskDetailInEditMode = false;
    notifyListeners();
  }

  void setTaskDetailEditMode(bool editMode) {
    _isTaskDetailInEditMode = editMode;
    notifyListeners();
  }

  void openDesignSandbox() {
    _isDesignSandboxOpen = true;
    _selectedTab = 4;
    notifyListeners();
  }

  void closeDesignSandbox() {
    _isDesignSandboxOpen = false;
    _selectedTab = 0;
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final notif in notifications) {
      _readNotificationIds.add(notif.id);
    }
    _savePrefsToStorage();
    notifyListeners();
  }

  void clearAllNotifications() {
    for (final notif in notifications) {
      _dismissedNotificationIds.add(notif.id);
    }
    _savePrefsToStorage();
    notifyListeners();
  }

  void removeNotification(String id) {
    _dismissedNotificationIds.add(id);
    _savePrefsToStorage();
    notifyListeners();
  }

  bool _isLoadingContent = false;
  bool get isLoadingContent => _isLoadingContent;

  void toggleContentLoading() {
    _isLoadingContent = !_isLoadingContent;
    notifyListeners();
  }

  void simulateReload() {
    _isLoadingContent = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1600), () {
      _isLoadingContent = false;
      notifyListeners();
    });
  }

  // In-App Notification Toast (strictly inside mobile device shape)
  String? _activeToastMessage;
  IconData? _activeToastIcon;
  Color? _activeToastColor;

  String? get activeToastMessage => _activeToastMessage;
  IconData? get activeToastIcon => _activeToastIcon;
  Color? get activeToastColor => _activeToastColor;

  void showToast(
    String message, {
    IconData icon = Icons.check_circle_rounded,
    Color color = const Color(0xFF10B981),
  }) {
    _activeToastMessage = message;
    _activeToastIcon = icon;
    _activeToastColor = color;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (_activeToastMessage == message) {
        _activeToastMessage = null;
        _activeToastIcon = null;
        _activeToastColor = null;
        notifyListeners();
      }
    });
  }

  // Soft atmospheric background tint matching the active mode
  Color get softAtmosphereColor {
    final mode = activeAtmosphereIndex;
    if (mode == 2) {
      return const Color(0xFFF1F5F9); // Soft Cool Slate Tint
    } else if (mode == 1) {
      return const Color(0xFFFAF3EC); // Soft Warm Sunset Golden Glow
    } else {
      return const Color(0xFFF2F7FC); // Soft Crisp Morning Sky Blue Tint
    }
  }

  void resetToThisWeekRoutine() {
    _tasks.clear();
    _liveEventNotifications.clear();
    LocalStorageService.remove(_storageKeyTasks);
    _initializeDefaultData();
    _recomputeMetrics();
    notifyListeners();
  }

  void _initializeDefaultData() {
    // Fresh Entry: starts with 0 tasks as requested
    _tasks = [];

    _routines = [
      RoutineItem(
        id: 1,
        name: 'Morning Deep Work',
        timeRange: '09:00 AM - 11:30 AM',
        category: 'Deep Focus',
        isEnabled: true,
      ),
      RoutineItem(
        id: 2,
        name: 'Midday Synchronization',
        timeRange: '11:45 AM - 01:00 PM',
        category: 'Collaboration',
        isEnabled: true,
      ),
      RoutineItem(
        id: 3,
        name: 'Afternoon Architecture Build',
        timeRange: '02:30 PM - 05:00 PM',
        category: 'Sprint',
        isEnabled: true,
      ),
      RoutineItem(
        id: 4,
        name: 'Evening Wrap-Up & Inbox Zero',
        timeRange: '05:30 PM - 06:15 PM',
        category: 'Review',
        isEnabled: true,
      ),
    ];
  }
}

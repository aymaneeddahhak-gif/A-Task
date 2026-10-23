import 'dart:math';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/notification_model.dart';
import '../models/user_profile_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  String _timeFilterScope = 'Daily Sprint';
  String _statusFilter = 'All'; // 'All', 'To Do', 'In Progress', 'In Review', 'Done'

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
  String _userBio = 'Senior UI/UX & Mobile Architect passionate about clean motion design, Flutter engineering, and AI-driven workflows.';
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
    UserDevice(deviceName: 'Google Pixel 9 Pro', location: 'San Francisco, CA', lastActive: 'Active Now', isCurrentDevice: true),
    UserDevice(deviceName: 'MacBook Pro 16"', location: 'San Francisco, CA', lastActive: '2 hours ago', isCurrentDevice: false),
    UserDevice(deviceName: 'iPad Air 5th Gen', location: 'Home Office', lastActive: 'Yesterday at 8:45 PM', isCurrentDevice: false),
  ];

  TaskProvider() {
    _initializeDefaultData();
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
    // Auto based on local hour
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 0; // Morning (5am - 11:59am)
    } else if (hour >= 12 && hour < 19) {
      return 1; // Afternoon / Sunset (12pm - 6:59pm)
    } else {
      return 2; // Night (7pm - 4:59am)
    }
  }

  void setAtmosphereMode(String mode) {
    _atmosphereMode = mode;
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

  bool verifyPassword(String pass) => pass == _currentPassword || pass == 'password123';

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

  // Filtered tasks by status: All, To Do, In Progress, In Review, Done
  List<TaskModel> get filteredTasks {
    if (_statusFilter == 'All') return _tasks;
    if (_statusFilter == 'To Do') {
      return _tasks.where((t) => (t.status == 'To Do' || t.status.isEmpty) && !t.isCompleted).toList();
    }
    if (_statusFilter == 'In Progress') {
      return _tasks.where((t) => t.status == 'In Progress' && !t.isCompleted).toList();
    }
    if (_statusFilter == 'In Review') {
      return _tasks.where((t) => t.status == 'In Review' && !t.isCompleted).toList();
    }
    if (_statusFilter == 'Done') {
      return _tasks.where((t) => t.status == 'Done' || t.isCompleted).toList();
    }
    return _tasks;
  }

  // Status Counts
  int get allCount => _tasks.length;
  int get todoCount => _tasks.where((t) => (t.status == 'To Do' || t.status.isEmpty) && !t.isCompleted).length;
  int get inProgressCount => _tasks.where((t) => t.status == 'In Progress' && !t.isCompleted).length;
  int get inReviewCount => _tasks.where((t) => t.status == 'In Review' && !t.isCompleted).length;
  int get doneCount => _tasks.where((t) => t.status == 'Done' || t.isCompleted).length;

  // Task Stats for Daily Progress Card
  int get totalTasksCount => _tasks.where((t) => !t.isFreeTime).length;
  int get completedTasksCount => _tasks.where((t) => !t.isFreeTime && (t.isCompleted || t.status.toLowerCase() == 'done')).length;
  int get pendingTasksCount => (totalTasksCount - completedTasksCount).clamp(0, 999);
  double get overallProgressFraction => totalTasksCount > 0 ? (completedTasksCount / totalTasksCount).clamp(0.0, 1.0) : 0.0;

  // Notifications - Strictly excluding any "Tomorrow" concepts & badge icons
  List<AppNotificationItem> get notifications {
    final List<AppNotificationItem> list = [
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
        title: 'Weekly Sprint: 85% Completion Goal',
        description: 'You completed 12 tasks this week. Keep up the high productivity!',
        timeAgo: 'This week',
        isRead: _readNotificationIds.contains('notif_4'),
        type: NotificationType.bestDayInsight,
        section: 'This Week',
      ),
      AppNotificationItem(
        id: 'notif_5',
        title: 'Productivity Summary: High Performance',
        description: 'All core routines completed on schedule.',
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
        .where((n) => !n.section.toLowerCase().contains('tomorrow') && !n.title.toLowerCase().contains('tomorrow'))
        .toList();
  }

  int get unreadNotificationCount => notifications.where((n) => !n.isRead).length;

  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void setTimeFilterScope(String scope) {
    _timeFilterScope = scope;
    notifyListeners();
  }

  void toggleTaskComplete(int taskId) {
    _tasks = _tasks.map((task) {
      if (task.id == taskId) {
        final newCompleted = !task.isCompleted;
        return task.copyWith(
          isCompleted: newCompleted,
          status: newCompleted ? 'Done' : 'In Progress',
        );
      }
      return task;
    }).toList();
    if (_selectedTaskForDetail != null && _selectedTaskForDetail!.id == taskId) {
      _selectedTaskForDetail = _tasks.firstWhere((t) => t.id == taskId);
    }
    notifyListeners();
  }

  void toggleTaskStarred(int taskId) {
    _tasks = _tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isStarred: !task.isStarred);
      }
      return task;
    }).toList();
    if (_selectedTaskForDetail != null && _selectedTaskForDetail!.id == taskId) {
      _selectedTaskForDetail = _tasks.firstWhere((t) => t.id == taskId);
    }
    notifyListeners();
  }

  void deleteTask(int taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    if (_selectedTaskForDetail?.id == taskId) {
      _selectedTaskForDetail = null;
    }
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
    final nextId = (_tasks.isNotEmpty ? _tasks.map((e) => e.id).reduce((a, b) => a > b ? a : b) : 0) + 1;
    final newTask = TaskModel(
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
      status: 'To Do',
      isCompleted: false,
      routineType: routineType,
    );
    _tasks.insert(0, newTask);
    showToast(
      routineType != 'None' ? '$routineType routine created!' : 'Task created successfully!',
      icon: Icons.check_circle_rounded,
    );
    notifyListeners();
  }

  void updateTask(TaskModel updated) {
    _tasks = _tasks.map((t) => t.id == updated.id ? updated : t).toList();
    if (_selectedTaskForDetail?.id == updated.id) {
      _selectedTaskForDetail = updated;
    }
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
    final randomProjects = ['Personal', 'Daily Routine', 'Productivity', 'Health & Fitness', 'Finance', 'Home & Life'];
    final randomThemes = ['blue', 'peach', 'mint', 'purple', 'pink'];
    final rand = Random();

    final nextId = (_tasks.isNotEmpty ? _tasks.map((e) => e.id).reduce((a, b) => a > b ? a : b) : 0) + 1;
    final hour = rand.nextInt(7) + 9; // 9 to 15
    final startHourStr = hour > 12 ? '${hour - 12}:00 PM' : '$hour:00 ${hour == 12 ? 'PM' : 'AM'}';
    final endHourStr = (hour + 1) > 12 ? '${hour + 1 - 12}:00 PM' : '${hour + 1}:00 PM';

    String dateStr;
    String tagStr;
    String projectStr;

    if (routineType == 'Day') {
      dateStr = 'Daily • Every Day';
      tagStr = 'Daily,Routine,Wellness';
      projectStr = 'Daily Routine';
    } else if (routineType == 'Week') {
      dateStr = 'Weekly • Every Mon';
      tagStr = 'Weekly,Routine,Goals';
      projectStr = 'Weekly Routine';
    } else if (routineType == 'Month') {
      dateStr = 'Monthly • Every 1st';
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
      status: 'In Progress',
      isCompleted: false,
      assigneeCount: rand.nextInt(3) + 1,
      routineType: routineType,
    );
  }

  void addCandidateTask(TaskModel task) {
    _tasks.insert(0, task);
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
    notifyListeners();
  }

  void clearAllNotifications() {
    for (final notif in notifications) {
      _dismissedNotificationIds.add(notif.id);
    }
    notifyListeners();
  }

  void removeNotification(String id) {
    _dismissedNotificationIds.add(id);
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

  // Soft atmospheric background tint matching the active mode (Light, soft touches so mode never overfills the page)
  Color get softAtmosphereColor {
    final mode = activeAtmosphereIndex;
    if (mode == 2) {
      return const Color(0xFFF1F5F9); // Soft Cool Slate Tint (Like morning & afternoon, night does NOT fill whole page!)
    } else if (mode == 1) {
      return const Color(0xFFFAF3EC); // Soft Warm Sunset Golden Glow
    } else {
      return const Color(0xFFF2F7FC); // Soft Crisp Morning Sky Blue Tint
    }
  }

  void resetToThisWeekRoutine() {
    _tasks.clear();
    _initializeDefaultData();
    notifyListeners();
  }

  void _initializeDefaultData() {
    // Fresh Entry: starts with 0 tasks as requested
    _tasks = [];

    _routines = [
      RoutineItem(id: 1, name: 'Morning Deep Work', timeRange: '09:00 AM - 11:30 AM', category: 'Deep Focus', isEnabled: true),
      RoutineItem(id: 2, name: 'Midday Synchronization', timeRange: '11:45 AM - 01:00 PM', category: 'Collaboration', isEnabled: true),
      RoutineItem(id: 3, name: 'Afternoon Architecture Build', timeRange: '02:30 PM - 05:00 PM', category: 'Sprint', isEnabled: true),
      RoutineItem(id: 4, name: 'Evening Wrap-Up & Inbox Zero', timeRange: '05:30 PM - 06:15 PM', category: 'Review', isEnabled: true),
    ];
  }
}

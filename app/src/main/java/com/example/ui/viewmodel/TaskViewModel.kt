package com.example.ui.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.data.local.AppDatabase
import com.example.data.local.RoutineEntity
import com.example.data.local.TaskEntity
import com.example.data.repository.TaskRepository
import com.example.R
import com.example.ui.screens.AppNotificationItem
import com.example.ui.screens.NotificationType
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

data class TaskStats(
    val totalCount: Int = 4,
    val completedCount: Int = 0,
    val pendingCount: Int = 4,
    val progressFraction: Float = 0.0f
)

enum class TimeFilterScope(val displayName: String, val icon: String) {
    DAY("Day", "☀️"),
    WEEK("Week", "📅"),
    MONTH("Month", "🗓️")
}

data class ConnectedDevice(
    val id: String,
    val deviceName: String,
    val deviceType: String,
    val location: String,
    val lastActive: String,
    val isCurrentDevice: Boolean
)

class TaskViewModel(application: Application) : AndroidViewModel(application) {
    private val repository: TaskRepository

    init {
        val db = AppDatabase.getDatabase(application)
        repository = TaskRepository(db.taskDao(), db.routineDao())
        viewModelScope.launch {
            repository.resetAllToThisWeekRoutineSchedule()
            repository.resetAllRoutinesToThisWeek()
        }
    }

    val allTasks: StateFlow<List<TaskEntity>> = repository.allTasks
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    val allRoutines: StateFlow<List<RoutineEntity>> = repository.allRoutines
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    // Time filter: DAY ("All Day", "Today", "Tomorrow", "Mon"...), WEEK ("All Weeks", "Week 1".."Week 4"), MONTH ("All Months", "Month 1".."Month 12")
    private val _timeFilterScope = MutableStateFlow(TimeFilterScope.DAY)
    val timeFilterScope: StateFlow<TimeFilterScope> = _timeFilterScope.asStateFlow()

    private val _timeFilterSubOption = MutableStateFlow("All Day")
    val timeFilterSubOption: StateFlow<String> = _timeFilterSubOption.asStateFlow()

    // Backward compatibility for day filter
    private val _currentDayFilter = MutableStateFlow("All Day")
    val currentDayFilter: StateFlow<String> = _currentDayFilter.asStateFlow()

    private val _isRoutineManagerOpen = MutableStateFlow(false)
    val isRoutineManagerOpen: StateFlow<Boolean> = _isRoutineManagerOpen.asStateFlow()

    private val _routineToApply = MutableStateFlow<RoutineEntity?>(null)
    val routineToApply: StateFlow<RoutineEntity?> = _routineToApply.asStateFlow()

    private val _isSaveRoutineDialogOpen = MutableStateFlow(false)
    val isSaveRoutineDialogOpen: StateFlow<Boolean> = _isSaveRoutineDialogOpen.asStateFlow()

    private val _statusFilter = MutableStateFlow("All")
    val statusFilter: StateFlow<String> = _statusFilter.asStateFlow()

    private val _categoryFilter = MutableStateFlow("All")
    val categoryFilter: StateFlow<String> = _categoryFilter.asStateFlow()

    // 0 represents "All Dates / All Tasks", while positive integers filter by day
    private val _selectedDay = MutableStateFlow(0)
    val selectedDay: StateFlow<Int> = _selectedDay.asStateFlow()

    private val _selectedDateString = MutableStateFlow("All Schedule")
    val selectedDateString: StateFlow<String> = _selectedDateString.asStateFlow()

    private val _isAddTaskOpen = MutableStateFlow(false)
    val isAddTaskOpen: StateFlow<Boolean> = _isAddTaskOpen.asStateFlow()

    private val _selectedTaskForDetail = MutableStateFlow<TaskEntity?>(null)
    val selectedTaskForDetail: StateFlow<TaskEntity?> = _selectedTaskForDetail.asStateFlow()

    private val _isTaskDetailInEditMode = MutableStateFlow(false)
    val isTaskDetailInEditMode: StateFlow<Boolean> = _isTaskDetailInEditMode.asStateFlow()

    private val _isNotificationsOpen = MutableStateFlow(false)
    val isNotificationsOpen: StateFlow<Boolean> = _isNotificationsOpen.asStateFlow()

    private val _isPushNotificationsEnabled = MutableStateFlow(true)
    val isPushNotificationsEnabled: StateFlow<Boolean> = _isPushNotificationsEnabled.asStateFlow()

    // Refresh animation state
    private val _isRefreshing = MutableStateFlow(false)
    val isRefreshing: StateFlow<Boolean> = _isRefreshing.asStateFlow()

    // ID of the most recently created task for highlight animation
    private val _lastAddedTaskId = MutableStateFlow<Long?>(null)
    val lastAddedTaskId: StateFlow<Long?> = _lastAddedTaskId.asStateFlow()

    // Profile Screen Settings State
    private val _userName = MutableStateFlow("Hadi Jafari")
    val userName: StateFlow<String> = _userName.asStateFlow()

    private val _userEmail = MutableStateFlow("hadijafari.official@gmail.com")
    val userEmail: StateFlow<String> = _userEmail.asStateFlow()

    private val _userRole = MutableStateFlow("Product Designer")
    val userRole: StateFlow<String> = _userRole.asStateFlow()

    private val _userLocation = MutableStateFlow("Madrid, Spain")
    val userLocation: StateFlow<String> = _userLocation.asStateFlow()

    private val _userBio = MutableStateFlow("Senior UI/UX & Mobile Architect passionate about clean motion design and AI workflows.")
    val userBio: StateFlow<String> = _userBio.asStateFlow()

    private val _selectedLanguage = MutableStateFlow("English (US)")
    val selectedLanguage: StateFlow<String> = _selectedLanguage.asStateFlow()

    private val _selectedCurrency = MutableStateFlow("USD ($)")
    val selectedCurrency: StateFlow<String> = _selectedCurrency.asStateFlow()

    private val _selectedTheme = MutableStateFlow("Light Theme")
    val selectedTheme: StateFlow<String> = _selectedTheme.asStateFlow()

    private val _accentColorName = MutableStateFlow("Signature Orange")
    val accentColorName: StateFlow<String> = _accentColorName.asStateFlow()

    private val _biometricEnabled = MutableStateFlow(true)
    val biometricEnabled: StateFlow<Boolean> = _biometricEnabled.asStateFlow()

    private val _autoLockEnabled = MutableStateFlow(true)
    val autoLockEnabled: StateFlow<Boolean> = _autoLockEnabled.asStateFlow()

    private val _twoFactorEnabled = MutableStateFlow(false)
    val twoFactorEnabled: StateFlow<Boolean> = _twoFactorEnabled.asStateFlow()

    private val _connectedDevices = MutableStateFlow(
        listOf(
            ConnectedDevice(
                id = "dev_1",
                deviceName = "Google Pixel 9 Pro",
                deviceType = "Mobile",
                location = "Madrid, Spain",
                lastActive = "Active Now",
                isCurrentDevice = true
            ),
            ConnectedDevice(
                id = "dev_2",
                deviceName = "MacBook Pro 16\" (Chrome)",
                deviceType = "Laptop",
                location = "Madrid, Spain",
                lastActive = "2 hours ago",
                isCurrentDevice = false
            ),
            ConnectedDevice(
                id = "dev_3",
                deviceName = "iPad Pro 12.9\" (Safari)",
                deviceType = "Tablet",
                location = "Barcelona, Spain",
                lastActive = "Yesterday at 4:15 PM",
                isCurrentDevice = false
            )
        )
    )
    val connectedDevices: StateFlow<List<ConnectedDevice>> = _connectedDevices.asStateFlow()

    private val _userNotifications = MutableStateFlow<List<AppNotificationItem>>(emptyList())
    private val _dismissedNotificationIds = MutableStateFlow<Set<String>>(emptySet())
    private val _readNotificationIds = MutableStateFlow<Set<String>>(emptySet())

    private val _notifState = combine(_dismissedNotificationIds, _readNotificationIds) { dismissed, read ->
        dismissed to read
    }

    val notifications: StateFlow<List<AppNotificationItem>> = combine(
        allTasks,
        _connectedDevices,
        _selectedCurrency,
        _userNotifications,
        _notifState
    ) { tasks: List<TaskEntity>, devices: List<ConnectedDevice>, currency: String, userNotifs: List<AppNotificationItem>, notifPrefs: Pair<Set<String>, Set<String>> ->
        val (dismissedIds, readIds) = notifPrefs
        val currSymbol = when {
            currency.contains("EUR", ignoreCase = true) -> "€"
            currency.contains("GBP", ignoreCase = true) -> "£"
            currency.contains("MAD", ignoreCase = true) -> "DH "
            currency.contains("JPY", ignoreCase = true) -> "¥"
            else -> "$"
        }

        val dynamicList = mutableListOf<AppNotificationItem>()

        // 1. Real-time user generated task events (completed tasks, newly created tasks)
        dynamicList.addAll(userNotifs)

        // 2. [Today] Task Achieved Notification (if a completed task exists)
        val completedTask = tasks.firstOrNull { it.isCompleted || it.status.equals("Done", ignoreCase = true) }
        if (completedTask != null) {
            dynamicList.add(
                AppNotificationItem(
                    id = "task_achieved_${completedTask.id}",
                    title = "Task Achieved: ${completedTask.title}",
                    description = "Completed on schedule · Great job!",
                    timeAgo = "This morning at ${completedTask.startTime.ifBlank { "08:30 AM" }}",
                    isRead = false,
                    type = NotificationType.TASK_ACHIEVED,
                    section = "Today",
                    taskId = completedTask.id
                )
            )
        }

        // 3. [Today] Upcoming Task / Next Deadline
        val upcomingTask = tasks.firstOrNull { !it.isCompleted && (it.dateString.contains("Today", ignoreCase = true) || it.priority.equals("High", ignoreCase = true)) }
            ?: tasks.firstOrNull { !it.isCompleted }
        if (upcomingTask != null) {
            dynamicList.add(
                AppNotificationItem(
                    id = "upcoming_${upcomingTask.id}",
                    title = "Upcoming: ${upcomingTask.title}",
                    description = "Starts at ${upcomingTask.startTime} · ${upcomingTask.priority} priority sprint",
                    timeAgo = "Today at ${upcomingTask.startTime}",
                    isRead = false,
                    type = NotificationType.UPCOMING_TASK,
                    section = "Today",
                    taskId = upcomingTask.id
                )
            )
        }

        // 4. [Today] Routine Suggestion
        val pendingCount = tasks.count { !it.isCompleted }
        dynamicList.add(
            AppNotificationItem(
                id = "routine_suggestion_today",
                title = "Routine Suggestion: Deep Work Sprint",
                description = "Recommended routine to finish remaining $pendingCount tasks today.",
                timeAgo = "Recommended for today",
                isRead = false,
                type = NotificationType.ROUTINE_SUGGESTION,
                section = "Today",
                actionRoute = "ROUTINE"
            )
        )

        // 5. [This Week] Best Day / Streak Insight
        val completedTotal = tasks.count { it.isCompleted || it.status.equals("Done", ignoreCase = true) }
        dynamicList.add(
            AppNotificationItem(
                id = "best_day_streak_insight",
                title = "Best Day Insight: Streak Record!",
                description = "You completed $completedTotal tasks this week. Keep up the high productivity!",
                timeAgo = "This week · Peak streak",
                isRead = false,
                type = NotificationType.BEST_DAY_INSIGHT,
                section = "This Week",
                actionRoute = "CALENDAR"
            )
        )

        // 6. [This Week] Weekly Sprint Summary
        dynamicList.add(
            AppNotificationItem(
                id = "productivity_summary_week",
                title = "Sprint Summary: High Performance",
                description = "Focus blocks completed with peak morning focus.",
                timeAgo = "This week",
                isRead = true,
                type = NotificationType.PRODUCTIVITY_SUMMARY,
                section = "This Week",
                actionRoute = "CALENDAR"
            )
        )

        // 7. [Security] Device verification from profile
        val otherDevice = devices.firstOrNull { !it.isCurrentDevice } ?: devices.firstOrNull()
        val deviceDesc = if (otherDevice != null) {
            "Login detected: ${otherDevice.deviceName}"
        } else {
            "Login detected from verified device"
        }
        dynamicList.add(
            AppNotificationItem(
                id = "device_login_alert",
                title = deviceDesc,
                description = "Profile session verified and synchronized.",
                timeAgo = otherDevice?.lastActive ?: "Active session",
                isRead = true,
                type = NotificationType.SECURITY_LOGIN,
                section = "Security",
                actionRoute = "PROFILE"
            )
        )

        // Filter out dismissed notifications, apply read state, and deduplicate
        dynamicList
            .filter { it.id !in dismissedIds }
            .map { notif ->
                if (notif.id in readIds) notif.copy(isRead = true) else notif
            }
            .distinctBy { it.id }
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    // Calculated progress and counts for the currently selected time filter (excluding free time from incomplete counts)
    val taskStats: StateFlow<TaskStats> = combine(
        allTasks,
        _timeFilterScope,
        _timeFilterSubOption
    ) { tasks, scope, subOption ->
        val relevantTasks = tasks.filter { matchesTimeFilter(it, scope, subOption) }
        val actionableTasks = relevantTasks.filter { !it.isFreeTime }
        val total = actionableTasks.size
        val completed = actionableTasks.count { it.isCompleted || it.status.equals("Done", ignoreCase = true) }
        val pending = (total - completed).coerceAtLeast(0)
        val fraction = if (total > 0) completed.toFloat() / total.toFloat() else 0.0f
        TaskStats(
            totalCount = total,
            completedCount = completed,
            pendingCount = pending,
            progressFraction = fraction
        )
    }.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = TaskStats()
    )

    fun setTimeFilterScope(scope: TimeFilterScope) {
        _timeFilterScope.value = scope
        _timeFilterSubOption.value = when (scope) {
            TimeFilterScope.DAY -> "All Day"
            TimeFilterScope.WEEK -> "All Weeks"
            TimeFilterScope.MONTH -> "All Months"
        }
        _currentDayFilter.value = _timeFilterSubOption.value
    }

    fun setTimeFilterSubOption(option: String) {
        _timeFilterSubOption.value = option
        _currentDayFilter.value = option
    }

    fun setDayFilter(day: String) {
        _timeFilterScope.value = TimeFilterScope.DAY
        _timeFilterSubOption.value = day
        _currentDayFilter.value = day
    }

    fun matchesTimeFilter(task: TaskEntity, scope: TimeFilterScope, subOption: String): Boolean {
        return when (scope) {
            TimeFilterScope.DAY -> {
                when {
                    subOption.equals("All Day", ignoreCase = true) ||
                    subOption.equals("All", ignoreCase = true) ||
                    subOption.equals("All Days", ignoreCase = true) -> true
                    subOption.equals("Today", ignoreCase = true) -> {
                        task.dateString.equals("Today", ignoreCase = true)
                    }
                    subOption.equals("Tomorrow", ignoreCase = true) -> {
                        task.dateString.equals("Tomorrow", ignoreCase = true)
                    }
                    else -> {
                        val target = subOption.take(3).lowercase()
                        task.dateString.lowercase().contains(target) ||
                        task.tags.lowercase().contains(target)
                    }
                }
            }
            TimeFilterScope.WEEK -> {
                when {
                    subOption.equals("All Weeks", ignoreCase = true) ||
                    subOption.equals("All", ignoreCase = true) -> true
                    subOption.startsWith("Week", ignoreCase = true) -> {
                        val weekNum = subOption.filter { it.isDigit() }.toIntOrNull() ?: 1
                        if (task.dateString.contains("Week $weekNum", ignoreCase = true) ||
                            task.tags.contains("Week $weekNum", ignoreCase = true)) {
                            return true
                        }
                        val dayNum = extractDayOfMonth(task.dateString)
                        if (dayNum != null) {
                            val computedWeek = when (dayNum) {
                                in 1..7 -> 1
                                in 8..14 -> 2
                                in 15..21 -> 3
                                else -> 4
                            }
                            if (computedWeek == weekNum) return true
                        }
                        val idWeek = (Math.abs(task.id) % 4) + 1
                        idWeek == weekNum
                    }
                    else -> true
                }
            }
            TimeFilterScope.MONTH -> {
                when {
                    subOption.equals("All Months", ignoreCase = true) ||
                    subOption.equals("All", ignoreCase = true) -> true
                    else -> {
                        val monthNum = subOption.filter { it.isDigit() }.toIntOrNull() ?: 1
                        val monthPrefixes = mapOf(
                            1 to listOf("jan", "month 1"),
                            2 to listOf("feb", "month 2"),
                            3 to listOf("mar", "month 3"),
                            4 to listOf("apr", "month 4"),
                            5 to listOf("may", "month 5"),
                            6 to listOf("jun", "month 6"),
                            7 to listOf("jul", "month 7"),
                            8 to listOf("aug", "month 8"),
                            9 to listOf("sep", "month 9"),
                            10 to listOf("oct", "month 10"),
                            11 to listOf("nov", "month 11"),
                            12 to listOf("dec", "month 12")
                        )
                        val prefixes = monthPrefixes[monthNum] ?: emptyList()
                        val lowerDate = task.dateString.lowercase()
                        val lowerTags = task.tags.lowercase()
                        if (prefixes.any { lowerDate.contains(it) || lowerTags.contains(it) }) {
                            return true
                        }
                        if (monthNum == 9 && (lowerDate == "today" || lowerDate == "tomorrow")) {
                            return true
                        }
                        val idMonth = (Math.abs(task.id) % 12) + 1
                        idMonth == monthNum
                    }
                }
            }
        }
    }

    private fun extractDayOfMonth(dateString: String): Int? {
        val regex = Regex("""\b([1-9]|[12][0-9]|3[01])\b""")
        return regex.find(dateString)?.value?.toIntOrNull()
    }

    fun openRoutineManager() {
        _isRoutineManagerOpen.value = true
    }

    fun closeRoutineManager() {
        _isRoutineManagerOpen.value = false
        _routineToApply.value = null
    }

    fun openSaveRoutineDialog() {
        _isSaveRoutineDialogOpen.value = true
    }

    fun closeSaveRoutineDialog() {
        _isSaveRoutineDialogOpen.value = false
    }

    fun openApplyRoutineDialog(routine: RoutineEntity) {
        _routineToApply.value = routine
    }

    fun closeApplyRoutineDialog() {
        _routineToApply.value = null
    }

    fun applyRoutineToDay(routine: RoutineEntity, targetDate: String) {
        viewModelScope.launch {
            repository.applyRoutineToDay(routine, targetDate, replaceExisting = true)
            _routineToApply.value = null
            _isRoutineManagerOpen.value = false
            _currentDayFilter.value = targetDate
        }
    }

    /**
     * Generates a realistic full-day schedule routine with all properties filled:
     * title, description, time slots, section, priority, project, tags, color theme, meeting & free time.
     */
    fun applyRandomFullDayRoutine(customDate: String? = null) {
        viewModelScope.launch {
            val date = customDate ?: when (_timeFilterScope.value) {
                TimeFilterScope.DAY -> {
                    if (_timeFilterSubOption.value.contains("All", ignoreCase = true)) "Today" else _timeFilterSubOption.value
                }
                TimeFilterScope.WEEK -> {
                    if (_timeFilterSubOption.value.contains("All", ignoreCase = true)) "Week 1" else _timeFilterSubOption.value
                }
                TimeFilterScope.MONTH -> {
                    if (_timeFilterSubOption.value.contains("All", ignoreCase = true)) "Month 10" else _timeFilterSubOption.value
                }
            }

            val routineTemplates = listOf(
                listOf(
                    TaskEntity(
                        title = "Early Sunrise Run & Stretch",
                        description = "30-minute outdoor jog, dynamic warm-up and deep hydration.",
                        dateString = date,
                        startTime = "06:45 AM",
                        endTime = "07:30 AM",
                        priority = "Medium",
                        status = "Done",
                        project = "Health & Fitness",
                        tags = "Running,Fitness,Cardio",
                        timeSection = "Morning",
                        colorTheme = "peach",
                        isCompleted = true,
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Breakfast & Daily Goal Setting",
                        description = "Nutritious protein breakfast, espresso & organize priority backlog.",
                        dateString = date,
                        startTime = "07:30 AM",
                        endTime = "08:15 AM",
                        priority = "Medium",
                        status = "Done",
                        project = "Daily Routine",
                        tags = "Morning,Breakfast,Planning",
                        timeSection = "Morning",
                        colorTheme = "mint",
                        isCompleted = true,
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Sprint Standup & Architecture Call",
                        description = "Core team sync: review daily deliverables, blockers & API contracts.",
                        dateString = date,
                        startTime = "08:30 AM",
                        endTime = "09:30 AM",
                        priority = "High",
                        status = "To Do",
                        project = "Work Sprint",
                        tags = "Meeting,Work,Architecture",
                        timeSection = "Morning",
                        colorTheme = "blue",
                        hasMeeting = true,
                        meetTitle = "Sprint Sync",
                        assigneeCount = 4
                    ),
                    TaskEntity(
                        title = "Deep Focus: Mobile App UI/UX",
                        description = "Design and prototype interactive user flows and micro-interactions.",
                        dateString = date,
                        startTime = "09:30 AM",
                        endTime = "12:00 PM",
                        priority = "High",
                        status = "In Progress",
                        project = "Mobile Design",
                        tags = "Design,Figma,UI",
                        timeSection = "Morning",
                        colorTheme = "lavender",
                        assigneeCount = 2
                    ),
                    TaskEntity(
                        title = "Healthy Lunch & Fresh Air Break",
                        description = "Casual lunch away from screens, light walk outside.",
                        dateString = date,
                        startTime = "12:00 PM",
                        endTime = "01:00 PM",
                        priority = "Low",
                        status = "To Do",
                        project = "Personal Time",
                        tags = "Lunch,Break,Wellness",
                        timeSection = "Afternoon",
                        colorTheme = "mint",
                        isFreeTime = true,
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "20-Min Brain Reboot Nap",
                        description = "Power rest to recharge cognitive focus for the afternoon.",
                        dateString = date,
                        startTime = "01:00 PM",
                        endTime = "01:30 PM",
                        priority = "Medium",
                        status = "To Do",
                        project = "Rest & Wellness",
                        tags = "Sleep,Rest,Recharge",
                        timeSection = "Afternoon",
                        colorTheme = "lavender",
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Client Feature Review & Demo",
                        description = "Live product demo of recent milestones and stakeholder feedback.",
                        dateString = date,
                        startTime = "01:45 PM",
                        endTime = "03:00 PM",
                        priority = "High",
                        status = "To Do",
                        project = "Client Projects",
                        tags = "Client,Review,Demo",
                        timeSection = "Afternoon",
                        colorTheme = "blue",
                        hasMeeting = true,
                        meetTitle = "Client Demo",
                        assigneeCount = 3
                    ),
                    TaskEntity(
                        title = "Gym Session: Strength & Weights",
                        description = "Full upper body hypertrophy training and core circuits.",
                        dateString = date,
                        startTime = "03:30 PM",
                        endTime = "05:00 PM",
                        priority = "High",
                        status = "To Do",
                        project = "Health & Fitness",
                        tags = "Gym,Strength,Workout",
                        timeSection = "Afternoon",
                        colorTheme = "red",
                        assigneeCount = 2
                    ),
                    TaskEntity(
                        title = "Coffee & Learning Break",
                        description = "Iced coffee, read technical articles & clean up notes.",
                        dateString = date,
                        startTime = "05:00 PM",
                        endTime = "05:45 PM",
                        priority = "Low",
                        status = "To Do",
                        project = "Break & Wellness",
                        tags = "Coffee,Reading,Focus",
                        timeSection = "Afternoon",
                        colorTheme = "peach",
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Football Match on Pitch ⚽",
                        description = "7-a-side competitive match with friends under the lights.",
                        dateString = date,
                        startTime = "06:00 PM",
                        endTime = "07:30 PM",
                        priority = "Medium",
                        status = "To Do",
                        project = "Sports & Football",
                        tags = "Football,Match,Sports",
                        timeSection = "Evening",
                        colorTheme = "mint",
                        assigneeCount = 6
                    ),
                    TaskEntity(
                        title = "Family Dinner & Chill Time",
                        description = "Warm home-cooked dinner, watch highlights & relax freely.",
                        dateString = date,
                        startTime = "07:45 PM",
                        endTime = "09:30 PM",
                        priority = "Low",
                        status = "To Do",
                        project = "Personal Time",
                        tags = "Dinner,Family,Relax",
                        timeSection = "Evening",
                        colorTheme = "yellow",
                        isFreeTime = true,
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Bedtime Reading & Sleep Prep",
                        description = "Read 20 pages of book, screen off & deep 8-hour sleep.",
                        dateString = date,
                        startTime = "10:30 PM",
                        endTime = "11:00 PM",
                        priority = "High",
                        status = "To Do",
                        project = "Rest & Sleep",
                        tags = "Sleep,Bedtime,Rest",
                        timeSection = "Evening",
                        colorTheme = "lavender",
                        assigneeCount = 1
                    )
                ),
                listOf(
                    TaskEntity(
                        title = "Morning Meditation & Yoga",
                        description = "20-minute mindfulness and mobility flow to start centered.",
                        dateString = date,
                        startTime = "07:00 AM",
                        endTime = "07:35 AM",
                        priority = "Medium",
                        status = "Done",
                        project = "Rest & Wellness",
                        tags = "Yoga,Mindfulness,Morning",
                        timeSection = "Morning",
                        colorTheme = "lavender",
                        isCompleted = true,
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Class & Research Workshop",
                        description = "Interactive design systems lecture & peer critique.",
                        dateString = date,
                        startTime = "08:15 AM",
                        endTime = "11:45 AM",
                        priority = "High",
                        status = "To Do",
                        project = "Education & School",
                        tags = "School,Research,Class",
                        timeSection = "Morning",
                        colorTheme = "blue",
                        hasMeeting = true,
                        meetTitle = "Workshop",
                        assigneeCount = 5
                    ),
                    TaskEntity(
                        title = "Lunch with Team & Coffee",
                        description = "Healthy wrap, cold brew & casual catchup.",
                        dateString = date,
                        startTime = "12:00 PM",
                        endTime = "01:00 PM",
                        priority = "Low",
                        status = "To Do",
                        project = "Personal Time",
                        tags = "Lunch,Team,Social",
                        timeSection = "Afternoon",
                        colorTheme = "mint",
                        isFreeTime = true,
                        assigneeCount = 2
                    ),
                    TaskEntity(
                        title = "Component Design System Polish",
                        description = "Build reusable Compose UI components and typography tokens.",
                        dateString = date,
                        startTime = "01:15 PM",
                        endTime = "03:30 PM",
                        priority = "High",
                        status = "In Progress",
                        project = "Mobile Design",
                        tags = "Design,Compose,UI",
                        timeSection = "Afternoon",
                        colorTheme = "peach",
                        assigneeCount = 2
                    ),
                    TaskEntity(
                        title = "Afternoon Cross-Training",
                        description = "Functional fitness, kettlebell circuits and mobility.",
                        dateString = date,
                        startTime = "03:45 PM",
                        endTime = "05:00 PM",
                        priority = "High",
                        status = "To Do",
                        project = "Health & Fitness",
                        tags = "Fitness,Gym,Crossfit",
                        timeSection = "Afternoon",
                        colorTheme = "red",
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Study Session & Practice Notes",
                        description = "Review algorithm exercises and exam study materials.",
                        dateString = date,
                        startTime = "05:30 PM",
                        endTime = "07:00 PM",
                        priority = "High",
                        status = "To Do",
                        project = "Study & Academics",
                        tags = "Study,Revision,Coding",
                        timeSection = "Evening",
                        colorTheme = "blue",
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Dinner & Gaming / Streaming",
                        description = "Dinner, unwind with favorite games and music.",
                        dateString = date,
                        startTime = "07:30 PM",
                        endTime = "09:30 PM",
                        priority = "Low",
                        status = "To Do",
                        project = "Personal Time",
                        tags = "FreeTime,Gaming,Dinner",
                        timeSection = "Evening",
                        colorTheme = "yellow",
                        isFreeTime = true,
                        assigneeCount = 1
                    ),
                    TaskEntity(
                        title = "Restorative Sleep",
                        description = "Wind down and sleep for complete muscle and mental recovery.",
                        dateString = date,
                        startTime = "10:30 PM",
                        endTime = "11:00 PM",
                        priority = "Medium",
                        status = "To Do",
                        project = "Rest & Sleep",
                        tags = "Sleep,Rest",
                        timeSection = "Evening",
                        colorTheme = "lavender",
                        assigneeCount = 1
                    )
                )
            )

            val chosenRoutine = routineTemplates.random()
            repository.deleteTasksByDate(date)
            repository.insertTasks(chosenRoutine)

            val newNotif = AppNotificationItem(
                id = System.currentTimeMillis().toString(),
                title = "Random Routine Applied",
                description = "Applied ${chosenRoutine.size} full-day activities for '$date'.",
                timeAgo = "Just now",
                isRead = false,
                type = NotificationType.NEW_TASK_CREATED
            )
            _userNotifications.value = listOf(newNotif) + _userNotifications.value
        }
    }

    /**
     * Applies a configured list of tasks to Today, Tomorrow, Week, or Month.
     * Optionally clears existing tasks to create a clean schedule.
     */
    fun applyTasksToScope(
        tasks: List<TaskEntity>,
        scope: String,
        replaceExisting: Boolean = true
    ) {
        viewModelScope.launch {
            repository.applyTasksToScope(tasks, scope, replaceExisting)
            if (scope.equals("Tomorrow", ignoreCase = true)) {
                _currentDayFilter.value = "Tomorrow"
            } else {
                _currentDayFilter.value = "Today"
            }
            closeAddTask()
        }
    }

    fun saveRoutine(
        name: String,
        description: String,
        category: String,
        tasks: List<TaskEntity>
    ) {
        viewModelScope.launch {
            repository.saveTasksAsRoutine(name.ifBlank { "My Routine" }, description, category, tasks)
        }
    }

    fun parseRoutineTasks(routine: RoutineEntity, dateString: String): List<TaskEntity> {
        return repository.parseTasksData(routine.tasksData, dateString)
    }

    fun saveCurrentDayAsRoutine(name: String, description: String, dateString: String = "Today", category: String = "Daily") {
        viewModelScope.launch {
            val tasksToSave = allTasks.value.filter { it.dateString.equals(dateString, ignoreCase = true) }
            if (tasksToSave.isNotEmpty()) {
                repository.saveTasksAsRoutine(name.ifBlank { "My Routine" }, description, category, tasksToSave)
            }
            _isSaveRoutineDialogOpen.value = false
        }
    }

    fun deleteRoutine(routine: RoutineEntity) {
        viewModelScope.launch {
            repository.deleteRoutine(routine)
        }
    }

    fun addQuickFootballMatch(isMorning: Boolean, targetDate: String = "Today") {
        viewModelScope.launch {
            val matchTask = if (isMorning) {
                TaskEntity(
                    title = "Morning Football Match ⚽",
                    description = "Morning friendly football match & drills with friends on the field.",
                    dateString = targetDate,
                    startTime = "06:30 AM",
                    endTime = "07:45 AM",
                    priority = "High",
                    status = "To Do",
                    project = "Sports & Football",
                    tags = "Football,Match,Morning",
                    timeSection = "Morning",
                    colorTheme = "mint",
                    isCompleted = false,
                    isFreeTime = false
                )
            } else {
                TaskEntity(
                    title = "Evening Football Match ⚽",
                    description = "Evening football match with friends under the lights.",
                    dateString = targetDate,
                    startTime = "06:00 PM",
                    endTime = "07:30 PM",
                    priority = "High",
                    status = "To Do",
                    project = "Sports & Football",
                    tags = "Football,Match,Sports",
                    timeSection = "Evening",
                    colorTheme = "mint",
                    isCompleted = false,
                    isFreeTime = false
                )
            }
            repository.insertTask(matchTask)
        }
    }

    fun resetToDefaultRoutineTimeline() {
        viewModelScope.launch {
            repository.resetAllToThisWeekRoutineSchedule()
            repository.resetAllRoutinesToThisWeek()
            _currentDayFilter.value = "Today"
        }
    }

    fun resetToThisWeekRoutine() {
        viewModelScope.launch {
            repository.resetAllToThisWeekRoutineSchedule()
            repository.resetAllRoutinesToThisWeek()
            _isRoutineManagerOpen.value = false
            _currentDayFilter.value = "Today"
        }
    }

    fun refreshTasks() {
        viewModelScope.launch {
            _isRefreshing.value = true
            delay(650) // Smooth refresh animation feedback
            _isRefreshing.value = false
        }
    }

    fun setStatusFilter(status: String) {
        _statusFilter.value = status
    }

    fun setCategoryFilter(category: String) {
        _categoryFilter.value = category
    }

    fun setSelectedDay(day: Int, dateStr: String) {
        _selectedDay.value = day
        _selectedDateString.value = dateStr
    }

    fun updateProfile(name: String, email: String, role: String, location: String, bio: String = "") {
        _userName.value = name.trim().ifEmpty { _userName.value }
        _userEmail.value = email.trim().ifEmpty { _userEmail.value }
        _userRole.value = role.trim().ifEmpty { _userRole.value }
        _userLocation.value = location.trim().ifEmpty { _userLocation.value }
        if (bio.isNotBlank()) _userBio.value = bio.trim()
    }

    fun setLanguage(lang: String) {
        _selectedLanguage.value = lang
    }

    fun setCurrency(currency: String) {
        _selectedCurrency.value = currency
    }

    fun setTheme(theme: String) {
        _selectedTheme.value = theme
    }

    fun setAccentColor(accent: String) {
        _accentColorName.value = accent
    }

    fun setBiometric(enabled: Boolean) {
        _biometricEnabled.value = enabled
        val notif = AppNotificationItem(
            id = "sec_bio_${System.currentTimeMillis()}",
            title = if (enabled) "Biometric Lock Enabled" else "Biometric Lock Disabled",
            description = "Security authentication preference updated in Profile.",
            timeAgo = "Just now",
            isRead = false,
            type = NotificationType.SECURITY_LOGIN,
            section = "Today",
            actionRoute = "PROFILE"
        )
        _userNotifications.value = listOf(notif) + _userNotifications.value
    }

    fun setAutoLock(enabled: Boolean) {
        _autoLockEnabled.value = enabled
        val notif = AppNotificationItem(
            id = "sec_auto_${System.currentTimeMillis()}",
            title = if (enabled) "Auto-Lock Enabled" else "Auto-Lock Disabled",
            description = "App session will lock automatically when idle.",
            timeAgo = "Just now",
            isRead = false,
            type = NotificationType.SECURITY_LOGIN,
            section = "Today",
            actionRoute = "PROFILE"
        )
        _userNotifications.value = listOf(notif) + _userNotifications.value
    }

    fun setTwoFactor(enabled: Boolean) {
        _twoFactorEnabled.value = enabled
        val notif = AppNotificationItem(
            id = "sec_2fa_${System.currentTimeMillis()}",
            title = if (enabled) "Two-Factor Auth Enabled" else "Two-Factor Auth Disabled",
            description = "Extra layer of security configured for this account.",
            timeAgo = "Just now",
            isRead = false,
            type = NotificationType.SECURITY_LOGIN,
            section = "Today",
            actionRoute = "PROFILE"
        )
        _userNotifications.value = listOf(notif) + _userNotifications.value
    }

    fun removeDevice(deviceId: String) {
        val dev = _connectedDevices.value.firstOrNull { it.id == deviceId }
        _connectedDevices.value = _connectedDevices.value.filter { it.id != deviceId }
        val notif = AppNotificationItem(
            id = "dev_removed_${System.currentTimeMillis()}",
            title = "Device Disconnected",
            description = "Logged out from ${dev?.deviceName ?: "device"}.",
            timeAgo = "Just now",
            isRead = false,
            type = NotificationType.SECURITY_LOGIN,
            section = "Today",
            actionRoute = "PROFILE"
        )
        _userNotifications.value = listOf(notif) + _userNotifications.value
    }

    fun logOutAllOtherDevices() {
        _connectedDevices.value = _connectedDevices.value.filter { it.isCurrentDevice }
        val notif = AppNotificationItem(
            id = "logout_others_${System.currentTimeMillis()}",
            title = "All Other Devices Logged Out",
            description = "All secondary sessions terminated successfully.",
            timeAgo = "Just now",
            isRead = false,
            type = NotificationType.SECURITY_LOGIN,
            section = "Today",
            actionRoute = "PROFILE"
        )
        _userNotifications.value = listOf(notif) + _userNotifications.value
    }

    fun openAddTask() {
        _isAddTaskOpen.value = true
    }

    fun closeAddTask() {
        _isAddTaskOpen.value = false
    }

    fun openTaskDetail(task: TaskEntity) {
        _isTaskDetailInEditMode.value = false
        _selectedTaskForDetail.value = task
    }

    fun openTaskEdit(task: TaskEntity) {
        _isTaskDetailInEditMode.value = true
        _selectedTaskForDetail.value = task
    }

    fun closeTaskDetail() {
        _selectedTaskForDetail.value = null
        _isTaskDetailInEditMode.value = false
    }

    fun openNotifications() {
        _isNotificationsOpen.value = true
    }

    fun closeNotifications() {
        _isNotificationsOpen.value = false
    }

    fun enablePushNotifications() {
        _isPushNotificationsEnabled.value = true
    }

    fun disablePushNotifications() {
        _isPushNotificationsEnabled.value = false
    }

    fun openTaskFromNotification(notif: AppNotificationItem, onNavigateToSchedule: () -> Unit) {
        markNotificationAsRead(notif.id)
        closeNotifications()
        val matchingTask = (if (notif.taskId != null) allTasks.value.firstOrNull { it.id == notif.taskId } else null)
            ?: allTasks.value.firstOrNull {
                it.title.contains(notif.title, ignoreCase = true) ||
                notif.title.contains(it.title, ignoreCase = true) ||
                notif.description.contains(it.title, ignoreCase = true) ||
                (notif.type == NotificationType.TASK_FINISHED && (it.isCompleted || it.status.equals("Done", ignoreCase = true))) ||
                (notif.type == NotificationType.DEADLINE_WARNING && it.priority.equals("High", ignoreCase = true))
            } ?: allTasks.value.firstOrNull()

        if (matchingTask != null) {
            _selectedTaskForDetail.value = matchingTask
        } else {
            onNavigateToSchedule()
        }
    }

    fun markNotificationAsRead(id: String) {
        _readNotificationIds.value = _readNotificationIds.value + id
    }

    fun removeNotification(id: String) {
        _dismissedNotificationIds.value = _dismissedNotificationIds.value + id
    }

    fun markAllNotificationsRead() {
        _readNotificationIds.value = _readNotificationIds.value + notifications.value.map { it.id }.toSet()
    }

    fun clearAllNotifications() {
        _dismissedNotificationIds.value = _dismissedNotificationIds.value + notifications.value.map { it.id }.toSet()
    }

    fun toggleTaskComplete(task: TaskEntity) {
        viewModelScope.launch {
            val newCompleted = !task.isCompleted
            val newStatus = if (newCompleted) "Done" else "To Do"
            repository.updateTask(
                task.copy(
                    isCompleted = newCompleted,
                    status = newStatus
                )
            )
            if (newCompleted) {
                val completeNotif = AppNotificationItem(
                    id = "complete_${task.id}_${System.currentTimeMillis()}",
                    title = "Task completed: ${task.title}",
                    description = "Finished successfully on schedule.",
                    timeAgo = "Just now",
                    isRead = false,
                    type = NotificationType.TASK_FINISHED,
                    section = "Today",
                    taskId = task.id
                )
                _userNotifications.value = listOf(completeNotif) + _userNotifications.value
            }
            // Also update currently viewed dialog task if open
            if (_selectedTaskForDetail.value?.id == task.id) {
                _selectedTaskForDetail.value = task.copy(isCompleted = newCompleted, status = newStatus)
            }
        }
    }

    fun createTask(
        title: String,
        description: String,
        date: String,
        startTime: String,
        endTime: String,
        priority: String,
        project: String,
        tags: String,
        hasMeeting: Boolean = false,
        colorTheme: String = "blue",
        isFreeTime: Boolean = false
    ) {
        viewModelScope.launch {
            val taskTitle = title.ifBlank { "New Task" }
            val newTask = TaskEntity(
                title = taskTitle,
                description = description,
                dateString = date.ifBlank { "Today" },
                startTime = startTime.ifBlank { "10:00 AM" },
                endTime = endTime.ifBlank { "11:00 AM" },
                priority = priority,
                status = "To Do",
                project = project.ifBlank { "Daily Routine" },
                tags = tags.ifBlank { "Routine" },
                hasMeeting = hasMeeting,
                meetTitle = "Meet",
                isStarred = false,
                assigneeCount = 1,
                timeSection = if (startTime.contains("AM", ignoreCase = true)) "Morning" else "Afternoon",
                isCompleted = false,
                colorTheme = colorTheme,
                isFreeTime = isFreeTime
            )
            val generatedId = repository.insertTask(newTask)
            _lastAddedTaskId.value = generatedId

            // Add notification for new task
            val newNotif = AppNotificationItem(
                id = System.currentTimeMillis().toString(),
                title = "New Task Created: $taskTitle",
                description = "Added '$taskTitle' to your ${newTask.dateString} schedule.",
                timeAgo = "Just now",
                isRead = false,
                type = NotificationType.NEW_TASK_CREATED,
                section = "Today",
                taskId = generatedId.toInt()
            )
            _userNotifications.value = listOf(newNotif) + _userNotifications.value

            // Switch to All or To Do filter so the user immediately sees their new task in the list
            _statusFilter.value = "All"
            _selectedDay.value = 0 // Show all dates in schedule filter
            _isAddTaskOpen.value = false
        }
    }

    fun updateTask(task: TaskEntity) {
        viewModelScope.launch {
            repository.updateTask(task)
            _selectedTaskForDetail.value = null
        }
    }

    fun deleteTask(task: TaskEntity) {
        viewModelScope.launch {
            repository.deleteTask(task)
            _selectedTaskForDetail.value = null
        }
    }
}


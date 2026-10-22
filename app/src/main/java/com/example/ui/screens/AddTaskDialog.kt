package com.example.ui.screens

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import com.example.ui.components.TaskConfigMode
import com.example.ui.components.TaskConfigModeSelector
import com.example.ui.components.DailyRoutineConfigContent
import com.example.ui.components.MatchDayConfigContent
import com.example.ui.viewmodel.TaskViewModel
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FlashOn
import androidx.compose.material.icons.filled.Folder
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material.icons.filled.PriorityHigh
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.components.AuroraBackground
import com.example.ui.theme.AccentPurpleLight
import com.example.ui.theme.AccentPurpleText
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import java.util.Calendar

data class TaskImportanceOption(
    val priorityKey: String,
    val colorThemeKey: String,
    val title: String,
    val shortBadge: String,
    val description: String,
    val dotColor: Color,
    val cardBg: Color,
    val borderColor: Color,
    val textColor: Color,
    val accentColor: Color,
    val gradientColors: List<Color>,
    val pillTextColor: Color,
    val icon: ImageVector,
    val badgeBgColor: Color,
    val badgeIconColor: Color,
    val shadowColor: Color
)

val taskImportanceOptions = listOf(
    TaskImportanceOption(
        priorityKey = "Urgent",
        colorThemeKey = "red",
        title = "Urgent",
        shortBadge = "Critical",
        description = "Critical deadline • Immediate emergency action",
        dotColor = Color(0xFFEF4444),
        cardBg = Color(0xFFFEF2F2),
        borderColor = Color(0xFFFECACA),
        textColor = Color(0xFFDC2626),
        accentColor = Color(0xFFDC2626),
        gradientColors = listOf(Color(0xFFFB7185), Color(0xFFE11D48)),
        pillTextColor = Color.White,
        icon = Icons.Default.FlashOn,
        badgeBgColor = Color.White.copy(alpha = 0.9f),
        badgeIconColor = Color(0xFFE11D48),
        shadowColor = Color(0x60E11D48)
    ),
    TaskImportanceOption(
        priorityKey = "High",
        colorThemeKey = "peach",
        title = "Important",
        shortBadge = "High Priority",
        description = "High priority • Needs attention today",
        dotColor = Color(0xFFEA580C),
        cardBg = Color(0xFFFFF7ED),
        borderColor = Color(0xFFFED7AA),
        textColor = Color(0xFFC2410C),
        accentColor = Color(0xFFEA580C),
        gradientColors = listOf(Color(0xFFFDBA74), Color(0xFFEA580C)),
        pillTextColor = Color.White,
        icon = Icons.Default.Star,
        badgeBgColor = Color.White.copy(alpha = 0.9f),
        badgeIconColor = Color(0xFFEA580C),
        shadowColor = Color(0x55EA580C)
    ),
    TaskImportanceOption(
        priorityKey = "Medium",
        colorThemeKey = "blue",
        title = "Normal",
        shortBadge = "Routine",
        description = "Routine task • Standard daily timeline",
        dotColor = Color(0xFF0284C7),
        cardBg = Color(0xFFF0F9FF),
        borderColor = Color(0xFFBAE6FD),
        textColor = Color(0xFF0369A1),
        accentColor = Color(0xFF0284C7),
        gradientColors = listOf(Color(0xFF93C5FD), Color(0xFF3B82F6)),
        pillTextColor = Color.White,
        icon = Icons.Default.Check,
        badgeBgColor = Color.White.copy(alpha = 0.9f),
        badgeIconColor = Color(0xFF2563EB),
        shadowColor = Color(0x503B82F6)
    ),
    TaskImportanceOption(
        priorityKey = "Low",
        colorThemeKey = "mint",
        title = "Low Priority",
        shortBadge = "When Free",
        description = "Flexible timing • Do whenever you have free time",
        dotColor = Color(0xFF059669),
        cardBg = Color(0xFFECFDF5),
        borderColor = Color(0xFFA7F3D0),
        textColor = Color(0xFF047857),
        accentColor = Color(0xFF059669),
        gradientColors = listOf(Color(0xFF5EEAD4), Color(0xFF0D9488)),
        pillTextColor = Color.White,
        icon = Icons.Default.ArrowDownward,
        badgeBgColor = Color.White.copy(alpha = 0.9f),
        badgeIconColor = Color(0xFF0F766E),
        shadowColor = Color(0x500D9488)
    ),
    TaskImportanceOption(
        priorityKey = "Routine",
        colorThemeKey = "lavender",
        title = "Daily Routine",
        shortBadge = "Habit",
        description = "Daily habit & personal wellness routine",
        dotColor = Color(0xFF7C3AED),
        cardBg = Color(0xFFF5F3FF),
        borderColor = Color(0xFFDDD6FE),
        textColor = Color(0xFF6D28D9),
        accentColor = Color(0xFF7C3AED),
        gradientColors = listOf(Color(0xFFDDD6FE), Color(0xFFA78BFA)),
        pillTextColor = Color(0xFF3B0764),
        icon = Icons.Default.Favorite,
        badgeBgColor = Color.White.copy(alpha = 0.9f),
        badgeIconColor = Color(0xFF7C3AED),
        shadowColor = Color(0x457C3AED)
    )
)

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun AddTaskScreen(
    onDismiss: () -> Unit,
    onCreateTask: (
        title: String,
        description: String,
        date: String,
        startTime: String,
        endTime: String,
        priority: String,
        project: String,
        tags: String,
        hasMeeting: Boolean,
        colorTheme: String
    ) -> Unit,
    viewModel: TaskViewModel? = null
) {
    val context = LocalContext.current

    var activeConfigMode by remember { mutableStateOf(TaskConfigMode.SINGLE_TASK) }
    var taskTitle by remember { mutableStateOf("") }
    var taskDescription by remember { mutableStateOf("") }
    var startDate by remember { mutableStateOf("Today") }
    var endDate by remember { mutableStateOf("Today") }
    var startTime by remember { mutableStateOf("10:00 AM") }
    var endTime by remember { mutableStateOf("11:30 AM") }
    var selectedPriority by remember { mutableStateOf("Medium") } // Urgent, High, Medium, Low, Routine
    var selectedProject by remember { mutableStateOf("Personal") }
    var selectedColorTheme by remember { mutableStateOf("blue") }
    var isProjectDropdownExpanded by remember { mutableStateOf(false) }
    var isImportanceSelectorOpen by remember { mutableStateOf(false) }

    val tagsList = remember { mutableStateListOf("Personal", "Daily") }
    var isAddingCustomTag by remember { mutableStateOf(false) }
    var newTagInput by remember { mutableStateOf("") }
    var hasMeeting by remember { mutableStateOf(false) }

    val suggestedTags = listOf(
        "Urgent", "Daily", "Errands", "Shopping", "Bills", "Health", "Workout", "Home", "Family", "Meeting", "Quick"
    )

    val projectsList = listOf(
        "Personal",
        "Work & Career",
        "Home & Chores",
        "Shopping & Groceries",
        "Health & Fitness",
        "Finance & Bills",
        "Study & Reading",
        "Family & Friends"
    )

    // Android Date Picker triggers for Start and End Date
    val startCalendar = Calendar.getInstance()
    val startDatePickerDialog = DatePickerDialog(
        context,
        { _, year, month, dayOfMonth ->
            val monthNames = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
            startDate = "${monthNames[month]} $dayOfMonth, $year"
            if (endDate == "Today") {
                endDate = startDate
            }
        },
        startCalendar.get(Calendar.YEAR),
        startCalendar.get(Calendar.MONTH),
        startCalendar.get(Calendar.DAY_OF_MONTH)
    )

    val endCalendar = Calendar.getInstance()
    val endDatePickerDialog = DatePickerDialog(
        context,
        { _, year, month, dayOfMonth ->
            val monthNames = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
            endDate = "${monthNames[month]} $dayOfMonth, $year"
        },
        endCalendar.get(Calendar.YEAR),
        endCalendar.get(Calendar.MONTH),
        endCalendar.get(Calendar.DAY_OF_MONTH)
    )

    // Android Time Picker triggers for Start and End Time
    val startTimePickerDialog = TimePickerDialog(
        context,
        { _, hourOfDay, minute ->
            val amPm = if (hourOfDay >= 12) "PM" else "AM"
            val hour12 = if (hourOfDay % 12 == 0) 12 else hourOfDay % 12
            val minStr = String.format("%02d", minute)
            startTime = "$hour12:$minStr $amPm"
        },
        10, 0, false
    )

    val endTimePickerDialog = TimePickerDialog(
        context,
        { _, hourOfDay, minute ->
            val amPm = if (hourOfDay >= 12) "PM" else "AM"
            val hour12 = if (hourOfDay % 12 == 0) 12 else hourOfDay % 12
            val minStr = String.format("%02d", minute)
            endTime = "$hour12:$minStr $amPm"
        },
        11, 30, false
    )

    fun submitTask() {
        val formattedDateString = if (startDate == endDate || endDate.isBlank()) {
            startDate
        } else {
            "$startDate - $endDate"
        }

        onCreateTask(
            taskTitle.ifBlank { "New Task" },
            taskDescription,
            formattedDateString,
            startTime,
            endTime,
            selectedPriority,
            selectedProject,
            tagsList.joinToString(","),
            hasMeeting,
            selectedColorTheme
        )
    }

    AuroraBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .imePadding()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp, vertical = 12.dp)
        ) {
            // Top Header: Close (X), Title, Checkmark (✓)
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 20.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Close (X) Circle
                Box(
                    modifier = Modifier
                        .size(42.dp)
                        .clip(CircleShape)
                        .background(Color.White.copy(alpha = 0.9f))
                        .border(1.dp, CardBorder, CircleShape)
                        .clickable { onDismiss() }
                        .testTag("add_task_close_button"),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Close,
                        contentDescription = "Close",
                        tint = TextPrimary,
                        modifier = Modifier.size(20.dp)
                    )
                }

                // Header Title
                Text(
                    text = when (activeConfigMode) {
                        TaskConfigMode.SINGLE_TASK -> "New Task"
                        TaskConfigMode.DAILY_ROUTINE -> "Daily Routine"
                        TaskConfigMode.MATCH_SPORTS -> "Football Match"
                    },
                    color = TextPrimary,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold
                )

                // Checkmark (✓) Circle
                Box(
                    modifier = Modifier
                        .size(42.dp)
                        .clip(CircleShape)
                        .background(Color.White.copy(alpha = 0.9f))
                        .border(1.dp, CardBorder, CircleShape)
                        .clickable {
                            if (activeConfigMode == TaskConfigMode.SINGLE_TASK) {
                                submitTask()
                            } else {
                                onDismiss()
                            }
                        }
                        .testTag("add_task_check_button"),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Check,
                        contentDescription = "Save Task",
                        tint = TextPrimary,
                        modifier = Modifier.size(20.dp)
                    )
                }
            }

            // 0. Mode Selector: Single Task | Daily Routine | Match Day
            TaskConfigModeSelector(
                selectedMode = activeConfigMode,
                onModeSelected = { activeConfigMode = it },
                modifier = Modifier.padding(bottom = 18.dp)
            )

            when (activeConfigMode) {
                TaskConfigMode.SINGLE_TASK -> {
                    Column {
                        // 1. Task Title Field (Normal Everyday Life Placeholder)
            Text(
                text = "Task Title",
                color = TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(8.dp))
            Surface(
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(4.dp, RoundedCornerShape(16.dp), spotColor = Color(0x0C000000)),
                shape = RoundedCornerShape(16.dp),
                color = Color.White,
                border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
            ) {
                BasicTextField(
                    value = taskTitle,
                    onValueChange = { taskTitle = it },
                    textStyle = TextStyle(
                        color = TextPrimary,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.Medium
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 14.dp)
                        .testTag("task_title_input"),
                    decorationBox = { innerTextField ->
                        if (taskTitle.isEmpty()) {
                            Text("e.g. Buy groceries, Pay electricity bill, Workout...", color = SubtitleGray, fontSize = 15.sp)
                        }
                        innerTextField()
                    }
                )
            }

            Spacer(modifier = Modifier.height(20.dp))

            // 2. Task Importance & Priority (Designed after soft pill reference image)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Task Importance",
                    color = TextPrimary,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.SemiBold
                )
                val currentOpt = taskImportanceOptions.find {
                    it.priorityKey.equals(selectedPriority, ignoreCase = true) || it.colorThemeKey.equals(selectedColorTheme, ignoreCase = true)
                } ?: taskImportanceOptions[2]

                Text(
                    text = if (isImportanceSelectorOpen) "Tap to select" else currentOpt.title,
                    color = if (isImportanceSelectorOpen) SubtitleGray else currentOpt.textColor,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold
                )
            }
            Spacer(modifier = Modifier.height(10.dp))

            // Main Trigger Pill Button (Matches the top soft floating pill from the design)
            val activeOpt = taskImportanceOptions.find {
                it.priorityKey.equals(selectedPriority, ignoreCase = true) || it.colorThemeKey.equals(selectedColorTheme, ignoreCase = true)
            } ?: taskImportanceOptions[2]

            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Collapsed Active Pill Button with 3D drop shadow
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .shadow(
                            elevation = 8.dp,
                            shape = CircleShape,
                            spotColor = activeOpt.shadowColor
                        )
                        .clip(CircleShape)
                        .clickable { isImportanceSelectorOpen = !isImportanceSelectorOpen }
                        .testTag("select_importance_trigger_button"),
                    shape = CircleShape,
                    color = Color.Transparent
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(Brush.horizontalGradient(activeOpt.gradientColors))
                            .padding(horizontal = 16.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        // Centered Title Text
                        Text(
                            text = activeOpt.title,
                            color = activeOpt.pillTextColor,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold
                        )

                        // Right Badge Circle (Like in the reference image)
                        Box(
                            modifier = Modifier
                                .align(Alignment.CenterEnd)
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(activeOpt.badgeBgColor)
                                .shadow(2.dp, CircleShape),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = if (isImportanceSelectorOpen) Icons.Default.KeyboardArrowUp else activeOpt.icon,
                                contentDescription = activeOpt.title,
                                tint = activeOpt.badgeIconColor,
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }

                // Subtitle description below the active pill button
                Spacer(modifier = Modifier.height(6.dp))
                Text(
                    text = activeOpt.description,
                    color = SubtitleGray,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Normal
                )

                // Expandable Section displaying all pill button designs when clicked
                AnimatedVisibility(
                    visible = isImportanceSelectorOpen,
                    enter = expandVertically() + fadeIn(),
                    exit = shrinkVertically() + fadeOut()
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        taskImportanceOptions.forEachIndexed { index, opt ->
                            val isSelected = selectedPriority == opt.priorityKey

                            // Downward flow arrow between pill buttons (as shown in reference image flow)
                            if (index > 0) {
                                Box(
                                    modifier = Modifier
                                        .padding(vertical = 6.dp)
                                        .size(20.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.KeyboardArrowDown,
                                        contentDescription = null,
                                        tint = SubtitleGray.copy(alpha = 0.6f),
                                        modifier = Modifier.size(16.dp)
                                    )
                                }
                            }

                            // Neumorphic / Soft Pill Button
                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth(0.92f)
                                    .height(52.dp)
                                    .shadow(
                                        elevation = if (isSelected) 10.dp else 4.dp,
                                        shape = CircleShape,
                                        spotColor = opt.shadowColor
                                    )
                                    .clip(CircleShape)
                                    .clickable {
                                        selectedPriority = opt.priorityKey
                                        selectedColorTheme = opt.colorThemeKey
                                        isImportanceSelectorOpen = false
                                    }
                                    .testTag("importance_pill_${opt.priorityKey}"),
                                shape = CircleShape,
                                color = Color.Transparent
                            ) {
                                Box(
                                    modifier = Modifier
                                        .fillMaxSize()
                                        .background(Brush.horizontalGradient(opt.gradientColors))
                                        .padding(horizontal = 14.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    // Centered Title Text
                                    Text(
                                        text = opt.title,
                                        color = opt.pillTextColor,
                                        fontSize = 15.sp,
                                        fontWeight = FontWeight.Bold
                                    )

                                    // Right Circular Pill Badge with Icon
                                    Box(
                                        modifier = Modifier
                                            .align(Alignment.CenterEnd)
                                            .size(34.dp)
                                            .clip(CircleShape)
                                            .background(opt.badgeBgColor),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Icon(
                                            imageVector = if (isSelected) Icons.Default.Check else opt.icon,
                                            contentDescription = opt.title,
                                            tint = opt.badgeIconColor,
                                            modifier = Modifier.size(16.dp)
                                        )
                                    }
                                }
                            }

                            // Label text placed directly below the button (exact style of image provided)
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = opt.description,
                                color = SubtitleGray,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Normal
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // 3. Notes & Details Field
            Text(
                text = "Notes & Details",
                color = TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(8.dp))
            Surface(
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(4.dp, RoundedCornerShape(16.dp), spotColor = Color(0x0C000000)),
                shape = RoundedCornerShape(16.dp),
                color = Color.White,
                border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
            ) {
                BasicTextField(
                    value = taskDescription,
                    onValueChange = { taskDescription = it },
                    textStyle = TextStyle(
                        color = TextPrimary,
                        fontSize = 14.sp,
                        lineHeight = 20.sp
                    ),
                    minLines = 2,
                    maxLines = 4,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 14.dp)
                        .testTag("task_description_input"),
                    decorationBox = { innerTextField ->
                        if (taskDescription.isEmpty()) {
                            Text("e.g. Milk, eggs, fruits, bread and check discounts...", color = SubtitleGray, fontSize = 14.sp)
                        }
                        innerTextField()
                    }
                )
            }

            Spacer(modifier = Modifier.height(20.dp))

            // 4. Start & End Dates
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Task Dates (Start & End)",
                    color = TextPrimary,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.SemiBold
                )

                // Range Indicator
                if (startDate != endDate && endDate.isNotBlank()) {
                    Surface(
                        shape = CircleShape,
                        color = Color(0xFFEFF6FF)
                    ) {
                        Text(
                            text = "Multi-Day",
                            color = Color(0xFF1D4ED8),
                            fontSize = 10.sp,
                            fontWeight = FontWeight.Bold,
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(6.dp))

            // Quick Presets Row: Today | Tomorrow | This Week | 3 Days
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
                val presets = listOf(
                    "Today" to {
                        startDate = "Today"
                        endDate = "Today"
                    },
                    "Tomorrow" to {
                        startDate = "Tomorrow"
                        endDate = "Tomorrow"
                    },
                    "This Week" to {
                        val cal = Calendar.getInstance()
                        val mNames = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
                        startDate = "Today"
                        cal.add(Calendar.DAY_OF_YEAR, 6)
                        endDate = "${mNames[cal.get(Calendar.MONTH)]} ${cal.get(Calendar.DAY_OF_MONTH)}, ${cal.get(Calendar.YEAR)}"
                    },
                    "3 Days" to {
                        val cal = Calendar.getInstance()
                        val mNames = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
                        startDate = "Today"
                        cal.add(Calendar.DAY_OF_YEAR, 3)
                        endDate = "${mNames[cal.get(Calendar.MONTH)]} ${cal.get(Calendar.DAY_OF_MONTH)}, ${cal.get(Calendar.YEAR)}"
                    }
                )

                presets.forEach { (label, onClick) ->
                    val isSelected = when (label) {
                        "Today" -> startDate == "Today" && endDate == "Today"
                        "Tomorrow" -> startDate == "Tomorrow" && endDate == "Tomorrow"
                        else -> false
                    }
                    Surface(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(8.dp))
                            .clickable { onClick() },
                        shape = RoundedCornerShape(8.dp),
                        color = if (isSelected) CharcoalDark else Color(0xFFF1F5F9)
                    ) {
                        Text(
                            text = label,
                            color = if (isSelected) Color.White else Color(0xFF475569),
                            fontSize = 11.sp,
                            fontWeight = FontWeight.SemiBold,
                            textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                            modifier = Modifier.padding(vertical = 5.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                // Start Date Picker Pill
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(CircleShape)
                        .clickable { startDatePickerDialog.show() }
                        .shadow(2.dp, CircleShape, spotColor = Color(0x0C000000))
                        .testTag("add_task_start_date_picker"),
                    shape = CircleShape,
                    color = Color.White,
                    border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Outlined.CalendarToday,
                            contentDescription = "Start Date",
                            tint = Color(0xFF2563EB),
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text(text = "Start Date", color = SubtitleGray, fontSize = 9.5.sp, fontWeight = FontWeight.Medium)
                            Text(
                                text = startDate,
                                color = TextPrimary,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold,
                                maxLines = 1
                            )
                        }
                    }
                }

                // End Date Picker Pill
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(CircleShape)
                        .clickable { endDatePickerDialog.show() }
                        .shadow(2.dp, CircleShape, spotColor = Color(0x0C000000))
                        .testTag("add_task_end_date_picker"),
                    shape = CircleShape,
                    color = Color.White,
                    border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Outlined.CalendarToday,
                            contentDescription = "End Date",
                            tint = Color(0xFF2563EB),
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text(text = "End Date", color = SubtitleGray, fontSize = 9.5.sp, fontWeight = FontWeight.Medium)
                            Text(
                                text = endDate,
                                color = TextPrimary,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold,
                                maxLines = 1
                            )
                        }
                    }
                }
            }

            // Date Range formatted preview
            if (startDate != endDate && endDate.isNotBlank()) {
                Spacer(modifier = Modifier.height(6.dp))
                Surface(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(10.dp),
                    color = Color(0xFFF0FDF4),
                    border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFBBF7D0))
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 7.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(text = "🗓️", fontSize = 12.sp)
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "Spans $startDate → $endDate",
                            fontSize = 11.5.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = Color(0xFF166534)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(14.dp))

            // Start & End Time Range
            Text(
                text = "Time Range (Start & End)",
                color = TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(8.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                // Start Time Picker Pill
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(CircleShape)
                        .clickable { startTimePickerDialog.show() }
                        .shadow(2.dp, CircleShape, spotColor = Color(0x0C000000))
                        .testTag("add_task_start_time_picker"),
                    shape = CircleShape,
                    color = Color.White,
                    border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Outlined.Schedule,
                            contentDescription = "Start Time",
                            tint = SubtitleGray,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text(text = "Start Time", color = SubtitleGray, fontSize = 9.5.sp, fontWeight = FontWeight.Medium)
                            Text(
                                text = startTime,
                                color = TextPrimary,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                }

                // End Time Picker Pill
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(CircleShape)
                        .clickable { endTimePickerDialog.show() }
                        .shadow(2.dp, CircleShape, spotColor = Color(0x0C000000))
                        .testTag("add_task_end_time_picker"),
                    shape = CircleShape,
                    color = Color.White,
                    border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Outlined.Schedule,
                            contentDescription = "End Time",
                            tint = SubtitleGray,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text(text = "End Time", color = SubtitleGray, fontSize = 9.5.sp, fontWeight = FontWeight.Medium)
                            Text(
                                text = endTime,
                                color = TextPrimary,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // 5. Category Dropdown
            Text(
                text = "Category",
                color = TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(8.dp))
            Box {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(CircleShape)
                        .clickable { isProjectDropdownExpanded = true }
                        .shadow(2.dp, CircleShape, spotColor = Color(0x0C000000))
                        .testTag("add_task_project_dropdown"),
                    shape = CircleShape,
                    color = Color.White,
                    border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp, vertical = 12.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                imageVector = Icons.Default.Folder,
                                contentDescription = null,
                                tint = AccentPurpleText,
                                modifier = Modifier.size(18.dp)
                            )
                            Spacer(modifier = Modifier.width(10.dp))
                            Text(
                                text = selectedProject,
                                color = TextPrimary,
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                        Icon(
                            imageVector = Icons.Default.KeyboardArrowDown,
                            contentDescription = "Select Category",
                            tint = SubtitleGray,
                            modifier = Modifier.size(18.dp)
                        )
                    }
                }

                DropdownMenu(
                    expanded = isProjectDropdownExpanded,
                    onDismissRequest = { isProjectDropdownExpanded = false }
                ) {
                    projectsList.forEach { proj ->
                        DropdownMenuItem(
                            text = { Text(proj) },
                            onClick = {
                                selectedProject = proj
                                isProjectDropdownExpanded = false
                            }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // 6. Everyday Tags / Chips
            Text(
                text = "Tags & Labels",
                color = TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold
            )
            Spacer(modifier = Modifier.height(8.dp))
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                tagsList.forEach { tag ->
                    Surface(
                        shape = CircleShape,
                        color = AccentPurpleLight
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 14.dp, vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                text = tag,
                                color = AccentPurpleText,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.Medium
                            )
                            Spacer(modifier = Modifier.width(6.dp))
                            Icon(
                                imageVector = Icons.Default.Close,
                                contentDescription = "Remove $tag",
                                tint = AccentPurpleText,
                                modifier = Modifier
                                    .size(14.dp)
                                    .clickable { tagsList.remove(tag) }
                            )
                        }
                    }
                }

                if (isAddingCustomTag) {
                    Surface(
                        shape = CircleShape,
                        color = Color.White,
                        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            BasicTextField(
                                value = newTagInput,
                                onValueChange = { newTagInput = it },
                                textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary),
                                modifier = Modifier.width(90.dp),
                                singleLine = true
                            )
                            Icon(
                                imageVector = Icons.Default.Check,
                                contentDescription = "Add",
                                tint = TextPrimary,
                                modifier = Modifier
                                    .size(16.dp)
                                    .clickable {
                                        if (newTagInput.isNotBlank()) {
                                            tagsList.add(newTagInput.trim())
                                            newTagInput = ""
                                        }
                                        isAddingCustomTag = false
                                    }
                            )
                        }
                    }
                } else {
                    Surface(
                        shape = CircleShape,
                        color = Color.White,
                        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder),
                        modifier = Modifier.clickable { isAddingCustomTag = true }
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.Add,
                                contentDescription = "Add Tag",
                                tint = TextSecondary,
                                modifier = Modifier.size(14.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = "Add Tag",
                                color = TextSecondary,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }
                }
            }

            // Quick suggestion tags
            Spacer(modifier = Modifier.height(10.dp))
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                verticalArrangement = Arrangement.spacedBy(6.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                suggestedTags.filter { it !in tagsList }.take(5).forEach { sug ->
                    Surface(
                        shape = CircleShape,
                        color = Color(0xFFF1F5F9),
                        modifier = Modifier.clickable { tagsList.add(sug) }
                    ) {
                        Text(
                            text = "+ $sug",
                            color = Color(0xFF475569),
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Medium,
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(28.dp))

            // 7. Large Bottom "Create Task" Pill Button
            Surface(
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(
                        elevation = 8.dp,
                        shape = CircleShape,
                        spotColor = Color(0x30000000)
                    )
                    .clip(CircleShape)
                    .clickable { submitTask() }
                    .testTag("create_task_button"),
                shape = CircleShape,
                color = CharcoalDark
            ) {
                Box(
                    modifier = Modifier.padding(vertical = 16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "Create Task",
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

                    Spacer(modifier = Modifier.height(20.dp))
                }
            }
            TaskConfigMode.DAILY_ROUTINE -> {
                DailyRoutineConfigContent(
                    viewModel = viewModel,
                    onDismiss = onDismiss
                )
            }
            TaskConfigMode.MATCH_SPORTS -> {
                MatchDayConfigContent(
                    viewModel = viewModel,
                    onDismiss = onDismiss
                )
            }
        }
    }
}
}

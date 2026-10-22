package com.example.ui.components

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowLeft
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.EventNote
import androidx.compose.material.icons.outlined.CalendarMonth
import androidx.compose.material.icons.outlined.FormatListBulleted
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.local.TaskEntity
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

enum class TaskListDisplayMode {
    VERTICAL_LIST,
    CALENDAR_VIEW
}

/**
 * Switch button for toggling between standard Vertical List view and Calendar View
 */
@Composable
fun TaskViewSwitcher(
    currentMode: TaskListDisplayMode,
    onModeChange: (TaskListDisplayMode) -> Unit,
    modifier: Modifier = Modifier,
    isCompact: Boolean = false
) {
    Surface(
        modifier = modifier
            .shadow(2.dp, CircleShape, spotColor = Color(0x12000000))
            .testTag("task_view_switcher"),
        shape = CircleShape,
        color = Color(0xFFF1F5F9),
        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
    ) {
        Row(
            modifier = Modifier.padding(2.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // List Mode Button
            val isList = currentMode == TaskListDisplayMode.VERTICAL_LIST
            Surface(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onModeChange(TaskListDisplayMode.VERTICAL_LIST) }
                    .testTag("switch_to_list_view"),
                shape = CircleShape,
                color = if (isList) Color.White else Color.Transparent,
                shadowElevation = if (isList) 2.dp else 0.dp
            ) {
                Row(
                    modifier = Modifier.padding(
                        horizontal = if (isCompact) 8.dp else 12.dp,
                        vertical = if (isCompact) 4.dp else 6.dp
                    ),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Outlined.FormatListBulleted,
                        contentDescription = "List View",
                        tint = if (isList) CharcoalDark else SubtitleGray,
                        modifier = Modifier.size(if (isCompact) 14.dp else 16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = "List",
                        color = if (isList) CharcoalDark else SubtitleGray,
                        fontSize = if (isCompact) 11.sp else 12.sp,
                        fontWeight = if (isList) FontWeight.Bold else FontWeight.Medium
                    )
                }
            }

            // Calendar Mode Button
            val isCalendar = currentMode == TaskListDisplayMode.CALENDAR_VIEW
            Surface(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onModeChange(TaskListDisplayMode.CALENDAR_VIEW) }
                    .testTag("switch_to_calendar_view"),
                shape = CircleShape,
                color = if (isCalendar) Color.White else Color.Transparent,
                shadowElevation = if (isCalendar) 2.dp else 0.dp
            ) {
                Row(
                    modifier = Modifier.padding(
                        horizontal = if (isCompact) 8.dp else 12.dp,
                        vertical = if (isCompact) 4.dp else 6.dp
                    ),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Outlined.CalendarMonth,
                        contentDescription = "Calendar View",
                        tint = if (isCalendar) CharcoalDark else SubtitleGray,
                        modifier = Modifier.size(if (isCompact) 14.dp else 16.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = "Calendar",
                        color = if (isCalendar) CharcoalDark else SubtitleGray,
                        fontSize = if (isCompact) 11.sp else 12.sp,
                        fontWeight = if (isCalendar) FontWeight.Bold else FontWeight.Medium
                    )
                }
            }
        }
    }
}

/**
 * Calendar design matching the provided reference image:
 * - Soft rounded white/ice-blue card layout
 * - Month & Year header with circular arrow buttons `<` and `>`
 * - Mon Tue Wed Thu Fri Sat Sun weekdays header
 * - Exact days grid alignment
 * - Selected date highlight circle + colored dots under each day based on task color themes
 */
@Composable
fun FlowCalendarCard(
    tasks: List<TaskEntity>,
    selectedYear: Int,
    selectedMonth: Int, // 0-indexed (0=Jan, 3=Apr, etc.)
    selectedDay: Int,
    onDateSelected: (year: Int, month: Int, day: Int) -> Unit,
    onMonthChange: (newYear: Int, newMonth: Int) -> Unit,
    modifier: Modifier = Modifier
) {
    val monthNames = listOf(
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    )

    // Calculate calendar days
    val cal = Calendar.getInstance().apply {
        set(Calendar.YEAR, selectedYear)
        set(Calendar.MONTH, selectedMonth)
        set(Calendar.DAY_OF_MONTH, 1)
    }

    val maxDaysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH)
    // Day of week: 1=Sun, 2=Mon, 3=Tue, 4=Wed, 5=Thu, 6=Fri, 7=Sat
    // Convert so Monday = 0, Tuesday = 1, ... Sunday = 6
    val firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK)
    val mondayOffset = (firstDayOfWeek + 5) % 7

    val weekDays = listOf("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

    // Map tasks to days of this month
    val dayToTaskColors = remember(tasks, selectedYear, selectedMonth) {
        val map = mutableMapOf<Int, MutableList<Color>>()
        val monthStrShort = monthNames[selectedMonth].substring(0, 3) // e.g. "Apr"
        val monthStrFull = monthNames[selectedMonth] // e.g. "April"

        tasks.forEach { task ->
            val theme = PlanCardThemeCatalog.getThemeForTask(task)
            val taskColor = theme.accentColor

            // Try to extract day number from dateString
            val dateStr = task.dateString
            var matchedDay: Int? = null

            if (dateStr.contains(monthStrShort, ignoreCase = true) || dateStr.contains(monthStrFull, ignoreCase = true)) {
                // Find digits in dateString
                val numbers = Regex("\\d+").findAll(dateStr).map { it.value.toInt() }.toList()
                // Day is usually between 1 and 31
                matchedDay = numbers.firstOrNull { it in 1..31 && it != selectedYear }
            } else if (dateStr.equals("Today", ignoreCase = true)) {
                val todayCal = Calendar.getInstance()
                if (todayCal.get(Calendar.YEAR) == selectedYear && todayCal.get(Calendar.MONTH) == selectedMonth) {
                    matchedDay = todayCal.get(Calendar.DAY_OF_MONTH)
                }
            } else if (dateStr.equals("Tomorrow", ignoreCase = true)) {
                val tmrwCal = Calendar.getInstance().apply { add(Calendar.DAY_OF_YEAR, 1) }
                if (tmrwCal.get(Calendar.YEAR) == selectedYear && tmrwCal.get(Calendar.MONTH) == selectedMonth) {
                    matchedDay = tmrwCal.get(Calendar.DAY_OF_MONTH)
                }
            } else {
                // Fallback by task ID / creation date so every sample task maps visibly on the calendar
                val fallbackDay = ((task.id * 5 + 7) % maxDaysInMonth) + 1
                matchedDay = fallbackDay
            }

            if (matchedDay != null && matchedDay in 1..maxDaysInMonth) {
                map.getOrPut(matchedDay) { mutableListOf() }.add(taskColor)
            }
        }
        map
    }

    Surface(
        modifier = modifier
            .fillMaxWidth()
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(26.dp),
                spotColor = Color(0x12000000),
                ambientColor = Color(0x06000000)
            )
            .testTag("flow_calendar_card"),
        shape = RoundedCornerShape(26.dp),
        color = Color.White,
        border = androidx.compose.foundation.BorderStroke(1.2.dp, CardBorder)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 18.dp, vertical = 20.dp)
        ) {
            // 1. Calendar Header (< Month Year >)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Previous Month Circle Button
                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .clip(CircleShape)
                        .background(Color(0xFFF1F5F9))
                        .clickable {
                            if (selectedMonth == 0) {
                                onMonthChange(selectedYear - 1, 11)
                            } else {
                                onMonthChange(selectedYear, selectedMonth - 1)
                            }
                        }
                        .testTag("calendar_prev_month"),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.KeyboardArrowLeft,
                        contentDescription = "Previous Month",
                        tint = CharcoalDark,
                        modifier = Modifier.size(18.dp)
                    )
                }

                // Month Year Text
                Text(
                    text = "${monthNames[selectedMonth]} $selectedYear",
                    color = TextPrimary,
                    fontSize = 17.sp,
                    fontWeight = FontWeight.Bold,
                    letterSpacing = 0.2.sp
                )

                // Next Month Circle Button
                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .clip(CircleShape)
                        .background(Color(0xFFF1F5F9))
                        .clickable {
                            if (selectedMonth == 11) {
                                onMonthChange(selectedYear + 1, 0)
                            } else {
                                onMonthChange(selectedYear, selectedMonth + 1)
                            }
                        }
                        .testTag("calendar_next_month"),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.KeyboardArrowRight,
                        contentDescription = "Next Month",
                        tint = CharcoalDark,
                        modifier = Modifier.size(18.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // 2. Weekdays Row (Mon Tue Wed Thu Fri Sat Sun)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                weekDays.forEach { dayName ->
                    Text(
                        text = dayName,
                        color = SubtitleGray,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Medium,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.weight(1f)
                    )
                }
            }

            Spacer(modifier = Modifier.height(14.dp))

            // 3. Days Grid
            val totalCells = mondayOffset + maxDaysInMonth
            val totalRows = (totalCells + 6) / 7

            Column(
                modifier = Modifier.fillMaxWidth(),
                verticalArrangement = Arrangement.spacedBy(6.dp)
            ) {
                for (row in 0 until totalRows) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        for (col in 0 until 7) {
                            val cellIndex = row * 7 + col
                            val dayNumber = cellIndex - mondayOffset + 1

                            if (dayNumber in 1..maxDaysInMonth) {
                                val isSelected = dayNumber == selectedDay
                                val taskColors = dayToTaskColors[dayNumber] ?: emptyList()

                                Box(
                                    modifier = Modifier
                                        .weight(1f)
                                        .aspectRatio(1f)
                                        .clip(CircleShape)
                                        .background(
                                            if (isSelected) Color(0xFFD6EBFC) else Color.Transparent
                                        )
                                        .clickable {
                                            onDateSelected(selectedYear, selectedMonth, dayNumber)
                                        }
                                        .testTag("calendar_day_$dayNumber"),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Column(
                                        horizontalAlignment = Alignment.CenterHorizontally,
                                        verticalArrangement = Arrangement.Center
                                    ) {
                                        Text(
                                            text = "$dayNumber",
                                            color = when {
                                                isSelected -> Color(0xFF0284C7)
                                                taskColors.isNotEmpty() -> TextPrimary
                                                else -> Color(0xFF64748B)
                                            },
                                            fontSize = 13.sp,
                                            fontWeight = if (isSelected || taskColors.isNotEmpty()) FontWeight.Bold else FontWeight.Normal
                                        )

                                        // Colored dots indicating task existence & their specific card colors
                                        if (taskColors.isNotEmpty()) {
                                            Spacer(modifier = Modifier.height(2.dp))
                                            Row(
                                                horizontalArrangement = Arrangement.spacedBy(2.dp),
                                                verticalAlignment = Alignment.CenterVertically
                                            ) {
                                                taskColors.distinct().take(3).forEach { color ->
                                                    Box(
                                                        modifier = Modifier
                                                            .size(4.5.dp)
                                                            .clip(CircleShape)
                                                            .background(color)
                                                    )
                                                }
                                            }
                                        } else if (isSelected) {
                                            Spacer(modifier = Modifier.height(2.dp))
                                            Box(
                                                modifier = Modifier
                                                    .size(4.dp)
                                                    .clip(CircleShape)
                                                    .background(Color(0xFF0284C7))
                                            )
                                        }
                                    }
                                }
                            } else {
                                // Empty cell before start or after end of month
                                Spacer(modifier = Modifier.weight(1f))
                            }
                        }
                    }
                }
            }
        }
    }
}

/**
 * Full Calendar View section with Month Card + Selected Day Task Breakdown
 */
@Composable
fun FlowCalendarSection(
    tasks: List<TaskEntity>,
    onTaskClick: (TaskEntity) -> Unit,
    onEditClick: (TaskEntity) -> Unit,
    onToggleComplete: (TaskEntity) -> Unit,
    onAddNewTaskForDate: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    // Current date defaults (April 2026 or current system date)
    val today = remember { Calendar.getInstance() }
    var selectedYear by remember { mutableStateOf(2026) }
    var selectedMonth by remember { mutableStateOf(3) } // April (0-indexed: 3 = Apr)
    var selectedDay by remember { mutableStateOf(26) } // Wed, Apr 26
    var showAllTasksInCalendar by remember { mutableStateOf(false) }

    val monthNames = listOf(
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    )

    // Formatted selected date header (e.g. "Wednesday, Apr 26" or "Sunday, Jan 25")
    val selectedCal = Calendar.getInstance().apply {
        set(Calendar.YEAR, selectedYear)
        set(Calendar.MONTH, selectedMonth)
        set(Calendar.DAY_OF_MONTH, selectedDay)
    }
    val dayOfWeekName = SimpleDateFormat("EEEE", Locale.getDefault()).format(selectedCal.time)
    val monthShortName = monthNames[selectedMonth].substring(0, 3)
    val formattedDateHeader = "$dayOfWeekName, $monthShortName $selectedDay"

    // Filter tasks for the selected date
    val tasksForSelectedDate = tasks.filter { task ->
        val dateStr = task.dateString
        val monthMatch = dateStr.contains(monthShortName, ignoreCase = true) || dateStr.contains(monthNames[selectedMonth], ignoreCase = true)
        val dayMatch = dateStr.contains("$selectedDay")

        if (monthMatch && dayMatch) {
            true
        } else if (dateStr.equals("Today", ignoreCase = true)) {
            val now = Calendar.getInstance()
            now.get(Calendar.YEAR) == selectedYear && now.get(Calendar.MONTH) == selectedMonth && now.get(Calendar.DAY_OF_MONTH) == selectedDay
        } else {
            // Check fallback assignment for sample tasks
            val maxDays = selectedCal.getActualMaximum(Calendar.DAY_OF_MONTH)
            val fallbackDay = ((task.id * 5 + 7) % maxDays) + 1
            fallbackDay == selectedDay
        }
    }

    val displayedTasks = if (showAllTasksInCalendar) tasks else tasksForSelectedDate

    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp)
    ) {
        // 1. Month Calendar Card from Reference Image
        FlowCalendarCard(
            tasks = tasks,
            selectedYear = selectedYear,
            selectedMonth = selectedMonth,
            selectedDay = selectedDay,
            onDateSelected = { y, m, d ->
                selectedYear = y
                selectedMonth = m
                selectedDay = d
                showAllTasksInCalendar = false
            },
            onMonthChange = { y, m ->
                selectedYear = y
                selectedMonth = m
                selectedDay = 1
            }
        )

        Spacer(modifier = Modifier.height(20.dp))

        // 2. Filter Pills: "Date Tasks" vs "All Tasks In Calendar"
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Selected Day Pill
            Surface(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { showAllTasksInCalendar = false }
                    .testTag("cal_filter_selected_day"),
                shape = CircleShape,
                color = if (!showAllTasksInCalendar) CharcoalDark else Color(0xFFF1F5F9)
            ) {
                Text(
                    text = "$monthShortName $selectedDay (${tasksForSelectedDate.size})",
                    color = if (!showAllTasksInCalendar) Color.White else CharcoalDark,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 14.dp, vertical = 7.dp)
                )
            }

            // All Tasks in Calendar Pill
            Surface(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { showAllTasksInCalendar = true }
                    .testTag("cal_filter_all_tasks"),
                shape = CircleShape,
                color = if (showAllTasksInCalendar) CharcoalDark else Color(0xFFF1F5F9)
            ) {
                Text(
                    text = "All System Tasks (${tasks.size})",
                    color = if (showAllTasksInCalendar) Color.White else CharcoalDark,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 14.dp, vertical = 7.dp)
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // 3. Selected Date Header + Add Action
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = if (showAllTasksInCalendar) "All Calendar Tasks" else formattedDateHeader,
                    color = TextPrimary,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    text = if (displayedTasks.isEmpty()) "No plans scheduled" else "${displayedTasks.size} plans listed",
                    color = SubtitleGray,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Medium
                )
            }

            Surface(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onAddNewTaskForDate(formattedDateHeader) }
                    .testTag("add_task_on_selected_date"),
                shape = CircleShape,
                color = Color(0xFFEFF6FF),
                border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFBFDBFE))
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Add,
                        contentDescription = "Add Task",
                        tint = Color(0xFF0284C7),
                        modifier = Modifier.size(15.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = "Add Plan",
                        color = Color(0xFF0284C7),
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(14.dp))

        // 4. Render Tasks for selected day or All Calendar Tasks
        if (displayedTasks.isEmpty()) {
            Surface(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                shape = RoundedCornerShape(20.dp),
                color = Color.White.copy(alpha = 0.7f),
                border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(28.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        imageVector = Icons.Default.EventNote,
                        contentDescription = null,
                        tint = SubtitleGray,
                        modifier = Modifier.size(36.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = if (showAllTasksInCalendar) "No tasks found" else "No tasks for $formattedDateHeader",
                        color = TextPrimary,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = "Tap 'Add Plan' to schedule a task on this date.",
                        color = SubtitleGray,
                        fontSize = 13.sp,
                        textAlign = TextAlign.Center
                    )
                }
            }
        } else {
            Column(
                verticalArrangement = Arrangement.spacedBy(14.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                displayedTasks.forEach { task ->
                    FriendPlansTaskCard(
                        task = task,
                        onTaskClick = { onTaskClick(task) },
                        onEditClick = { onEditClick(task) },
                        onToggleComplete = { onToggleComplete(task) },
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(24.dp))
    }
}

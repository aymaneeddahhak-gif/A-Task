package com.example.ui.screens

import android.widget.Toast
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectVerticalDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.outlined.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.MoreHoriz
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material.icons.filled.Videocam
import androidx.compose.material.icons.filled.Work
import androidx.compose.material.icons.outlined.CalendarMonth
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material.icons.outlined.StarBorder
import androidx.compose.material.icons.outlined.WbSunny
import androidx.compose.material.icons.outlined.Work
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.data.local.TaskEntity
import com.example.ui.components.AvatarStack
import com.example.ui.components.FlowCalendarSection
import com.example.ui.components.TaskListDisplayMode
import com.example.ui.components.TaskViewSwitcher
import com.example.ui.theme.AccentBlue
import com.example.ui.theme.AccentPurple
import com.example.ui.theme.AccentPurpleLight
import com.example.ui.theme.AccentPurpleText
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.viewmodel.TaskViewModel

data class CalendarDay(
    val dayName: String,
    val dayNumber: Int,
    val fullDate: String
)

@Composable
fun ScheduleScreen(
    viewModel: TaskViewModel,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val allTasks by viewModel.allTasks.collectAsStateWithLifecycle()
    val selectedDay by viewModel.selectedDay.collectAsStateWithLifecycle()
    val selectedDateString by viewModel.selectedDateString.collectAsStateWithLifecycle()
    val selectedCategory by viewModel.categoryFilter.collectAsStateWithLifecycle()
    val isRefreshing by viewModel.isRefreshing.collectAsStateWithLifecycle()
    var scheduleDisplayMode by remember { mutableStateOf(TaskListDisplayMode.VERTICAL_LIST) }

    // Pull-to-refresh drag state for moving tasks down with looping refresh indicator
    var pullOffset by remember { mutableFloatStateOf(0f) }
    val maxPullDistance = 220f
    val triggerDistance = 120f

    val animatedPullOffset by animateFloatAsState(
        targetValue = if (isRefreshing) 110f else pullOffset,
        animationSpec = tween(durationMillis = 250, easing = FastOutSlowInEasing),
        label = "schedule_pull_offset"
    )

    val listState = rememberLazyListState()

    val daysList = listOf(
        CalendarDay("All", 0, "All Scheduled Plans"),
        CalendarDay("Mon", 12, "Mon, April 24"),
        CalendarDay("Tue", 13, "Tue, April 25"),
        CalendarDay("Wed", 14, "Wed, April 26"),
        CalendarDay("Thu", 15, "Thu, April 27"),
        CalendarDay("Fri", 16, "Fri, April 28"),
        CalendarDay("Sat", 17, "Sat, April 29"),
        CalendarDay("Sun", 18, "Sun, April 30")
    )

    val filteredTasks = allTasks.filter { task ->
        val matchesCategory = when (selectedCategory) {
            "All" -> true
            "Work" -> task.tags.contains("Work", ignoreCase = true) || task.tags.contains("School", ignoreCase = true) || task.tags.contains("Study", ignoreCase = true) || task.project.contains("Education", ignoreCase = true)
            "Personal" -> task.tags.contains("Personal", ignoreCase = true) || task.tags.contains("Routine", ignoreCase = true) || task.isFreeTime
            "Design", "Fitness" -> task.tags.contains("Fitness", ignoreCase = true) || task.tags.contains("Gym", ignoreCase = true) || task.tags.contains("Football", ignoreCase = true) || task.tags.contains("Design", ignoreCase = true)
            else -> true
        }
        matchesCategory
    }

    val morningTasks = filteredTasks.filter { it.timeSection == "Morning" }
    val afternoonTasks = filteredTasks.filter { it.timeSection == "Afternoon" }
    val eveningTasks = filteredTasks.filter { it.timeSection == "Evening" }
    val otherTasks = filteredTasks.filter { it.timeSection != "Morning" && it.timeSection != "Afternoon" && it.timeSection != "Evening" }

    // Refresh rotation animation for title row refresh button
    val refreshInfiniteTransition = rememberInfiniteTransition(label = "schedule_section_refresh")
    val refreshRotation by refreshInfiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 800, easing = LinearEasing)
        ),
        label = "rotation"
    )

    Box(
        modifier = modifier
            .fillMaxSize()
            .pointerInput(Unit) {
                detectVerticalDragGestures(
                    onDragStart = { },
                    onDragEnd = {
                        if (pullOffset >= triggerDistance) {
                            viewModel.refreshTasks()
                        }
                        pullOffset = 0f
                    },
                    onDragCancel = {
                        pullOffset = 0f
                    },
                    onVerticalDrag = { _, dragAmount ->
                        if (listState.firstVisibleItemIndex == 0 && listState.firstVisibleItemScrollOffset == 0) {
                            val newOffset = (pullOffset + dragAmount * 0.55f).coerceIn(0f, maxPullDistance)
                            pullOffset = newOffset
                        } else if (pullOffset > 0f) {
                            pullOffset = (pullOffset + dragAmount * 0.55f).coerceIn(0f, maxPullDistance)
                        }
                    }
                )
            }
    ) {
        LazyColumn(
            state = listState,
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding(),
            contentPadding = PaddingValues(bottom = 100.dp)
        ) {
            // 1. Header Bar: Back Button, Date Pill, Add +, More ...
            item {
                ScheduleHeader(
                    currentDateText = selectedDateString,
                    onBackClick = onBackClick,
                    onAddClick = { viewModel.openAddTask() },
                    onMoreClick = {
                        Toast.makeText(context, "Schedule settings & export options", Toast.LENGTH_SHORT).show()
                    },
                    modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp)
                )
            }

            // 2. Title Row: "Task Schedule" & Refresh button + Task View Switcher (List <-> Calendar)
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 20.dp, vertical = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Task\nSchedule",
                        color = TextPrimary,
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Bold,
                        lineHeight = 38.sp
                    )

                    // Refresh Button beside List <-> Calendar Task Switcher
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Animated Refresh / Sync Button
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(Color.White.copy(alpha = 0.9f))
                                .border(1.dp, CardBorder, CircleShape)
                                .clickable { viewModel.refreshTasks() }
                                .testTag("schedule_refresh_button"),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Sync,
                                contentDescription = "Refresh Tasks",
                                tint = if (isRefreshing) Color(0xFF0284C7) else CharcoalDark,
                                modifier = Modifier
                                    .size(18.dp)
                                    .rotate(if (isRefreshing) refreshRotation else 0f)
                            )
                        }

                        // Task View Switcher (List <-> Calendar)
                        TaskViewSwitcher(
                            currentMode = scheduleDisplayMode,
                            onModeChange = { scheduleDisplayMode = it },
                            isCompact = false
                        )
                    }
                }
            }

            // Looping Refresh Circle Animation banner when pulling down tasks or refreshing
            if (animatedPullOffset > 10f || isRefreshing) {
                item {
                    PullRefreshLoopingCircle(
                        pullProgress = (animatedPullOffset / triggerDistance).coerceIn(0f, 1f),
                        isRefreshing = isRefreshing
                    )
                }
            }

            if (scheduleDisplayMode == TaskListDisplayMode.CALENDAR_VIEW) {
                item {
                    Spacer(modifier = Modifier.height(8.dp))
                    Box(
                        modifier = Modifier.graphicsLayer {
                            translationY = animatedPullOffset * 0.4f
                        }
                    ) {
                        FlowCalendarSection(
                            tasks = allTasks,
                            onTaskClick = { viewModel.openTaskDetail(it) },
                            onEditClick = { viewModel.openTaskEdit(it) },
                            onToggleComplete = { viewModel.toggleTaskComplete(it) },
                            onAddNewTaskForDate = { dateStr ->
                                viewModel.openAddTask()
                            }
                        )
                    }
                }
            } else {
                // 3. Day of Week Horizontal Selector
                item {
                    Spacer(modifier = Modifier.height(8.dp))
                    LazyRow(
                        contentPadding = PaddingValues(horizontal = 20.dp),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        items(daysList) { day ->
                            val isSelected = day.dayNumber == selectedDay
                            DaySelectorPill(
                                day = day,
                                isSelected = isSelected,
                                onClick = { viewModel.setSelectedDay(day.dayNumber, day.fullDate) }
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(16.dp))
                }

                // 4. Category Filter Chips (All, Work, Personal, Star)
                item {
                    LazyRow(
                        contentPadding = PaddingValues(horizontal = 20.dp),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        val categories = listOf(
                            CategoryChipData("All", null),
                            CategoryChipData("Work", Icons.Outlined.Work),
                            CategoryChipData("Personal", Icons.Outlined.Person),
                            CategoryChipData("Design", Icons.Outlined.StarBorder)
                        )

                        items(categories) { cat ->
                            val isSelected = selectedCategory == cat.name
                            CategoryPill(
                                data = cat,
                                isSelected = isSelected,
                                onClick = { viewModel.setCategoryFilter(cat.name) }
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(20.dp))
                }

                // 5. Timeline Sections (with smooth task offset when pulling down)
                // Section A: Morning
                if (morningTasks.isNotEmpty()) {
                    item {
                        TimelineSectionHeader(
                            title = "Morning",
                            tag = "Today",
                            icon = Icons.Outlined.WbSunny
                        )
                    }
                    itemsIndexed(morningTasks, key = { _, it -> "m_${it.id}" }) { index, task ->
                        val taskDownOffset = if (index == 0) {
                            animatedPullOffset * 0.7f
                        } else {
                            (animatedPullOffset * (0.7f - index * 0.08f)).coerceAtLeast(0f)
                        }

                        TimelineTaskItem(
                            task = task,
                            onTaskClick = { viewModel.openTaskDetail(task) },
                            onMeetClick = {
                                Toast.makeText(context, "Opening Google Meet: meet.google.com/abc-defg-hij", Toast.LENGTH_LONG).show()
                            },
                            modifier = Modifier.graphicsLayer {
                                translationY = taskDownOffset
                            }
                        )
                    }
                }

                // Section B: Afternoon
                if (afternoonTasks.isNotEmpty()) {
                    item {
                        TimelineSectionHeader(
                            title = "Afternoon",
                            tag = "Today",
                            icon = Icons.Outlined.WbSunny
                        )
                    }
                    itemsIndexed(afternoonTasks, key = { _, it -> "a_${it.id}" }) { index, task ->
                        val taskDownOffset = if (morningTasks.isEmpty() && index == 0) {
                            animatedPullOffset * 0.7f
                        } else {
                            0f
                        }

                        TimelineTaskItem(
                            task = task,
                            onTaskClick = { viewModel.openTaskDetail(task) },
                            onMeetClick = {
                                Toast.makeText(context, "Opening Google Meet: meet.google.com/abc-defg-hij", Toast.LENGTH_LONG).show()
                            },
                            modifier = Modifier.graphicsLayer {
                                translationY = taskDownOffset
                            }
                        )
                    }
                }

                // Section C: Evening
                if (eveningTasks.isNotEmpty()) {
                    item {
                        TimelineSectionHeader(
                            title = "Evening",
                            tag = "Today",
                            icon = Icons.Outlined.WbSunny
                        )
                    }
                    items(eveningTasks, key = { "e_${it.id}" }) { task ->
                        TimelineTaskItem(
                            task = task,
                            onTaskClick = { viewModel.openTaskDetail(task) },
                            onMeetClick = {
                                Toast.makeText(context, "Opening Google Meet: meet.google.com/abc-defg-hij", Toast.LENGTH_LONG).show()
                            }
                        )
                    }
                }

                // Section D: Other Scheduled Plans
                if (otherTasks.isNotEmpty()) {
                    item {
                        TimelineSectionHeader(
                            title = "Scheduled Tasks",
                            tag = "All-Day",
                            icon = Icons.Outlined.Schedule
                        )
                    }
                    items(otherTasks, key = { "o_${it.id}" }) { task ->
                        TimelineTaskItem(
                            task = task,
                            onTaskClick = { viewModel.openTaskDetail(task) },
                            onMeetClick = {
                                Toast.makeText(context, "Opening Google Meet: meet.google.com/abc-defg-hij", Toast.LENGTH_LONG).show()
                            }
                        )
                    }
                }

                if (morningTasks.isEmpty() && afternoonTasks.isEmpty() && eveningTasks.isEmpty() && otherTasks.isEmpty()) {
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(40.dp)
                                .graphicsLayer {
                                    translationY = animatedPullOffset * 0.5f
                                },
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "No scheduled tasks found for this day & category.\nTap + to add a task!",
                                color = SubtitleGray,
                                fontSize = 14.sp,
                                textAlign = androidx.compose.ui.text.style.TextAlign.Center
                            )
                        }
                    }
                }
            }
        }
    }
}

data class CategoryChipData(
    val name: String,
    val icon: ImageVector?
)

@Composable
private fun ScheduleHeader(
    currentDateText: String,
    onBackClick: () -> Unit,
    onAddClick: () -> Unit,
    onMoreClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Left Back button + Date (Today / Selected date)
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier
                .clip(CircleShape)
                .background(Color.White.copy(alpha = 0.85f))
                .border(1.dp, CardBorder, CircleShape)
                .clickable { onBackClick() }
                .padding(horizontal = 12.dp, vertical = 8.dp)
                .testTag("schedule_back_button")
        ) {
            Icon(
                imageVector = Icons.AutoMirrored.Outlined.ArrowBack,
                contentDescription = "Back",
                tint = TextPrimary,
                modifier = Modifier.size(16.dp)
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
                text = currentDateText,
                color = TextPrimary,
                fontSize = 13.sp,
                fontWeight = FontWeight.SemiBold
            )
        }

        // Right Actions: Dark '+' and White '...'
        Row(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Dark '+' Button
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(CharcoalDark)
                    .clickable { onAddClick() }
                    .testTag("schedule_add_button"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = "Add Task",
                    tint = Color.White,
                    modifier = Modifier.size(18.dp)
                )
            }

            // White '...' Button
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(Color.White.copy(alpha = 0.85f))
                    .border(1.dp, CardBorder, CircleShape)
                    .clickable { onMoreClick() }
                    .testTag("schedule_more_button"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.MoreHoriz,
                    contentDescription = "More Options",
                    tint = TextPrimary,
                    modifier = Modifier.size(18.dp)
                )
            }
        }
    }
}

@Composable
private fun DaySelectorPill(
    day: CalendarDay,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Surface(
        modifier = Modifier
            .clip(RoundedCornerShape(24.dp))
            .clickable { onClick() }
            .testTag("calendar_day_${day.dayNumber}"),
        shape = RoundedCornerShape(24.dp),
        color = if (isSelected) CharcoalDark else Color.White.copy(alpha = 0.85f),
        border = if (isSelected) null else androidx.compose.foundation.BorderStroke(1.dp, CardBorder),
        shadowElevation = if (isSelected) 4.dp else 1.dp
    ) {
        Column(
            modifier = Modifier.padding(horizontal = 14.dp, vertical = 12.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = day.dayName,
                color = if (isSelected) Color.White.copy(alpha = 0.8f) else SubtitleGray,
                fontSize = 11.sp,
                fontWeight = FontWeight.Medium
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = "${day.dayNumber}",
                color = if (isSelected) Color.White else TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold
            )
        }
    }
}

@Composable
private fun CategoryPill(
    data: CategoryChipData,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Surface(
        modifier = Modifier
            .clip(CircleShape)
            .clickable { onClick() }
            .testTag("category_pill_${data.name}"),
        shape = CircleShape,
        color = if (isSelected) CharcoalDark else Color.White.copy(alpha = 0.85f),
        border = if (isSelected) null else androidx.compose.foundation.BorderStroke(1.dp, CardBorder),
        shadowElevation = if (isSelected) 4.dp else 1.dp
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 9.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            if (data.icon != null) {
                Icon(
                    imageVector = data.icon,
                    contentDescription = null,
                    tint = if (isSelected) Color.White else TextSecondary,
                    modifier = Modifier.size(15.dp)
                )
                Spacer(modifier = Modifier.width(6.dp))
            }
            Text(
                text = data.name,
                color = if (isSelected) Color.White else TextPrimary,
                fontSize = 13.sp,
                fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Medium
            )
        }
    }
}

@Composable
private fun TimelineSectionHeader(
    title: String,
    tag: String,
    icon: ImageVector
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp, vertical = 10.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = Color(0xFFF59E0B),
                modifier = Modifier.size(16.dp)
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
                text = title,
                color = TextPrimary,
                fontSize = 15.sp,
                fontWeight = FontWeight.Bold
            )
        }

        Text(
            text = tag,
            color = SubtitleGray,
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium
        )
    }
}

@Composable
private fun TimelineTaskItem(
    task: TaskEntity,
    onTaskClick: () -> Unit,
    onMeetClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp, vertical = 6.dp)
    ) {
        // Left Column: Time & Vertical Timeline Indicator
        Column(
            modifier = Modifier
                .width(58.dp)
                .padding(top = 8.dp),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = task.startTime.substringBefore(" "),
                color = TextPrimary,
                fontSize = 13.sp,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = task.startTime.substringAfter(" ", "AM"),
                color = SubtitleGray,
                fontSize = 10.sp,
                fontWeight = FontWeight.Medium
            )

            Spacer(modifier = Modifier.height(10.dp))

            // Dotted vertical line
            Box(
                modifier = Modifier
                    .width(1.dp)
                    .height(60.dp)
                    .drawBehind {
                        drawLine(
                            color = CardBorder,
                            start = Offset(0f, 0f),
                            end = Offset(0f, size.height),
                            strokeWidth = 2.dp.toPx(),
                            pathEffect = PathEffect.dashPathEffect(floatArrayOf(8f, 8f), 0f)
                        )
                    }
            )
        }

        // Right Column: Rounded White Card
        Surface(
            modifier = Modifier
                .weight(1f)
                .shadow(
                    elevation = 6.dp,
                    shape = RoundedCornerShape(22.dp),
                    spotColor = Color(0x10000000),
                    ambientColor = Color(0x06000000)
                )
                .clip(RoundedCornerShape(22.dp))
                .clickable { onTaskClick() }
                .testTag("schedule_task_card_${task.id}"),
            shape = RoundedCornerShape(22.dp),
            color = Color.White,
            border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
        ) {
            Column(
                modifier = Modifier.padding(16.dp)
            ) {
                // Task Title
                Text(
                    text = task.title,
                    color = TextPrimary,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold
                )

                if (task.description.isNotBlank()) {
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = task.description,
                        color = TextSecondary,
                        fontSize = 12.sp,
                        lineHeight = 16.sp,
                        maxLines = 2
                    )
                }

                Spacer(modifier = Modifier.height(10.dp))

                // Dynamic Progress Line on every timeline task
                val (progressFraction, progressLabel) = com.example.ui.components.calculateDynamicTaskProgress(task)
                val animatedProgress by animateFloatAsState(
                    targetValue = progressFraction,
                    animationSpec = tween(durationMillis = 600, easing = FastOutSlowInEasing),
                    label = "TimelineProgress_${task.id}"
                )

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = if (task.isCompleted) "TASK COMPLETED" else "TASK PROGRESS",
                        color = SubtitleGray,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 0.5.sp
                    )
                    Text(
                        text = progressLabel,
                        color = if (task.isCompleted) Color(0xFF10B981) else TextPrimary,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
                Spacer(modifier = Modifier.height(5.dp))
                LinearProgressIndicator(
                    progress = { animatedProgress },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(5.dp)
                        .clip(CircleShape),
                    color = if (task.isCompleted) Color(0xFF10B981) else AccentBlue,
                    trackColor = Color(0xFFF1F5F9)
                )

                Spacer(modifier = Modifier.height(12.dp))

                // Bottom row with avatars and badges
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Avatars
                    AvatarStack(count = task.assigneeCount, avatarSize = 24.dp)

                    // Right action: Meet button (Blue pill) OR Status badge (Purple pill)
                    if (task.hasMeeting) {
                        Surface(
                            modifier = Modifier
                                .clip(CircleShape)
                                .clickable { onMeetClick() }
                                .testTag("meet_button_${task.id}"),
                            shape = CircleShape,
                            color = AccentBlue
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 14.dp, vertical = 6.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Videocam,
                                    contentDescription = "Join Meet",
                                    tint = Color.White,
                                    modifier = Modifier.size(14.dp)
                                )
                                Spacer(modifier = Modifier.width(5.dp))
                                Text(
                                    text = task.meetTitle,
                                    color = Color.White,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    } else {
                        // Purple / Colored Status Badge
                        Surface(
                            shape = CircleShape,
                            color = AccentPurpleLight
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 12.dp, vertical = 5.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Box(
                                    modifier = Modifier
                                        .size(6.dp)
                                        .clip(CircleShape)
                                        .background(AccentPurple)
                                )
                                Spacer(modifier = Modifier.width(5.dp))
                                Text(
                                    text = task.status,
                                    color = AccentPurpleText,
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.SemiBold
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

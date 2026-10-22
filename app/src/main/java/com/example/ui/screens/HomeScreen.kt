package com.example.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectVerticalDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import android.widget.Toast
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Bolt
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.Image
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.RadioButtonUnchecked
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Sync
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.Description
import androidx.compose.material.icons.outlined.Notifications
import androidx.compose.material.icons.outlined.Refresh
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material.icons.rounded.CheckCircle
import androidx.compose.material.icons.rounded.FormatListBulleted
import androidx.compose.material.icons.rounded.HourglassEmpty
import androidx.compose.material.icons.rounded.NorthEast
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import com.example.R
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.data.local.TaskEntity
import com.example.ui.components.AvatarStack
import com.example.ui.components.CircularProgressRing
import com.example.ui.components.FlowCalendarSection
import com.example.ui.components.FriendPlansTaskCard
import com.example.ui.components.TaskListDisplayMode
import com.example.ui.components.TaskViewSwitcher
import com.example.ui.components.UserAvatarHeader
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalCard
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.LimeGreen
import com.example.ui.theme.LimeGreenDark
import com.example.ui.theme.PriorityHighDot
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.viewmodel.TaskViewModel
import com.example.ui.viewmodel.TimeFilterScope
import kotlin.math.roundToInt

@Composable
fun HomeScreen(
    viewModel: TaskViewModel,
    onNavigateToSchedule: () -> Unit,
    onNavigateToDocs: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val tasks by viewModel.allTasks.collectAsStateWithLifecycle()
    val stats by viewModel.taskStats.collectAsStateWithLifecycle()
    val currentFilter by viewModel.statusFilter.collectAsStateWithLifecycle()
    val timeFilterScope by viewModel.timeFilterScope.collectAsStateWithLifecycle()
    val timeFilterSubOption by viewModel.timeFilterSubOption.collectAsStateWithLifecycle()
    val currentDayFilter by viewModel.currentDayFilter.collectAsStateWithLifecycle()
    val isRefreshing by viewModel.isRefreshing.collectAsStateWithLifecycle()
    val lastAddedTaskId by viewModel.lastAddedTaskId.collectAsStateWithLifecycle()
    val isRoutineManagerOpen by viewModel.isRoutineManagerOpen.collectAsStateWithLifecycle()
    val allRoutines by viewModel.allRoutines.collectAsStateWithLifecycle()
    val context = LocalContext.current

    var showRandomTaskConfirmDialog by remember { mutableStateOf(false) }
    var showFilterScopeDialog by remember { mutableStateOf(false) }

    val dayFilteredTasks = tasks.filter {
        viewModel.matchesTimeFilter(it, timeFilterScope, timeFilterSubOption)
    }

    val totalAllCount = dayFilteredTasks.size
    val todoCount = dayFilteredTasks.count { it.status == "To Do" && !it.isCompleted }
    val inProgressCount = dayFilteredTasks.count { it.status == "In Progress" && !it.isCompleted }
    val inReviewCount = dayFilteredTasks.count { it.status == "In Review" && !it.isCompleted }
    val doneCount = dayFilteredTasks.count { it.status == "Done" || it.isCompleted }

    var displayMode by remember { mutableStateOf(TaskListDisplayMode.VERTICAL_LIST) }

    // Pull-to-refresh drag state for moving tasks down with looping refresh indicator
    var pullOffset by remember { mutableFloatStateOf(0f) }
    val maxPullDistance = 220f
    val triggerDistance = 120f

    // Animate smoothly back to 0 or refreshing position
    val animatedPullOffset by animateFloatAsState(
        targetValue = if (isRefreshing) 110f else pullOffset,
        animationSpec = tween(durationMillis = 250, easing = FastOutSlowInEasing),
        label = "pull_offset"
    )

    val listState = rememberLazyListState()

    val filteredTasks = dayFilteredTasks.filter {
        when (currentFilter) {
            "All" -> true
            "To Do" -> (it.status == "To Do" && !it.isCompleted)
            "In Progress" -> (it.status == "In Progress" && !it.isCompleted)
            "In Review" -> (it.status == "In Review" && !it.isCompleted)
            "Done" -> (it.status == "Done" || it.isCompleted)
            else -> true
        }
    }

    // Refresh rotation animation for section refresh button
    val refreshInfiniteTransition = rememberInfiniteTransition(label = "home_section_refresh")
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
                        // Only allow dragging down if at top of scroll
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
            // 1. Top Header Bar: User Avatar, Doc button & Notifications
            item {
                HomeHeader(
                    onDocsClick = onNavigateToDocs,
                    onNotificationClick = { viewModel.openNotifications() },
                    modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp)
                )
            }

            // 2. Bold Headline & Random Task Button placed OUT of color box on top right of it
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 20.dp, vertical = 6.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.Bottom
                ) {
                    Text(
                        text = "Let's Make\nToday Productive",
                        color = TextPrimary,
                        fontSize = 30.sp,
                        fontWeight = FontWeight.Bold,
                        lineHeight = 36.sp
                    )

                    // Random Task button placed OUT of the color box on top right of it
                    Surface(
                        modifier = Modifier
                            .clip(RoundedCornerShape(12.dp))
                            .clickable { showRandomTaskConfirmDialog = true }
                            .testTag("random_task_button"),
                        shape = RoundedCornerShape(12.dp),
                        color = Color.White,
                        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder),
                        shadowElevation = 2.dp
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 7.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(6.dp)
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Bolt,
                                contentDescription = "Random Task",
                                tint = Color(0xFF578EF5),
                                modifier = Modifier.size(15.dp)
                            )
                            Text(
                                text = "Random Task",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold,
                                color = CharcoalDark
                            )
                        }
                    }
                }
            }

            // 3. Today's Progress Card
            item {
                TodayProgressCard(
                    progressFraction = stats.progressFraction,
                    totalCount = stats.totalCount,
                    completedCount = stats.completedCount,
                    pendingCount = stats.pendingCount,
                    scope = timeFilterScope,
                    subOption = timeFilterSubOption,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 20.dp, vertical = 8.dp)
                )
            }

            // 4. Section Header: "Plans & Tasks" on left, Uiverse filter button on right on same line
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 20.dp, vertical = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Plans & Tasks",
                        color = TextPrimary,
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold
                    )

                    // Uiverse.io styled Filter Button (50px by 50px, border-radius 10px, 1px solid rgba(0,0,0,0.192))
                    Surface(
                        modifier = Modifier
                            .size(50.dp)
                            .shadow(elevation = 2.dp, shape = RoundedCornerShape(10.dp), spotColor = Color(0x15000000))
                            .clip(RoundedCornerShape(10.dp))
                            .clickable { showFilterScopeDialog = true }
                            .testTag("home_iconic_filter_button"),
                        shape = RoundedCornerShape(10.dp),
                        color = Color.White,
                        border = androidx.compose.foundation.BorderStroke(1.dp, Color(0x31000000))
                    ) {
                        Box(
                            contentAlignment = Alignment.Center,
                            modifier = Modifier.fillMaxSize()
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_uiverse_filter),
                                contentDescription = "filter",
                                tint = Color(0xFF4D4D4D), // rgb(77, 77, 77)
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }
            }

            // 5. Tasks List OR Calendar View (Moves down when pulling down)
            if (displayMode == TaskListDisplayMode.CALENDAR_VIEW) {
                item {
                    Box(
                        modifier = Modifier.graphicsLayer {
                            translationY = animatedPullOffset * 0.4f
                        }
                    ) {
                        FlowCalendarSection(
                            tasks = tasks,
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
                if (filteredTasks.isEmpty()) {
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
                                text = "No tasks in '$currentFilter' status.\nTap + above to create one!",
                                color = SubtitleGray,
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Medium,
                                textAlign = androidx.compose.ui.text.style.TextAlign.Center
                            )
                        }
                    }
                } else {
                    itemsIndexed(filteredTasks, key = { _, it -> it.id }) { index, task ->
                        // The tasks (especially the first task) move down smoothly based on pull offset
                        val taskDownOffset = if (index == 0) {
                            animatedPullOffset * 0.7f
                        } else {
                            (animatedPullOffset * (0.7f - index * 0.08f)).coerceAtLeast(0f)
                        }

                        FriendPlansTaskCard(
                            task = task,
                            onTaskClick = { viewModel.openTaskDetail(task) },
                            onEditClick = { viewModel.openTaskEdit(task) },
                            onToggleComplete = { viewModel.toggleTaskComplete(task) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .graphicsLayer {
                                    translationY = taskDownOffset
                                }
                                .padding(horizontal = 20.dp, vertical = 8.dp)
                        )
                    }
                }
            }
        }

        // Random Task Confirmation Dialog
        if (showRandomTaskConfirmDialog) {
            Dialog(
                onDismissRequest = { showRandomTaskConfirmDialog = false },
                properties = DialogProperties(usePlatformDefaultWidth = false)
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.88f)
                        .shadow(24.dp, RoundedCornerShape(26.dp), spotColor = Color(0x35000000))
                        .clip(RoundedCornerShape(26.dp)),
                    shape = RoundedCornerShape(26.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier.padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Box(
                            modifier = Modifier
                                .size(50.dp)
                                .clip(CircleShape)
                                .background(Color(0xFFE0F2FE)),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Bolt,
                                contentDescription = null,
                                tint = Color(0xFF0284C7),
                                modifier = Modifier.size(25.dp)
                            )
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        Text(
                            text = "Apply Random Task?",
                            fontSize = 19.sp,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Text(
                            text = "Do you want to apply a random task? This will generate a full-day schedule routine with morning, afternoon & evening activities covering all options.",
                            fontSize = 13.sp,
                            color = SubtitleGray,
                            textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                            lineHeight = 19.sp
                        )

                        Spacer(modifier = Modifier.height(22.dp))

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(10.dp)
                        ) {
                            Surface(
                                modifier = Modifier
                                    .weight(1f)
                                    .clip(CircleShape)
                                    .clickable { showRandomTaskConfirmDialog = false }
                                    .testTag("random_task_cancel_button"),
                                shape = CircleShape,
                                color = Color(0xFFF1F5F9)
                            ) {
                                Box(
                                    modifier = Modifier.padding(vertical = 12.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text(
                                        text = "Cancel",
                                        color = TextPrimary,
                                        fontSize = 13.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }

                            Surface(
                                modifier = Modifier
                                    .weight(1f)
                                    .shadow(6.dp, CircleShape, spotColor = Color(0x25000000))
                                    .clip(CircleShape)
                                    .clickable {
                                        showRandomTaskConfirmDialog = false
                                        viewModel.applyRandomFullDayRoutine()
                                        Toast.makeText(context, "Applied random full-day routine!", Toast.LENGTH_SHORT).show()
                                    }
                                    .testTag("random_task_ok_button"),
                                shape = CircleShape,
                                color = CharcoalDark
                            ) {
                                Box(
                                    modifier = Modifier.padding(vertical = 12.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text(
                                        text = "OK",
                                        color = Color.White,
                                        fontSize = 13.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }

        // Time & Status Filter Dialog (Day, Week, Month with sub-options and status)
        if (showFilterScopeDialog) {
            val subOptions = remember(timeFilterScope) {
                when (timeFilterScope) {
                    TimeFilterScope.DAY -> listOf("All Day", "Today", "Tomorrow", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
                    TimeFilterScope.WEEK -> listOf("All Weeks", "Week 1", "Week 2", "Week 3", "Week 4")
                    TimeFilterScope.MONTH -> listOf(
                        "All Months",
                        "Month 1 (Jan)", "Month 2 (Feb)", "Month 3 (Mar)", "Month 4 (Apr)",
                        "Month 5 (May)", "Month 6 (Jun)", "Month 7 (Jul)", "Month 8 (Aug)",
                        "Month 9 (Sep)", "Month 10 (Oct)", "Month 11 (Nov)", "Month 12 (Dec)"
                    )
                }
            }

            Dialog(
                onDismissRequest = { showFilterScopeDialog = false },
                properties = DialogProperties(usePlatformDefaultWidth = false)
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.92f)
                        .shadow(24.dp, RoundedCornerShape(26.dp), spotColor = Color(0x35000000))
                        .clip(RoundedCornerShape(26.dp)),
                    shape = RoundedCornerShape(26.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .padding(22.dp)
                            .verticalScroll(rememberScrollState())
                    ) {
                        // Header: Title + Close Icon
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.FilterList,
                                    contentDescription = null,
                                    tint = Color(0xFF578EF5),
                                    modifier = Modifier.size(20.dp)
                                )
                                Text(
                                    text = "Filter Tasks",
                                    fontSize = 19.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = TextPrimary
                                )
                            }
                            Box(
                                modifier = Modifier
                                    .size(32.dp)
                                    .clip(CircleShape)
                                    .background(Color(0xFFF1F5F9))
                                    .clickable { showFilterScopeDialog = false },
                                contentAlignment = Alignment.Center
                            ) {
                                Text("✕", fontSize = 13.sp, color = SubtitleGray, fontWeight = FontWeight.Bold)
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        // 1. Time Scope Tabs (Day | Week | Month)
                        Text(
                            text = "Timeframe View",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = SubtitleGray,
                            letterSpacing = 0.5.sp
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(14.dp))
                                .background(Color(0xFFF1F5F9))
                                .padding(4.dp),
                            horizontalArrangement = Arrangement.spacedBy(4.dp)
                        ) {
                            TimeFilterScope.values().forEach { scope ->
                                val isSelected = timeFilterScope == scope
                                Box(
                                    modifier = Modifier
                                        .weight(1f)
                                        .clip(RoundedCornerShape(11.dp))
                                        .background(if (isSelected) Color(0xFF578EF5) else Color.Transparent)
                                        .clickable { viewModel.setTimeFilterScope(scope) }
                                        .padding(vertical = 9.dp)
                                        .testTag("filter_dialog_scope_${scope.name.lowercase()}"),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text(
                                        text = "${scope.icon} ${scope.displayName}",
                                        fontSize = 12.sp,
                                        fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                                        color = if (isSelected) Color.White else Color(0xFF475569)
                                    )
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        // 2. Sub-options for current scope
                        Text(
                            text = when (timeFilterScope) {
                                TimeFilterScope.DAY -> "Day Selection (All Day, Today, Weekdays)"
                                TimeFilterScope.WEEK -> "Week Selection"
                                TimeFilterScope.MONTH -> "Month Selection"
                            },
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = SubtitleGray,
                            letterSpacing = 0.5.sp
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        @OptIn(ExperimentalLayoutApi::class)
                        FlowRow(
                            horizontalArrangement = Arrangement.spacedBy(8.dp),
                            verticalArrangement = Arrangement.spacedBy(8.dp),
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            subOptions.forEach { option ->
                                val isSelected = timeFilterSubOption.equals(option, ignoreCase = true) ||
                                        (timeFilterScope == TimeFilterScope.MONTH && timeFilterSubOption.startsWith(option.substringBefore(" ("), ignoreCase = true))

                                Surface(
                                    modifier = Modifier
                                        .clip(RoundedCornerShape(12.dp))
                                        .clickable { viewModel.setTimeFilterSubOption(option) }
                                        .testTag("sub_filter_chip_$option"),
                                    shape = RoundedCornerShape(12.dp),
                                    color = if (isSelected) Color(0xFF578EF5) else Color(0xFFF8FAFC),
                                    border = androidx.compose.foundation.BorderStroke(
                                        1.dp,
                                        if (isSelected) Color(0xFF578EF5) else CardBorder
                                    )
                                ) {
                                    Text(
                                        text = option,
                                        fontSize = 12.sp,
                                        fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                                        color = if (isSelected) Color.White else Color(0xFF334155),
                                        modifier = Modifier.padding(horizontal = 12.dp, vertical = 7.dp)
                                    )
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(18.dp))

                        // 3. Status filter options
                        Text(
                            text = "Status Filter",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = SubtitleGray,
                            letterSpacing = 0.5.sp
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        val statusOptions = listOf("All", "To Do", "In Progress", "In Review", "Done")
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(6.dp)
                        ) {
                            statusOptions.forEach { status ->
                                val isSelected = currentFilter.equals(status, ignoreCase = true)
                                Surface(
                                    modifier = Modifier
                                        .weight(1f)
                                        .clip(RoundedCornerShape(10.dp))
                                        .clickable { viewModel.setStatusFilter(status) }
                                        .testTag("status_filter_chip_$status"),
                                    shape = RoundedCornerShape(10.dp),
                                    color = if (isSelected) Color(0xFF0F172A) else Color(0xFFF8FAFC),
                                    border = androidx.compose.foundation.BorderStroke(
                                        1.dp,
                                        if (isSelected) Color(0xFF0F172A) else CardBorder
                                    )
                                ) {
                                    Box(
                                        modifier = Modifier.padding(vertical = 8.dp),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Text(
                                            text = status,
                                            fontSize = 11.sp,
                                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                                            color = if (isSelected) Color.White else Color(0xFF334155),
                                            textAlign = TextAlign.Center
                                        )
                                    }
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(20.dp))

                        // Action Buttons: Reset & Done
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(10.dp)
                        ) {
                            Surface(
                                modifier = Modifier
                                    .weight(1f)
                                    .clip(CircleShape)
                                    .clickable {
                                        viewModel.setTimeFilterScope(TimeFilterScope.DAY)
                                        viewModel.setTimeFilterSubOption("All Day")
                                        viewModel.setStatusFilter("All")
                                    },
                                shape = CircleShape,
                                color = Color(0xFFF1F5F9)
                            ) {
                                Box(
                                    modifier = Modifier.padding(vertical = 12.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text("Reset", color = TextPrimary, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                                }
                            }

                            Surface(
                                modifier = Modifier
                                    .weight(1f)
                                    .clip(CircleShape)
                                    .clickable { showFilterScopeDialog = false },
                                shape = CircleShape,
                                color = Color(0xFF578EF5)
                            ) {
                                Box(
                                    modifier = Modifier.padding(vertical = 12.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text("Done", color = Color.White, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/**
 * Looping circular refresh spinner indicator that appears when moving down the task list
 */
@Composable
fun PullRefreshLoopingCircle(
    pullProgress: Float,
    isRefreshing: Boolean,
    modifier: Modifier = Modifier
) {
    val infiniteTransition = rememberInfiniteTransition(label = "pull_refresh_loop")
    val rotation by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 750, easing = LinearEasing)
        ),
        label = "spinner_rotation"
    )

    Box(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        contentAlignment = Alignment.Center
    ) {
        Surface(
            shape = CircleShape,
            color = Color.White,
            shadowElevation = 4.dp,
            border = androidx.compose.foundation.BorderStroke(1.5.dp, Color(0xFFE2E8F0)),
            modifier = Modifier.size(44.dp)
        ) {
            Box(
                contentAlignment = Alignment.Center,
                modifier = Modifier.fillMaxSize()
            ) {
                if (isRefreshing) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(24.dp),
                        color = Color(0xFF0284C7),
                        strokeWidth = 2.5.dp,
                        strokeCap = StrokeCap.Round
                    )
                } else {
                    Icon(
                        imageVector = Icons.Filled.Sync,
                        contentDescription = "Pull to refresh",
                        tint = if (pullProgress >= 0.9f) Color(0xFF0284C7) else SubtitleGray,
                        modifier = Modifier
                            .size(20.dp)
                            .rotate(pullProgress * 180f)
                    )
                }
            }
        }
    }
}

@Composable
private fun HomeHeader(
    onDocsClick: () -> Unit,
    onNotificationClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Left User Avatar + Subtitle
        Row(
            verticalAlignment = Alignment.CenterVertically
        ) {
            UserAvatarHeader(size = 46.dp)
            Spacer(modifier = Modifier.width(12.dp))
            Column {
                Text(
                    text = "Good Morning",
                    color = SubtitleGray,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Normal
                )
                Text(
                    text = "AYMANE",
                    color = TextPrimary,
                    fontSize = 17.sp,
                    fontWeight = FontWeight.Bold
                )
            }
        }

        // Right Controls: Documentation + Notification Bell
        Row(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Doc / Documentation Icon Button
            Box(
                modifier = Modifier
                    .size(42.dp)
                    .clip(CircleShape)
                    .background(CharcoalDark)
                    .clickable { onDocsClick() }
                    .testTag("home_docs_button"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Description,
                    contentDescription = "Documentation",
                    tint = Color.White,
                    modifier = Modifier.size(19.dp)
                )
            }

            // Frosted White Notification Bell Button
            Box(
                modifier = Modifier
                    .size(42.dp)
                    .clip(CircleShape)
                    .background(Color.White.copy(alpha = 0.9f))
                    .border(1.dp, CardBorder, CircleShape)
                    .clickable { onNotificationClick() }
                    .testTag("notifications_button"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.Notifications,
                    contentDescription = "Notifications",
                    tint = CharcoalDark,
                    modifier = Modifier.size(20.dp)
                )
                // Red notification dot indicator
                Box(
                    modifier = Modifier
                        .size(7.dp)
                        .align(Alignment.TopEnd)
                        .padding(top = 10.dp, end = 10.dp)
                        .clip(CircleShape)
                        .background(PriorityHighDot)
                )
            }
        }
    }
}

@Composable
fun TodayProgressCard(
    progressFraction: Float,
    totalCount: Int,
    completedCount: Int,
    pendingCount: Int,
    scope: TimeFilterScope = TimeFilterScope.DAY,
    subOption: String = "All Day",
    onRandomTaskClick: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val badgeTitle = when (scope) {
        TimeFilterScope.DAY -> if (subOption.equals("All Day", ignoreCase = true)) "Daily Sprint" else "$subOption's Sprint"
        TimeFilterScope.WEEK -> "$subOption Sprint"
        TimeFilterScope.MONTH -> "$subOption Overview"
    }

    val progressTitle = when (scope) {
        TimeFilterScope.DAY -> if (subOption.equals("All Day", ignoreCase = true)) "Your Daily\nProgress" else "$subOption's\nProgress"
        TimeFilterScope.WEEK -> "$subOption\nProgress"
        TimeFilterScope.MONTH -> "$subOption\nProgress"
    }

    Surface(
        modifier = modifier
            .shadow(
                elevation = 14.dp,
                shape = RoundedCornerShape(26.dp),
                spotColor = Color(0x35669E1C),
                ambientColor = Color(0x18000000)
            ),
        shape = RoundedCornerShape(26.dp),
        color = Color(0xFFD6F49D), // Fresh pastel spring green
        border = BorderStroke(1.dp, Color(0xFFE5FAC0))
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(
                    Brush.linearGradient(
                        colors = listOf(
                            Color(0xFFDCF8A7),
                            Color(0xFFCEF193)
                        )
                    )
                )
                .padding(20.dp)
        ) {
            Column {
                // Top Mini Pill Badge "⚡ Daily Sprint"
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(Color.White.copy(alpha = 0.65f))
                        .padding(horizontal = 10.dp, vertical = 4.dp)
                ) {
                    Icon(
                        imageVector = Icons.Filled.Bolt,
                        contentDescription = null,
                        tint = Color(0xFF2C4C18),
                        modifier = Modifier.size(13.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = badgeTitle,
                        color = Color(0xFF233D14),
                        fontSize = 11.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }

                Spacer(modifier = Modifier.height(10.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    // Left Side: Title & Stat Breakdown
                    Column(
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(
                            text = progressTitle,
                            color = Color(0xFF142410),
                            fontSize = 20.sp,
                            fontWeight = FontWeight.ExtraBold,
                            lineHeight = 24.sp
                        )

                        Spacer(modifier = Modifier.height(14.dp))

                        // Stats breakdown rows
                        Column(
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            ProgressStatRow(
                                count = totalCount,
                                label = "Total Tasks",
                                icon = Icons.Rounded.FormatListBulleted
                            )
                            ProgressStatRow(
                                count = completedCount,
                                label = "Completed",
                                icon = Icons.Rounded.CheckCircle
                            )
                            ProgressStatRow(
                                count = pendingCount,
                                label = "In Progress",
                                icon = Icons.Rounded.HourglassEmpty
                            )
                        }
                    }

                    Spacer(modifier = Modifier.width(14.dp))

                    // Right Side: Circular Progress Ring with Inner White Disk
                    CircularProgressRing(
                        progress = progressFraction,
                        size = 102.dp,
                        strokeWidth = 10.dp,
                        trackColor = Color(0xFFC7EC87),
                        progressColor = Color(0xFF75CE17),
                        centerCircleColor = Color.White,
                        textColor = Color(0xFF142410),
                        centerSubtitle = "done",
                        centerSubtitleColor = Color(0xFF4C6F3B)
                    )
                }
            }
        }
    }
}

@Composable
private fun ProgressStatRow(
    count: Int,
    label: String,
    icon: ImageVector
) {
    Row(
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(24.dp)
                .clip(RoundedCornerShape(6.dp))
                .background(Color.White.copy(alpha = 0.75f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = Color(0xFF28481B),
                modifier = Modifier.size(13.dp)
            )
        }

        Spacer(modifier = Modifier.width(8.dp))

        Text(
            text = "$count",
            color = Color(0xFF142410),
            fontSize = 13.sp,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.width(5.dp))

        Text(
            text = label,
            color = Color(0xFF38552C),
            fontSize = 12.sp,
            fontWeight = FontWeight.Medium
        )
    }
}

@Composable
private fun FilterPill(
    count: String,
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Surface(
        modifier = Modifier
            .clip(CircleShape)
            .clickable { onClick() }
            .testTag("filter_pill_$label"),
        shape = CircleShape,
        color = if (isSelected) LimeGreen else Color.White,
        border = if (isSelected) null else androidx.compose.foundation.BorderStroke(1.dp, CardBorder),
        shadowElevation = if (isSelected) 4.dp else 1.dp
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            Text(
                text = count,
                color = if (isSelected) LimeGreenDark else TextPrimary,
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
                text = label,
                color = if (isSelected) LimeGreenDark else TextSecondary,
                fontSize = 13.sp,
                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium
            )
        }
    }
}

@Composable
fun HomeTaskCard(
    task: TaskEntity,
    onTaskClick: () -> Unit,
    onToggleComplete: () -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier
            .shadow(
                elevation = 6.dp,
                shape = RoundedCornerShape(22.dp),
                spotColor = Color(0x12000000),
                ambientColor = Color(0x08000000)
            )
            .clip(RoundedCornerShape(22.dp))
            .clickable { onTaskClick() }
            .testTag("task_item_card_${task.id}"),
        shape = RoundedCornerShape(22.dp),
        color = Color.White,
        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
    ) {
        val durationRegex = Regex("\\s*\\(([^)]+)\\)")
        val durationMatch = durationRegex.find(task.title)
        val extractedDuration = durationMatch?.groupValues?.getOrNull(1)?.trim()
        val durationValue = if (!extractedDuration.isNullOrBlank()) {
            extractedDuration
        } else if (task.startTime.isNotBlank() && task.endTime.isNotBlank() && task.startTime != task.endTime) {
            val format = java.text.SimpleDateFormat("hh:mm a", java.util.Locale.US)
            try {
                val start = format.parse(task.startTime)
                val end = format.parse(task.endTime)
                if (start != null && end != null) {
                    val diffMs = (end.time - start.time).let { if (it < 0) it + 24 * 3600 * 1000 else it }
                    val diffMinutes = (diffMs / (1000 * 60)).toInt()
                    val hours = diffMinutes / 60
                    val minutes = diffMinutes % 60
                    if (hours > 0 && minutes > 0) "${hours}h ${minutes}m"
                    else if (hours > 0) "${hours}h"
                    else "${minutes} min"
                } else "30 min"
            } catch (e: Exception) {
                "30 min"
            }
        } else {
            "30 min"
        }
        val cleanDuration = durationValue
            .replace("(", "")
            .replace(")", "")
            .replace(":", "h ")
            .replace("h 00", "h")
            .trim()
            .let { dur ->
                if (!dur.contains("min", ignoreCase = true) && !dur.contains("h", ignoreCase = true) && !dur.contains("m", ignoreCase = true)) {
                    "$dur min"
                } else {
                    dur
                }
            }

        Column(
            modifier = Modifier.padding(18.dp)
        ) {
            // Row 1: Duration badge (Top Left) + Priority badge (Top Right)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Top Left: 30 min Duration pill (no parentheses, no colons)
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(Color(0xFFF1F5F9))
                        .padding(horizontal = 10.dp, vertical = 5.dp)
                ) {
                    Icon(
                        imageVector = Icons.Outlined.Schedule,
                        contentDescription = "Duration",
                        tint = SubtitleGray,
                        modifier = Modifier.size(13.dp)
                    )
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = cleanDuration,
                        color = TextPrimary,
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold
                    )
                }

                // Top Right: Priority pill
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(Color(0xFFFBF8F5))
                        .border(1.dp, CardBorder, CircleShape)
                        .padding(horizontal = 10.dp, vertical = 4.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(6.dp)
                            .clip(CircleShape)
                            .background(
                                when (task.priority.lowercase()) {
                                    "high" -> PriorityHighDot
                                    "medium" -> Color(0xFFFB8C00)
                                    else -> Color(0xFF43A047)
                                }
                            )
                    )
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = "${task.priority} Priority",
                        color = TextPrimary,
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Medium
                    )
                }
            }

            Spacer(modifier = Modifier.height(10.dp))

            // Task Title
            Text(
                text = task.title,
                color = if (task.isCompleted) SubtitleGray else TextPrimary,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                textDecoration = if (task.isCompleted) TextDecoration.LineThrough else TextDecoration.None
            )

            Spacer(modifier = Modifier.height(10.dp))

            // Dynamic Progress Line
            val (progressFraction, progressLabel) = com.example.ui.components.calculateDynamicTaskProgress(task)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = if (task.isCompleted) "TASK COMPLETED" else "TASK PROGRESS",
                    color = SubtitleGray,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Bold,
                    letterSpacing = 0.5.sp
                )
                Text(
                    text = progressLabel,
                    color = if (task.isCompleted) Color(0xFF10B981) else TextPrimary,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Bold
                )
            }
            Spacer(modifier = Modifier.height(6.dp))
            androidx.compose.material3.LinearProgressIndicator(
                progress = { progressFraction },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(6.dp)
                    .clip(CircleShape),
                color = if (task.isCompleted) Color(0xFF10B981) else Color(0xFF4F46E5),
                trackColor = Color(0xFFF1F5F9)
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Bottom Row: Time badge + Team avatars + Toggle Checkbox
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Date
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(Color(0xFFF8F7F5))
                        .padding(horizontal = 10.dp, vertical = 5.dp)
                ) {
                    Icon(
                        imageVector = Icons.Outlined.CalendarToday,
                        contentDescription = null,
                        tint = SubtitleGray,
                        modifier = Modifier.size(14.dp)
                    )
                    Spacer(modifier = Modifier.width(5.dp))
                    Text(
                        text = task.dateString.ifBlank { "Today" },
                        color = TextSecondary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Medium
                    )
                }

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // Completion Toggle Circle
                    Box(
                        modifier = Modifier
                            .size(28.dp)
                            .clip(CircleShape)
                            .background(if (task.isCompleted) LimeGreen else Color(0xFFF5F4F0))
                            .clickable { onToggleComplete() }
                            .testTag("task_toggle_complete_${task.id}"),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = if (task.isCompleted) Icons.Default.Check else Icons.Filled.RadioButtonUnchecked,
                            contentDescription = "Toggle Complete",
                            tint = if (task.isCompleted) CharcoalDark else SubtitleGray,
                            modifier = Modifier.size(16.dp)
                        )
                    }
                }
            }
        }
    }
}

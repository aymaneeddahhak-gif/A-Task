package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Scaffold
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.ui.components.AppBottomNavBar
import com.example.ui.components.AuroraBackground
import com.example.ui.components.NavigationTab
import com.example.ui.screens.AddTaskScreen
import com.example.ui.screens.ChatbotScreen
import com.example.ui.screens.DesignSandboxScreen
import com.example.ui.screens.HomeScreen
import com.example.ui.screens.NotificationsDialog
import com.example.ui.screens.ProfileScreen
import com.example.ui.screens.ProjectsScreen
import com.example.ui.screens.ScheduleScreen
import com.example.ui.screens.TaskDetailDialog
import com.example.ui.theme.TaskPlannerTheme
import com.example.ui.viewmodel.TaskViewModel

class MainActivity : ComponentActivity() {
    private val taskViewModel: TaskViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            TaskPlannerTheme {
                MainAppScreen(viewModel = taskViewModel)
            }
        }
    }
}

@Composable
fun MainAppScreen(viewModel: TaskViewModel) {
    var selectedTab by remember { mutableStateOf(NavigationTab.HOME) }
    var isDesignSandboxOpen by remember { mutableStateOf(false) }
    val isAddTaskOpen by viewModel.isAddTaskOpen.collectAsStateWithLifecycle()
    val isNotificationsOpen by viewModel.isNotificationsOpen.collectAsStateWithLifecycle()
    val isPushEnabled by viewModel.isPushNotificationsEnabled.collectAsStateWithLifecycle()
    val notifications by viewModel.notifications.collectAsStateWithLifecycle()
    val selectedTaskForDetail by viewModel.selectedTaskForDetail.collectAsStateWithLifecycle()
    val isTaskDetailInEditMode by viewModel.isTaskDetailInEditMode.collectAsStateWithLifecycle()

    if (isDesignSandboxOpen) {
        DesignSandboxScreen(
            viewModel = viewModel,
            onBackClick = { isDesignSandboxOpen = false }
        )
    } else if (isAddTaskOpen) {
        AddTaskScreen(
            onDismiss = { viewModel.closeAddTask() },
            onCreateTask = { title, description, date, startTime, endTime, priority, project, tags, hasMeeting, colorTheme ->
                viewModel.createTask(
                    title = title,
                    description = description,
                    date = date,
                    startTime = startTime,
                    endTime = endTime,
                    priority = priority,
                    project = project,
                    tags = tags,
                    hasMeeting = hasMeeting,
                    colorTheme = colorTheme
                )
            },
            viewModel = viewModel
        )
    } else {
        AuroraBackground {
            Scaffold(
                containerColor = Color.Transparent,
                bottomBar = {
                    AppBottomNavBar(
                        selectedTab = selectedTab,
                        onTabSelected = { selectedTab = it },
                        onAddClick = { viewModel.openAddTask() }
                    )
                }
            ) { innerPadding ->
                Box(modifier = Modifier.fillMaxSize()) {
                    AnimatedContent(
                        targetState = selectedTab,
                        transitionSpec = {
                            if (targetState.ordinal > initialState.ordinal) {
                                (slideInHorizontally { width -> width / 4 } + fadeIn())
                                    .togetherWith(slideOutHorizontally { width -> -width / 4 } + fadeOut())
                            } else {
                                (slideInHorizontally { width -> -width / 4 } + fadeIn())
                                    .togetherWith(slideOutHorizontally { width -> width / 4 } + fadeOut())
                            }
                        },
                        label = "TabContentAnimation"
                    ) { tab ->
                        when (tab) {
                            NavigationTab.HOME -> {
                                HomeScreen(
                                    viewModel = viewModel,
                                    onNavigateToSchedule = { selectedTab = NavigationTab.CALENDAR },
                                    onNavigateToDocs = { selectedTab = NavigationTab.PROJECTS }
                                )
                            }
                            NavigationTab.PROJECTS -> {
                                ProjectsScreen(viewModel = viewModel)
                            }
                            NavigationTab.CALENDAR -> {
                                ScheduleScreen(
                                    viewModel = viewModel,
                                    onBackClick = { selectedTab = NavigationTab.HOME }
                                )
                            }
                            NavigationTab.CHATBOT -> {
                                ChatbotScreen(
                                    viewModel = viewModel,
                                    onBackClick = { selectedTab = NavigationTab.HOME }
                                )
                            }
                            NavigationTab.PROFILE -> {
                                ProfileScreen(
                                    viewModel = viewModel,
                                    onBackClick = { selectedTab = NavigationTab.HOME },
                                    onOpenDesignSandbox = { isDesignSandboxOpen = true }
                                )
                            }
                        }
                    }

                    // Floating quick access pill to Design Sandbox in the middle of top bar
                    Surface(
                        shape = RoundedCornerShape(20.dp),
                        color = Color(0xFF0F172A).copy(alpha = 0.88f),
                        shadowElevation = 6.dp,
                        modifier = Modifier
                            .align(Alignment.TopCenter)
                            .statusBarsPadding()
                            .padding(top = 10.dp)
                            .clip(RoundedCornerShape(20.dp))
                            .clickable { isDesignSandboxOpen = true }
                            .testTag("open_sandbox_fab")
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(text = "🎨", fontSize = 12.sp)
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = "Sandbox",
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color.White
                            )
                        }
                    }
                }
            }

            // Task Detail Dialog
            selectedTaskForDetail?.let { task ->
                TaskDetailDialog(
                    task = task,
                    startInEditMode = isTaskDetailInEditMode,
                    onDismiss = { viewModel.closeTaskDetail() },
                    onToggleComplete = { viewModel.toggleTaskComplete(task) },
                    onDelete = { viewModel.deleteTask(task) },
                    onSaveEdit = { viewModel.updateTask(it) }
                )
            }

            // Notifications Dialog
            if (isNotificationsOpen) {
                NotificationsDialog(
                    isPushEnabled = isPushEnabled,
                    notifications = notifications,
                    onDismiss = { viewModel.closeNotifications() },
                    onEnablePushNotifications = { viewModel.enablePushNotifications() },
                    onMarkAllAsRead = { viewModel.markAllNotificationsRead() },
                    onClearAll = { viewModel.clearAllNotifications() },
                    onItemClick = { notif ->
                        when (notif.actionRoute) {
                            "PROFILE" -> {
                                viewModel.closeNotifications()
                                selectedTab = NavigationTab.PROFILE
                            }
                            "CALENDAR", "ROUTINE" -> {
                                viewModel.closeNotifications()
                                selectedTab = NavigationTab.CALENDAR
                            }
                            else -> {
                                viewModel.openTaskFromNotification(notif) {
                                    selectedTab = NavigationTab.CALENDAR
                                }
                            }
                        }
                    },
                    onRemoveItem = { notifId ->
                        viewModel.removeNotification(notifId)
                    }
                )
            }
        }
    }
}

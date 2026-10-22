package com.example.ui.components

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.BorderStroke
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
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material.icons.rounded.Add
import androidx.compose.material.icons.rounded.AutoAwesome
import androidx.compose.material.icons.rounded.Check
import androidx.compose.material.icons.rounded.DeleteOutline
import androidx.compose.material.icons.rounded.FitnessCenter
import androidx.compose.material.icons.rounded.Schedule
import androidx.compose.material.icons.rounded.School
import androidx.compose.material.icons.rounded.SportsSoccer
import androidx.compose.material.icons.rounded.WbSunny
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.data.local.RoutineEntity
import com.example.data.local.TaskEntity
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.LimeGreen
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.viewmodel.TaskViewModel
import java.util.Calendar
import java.util.UUID

enum class TaskConfigMode(val title: String, val iconText: String) {
    SINGLE_TASK("Single Task", "📝"),
    DAILY_ROUTINE("Daily Routine", "⏰"),
    MATCH_SPORTS("Match Day", "⚽")
}

data class RoutineSlotItem(
    val id: String = UUID.randomUUID().toString(),
    var title: String,
    var description: String,
    var startTime: String,
    var endTime: String,
    var priority: String = "Medium",
    var project: String = "Daily Routine",
    var tags: String = "Routine",
    var timeSection: String = "Morning",
    var colorTheme: String = "blue",
    var isFreeTime: Boolean = false
) {
    fun toTaskEntity(dateString: String): TaskEntity {
        return TaskEntity(
            title = title,
            description = description,
            dateString = dateString,
            startTime = startTime,
            endTime = endTime,
            priority = priority,
            status = "To Do",
            project = project,
            tags = tags,
            timeSection = timeSection,
            colorTheme = colorTheme,
            isCompleted = false,
            isFreeTime = isFreeTime
        )
    }
}

fun getDefaultRoutineSlots(): List<RoutineSlotItem> {
    return listOf(
        RoutineSlotItem(
            title = "Wake Up & Morning Prep",
            description = "Wake up at 7:00 AM, fresh hydration, wash up & prepare for school.",
            startTime = "07:00 AM",
            endTime = "07:45 AM",
            priority = "Medium",
            project = "Morning Routine",
            tags = "WakeUp,Morning,Routine",
            timeSection = "Morning",
            colorTheme = "peach"
        ),
        RoutineSlotItem(
            title = "School & Classes",
            description = "School from 8:00 AM to 12:00 PM. Focus on lectures, coursework & discussions.",
            startTime = "08:00 AM",
            endTime = "12:00 PM",
            priority = "High",
            project = "Education & School",
            tags = "School,Class,Academics",
            timeSection = "Morning",
            colorTheme = "blue"
        ),
        RoutineSlotItem(
            title = "Back Home & Lunch",
            description = "Arrive home from school, eat a nutritious lunch & recharge.",
            startTime = "12:00 PM",
            endTime = "12:45 PM",
            priority = "Medium",
            project = "Daily Routine",
            tags = "Lunch,Home,Food",
            timeSection = "Afternoon",
            colorTheme = "mint"
        ),
        RoutineSlotItem(
            title = "Power Nap / Sleep (45 min)",
            description = "45-minute power nap to rest brain and recover physical energy.",
            startTime = "12:45 PM",
            endTime = "01:30 PM",
            priority = "Medium",
            project = "Rest & Wellness",
            tags = "Sleep,Nap,Rest",
            timeSection = "Afternoon",
            colorTheme = "lavender"
        ),
        RoutineSlotItem(
            title = "Free Time & Relaxation",
            description = "Open personal free time — unwind, relax, play or browse. No checklist pressure.",
            startTime = "01:30 PM",
            endTime = "02:30 PM",
            priority = "Low",
            project = "Personal Time",
            tags = "FreeTime,Relax,Break",
            timeSection = "Afternoon",
            colorTheme = "yellow",
            isFreeTime = true
        ),
        RoutineSlotItem(
            title = "Gym Session (1 Hour)",
            description = "Go to the gym for 1 Hour: weight lifting, fitness drills & cardio.",
            startTime = "02:30 PM",
            endTime = "03:30 PM",
            priority = "High",
            project = "Health & Fitness",
            tags = "Gym,Fitness,Workout",
            timeSection = "Afternoon",
            colorTheme = "red"
        ),
        RoutineSlotItem(
            title = "Coffee Break (30 min)",
            description = "Warm coffee for 30 minutes, protein snack & calm breather.",
            startTime = "03:30 PM",
            endTime = "04:00 PM",
            priority = "Low",
            project = "Personal & Coffee",
            tags = "Coffee,Break,Snack",
            timeSection = "Afternoon",
            colorTheme = "peach"
        ),
        RoutineSlotItem(
            title = "Study & Revision (1h 30m)",
            description = "1 Hour 30 min focused revision, practice exercises & summary notes.",
            startTime = "04:00 PM",
            endTime = "05:30 PM",
            priority = "High",
            project = "Study & Revision",
            tags = "Study,Revision,School",
            timeSection = "Evening",
            colorTheme = "blue"
        ),
        RoutineSlotItem(
            title = "Reading a Book (30 min)",
            description = "Read 30 minutes of a good book, novel or self-growth guide.",
            startTime = "05:30 PM",
            endTime = "06:00 PM",
            priority = "Medium",
            project = "Reading & Growth",
            tags = "Book,Reading,Mindset",
            timeSection = "Evening",
            colorTheme = "lavender"
        ),
        RoutineSlotItem(
            title = "Go to Sleep & Rest",
            description = "Bedtime wind down, prepare bedroom & sleep for full 8h recovery.",
            startTime = "10:00 PM",
            endTime = "10:45 PM",
            priority = "Medium",
            project = "Sleep & Health",
            tags = "Sleep,Rest,Night",
            timeSection = "Evening",
            colorTheme = "charcoal"
        )
    )
}

/**
 * Top Segmented Bar inside AddTaskScreen to choose Single Task vs Routine vs Match Day
 */
@Composable
fun TaskConfigModeSelector(
    selectedMode: TaskConfigMode,
    onModeSelected: (TaskConfigMode) -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier
            .fillMaxWidth()
            .shadow(2.dp, RoundedCornerShape(16.dp), spotColor = Color(0x10000000)),
        shape = RoundedCornerShape(16.dp),
        color = Color.White,
        border = BorderStroke(1.dp, CardBorder)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(4.dp),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            TaskConfigMode.values().forEach { mode ->
                val isSelected = selectedMode == mode
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(12.dp))
                        .clickable { onModeSelected(mode) }
                        .testTag("task_config_mode_${mode.name}"),
                    shape = RoundedCornerShape(12.dp),
                    color = if (isSelected) CharcoalDark else Color.Transparent
                ) {
                    Row(
                        modifier = Modifier.padding(vertical = 10.dp),
                        horizontalArrangement = Arrangement.Center,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = mode.iconText,
                            fontSize = 13.sp
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = mode.title,
                            fontSize = 12.sp,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                            color = if (isSelected) Color.White else TextSecondary
                        )
                    }
                }
            }
        }
    }
}

/**
 * Full Routine Configuration Tab inside AddTaskScreen:
 * - Scope selector: Today, Tomorrow, This Week, This Month
 * - Replace existing tasks toggle (clean up old tasks vs append)
 * - Preset chips (School & Gym, Morning Football & School, Weekend, Custom)
 * - Interactive timeline editor: edit every hour, delete, add Football match, add Free Time, add slot
 * - Save routine template
 * - Apply Schedule Button
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
fun DailyRoutineConfigContent(
    viewModel: TaskViewModel?,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val allRoutines by (viewModel?.allRoutines?.collectAsStateWithLifecycle() ?: remember { mutableStateOf(emptyList<RoutineEntity>()) })

    var selectedScope by remember { mutableStateOf("Today") } // Today, Tomorrow, Week, Month
    var replaceExistingTasks by remember { mutableStateOf(true) }
    var selectedPresetName by remember { mutableStateOf("Standard Day") }

    val routineSlots = remember { mutableStateListOf<RoutineSlotItem>().apply { addAll(getDefaultRoutineSlots()) } }

    // Dialog state for editing / adding slot
    var editingSlotIndex by remember { mutableStateOf<Int?>(null) }
    var isAddingNewSlot by remember { mutableStateOf(false) }

    // Slot edit fields
    var editTitle by remember { mutableStateOf("") }
    var editDesc by remember { mutableStateOf("") }
    var editStartTime by remember { mutableStateOf("08:00 AM") }
    var editEndTime by remember { mutableStateOf("09:00 AM") }
    var editPriority by remember { mutableStateOf("Medium") }
    var editProject by remember { mutableStateOf("Daily Routine") }
    var editTags by remember { mutableStateOf("Routine") }
    var editColorTheme by remember { mutableStateOf("blue") }
    var editIsFreeTime by remember { mutableStateOf(false) }

    // Save as routine template state
    var isSaveTemplateDialogOpen by remember { mutableStateOf(false) }
    var templateNameInput by remember { mutableStateOf("") }
    var templateDescInput by remember { mutableStateOf("") }

    fun openEditSlot(index: Int) {
        val slot = routineSlots[index]
        editingSlotIndex = index
        editTitle = slot.title
        editDesc = slot.description
        editStartTime = slot.startTime
        editEndTime = slot.endTime
        editPriority = slot.priority
        editProject = slot.project
        editTags = slot.tags
        editColorTheme = slot.colorTheme
        editIsFreeTime = slot.isFreeTime
    }

    fun openAddNewSlot(defaultTitle: String = "New Activity", isFreeTime: Boolean = false, isFootball: Boolean = false) {
        editingSlotIndex = null
        isAddingNewSlot = true
        editTitle = defaultTitle
        editDesc = if (isFreeTime) "Open personal free time to unwind." else if (isFootball) "Friendly football match & drills." else ""
        editStartTime = if (isFootball) "06:30 AM" else "02:00 PM"
        editEndTime = if (isFootball) "07:45 AM" else "03:00 PM"
        editPriority = if (isFootball) "High" else if (isFreeTime) "Low" else "Medium"
        editProject = if (isFootball) "Sports & Football" else if (isFreeTime) "Personal Time" else "Daily Routine"
        editTags = if (isFootball) "Football,Match,Sports" else if (isFreeTime) "FreeTime,Relax" else "Routine"
        editColorTheme = if (isFootball) "mint" else if (isFreeTime) "yellow" else "blue"
        editIsFreeTime = isFreeTime
    }

    fun saveSlotChanges() {
        val slotItem = RoutineSlotItem(
            title = editTitle.ifBlank { "Activity" },
            description = editDesc,
            startTime = editStartTime,
            endTime = editEndTime,
            priority = editPriority,
            project = editProject,
            tags = editTags,
            timeSection = if (editStartTime.contains("AM", ignoreCase = true)) "Morning" else if (editStartTime.startsWith("12") || editStartTime.startsWith("01") || editStartTime.startsWith("02") || editStartTime.startsWith("03") || editStartTime.startsWith("04")) "Afternoon" else "Evening",
            colorTheme = editColorTheme,
            isFreeTime = editIsFreeTime
        )
        val idx = editingSlotIndex
        if (idx != null && idx in routineSlots.indices) {
            routineSlots[idx] = slotItem
        } else if (isAddingNewSlot) {
            routineSlots.add(slotItem)
        }
        editingSlotIndex = null
        isAddingNewSlot = false
    }

    fun applyPreset(preset: String) {
        selectedPresetName = preset
        routineSlots.clear()
        when (preset) {
            "Standard Day" -> {
                routineSlots.addAll(getDefaultRoutineSlots())
            }
            "Morning Football" -> {
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Morning Football Match ⚽",
                        description = "Early friendly football match & drills with teammates on the pitch.",
                        startTime = "06:30 AM",
                        endTime = "07:45 AM",
                        priority = "High",
                        project = "Sports & Football",
                        tags = "Football,Match,Morning",
                        timeSection = "Morning",
                        colorTheme = "mint"
                    )
                )
                routineSlots.addAll(getDefaultRoutineSlots().drop(1)) // keep rest of day
            }
            "Weekend & Sports" -> {
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Morning Gym & Workout 🏋️",
                        description = "Full body workout session and stretching.",
                        startTime = "08:30 AM",
                        endTime = "09:45 AM",
                        priority = "High",
                        project = "Health & Fitness",
                        tags = "Gym,Fitness,Weekend",
                        timeSection = "Morning",
                        colorTheme = "red"
                    )
                )
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Free Time & Gaming 🎮",
                        description = "Free time to play, relax and browse.",
                        startTime = "10:00 AM",
                        endTime = "12:30 PM",
                        priority = "Low",
                        project = "Personal Time",
                        tags = "FreeTime,Relax",
                        timeSection = "Morning",
                        colorTheme = "yellow",
                        isFreeTime = true
                    )
                )
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Lunch & Family Time 🍽️",
                        description = "Relaxed weekend lunch.",
                        startTime = "12:30 PM",
                        endTime = "01:30 PM",
                        priority = "Medium",
                        project = "Family & Friends",
                        tags = "Lunch,Weekend",
                        timeSection = "Afternoon",
                        colorTheme = "mint"
                    )
                )
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Reading & Book Session 📚",
                        description = "45 minutes reading inspiring book chapters.",
                        startTime = "02:30 PM",
                        endTime = "03:15 PM",
                        priority = "Medium",
                        project = "Reading & Growth",
                        tags = "Book,Reading",
                        timeSection = "Afternoon",
                        colorTheme = "lavender"
                    )
                )
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Evening Football Match ⚽",
                        description = "Weekend 7v7 football match under the field lights.",
                        startTime = "05:30 PM",
                        endTime = "07:00 PM",
                        priority = "High",
                        project = "Sports & Football",
                        tags = "Football,Match,Sports",
                        timeSection = "Evening",
                        colorTheme = "mint"
                    )
                )
                routineSlots.add(
                    RoutineSlotItem(
                        title = "Night Rest & Sleep 🌙",
                        description = "Wind down and bedtime recovery.",
                        startTime = "11:00 PM",
                        endTime = "11:45 PM",
                        priority = "Low",
                        project = "Rest",
                        tags = "Sleep,Rest",
                        timeSection = "Evening",
                        colorTheme = "charcoal"
                    )
                )
            }
        }
    }

    Column(
        modifier = modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // 1. Choose Target Period (Today, Tomorrow, Week, Month)
        Column {
            Text(
                text = "Apply Routine To",
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold,
                color = TextPrimary
            )
            Spacer(modifier = Modifier.height(8.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                val scopes = listOf(
                    Triple("Today", "☀️ Today", "today_scope"),
                    Triple("Tomorrow", "🌙 Tomorrow", "tomorrow_scope"),
                    Triple("Week", "📅 This Week", "week_scope"),
                    Triple("Month", "🗓️ This Month", "month_scope")
                )
                scopes.forEach { (key, label, tag) ->
                    val isSelected = selectedScope.equals(key, ignoreCase = true)
                    Surface(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(12.dp))
                            .clickable { selectedScope = key }
                            .testTag(tag),
                        shape = RoundedCornerShape(12.dp),
                        color = if (isSelected) Color(0xFF0F172A) else Color.White,
                        border = BorderStroke(1.dp, if (isSelected) Color(0xFF0F172A) else CardBorder)
                    ) {
                        Text(
                            text = label,
                            fontSize = 12.sp,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                            color = if (isSelected) Color.White else Color(0xFF334155),
                            modifier = Modifier.padding(vertical = 10.dp, horizontal = 4.dp),
                            textAlign = androidx.compose.ui.text.style.TextAlign.Center
                        )
                    }
                }
            }
        }

        // 2. Replace Existing Tasks Card (User requested: "remove all exist task on th ap and ad this")
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .shadow(2.dp, RoundedCornerShape(16.dp), spotColor = Color(0x0C000000)),
            shape = RoundedCornerShape(16.dp),
            color = if (replaceExistingTasks) Color(0xFFFEF2F2) else Color(0xFFF8FAFC),
            border = BorderStroke(1.dp, if (replaceExistingTasks) Color(0xFFFECACA) else CardBorder)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 14.dp, vertical = 10.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            imageVector = Icons.Default.Delete,
                            contentDescription = null,
                            tint = if (replaceExistingTasks) Color(0xFFDC2626) else SubtitleGray,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "Replace existing tasks",
                            fontSize = 13.sp,
                            fontWeight = FontWeight.Bold,
                            color = if (replaceExistingTasks) Color(0xFFDC2626) else TextPrimary
                        )
                    }
                    Text(
                        text = if (replaceExistingTasks) "Clears previous tasks on selected day(s) for a clean day schedule" else "Appends to current tasks without removing them",
                        fontSize = 11.sp,
                        color = SubtitleGray,
                        lineHeight = 15.sp,
                        modifier = Modifier.padding(start = 22.dp, top = 2.dp)
                    )
                }

                Switch(
                    checked = replaceExistingTasks,
                    onCheckedChange = { replaceExistingTasks = it },
                    colors = SwitchDefaults.colors(
                        checkedThumbColor = Color.White,
                        checkedTrackColor = Color(0xFFEF4444)
                    ),
                    modifier = Modifier.testTag("replace_existing_tasks_toggle")
                )
            }
        }

        // 3. Preset Routine Selector
        Column {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Routine Templates",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = TextPrimary
                )
                Text(
                    text = "${routineSlots.size} slots configured",
                    fontSize = 12.sp,
                    color = SubtitleGray
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                val presets = listOf(
                    "Standard Day",
                    "Morning Football",
                    "Weekend & Sports"
                )
                presets.forEach { preset ->
                    val isSelected = selectedPresetName == preset
                    Surface(
                        modifier = Modifier
                            .clip(CircleShape)
                            .clickable { applyPreset(preset) },
                        shape = CircleShape,
                        color = if (isSelected) Color(0xFFE0F2FE) else Color.White,
                        border = BorderStroke(1.dp, if (isSelected) Color(0xFF0284C7) else CardBorder)
                    ) {
                        Text(
                            text = preset,
                            fontSize = 12.sp,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                            color = if (isSelected) Color(0xFF0369A1) else TextSecondary,
                            modifier = Modifier.padding(horizontal = 14.dp, vertical = 7.dp)
                        )
                    }
                }

                // Show any custom saved routines
                allRoutines.filter { it.name !in presets }.take(3).forEach { saved ->
                    Surface(
                        modifier = Modifier
                            .clip(CircleShape)
                            .clickable {
                                selectedPresetName = saved.name
                                if (viewModel != null) {
                                    val parsed = viewModel.parseRoutineTasks(saved, selectedScope)
                                    routineSlots.clear()
                                    routineSlots.addAll(parsed.map {
                                        RoutineSlotItem(
                                            title = it.title,
                                            description = it.description,
                                            startTime = it.startTime,
                                            endTime = it.endTime,
                                            priority = it.priority,
                                            project = it.project,
                                            tags = it.tags,
                                            timeSection = it.timeSection,
                                            colorTheme = it.colorTheme,
                                            isFreeTime = it.isFreeTime
                                        )
                                    })
                                }
                            },
                        shape = CircleShape,
                        color = Color(0xFFF1F5F9),
                        border = BorderStroke(1.dp, CardBorder)
                    ) {
                        Text(
                            text = "⭐ ${saved.name}",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Medium,
                            color = CharcoalDark,
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 7.dp)
                        )
                    }
                }
            }
        }

        // 4. Action Chips to Add Slots (Football, Free Time, Custom)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            // Quick Add Morning Football Match
            Surface(
                modifier = Modifier
                    .weight(1f)
                    .clip(RoundedCornerShape(12.dp))
                    .clickable { openAddNewSlot("Morning Football Match ⚽", isFreeTime = false, isFootball = true) }
                    .testTag("add_morning_football_slot"),
                shape = RoundedCornerShape(12.dp),
                color = Color(0xFFECFDF5),
                border = BorderStroke(1.dp, Color(0xFFA7F3D0))
            ) {
                Row(
                    modifier = Modifier.padding(vertical = 8.dp, horizontal = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "⚽ + Morning Match",
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF047857)
                    )
                }
            }

            // Quick Add Free Time Block
            Surface(
                modifier = Modifier
                    .weight(1f)
                    .clip(RoundedCornerShape(12.dp))
                    .clickable { openAddNewSlot("Free Time & Relaxation 🌿", isFreeTime = true, isFootball = false) }
                    .testTag("add_free_time_slot"),
                shape = RoundedCornerShape(12.dp),
                color = Color(0xFFFEFCE8),
                border = BorderStroke(1.dp, Color(0xFFFEF08A))
            ) {
                Row(
                    modifier = Modifier.padding(vertical = 8.dp, horizontal = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = "🌿 + Free Time",
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFFB45309)
                    )
                }
            }

            // Custom Slot Button
            Surface(
                modifier = Modifier
                    .weight(1f)
                    .clip(RoundedCornerShape(12.dp))
                    .clickable { openAddNewSlot("New Activity", isFreeTime = false, isFootball = false) }
                    .testTag("add_custom_routine_slot"),
                shape = RoundedCornerShape(12.dp),
                color = Color.White,
                border = BorderStroke(1.dp, CardBorder)
            ) {
                Row(
                    modifier = Modifier.padding(vertical = 8.dp, horizontal = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.Center
                ) {
                    Icon(imageVector = Icons.Rounded.Add, contentDescription = null, tint = TextSecondary, modifier = Modifier.size(14.dp))
                    Spacer(modifier = Modifier.width(3.dp))
                    Text(
                        text = "Add Slot",
                        fontSize = 11.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = TextSecondary
                    )
                }
            }
        }

        // 5. Interactive Timeline List ("All this can be changed")
        Text(
            text = "Timeline Schedule (Tap to edit)",
            fontSize = 14.sp,
            fontWeight = FontWeight.SemiBold,
            color = TextPrimary
        )

        Column(
            verticalArrangement = Arrangement.spacedBy(8.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            routineSlots.forEachIndexed { index, slot ->
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .shadow(2.dp, RoundedCornerShape(14.dp), spotColor = Color(0x0A000000))
                        .clip(RoundedCornerShape(14.dp))
                        .clickable { openEditSlot(index) }
                        .testTag("routine_slot_item_$index"),
                    shape = RoundedCornerShape(14.dp),
                    color = if (slot.isFreeTime) Color(0xFFFEFDF7) else Color.White,
                    border = BorderStroke(
                        1.dp,
                        if (slot.isFreeTime) Color(0xFFFDE68A) else CardBorder
                    )
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 12.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        // Left Column: Time badge + Title + Tag
                        Column(modifier = Modifier.weight(1f)) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                // Time Pill
                                Surface(
                                    shape = RoundedCornerShape(6.dp),
                                    color = if (slot.isFreeTime) Color(0xFFFEF3C7) else Color(0xFFF1F5F9)
                                ) {
                                    Text(
                                        text = "${slot.startTime} - ${slot.endTime}",
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.Bold,
                                        color = if (slot.isFreeTime) Color(0xFF92400E) else Color(0xFF334155),
                                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                                    )
                                }

                                if (slot.isFreeTime) {
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text(
                                        text = "Free Time",
                                        fontSize = 10.sp,
                                        fontWeight = FontWeight.Bold,
                                        color = Color(0xFF059669)
                                    )
                                }
                            }

                            Spacer(modifier = Modifier.height(4.dp))

                            Text(
                                text = slot.title,
                                fontSize = 13.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = TextPrimary
                            )

                            if (slot.description.isNotBlank()) {
                                Text(
                                    text = slot.description,
                                    fontSize = 11.sp,
                                    color = SubtitleGray,
                                    maxLines = 1
                                )
                            }
                        }

                        // Right: Edit & Delete buttons
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            IconButton(
                                onClick = { openEditSlot(index) },
                                modifier = Modifier.size(32.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Edit,
                                    contentDescription = "Edit Slot",
                                    tint = Color(0xFF2563EB),
                                    modifier = Modifier.size(16.dp)
                                )
                            }

                            IconButton(
                                onClick = { routineSlots.removeAt(index) },
                                modifier = Modifier.size(32.dp)
                            ) {
                                Icon(
                                    imageVector = Icons.Rounded.DeleteOutline,
                                    contentDescription = "Delete Slot",
                                    tint = Color(0xFFEF4444),
                                    modifier = Modifier.size(16.dp)
                                )
                            }
                        }
                    }
                }
            }
        }

        // 6. Save as Reusable Routine Template Button
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(14.dp))
                .clickable { isSaveTemplateDialogOpen = true }
                .testTag("save_routine_template_button"),
            shape = RoundedCornerShape(14.dp),
            color = Color(0xFFF8FAFC),
            border = BorderStroke(1.dp, CardBorder)
        ) {
            Row(
                modifier = Modifier.padding(vertical = 12.dp, horizontal = 14.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.Center
            ) {
                Icon(
                    imageVector = Icons.Rounded.AutoAwesome,
                    contentDescription = null,
                    tint = Color(0xFF7C3AED),
                    modifier = Modifier.size(16.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Save this schedule as a reusable routine",
                    fontSize = 13.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF6D28D9)
                )
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // 7. Primary Action Button: Apply Routine to Scope
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .shadow(8.dp, CircleShape, spotColor = Color(0x30000000))
                .clip(CircleShape)
                .clickable {
                    if (viewModel != null) {
                        val taskEntities = routineSlots.map { it.toTaskEntity(selectedScope) }
                        viewModel.applyTasksToScope(
                            tasks = taskEntities,
                            scope = selectedScope,
                            replaceExisting = replaceExistingTasks
                        )
                    } else {
                        onDismiss()
                    }
                }
                .testTag("apply_routine_button"),
            shape = CircleShape,
            color = CharcoalDark
        ) {
            Box(
                modifier = Modifier.padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Apply Routine to $selectedScope (${routineSlots.size} Activities)",
                    color = Color.White,
                    fontSize = 15.sp,
                    fontWeight = FontWeight.Bold
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
    }

    // Modal Dialog to Edit or Add an Activity Slot in the Routine
    if (editingSlotIndex != null || isAddingNewSlot) {
        Dialog(onDismissRequest = {
            editingSlotIndex = null
            isAddingNewSlot = false
        }) {
            Surface(
                modifier = Modifier
                    .fillMaxWidth(0.95f)
                    .shadow(16.dp, RoundedCornerShape(24.dp)),
                shape = RoundedCornerShape(24.dp),
                color = Color.White
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(20.dp),
                    verticalArrangement = Arrangement.spacedBy(14.dp)
                ) {
                    Text(
                        text = if (isAddingNewSlot) "Add New Routine Slot" else "Edit Routine Slot",
                        fontSize = 17.sp,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    // Title
                    Column {
                        Text("Activity Name", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                        Spacer(modifier = Modifier.height(4.dp))
                        BasicTextField(
                            value = editTitle,
                            onValueChange = { editTitle = it },
                            textStyle = TextStyle(fontSize = 14.sp, color = TextPrimary),
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(Color(0xFFF8FAFC), RoundedCornerShape(10.dp))
                                .border(1.dp, CardBorder, RoundedCornerShape(10.dp))
                                .padding(12.dp)
                        )
                    }

                    // Description
                    Column {
                        Text("Description / Notes", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                        Spacer(modifier = Modifier.height(4.dp))
                        BasicTextField(
                            value = editDesc,
                            onValueChange = { editDesc = it },
                            textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary),
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(Color(0xFFF8FAFC), RoundedCornerShape(10.dp))
                                .border(1.dp, CardBorder, RoundedCornerShape(10.dp))
                                .padding(12.dp)
                        )
                    }

                    // Start Time & End Time
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text("Start Time", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                            Spacer(modifier = Modifier.height(4.dp))
                            BasicTextField(
                                value = editStartTime,
                                onValueChange = { editStartTime = it },
                                textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary, fontWeight = FontWeight.Medium),
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .background(Color(0xFFF8FAFC), RoundedCornerShape(10.dp))
                                    .border(1.dp, CardBorder, RoundedCornerShape(10.dp))
                                    .padding(10.dp)
                            )
                        }

                        Column(modifier = Modifier.weight(1f)) {
                            Text("End Time", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                            Spacer(modifier = Modifier.height(4.dp))
                            BasicTextField(
                                value = editEndTime,
                                onValueChange = { editEndTime = it },
                                textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary, fontWeight = FontWeight.Medium),
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .background(Color(0xFFF8FAFC), RoundedCornerShape(10.dp))
                                    .border(1.dp, CardBorder, RoundedCornerShape(10.dp))
                                    .padding(10.dp)
                            )
                        }
                    }

                    // Free time toggle
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(Color(0xFFF8FAFC), RoundedCornerShape(12.dp))
                            .padding(horizontal = 12.dp, vertical = 6.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text("Is Free Time Block", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                            Text("Open personal time, won't show incomplete", fontSize = 10.sp, color = SubtitleGray)
                        }
                        Switch(
                            checked = editIsFreeTime,
                            onCheckedChange = { editIsFreeTime = it },
                            colors = SwitchDefaults.colors(
                                checkedThumbColor = Color.White,
                                checkedTrackColor = Color(0xFF10B981)
                            )
                        )
                    }

                    // Buttons: Cancel & Save
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .clickable {
                                    editingSlotIndex = null
                                    isAddingNewSlot = false
                                },
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFFF1F5F9)
                        ) {
                            Box(modifier = Modifier.padding(vertical = 12.dp), contentAlignment = Alignment.Center) {
                                Text("Cancel", color = TextSecondary, fontWeight = FontWeight.Medium, fontSize = 14.sp)
                            }
                        }

                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .clickable { saveSlotChanges() },
                            shape = RoundedCornerShape(12.dp),
                            color = CharcoalDark
                        ) {
                            Box(modifier = Modifier.padding(vertical = 12.dp), contentAlignment = Alignment.Center) {
                                Text("Save Slot", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                            }
                        }
                    }
                }
            }
        }
    }

    // Save Template Dialog
    if (isSaveTemplateDialogOpen) {
        Dialog(onDismissRequest = { isSaveTemplateDialogOpen = false }) {
            Surface(
                modifier = Modifier
                    .fillMaxWidth(0.95f)
                    .shadow(16.dp, RoundedCornerShape(24.dp)),
                shape = RoundedCornerShape(24.dp),
                color = Color.White
            ) {
                Column(
                    modifier = Modifier.padding(20.dp),
                    verticalArrangement = Arrangement.spacedBy(14.dp)
                ) {
                    Text("Save As Reusable Routine", fontSize = 17.sp, fontWeight = FontWeight.Bold, color = TextPrimary)

                    Column {
                        Text("Routine Name", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                        Spacer(modifier = Modifier.height(4.dp))
                        BasicTextField(
                            value = templateNameInput,
                            onValueChange = { templateNameInput = it },
                            textStyle = TextStyle(fontSize = 14.sp, color = TextPrimary),
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(Color(0xFFF8FAFC), RoundedCornerShape(10.dp))
                                .border(1.dp, CardBorder, RoundedCornerShape(10.dp))
                                .padding(12.dp),
                            decorationBox = { inner ->
                                if (templateNameInput.isEmpty()) Text("e.g. Weekday Study & Football", color = SubtitleGray, fontSize = 14.sp)
                                inner()
                            }
                        )
                    }

                    Column {
                        Text("Description", fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
                        Spacer(modifier = Modifier.height(4.dp))
                        BasicTextField(
                            value = templateDescInput,
                            onValueChange = { templateDescInput = it },
                            textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary),
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(Color(0xFFF8FAFC), RoundedCornerShape(10.dp))
                                .border(1.dp, CardBorder, RoundedCornerShape(10.dp))
                                .padding(12.dp)
                        )
                    }

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .clickable { isSaveTemplateDialogOpen = false },
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFFF1F5F9)
                        ) {
                            Box(modifier = Modifier.padding(vertical = 12.dp), contentAlignment = Alignment.Center) {
                                Text("Cancel", color = TextSecondary, fontWeight = FontWeight.Medium, fontSize = 14.sp)
                            }
                        }

                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .clickable {
                                    if (viewModel != null && templateNameInput.isNotBlank()) {
                                        val taskEntities = routineSlots.map { it.toTaskEntity("Template") }
                                        viewModel.saveRoutine(
                                            name = templateNameInput.trim(),
                                            description = templateDescInput.trim(),
                                            category = "Custom Routine",
                                            tasks = taskEntities
                                        )
                                    }
                                    isSaveTemplateDialogOpen = false
                                },
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFF7C3AED)
                        ) {
                            Box(modifier = Modifier.padding(vertical = 12.dp), contentAlignment = Alignment.Center) {
                                Text("Save Template", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                            }
                        }
                    }
                }
            }
        }
    }
}

/**
 * Dedicated Match Day Tab inside AddTaskScreen:
 * Configure Morning or Evening Football Match with quick timing and target day.
 */
@Composable
fun MatchDayConfigContent(
    viewModel: TaskViewModel?,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier
) {
    var matchTitle by remember { mutableStateOf("Morning Football Match ⚽") }
    var matchDesc by remember { mutableStateOf("Friendly football match & drills with friends on the pitch.") }
    var selectedTargetDay by remember { mutableStateOf("Today") }
    var matchTimeType by remember { mutableStateOf("Morning") } // Morning, Evening, Custom
    var matchStartTime by remember { mutableStateOf("06:30 AM") }
    var matchEndTime by remember { mutableStateOf("07:45 AM") }

    Column(
        modifier = modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = "Schedule Football Match",
            fontSize = 15.sp,
            fontWeight = FontWeight.Bold,
            color = TextPrimary
        )

        // Time Preset Options
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            val options = listOf(
                Triple("Morning", "🌅 Morning (6:30 AM)", Pair("06:30 AM", "07:45 AM")),
                Triple("Evening", "🌆 Evening (6:00 PM)", Pair("06:00 PM", "07:30 PM")),
                Triple("Custom", "⏱️ Custom Time", Pair("04:00 PM", "05:30 PM"))
            )
            options.forEach { (type, label, times) ->
                val isSelected = matchTimeType == type
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(RoundedCornerShape(12.dp))
                        .clickable {
                            matchTimeType = type
                            matchStartTime = times.first
                            matchEndTime = times.second
                            if (type == "Morning") {
                                matchTitle = "Morning Football Match ⚽"
                                matchDesc = "Morning friendly football match & drills with teammates on the field."
                            } else if (type == "Evening") {
                                matchTitle = "Evening Football Match ⚽"
                                matchDesc = "Evening football match with friends under the lights."
                            }
                        }
                        .testTag("match_type_$type"),
                    shape = RoundedCornerShape(12.dp),
                    color = if (isSelected) Color(0xFFECFDF5) else Color.White,
                    border = BorderStroke(1.2.dp, if (isSelected) Color(0xFF10B981) else CardBorder)
                ) {
                    Text(
                        text = label,
                        fontSize = 11.sp,
                        fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                        color = if (isSelected) Color(0xFF047857) else TextSecondary,
                        modifier = Modifier.padding(vertical = 10.dp, horizontal = 4.dp),
                        textAlign = androidx.compose.ui.text.style.TextAlign.Center
                    )
                }
            }
        }

        // Match Title Input
        Column {
            Text("Match Title", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
            Spacer(modifier = Modifier.height(6.dp))
            Surface(
                shape = RoundedCornerShape(14.dp),
                color = Color.White,
                border = BorderStroke(1.dp, CardBorder)
            ) {
                BasicTextField(
                    value = matchTitle,
                    onValueChange = { matchTitle = it },
                    textStyle = TextStyle(fontSize = 14.sp, color = TextPrimary, fontWeight = FontWeight.Medium),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(14.dp)
                        .testTag("match_title_input")
                )
            }
        }

        // Match Notes / Pitch
        Column {
            Text("Details / Pitch Location", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
            Spacer(modifier = Modifier.height(6.dp))
            Surface(
                shape = RoundedCornerShape(14.dp),
                color = Color.White,
                border = BorderStroke(1.dp, CardBorder)
            ) {
                BasicTextField(
                    value = matchDesc,
                    onValueChange = { matchDesc = it },
                    textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(14.dp)
                        .testTag("match_desc_input")
                )
            }
        }

        // Target Day Selector
        Column {
            Text("Target Day", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextPrimary)
            Spacer(modifier = Modifier.height(6.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                listOf("Today", "Tomorrow").forEach { day ->
                    val isSelected = selectedTargetDay.equals(day, ignoreCase = true)
                    Surface(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(12.dp))
                            .clickable { selectedTargetDay = day }
                            .testTag("match_day_$day"),
                        shape = RoundedCornerShape(12.dp),
                        color = if (isSelected) CharcoalDark else Color.White,
                        border = BorderStroke(1.dp, if (isSelected) CharcoalDark else CardBorder)
                    ) {
                        Text(
                            text = if (day == "Today") "☀️ Today" else "🌙 Tomorrow",
                            fontSize = 13.sp,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                            color = if (isSelected) Color.White else TextPrimary,
                            modifier = Modifier.padding(vertical = 12.dp),
                            textAlign = androidx.compose.ui.text.style.TextAlign.Center
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(10.dp))

        // Schedule Match Button
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .shadow(8.dp, CircleShape, spotColor = Color(0x3010B981))
                .clip(CircleShape)
                .clickable {
                    if (viewModel != null) {
                        val isMorning = matchTimeType == "Morning" || matchStartTime.contains("AM", ignoreCase = true)
                        viewModel.addQuickFootballMatch(isMorning, selectedTargetDay)
                        viewModel.closeAddTask()
                    } else {
                        onDismiss()
                    }
                }
                .testTag("schedule_match_button"),
            shape = CircleShape,
            color = Color(0xFF059669)
        ) {
            Box(
                modifier = Modifier.padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Schedule Football Match ⚽",
                    color = Color.White,
                    fontSize = 15.sp,
                    fontWeight = FontWeight.Bold
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
    }
}

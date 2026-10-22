package com.example.ui.screens

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.widget.Toast
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccessTime
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Folder
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.data.local.TaskEntity
import com.example.ui.components.AvatarStack
import com.example.ui.theme.AccentPurpleLight
import com.example.ui.theme.AccentPurpleText
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.LimeGreen
import com.example.ui.theme.PriorityHighDot
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun TaskDetailDialog(
    task: TaskEntity,
    startInEditMode: Boolean = false,
    onDismiss: () -> Unit,
    onToggleComplete: () -> Unit,
    onDelete: () -> Unit,
    onSaveEdit: (TaskEntity) -> Unit = {}
) {
    val context = LocalContext.current
    var isEditMode by remember { mutableStateOf(startInEditMode) }

    var editTitle by remember { mutableStateOf(task.title) }
    var editDescription by remember { mutableStateOf(task.description) }
    val initialStartDate = if (task.dateString.contains(" - ")) task.dateString.substringBefore(" - ").trim() else task.dateString
    val initialEndDate = if (task.dateString.contains(" - ")) task.dateString.substringAfter(" - ").trim() else task.dateString
    var editStartDate by remember { mutableStateOf(initialStartDate) }
    var editEndDate by remember { mutableStateOf(initialEndDate) }
    var editDateString by remember { mutableStateOf(task.dateString) }
    var editStartTime by remember { mutableStateOf(task.startTime) }
    var editEndTime by remember { mutableStateOf(task.endTime) }
    var editPriority by remember { mutableStateOf(task.priority) }
    var editProject by remember { mutableStateOf(task.project) }
    var editStatus by remember { mutableStateOf(task.status) }
    var editTags by remember { mutableStateOf(task.tags) }
    var editColorTheme by remember { mutableStateOf(task.colorTheme) }

    fun showStartDatePicker() {
        val cal = java.util.Calendar.getInstance()
        val picker = DatePickerDialog(
            context,
            { _, year, month, dayOfMonth ->
                val monthNames = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
                editStartDate = "${monthNames[month]} $dayOfMonth, $year"
                if (editEndDate == "Today" || editEndDate.isBlank()) {
                    editEndDate = editStartDate
                }
                editDateString = if (editStartDate == editEndDate || editEndDate.isBlank()) editStartDate else "$editStartDate - $editEndDate"
            },
            cal.get(java.util.Calendar.YEAR),
            cal.get(java.util.Calendar.MONTH),
            cal.get(java.util.Calendar.DAY_OF_MONTH)
        )
        picker.show()
    }

    fun showEndDatePicker() {
        val cal = java.util.Calendar.getInstance()
        val picker = DatePickerDialog(
            context,
            { _, year, month, dayOfMonth ->
                val monthNames = listOf("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
                editEndDate = "${monthNames[month]} $dayOfMonth, $year"
                editDateString = if (editStartDate == editEndDate || editEndDate.isBlank()) editStartDate else "$editStartDate - $editEndDate"
            },
            cal.get(java.util.Calendar.YEAR),
            cal.get(java.util.Calendar.MONTH),
            cal.get(java.util.Calendar.DAY_OF_MONTH)
        )
        picker.show()
    }

    fun showStartTimePicker() {
        val picker = TimePickerDialog(
            context,
            { _, hour, minute ->
                val amPm = if (hour < 12) "AM" else "PM"
                val h = if (hour % 12 == 0) 12 else hour % 12
                val m = if (minute < 10) "0$minute" else "$minute"
                editStartTime = "$h:$m $amPm"
            },
            10, 0, false
        )
        picker.show()
    }

    fun showEndTimePicker() {
        val picker = TimePickerDialog(
            context,
            { _, hour, minute ->
                val amPm = if (hour < 12) "AM" else "PM"
                val h = if (hour % 12 == 0) 12 else hour % 12
                val m = if (minute < 10) "0$minute" else "$minute"
                editEndTime = "$h:$m $amPm"
            },
            11, 30, false
        )
        picker.show()
    }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Surface(
            modifier = Modifier
                .fillMaxWidth(0.92f)
                .shadow(24.dp, RoundedCornerShape(28.dp), spotColor = Color(0x35000000))
                .clip(RoundedCornerShape(28.dp)),
            shape = RoundedCornerShape(28.dp),
            color = Color.White
        ) {
            Column(
                modifier = Modifier
                    .padding(24.dp)
                    .verticalScroll(rememberScrollState())
            ) {
                // Top Action Row
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Priority Pill
                    val currentOpt = taskImportanceOptions.find {
                        it.priorityKey.equals(if (isEditMode) editPriority else task.priority, ignoreCase = true)
                    }
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .clip(CircleShape)
                            .background(currentOpt?.cardBg ?: Color(0xFFFBF8F5))
                            .border(1.dp, currentOpt?.borderColor ?: CardBorder, CircleShape)
                            .padding(horizontal = 12.dp, vertical = 6.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(7.dp)
                                .clip(CircleShape)
                                .background(currentOpt?.dotColor ?: Color(0xFF0284C7))
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = if (isEditMode) "${currentOpt?.title ?: editPriority} Priority" else "${currentOpt?.title ?: task.priority} Priority",
                            color = currentOpt?.textColor ?: TextPrimary,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        // Edit Toggle Button
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(if (isEditMode) Color(0xFFDBEAFE) else Color(0xFFF3F4F6))
                                .clickable { isEditMode = !isEditMode }
                                .testTag("task_detail_edit_button"),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.Edit,
                                contentDescription = "Edit Task",
                                tint = if (isEditMode) Color(0xFF2563EB) else TextPrimary,
                                modifier = Modifier.size(17.dp)
                            )
                        }

                        // Delete Button
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(Color(0xFFFEE2E2))
                                .clickable { onDelete() }
                                .testTag("task_detail_delete_button"),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.Delete,
                                contentDescription = "Delete Task",
                                tint = Color(0xFFDC2626),
                                modifier = Modifier.size(18.dp)
                            )
                        }

                        // Close Button
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                                .background(Color(0xFFF3F4F6))
                                .clickable { onDismiss() }
                                .testTag("task_detail_close_button"),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.Close,
                                contentDescription = "Close",
                                tint = TextPrimary,
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                if (isEditMode) {
                    // EDIT MODE UI
                    Text(
                        text = "Task Title",
                        color = SubtitleGray,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Surface(
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(12.dp),
                        color = Color(0xFFF8FAFC),
                        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                    ) {
                        BasicTextField(
                            value = editTitle,
                            onValueChange = { editTitle = it },
                            textStyle = TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Bold, color = TextPrimary),
                            modifier = Modifier
                                .padding(12.dp)
                                .testTag("edit_task_title_input")
                        )
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    Text(
                        text = "Description / Notes",
                        color = SubtitleGray,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Surface(
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(12.dp),
                        color = Color(0xFFF8FAFC),
                        border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                    ) {
                        BasicTextField(
                            value = editDescription,
                            onValueChange = { editDescription = it },
                            textStyle = TextStyle(fontSize = 13.sp, color = TextSecondary),
                            minLines = 2,
                            modifier = Modifier
                                .padding(12.dp)
                                .testTag("edit_task_desc_input")
                        )
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    // Start Date & End Date Row
                    Text(
                        text = "Task Dates (Start & End)",
                        color = SubtitleGray,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        // Start Date Button
                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .clickable { showStartDatePicker() },
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFFF8FAFC),
                            border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 10.dp, vertical = 10.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(Icons.Outlined.CalendarToday, contentDescription = "Start Date", tint = Color(0xFF2563EB), modifier = Modifier.size(15.dp))
                                Spacer(modifier = Modifier.width(6.dp))
                                Column {
                                    Text("Start Date", color = SubtitleGray, fontSize = 9.sp, fontWeight = FontWeight.Medium)
                                    Text(editStartDate, fontSize = 12.sp, color = TextPrimary, fontWeight = FontWeight.Bold, maxLines = 1)
                                }
                            }
                        }

                        // End Date Button
                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(12.dp))
                                .clickable { showEndDatePicker() },
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFFF8FAFC),
                            border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 10.dp, vertical = 10.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(Icons.Outlined.CalendarToday, contentDescription = "End Date", tint = Color(0xFF2563EB), modifier = Modifier.size(15.dp))
                                Spacer(modifier = Modifier.width(6.dp))
                                Column {
                                    Text("End Date", color = SubtitleGray, fontSize = 9.sp, fontWeight = FontWeight.Medium)
                                    Text(editEndDate, fontSize = 12.sp, color = TextPrimary, fontWeight = FontWeight.Bold, maxLines = 1)
                                }
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(10.dp))

                    // Project / Location row
                    Column(modifier = Modifier.fillMaxWidth()) {
                        Text(
                            text = "Project / Category",
                            color = SubtitleGray,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Surface(
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(12.dp),
                            color = Color(0xFFF8FAFC),
                            border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                        ) {
                            BasicTextField(
                                value = editProject,
                                onValueChange = { editProject = it },
                                textStyle = TextStyle(fontSize = 13.sp, color = TextPrimary, fontWeight = FontWeight.Medium),
                                modifier = Modifier.padding(10.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    // Start & End Time Pickers
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text("Start Time", color = SubtitleGray, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                            Spacer(modifier = Modifier.height(4.dp))
                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable { showStartTimePicker() },
                                shape = RoundedCornerShape(12.dp),
                                color = Color(0xFFF8FAFC),
                                border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                            ) {
                                Row(
                                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 10.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(Icons.Filled.AccessTime, contentDescription = null, tint = Color(0xFF2563EB), modifier = Modifier.size(16.dp))
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text(editStartTime, fontSize = 13.sp, color = TextPrimary, fontWeight = FontWeight.Medium)
                                }
                            }
                        }

                        Column(modifier = Modifier.weight(1f)) {
                            Text("End Time", color = SubtitleGray, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                            Spacer(modifier = Modifier.height(4.dp))
                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable { showEndTimePicker() },
                                shape = RoundedCornerShape(12.dp),
                                color = Color(0xFFF8FAFC),
                                border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                            ) {
                                Row(
                                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 10.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(Icons.Filled.AccessTime, contentDescription = null, tint = Color(0xFF2563EB), modifier = Modifier.size(16.dp))
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text(editEndTime, fontSize = 13.sp, color = TextPrimary, fontWeight = FontWeight.Medium)
                                }
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    // Importance & Priority Level selector
                    Text("Importance & Priority", color = SubtitleGray, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                    Spacer(modifier = Modifier.height(6.dp))
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        verticalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        taskImportanceOptions.forEach { opt ->
                            val isSelected = editPriority.equals(opt.priorityKey, ignoreCase = true)
                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(12.dp))
                                    .clickable {
                                        editPriority = opt.priorityKey
                                        editColorTheme = opt.colorThemeKey
                                    },
                                shape = RoundedCornerShape(12.dp),
                                color = if (isSelected) opt.cardBg else Color(0xFFF8FAFC),
                                border = androidx.compose.foundation.BorderStroke(
                                    width = if (isSelected) 1.5.dp else 1.dp,
                                    color = if (isSelected) opt.accentColor else CardBorder
                                )
                            ) {
                                Column(modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp)) {
                                    Row(
                                        modifier = Modifier.fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Row(verticalAlignment = Alignment.CenterVertically) {
                                            Box(
                                                modifier = Modifier
                                                    .size(10.dp)
                                                    .clip(CircleShape)
                                                    .background(opt.dotColor)
                                            )
                                            Spacer(modifier = Modifier.width(8.dp))
                                            Text(
                                                text = opt.title,
                                                color = if (isSelected) opt.textColor else TextPrimary,
                                                fontSize = 13.sp,
                                                fontWeight = FontWeight.Bold
                                            )
                                        }
                                        if (isSelected) {
                                            Icon(
                                                imageVector = Icons.Default.Check,
                                                contentDescription = "Selected",
                                                tint = opt.accentColor,
                                                modifier = Modifier.size(14.dp)
                                            )
                                        }
                                    }
                                    Spacer(modifier = Modifier.height(2.dp))
                                    Text(
                                        text = opt.description,
                                        color = if (isSelected) opt.textColor.copy(alpha = 0.8f) else SubtitleGray,
                                        fontSize = 11.sp
                                    )
                                }
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    // Status selector pills
                    Text("Status", color = SubtitleGray, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        listOf("To Do", "In Progress", "In Review", "Done").forEach { st ->
                            val isSelected = editStatus.equals(st, ignoreCase = true)
                            Surface(
                                modifier = Modifier
                                    .weight(1f)
                                    .clip(CircleShape)
                                    .clickable {
                                        editStatus = st
                                    },
                                shape = CircleShape,
                                color = if (isSelected) CharcoalDark else Color(0xFFF1F5F9)
                            ) {
                                Box(modifier = Modifier.padding(vertical = 8.dp), contentAlignment = Alignment.Center) {
                                    Text(
                                        text = st,
                                        color = if (isSelected) Color.White else TextPrimary,
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.SemiBold,
                                        maxLines = 1
                                    )
                                }
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(20.dp))

                    // Save Changes Button (Working edit option!)
                    Surface(
                        modifier = Modifier
                            .fillMaxWidth()
                            .shadow(6.dp, CircleShape, spotColor = Color(0x20000000))
                            .clip(CircleShape)
                            .clickable {
                                val updated = task.copy(
                                    title = editTitle.ifBlank { task.title },
                                    description = editDescription,
                                    dateString = editDateString.ifBlank { task.dateString },
                                    startTime = editStartTime,
                                    endTime = editEndTime,
                                    priority = editPriority,
                                    project = editProject.ifBlank { task.project },
                                    status = editStatus,
                                    tags = editTags,
                                    isCompleted = editStatus.equals("Done", ignoreCase = true),
                                    colorTheme = editColorTheme
                                )
                                onSaveEdit(updated)
                                Toast.makeText(context, "Task updated successfully!", Toast.LENGTH_SHORT).show()
                                isEditMode = false
                            }
                            .testTag("save_edit_task_button"),
                        shape = CircleShape,
                        color = CharcoalDark
                    ) {
                        Box(
                            modifier = Modifier.padding(vertical = 14.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "Save Changes",
                                color = Color.White,
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                } else {
                    // VIEW MODE UI
                    // Task Title
                    Text(
                        text = task.title,
                        color = TextPrimary,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold,
                        lineHeight = 28.sp
                    )

                    if (task.description.isNotBlank()) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = task.description,
                            color = TextSecondary,
                            fontSize = 14.sp,
                            lineHeight = 20.sp
                        )
                    }

                    // Dynamic Progress Line for Task Detail
                    val (progressFraction, progressLabel) = com.example.ui.components.calculateDynamicTaskProgress(task)
                    val animatedProgress by animateFloatAsState(
                        targetValue = progressFraction,
                        animationSpec = tween(durationMillis = 600, easing = FastOutSlowInEasing),
                        label = "TaskDetailProgress_${task.id}"
                    )
                    Spacer(modifier = Modifier.height(14.dp))
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
                    LinearProgressIndicator(
                        progress = { animatedProgress },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(6.dp)
                            .clip(CircleShape),
                        color = if (task.isCompleted) Color(0xFF10B981) else Color(0xFF2563EB),
                        trackColor = Color(0xFFF1F5F9)
                    )

                    Spacer(modifier = Modifier.height(18.dp))

                    // Info Rows (Project & Date/Time)
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        // Project Pill
                        Surface(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(14.dp),
                            color = Color(0xFFF8F7F5),
                            border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 12.dp, vertical = 10.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Folder,
                                    contentDescription = null,
                                    tint = AccentPurpleText,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = task.project,
                                    color = TextPrimary,
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }

                        // Time Pill
                        Surface(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(14.dp),
                            color = Color(0xFFF8F7F5),
                            border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 12.dp, vertical = 10.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(
                                    imageVector = Icons.Outlined.Schedule,
                                    contentDescription = null,
                                    tint = SubtitleGray,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = "${task.startTime} - ${task.endTime}",
                                    color = TextPrimary,
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Medium
                                )
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Tags & Assignees Row
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Tags
                        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                            task.getTagList().take(3).forEach { tag ->
                                Surface(
                                    shape = CircleShape,
                                    color = AccentPurpleLight
                                ) {
                                    Text(
                                        text = tag,
                                        color = AccentPurpleText,
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.Medium,
                                        modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp)
                                    )
                                }
                            }
                        }

                        // Assignees
                        AvatarStack(count = task.assigneeCount, avatarSize = 24.dp)
                    }

                    Spacer(modifier = Modifier.height(20.dp))

                    // Edit Button Row
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        // Quick Edit Button
                        Surface(
                            modifier = Modifier
                                .weight(1f)
                                .clip(CircleShape)
                                .clickable { isEditMode = true }
                                .testTag("task_detail_quick_edit_button"),
                            shape = CircleShape,
                            color = Color(0xFFF1F5F9)
                        ) {
                            Row(
                                modifier = Modifier.padding(vertical = 12.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.Center
                            ) {
                                Icon(Icons.Default.Edit, contentDescription = null, tint = TextPrimary, modifier = Modifier.size(16.dp))
                                Spacer(modifier = Modifier.width(6.dp))
                                Text("Edit Details", color = TextPrimary, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                            }
                        }

                        // Mark Completed / Reopen Button
                        Surface(
                            modifier = Modifier
                                .weight(1.3f)
                                .shadow(6.dp, CircleShape, spotColor = Color(0x20000000))
                                .clip(CircleShape)
                                .clickable { onToggleComplete() }
                                .testTag("task_detail_toggle_button"),
                            shape = CircleShape,
                            color = if (task.isCompleted) LimeGreen else CharcoalDark
                        ) {
                            Box(
                                modifier = Modifier.padding(vertical = 12.dp),
                                contentAlignment = Alignment.Center
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        imageVector = Icons.Default.Check,
                                        contentDescription = null,
                                        tint = if (task.isCompleted) CharcoalDark else Color.White,
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text(
                                        text = if (task.isCompleted) "Completed" else "Complete",
                                        color = if (task.isCompleted) CharcoalDark else Color.White,
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
    }
}

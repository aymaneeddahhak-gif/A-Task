package com.example.ui.components

import androidx.compose.animation.AnimatedVisibility
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
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.rounded.Add
import androidx.compose.material.icons.rounded.AutoAwesome
import androidx.compose.material.icons.rounded.Check
import androidx.compose.material.icons.rounded.Close
import androidx.compose.material.icons.rounded.DeleteOutline
import androidx.compose.material.icons.rounded.FitnessCenter
import androidx.compose.material.icons.rounded.Refresh
import androidx.compose.material.icons.rounded.Schedule
import androidx.compose.material.icons.rounded.School
import androidx.compose.material.icons.rounded.SportsSoccer
import androidx.compose.material.icons.rounded.WbSunny
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
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
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.data.local.RoutineEntity
import com.example.ui.theme.AccentBlue
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary

@Composable
fun RoutineManagerDialog(
    routines: List<RoutineEntity>,
    onDismiss: () -> Unit,
    onApplyRoutine: (routine: RoutineEntity, targetDate: String) -> Unit,
    onSaveCurrentDayAsRoutine: (name: String, description: String, dateString: String) -> Unit,
    onDeleteRoutine: (routine: RoutineEntity) -> Unit,
    onAddQuickFootballMatch: (isMorning: Boolean, targetDate: String) -> Unit,
    onResetDefaultTimeline: () -> Unit
) {
    var selectedRoutineForApply by remember { mutableStateOf<RoutineEntity?>(null) }
    var isSaveMode by remember { mutableStateOf(false) }
    var routineNameInput by remember { mutableStateOf("") }
    var routineDescInput by remember { mutableStateOf("") }
    var selectedSaveSourceDay by remember { mutableStateOf("Today") }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Surface(
            modifier = Modifier
                .fillMaxWidth(0.94f)
                .padding(vertical = 24.dp)
                .testTag("routine_manager_dialog"),
            shape = RoundedCornerShape(28.dp),
            color = Color.White,
            border = androidx.compose.foundation.BorderStroke(1.2.dp, CardBorder)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(22.dp)
            ) {
                // Header Row
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(42.dp)
                                .clip(RoundedCornerShape(12.dp))
                                .background(Color(0xFFE0F2FE)),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Rounded.Schedule,
                                contentDescription = null,
                                tint = Color(0xFF0284C7),
                                modifier = Modifier.size(24.dp)
                            )
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Column {
                            Text(
                                text = "Routines for This Week",
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold,
                                color = TextPrimary
                            )
                            Text(
                                text = "Weekly schedule & productivity presets",
                                fontSize = 12.sp,
                                color = SubtitleGray
                            )
                        }
                    }

                    IconButton(
                        onClick = onDismiss,
                        modifier = Modifier.testTag("close_routine_dialog_button")
                    ) {
                        Icon(
                            imageVector = Icons.Rounded.Close,
                            contentDescription = "Close",
                            tint = CharcoalDark
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Action Bar (Save Day as Routine & Quick Match Buttons)
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // Save Day Button
                    Surface(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(14.dp))
                            .clickable { isSaveMode = !isSaveMode }
                            .testTag("toggle_save_routine_button"),
                        shape = RoundedCornerShape(14.dp),
                        color = if (isSaveMode) Color(0xFF0284C7) else Color(0xFFF1F5F9),
                        border = androidx.compose.foundation.BorderStroke(
                            1.dp,
                            if (isSaveMode) Color(0xFF0284C7) else Color(0xFFE2E8F0)
                        )
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 8.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Icon(
                                imageVector = if (isSaveMode) Icons.Rounded.Check else Icons.Rounded.Add,
                                contentDescription = null,
                                tint = if (isSaveMode) Color.White else Color(0xFF0F172A),
                                modifier = Modifier.size(15.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = if (isSaveMode) "Close Form" else "Save as Routine",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = if (isSaveMode) Color.White else Color(0xFF0F172A)
                            )
                        }
                    }

                    // Quick Match Button
                    Surface(
                        modifier = Modifier
                            .weight(1f)
                            .clip(RoundedCornerShape(14.dp))
                            .clickable {
                                onAddQuickFootballMatch(false, "Today")
                                onDismiss()
                            }
                            .testTag("add_evening_match_quick_button"),
                        shape = RoundedCornerShape(14.dp),
                        color = Color(0xFFECFDF5),
                        border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFA7F3D0))
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 8.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Icon(
                                imageVector = Icons.Rounded.SportsSoccer,
                                contentDescription = null,
                                tint = Color(0xFF059669),
                                modifier = Modifier.size(15.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = "+ Match (6 PM)",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = Color(0xFF065F46)
                            )
                        }
                    }
                }

                // Expandable Save Routine Form
                AnimatedVisibility(visible = isSaveMode) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 14.dp)
                            .clip(RoundedCornerShape(18.dp))
                            .background(Color(0xFFF8FAFC))
                            .border(1.dp, Color(0xFFE2E8F0), RoundedCornerShape(18.dp))
                            .padding(14.dp)
                    ) {
                        Text(
                            text = "Save Current Day as Routine",
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp,
                            color = TextPrimary
                        )
                        Spacer(modifier = Modifier.height(8.dp))

                        // Source Day Picker (Today or Tomorrow)
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            listOf("Today", "Tomorrow").forEach { day ->
                                val isSelected = selectedSaveSourceDay == day
                                Surface(
                                    modifier = Modifier
                                        .weight(1f)
                                        .clip(RoundedCornerShape(10.dp))
                                        .clickable { selectedSaveSourceDay = day },
                                    color = if (isSelected) Color(0xFF0284C7) else Color.White,
                                    border = androidx.compose.foundation.BorderStroke(
                                        1.dp,
                                        if (isSelected) Color(0xFF0284C7) else Color(0xFFCBD5E1)
                                    ),
                                    shape = RoundedCornerShape(10.dp)
                                ) {
                                    Text(
                                        text = "From $day",
                                        modifier = Modifier.padding(vertical = 6.dp),
                                        textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                                        fontSize = 12.sp,
                                        fontWeight = FontWeight.SemiBold,
                                        color = if (isSelected) Color.White else Color(0xFF334155)
                                    )
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(10.dp))

                        OutlinedTextField(
                            value = routineNameInput,
                            onValueChange = { routineNameInput = it },
                            placeholder = { Text("Routine Name (e.g. Exam Prep Day)", fontSize = 13.sp) },
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(12.dp)
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        OutlinedTextField(
                            value = routineDescInput,
                            onValueChange = { routineDescInput = it },
                            placeholder = { Text("Short description (optional)", fontSize = 13.sp) },
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(12.dp)
                        )

                        Spacer(modifier = Modifier.height(10.dp))

                        Button(
                            onClick = {
                                if (routineNameInput.isNotBlank()) {
                                    onSaveCurrentDayAsRoutine(
                                        routineNameInput.trim(),
                                        routineDescInput.trim(),
                                        selectedSaveSourceDay
                                    )
                                    routineNameInput = ""
                                    routineDescInput = ""
                                    isSaveMode = false
                                }
                            },
                            modifier = Modifier.fillMaxWidth().testTag("confirm_save_routine_button"),
                            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF0284C7)),
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Text("Save Routine Preset", fontWeight = FontWeight.Bold)
                        }
                    }
                }

                // If user selected a routine to apply, show quick target day selector
                AnimatedVisibility(visible = selectedRoutineForApply != null) {
                    val routine = selectedRoutineForApply
                    if (routine != null) {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(vertical = 12.dp)
                                .clip(RoundedCornerShape(18.dp))
                                .background(Color(0xFFEFF6FF))
                                .border(1.2.dp, Color(0xFF93C5FD), RoundedCornerShape(18.dp))
                                .padding(14.dp)
                        ) {
                            Text(
                                text = "Apply '${routine.name}'",
                                fontWeight = FontWeight.Bold,
                                fontSize = 14.sp,
                                color = Color(0xFF1E3A8A)
                            )
                            Text(
                                text = "Choose which day to populate with this routine:",
                                fontSize = 12.sp,
                                color = Color(0xFF3B82F6)
                            )

                            Spacer(modifier = Modifier.height(10.dp))

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                Button(
                                    onClick = {
                                        onApplyRoutine(routine, "Today")
                                        selectedRoutineForApply = null
                                    },
                                    modifier = Modifier.weight(1f).testTag("apply_to_today_button"),
                                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF0284C7)),
                                    shape = RoundedCornerShape(10.dp)
                                ) {
                                    Text("Apply to Today", fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }

                                Button(
                                    onClick = {
                                        onApplyRoutine(routine, "Tomorrow")
                                        selectedRoutineForApply = null
                                    },
                                    modifier = Modifier.weight(1f).testTag("apply_to_tomorrow_button"),
                                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2563EB)),
                                    shape = RoundedCornerShape(10.dp)
                                ) {
                                    Text("Apply to Tomorrow", fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                Text(
                    text = "Saved Routines (${routines.size})",
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Bold,
                    color = SubtitleGray
                )

                Spacer(modifier = Modifier.height(8.dp))

                // Routines List
                LazyColumn(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f, fill = false),
                    verticalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    items(routines, key = { it.id }) { routine ->
                        RoutineCardItem(
                            routine = routine,
                            onApplyClick = { selectedRoutineForApply = routine },
                            onDeleteClick = { onDeleteRoutine(routine) }
                        )
                    }
                }

                Spacer(modifier = Modifier.height(14.dp))

                // Bottom Reset / Match Presets
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Reset to This Week Routine",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF0284C7),
                        modifier = Modifier
                            .clickable {
                                onResetDefaultTimeline()
                                onDismiss()
                            }
                            .padding(4.dp)
                    )

                    OutlinedButton(
                        onClick = {
                            onAddQuickFootballMatch(true, "Today")
                            onDismiss()
                        },
                        shape = RoundedCornerShape(10.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Rounded.SportsSoccer,
                            contentDescription = null,
                            modifier = Modifier.size(14.dp),
                            tint = Color(0xFF0284C7)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("Morning Match", fontSize = 11.sp)
                    }
                }
            }
        }
    }
}

@Composable
private fun RoutineCardItem(
    routine: RoutineEntity,
    onApplyClick: () -> Unit,
    onDeleteClick: () -> Unit
) {
    val isSports = routine.name.contains("Football", ignoreCase = true) || routine.category.contains("Sports", ignoreCase = true)
    val isWeekend = routine.name.contains("Weekend", ignoreCase = true)

    Surface(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(18.dp)),
        shape = RoundedCornerShape(18.dp),
        color = if (isSports) Color(0xFFF0FDF4) else if (isWeekend) Color(0xFFFFFBEB) else Color(0xFFF8FAFC),
        border = androidx.compose.foundation.BorderStroke(
            1.dp,
            if (isSports) Color(0xFFBBF7D0) else if (isWeekend) Color(0xFFFDE68A) else Color(0xFFE2E8F0)
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(14.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Category Pill
                Box(
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(
                            if (isSports) Color(0xFFDCFCE7)
                            else if (isWeekend) Color(0xFFFEF3C7)
                            else Color(0xFFE0F2FE)
                        )
                        .padding(horizontal = 8.dp, vertical = 3.dp)
                ) {
                    Text(
                        text = routine.category,
                        fontSize = 10.sp,
                        fontWeight = FontWeight.Bold,
                        color = if (isSports) Color(0xFF166534) else if (isWeekend) Color(0xFF92400E) else Color(0xFF0369A1)
                    )
                }

                if (routine.id > 3) {
                    IconButton(
                        onClick = onDeleteClick,
                        modifier = Modifier.size(24.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Rounded.DeleteOutline,
                            contentDescription = "Delete",
                            tint = Color(0xFFEF4444),
                            modifier = Modifier.size(16.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(6.dp))

            Text(
                text = routine.name,
                fontSize = 15.sp,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            if (routine.description.isNotBlank()) {
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = routine.description,
                    fontSize = 12.sp,
                    color = Color(0xFF475569),
                    lineHeight = 16.sp
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Timeline summary badge & Apply Button
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = routine.itemsSummary,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF64748B)
                )

                Button(
                    onClick = onApplyClick,
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF0F172A)),
                    shape = RoundedCornerShape(10.dp),
                    contentPadding = androidx.compose.foundation.layout.PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                ) {
                    Text("Apply", fontSize = 11.sp, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.width(3.dp))
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowForward,
                        contentDescription = null,
                        modifier = Modifier.size(12.dp)
                    )
                }
            }
        }
    }
}

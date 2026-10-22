package com.example.ui.components

import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
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
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Folder
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.WarningAmber
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.ChatBubbleOutline
import androidx.compose.material.icons.outlined.Schedule
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Fill
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.local.TaskEntity
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import java.text.SimpleDateFormat
import java.util.Locale

/**
 * Visual Theme specification for the card design matching the user's reference image
 */
data class PlanCardTheme(
    val id: Int,
    val keyName: String,
    val displayName: String,
    val cardBg: Color,
    val chipBg: Color,
    val cardBorder: Color,
    val bannerGradientStart: Color,
    val bannerGradientEnd: Color,
    val doodleAccent1: Color,
    val doodleAccent2: Color,
    val doodleAccent3: Color,
    val statusPillBg: Color,
    val statusPillText: Color,
    val statusDotColor: Color,
    val defaultStatusText: String,
    val accentColor: Color,
    val themeType: PlanThemeType
)

enum class PlanThemeType {
    CRIMSON_RED,
    ICE_BLUE,
    WARM_PEACH,
    LAVENDER,
    MINT_SAGE,
    HONEY_YELLOW,
    ROSE_PINK
}

object PlanCardThemeCatalog {
    val themes = listOf(
        // 0. Crimson Red (Urgent / Critical Tasks - Rich, noticeable Red tone)
        PlanCardTheme(
            id = 0,
            keyName = "red",
            displayName = "Urgent Red",
            cardBg = Color(0xFFFFECEC),
            chipBg = Color(0xFFFED7D7),
            cardBorder = Color(0xFFFCA5A5),
            bannerGradientStart = Color(0xFFFFECEC),
            bannerGradientEnd = Color(0xFFFED0D0),
            doodleAccent1 = Color(0xFFEF4444),
            doodleAccent2 = Color(0xFFF87171),
            doodleAccent3 = Color(0xFFDC2626),
            statusPillBg = Color.White,
            statusPillText = Color(0xFFBE123C),
            statusDotColor = Color(0xFFE11D48),
            defaultStatusText = "Urgent",
            accentColor = Color(0xFFE11D48),
            themeType = PlanThemeType.CRIMSON_RED
        ),
        // 1. Soft Ice Blue (Normal / Routine Tasks)
        PlanCardTheme(
            id = 1,
            keyName = "blue",
            displayName = "Normal Blue",
            cardBg = Color(0xFFEBF5FF),
            chipBg = Color(0xFFD6EBFF),
            cardBorder = Color(0xFF93C5FD),
            bannerGradientStart = Color(0xFFEBF5FF),
            bannerGradientEnd = Color(0xFFD8ECFE),
            doodleAccent1 = Color(0xFF38BDF8),
            doodleAccent2 = Color(0xFF93C5FD),
            doodleAccent3 = Color(0xFF0284C7),
            statusPillBg = Color.White,
            statusPillText = Color(0xFF0369A1),
            statusDotColor = Color(0xFF0284C7),
            defaultStatusText = "Normal",
            accentColor = Color(0xFF0284C7),
            themeType = PlanThemeType.ICE_BLUE
        ),
        // 2. Warm Apricot / Peach (Important / High Priority Tasks)
        PlanCardTheme(
            id = 2,
            keyName = "peach",
            displayName = "Important Orange",
            cardBg = Color(0xFFFFF1E8),
            chipBg = Color(0xFFFFE0D0),
            cardBorder = Color(0xFFFDBA74),
            bannerGradientStart = Color(0xFFFFF1E8),
            bannerGradientEnd = Color(0xFFFFE2D4),
            doodleAccent1 = Color(0xFFFF8E72),
            doodleAccent2 = Color(0xFFFFC09F),
            doodleAccent3 = Color(0xFFEA580C),
            statusPillBg = Color.White,
            statusPillText = Color(0xFFC2410C),
            statusDotColor = Color(0xFFEA580C),
            defaultStatusText = "Important",
            accentColor = Color(0xFFEA580C),
            themeType = PlanThemeType.WARM_PEACH
        ),
        // 3. Soft Lavender / Lilac (Personal / Routine)
        PlanCardTheme(
            id = 3,
            keyName = "lavender",
            displayName = "Lavender",
            cardBg = Color(0xFFF5F0FF),
            chipBg = Color(0xFFEAE0FD),
            cardBorder = Color(0xFFC4B5FD),
            bannerGradientStart = Color(0xFFF5F0FF),
            bannerGradientEnd = Color(0xFFEDE4FE),
            doodleAccent1 = Color(0xFFA78BFA),
            doodleAccent2 = Color(0xFFC4B5FD),
            doodleAccent3 = Color(0xFF7C3AED),
            statusPillBg = Color.White,
            statusPillText = Color(0xFF6D28D9),
            statusDotColor = Color(0xFF7C3AED),
            defaultStatusText = "Routine",
            accentColor = Color(0xFF7C3AED),
            themeType = PlanThemeType.LAVENDER
        ),
        // 4. Fresh Mint / Sage (Low Priority Tasks)
        PlanCardTheme(
            id = 4,
            keyName = "mint",
            displayName = "Low Priority Mint",
            cardBg = Color(0xFFE6FAF6),
            chipBg = Color(0xFFCCFBF1),
            cardBorder = Color(0xFF5EEAD4),
            bannerGradientStart = Color(0xFFE6FAF6),
            bannerGradientEnd = Color(0xFFD3F8F1),
            doodleAccent1 = Color(0xFF34D399),
            doodleAccent2 = Color(0xFFA7F3D0),
            doodleAccent3 = Color(0xFF059669),
            statusPillBg = Color.White,
            statusPillText = Color(0xFF047857),
            statusDotColor = Color(0xFF059669),
            defaultStatusText = "Low Priority",
            accentColor = Color(0xFF059669),
            themeType = PlanThemeType.MINT_SAGE
        ),
        // 5. Honey Yellow (Routine / Habits)
        PlanCardTheme(
            id = 5,
            keyName = "yellow",
            displayName = "Honey Amber",
            cardBg = Color(0xFFFEFCE8),
            chipBg = Color(0xFFFEF08A),
            cardBorder = Color(0xFFFDE047),
            bannerGradientStart = Color(0xFFFEFCE8),
            bannerGradientEnd = Color(0xFFFEF6AA),
            doodleAccent1 = Color(0xFFFBBF24),
            doodleAccent2 = Color(0xFFFED7AA),
            doodleAccent3 = Color(0xFFD97706),
            statusPillBg = Color.White,
            statusPillText = Color(0xFFB45309),
            statusDotColor = Color(0xFFD97706),
            defaultStatusText = "Routine",
            accentColor = Color(0xFFD97706),
            themeType = PlanThemeType.HONEY_YELLOW
        ),
        // 6. Rose Pink (Creative / Habits)
        PlanCardTheme(
            id = 6,
            keyName = "pink",
            displayName = "Rose Pink",
            cardBg = Color(0xFFFDF2F8),
            chipBg = Color(0xFFFCE7F3),
            cardBorder = Color(0xFFF9A8D4),
            bannerGradientStart = Color(0xFFFDF2F8),
            bannerGradientEnd = Color(0xFFFCDDEC),
            doodleAccent1 = Color(0xFFF472B6),
            doodleAccent2 = Color(0xFFFBCFE8),
            doodleAccent3 = Color(0xFFDB2777),
            statusPillBg = Color.White,
            statusPillText = Color(0xFFBE185D),
            statusDotColor = Color(0xFFDB2777),
            defaultStatusText = "Habit",
            accentColor = Color(0xFFDB2777),
            themeType = PlanThemeType.ROSE_PINK
        )
    )

    fun getThemeForTask(task: TaskEntity): PlanCardTheme {
        val matchingKey = task.colorTheme.lowercase().trim()
        val foundByKey = themes.firstOrNull { it.keyName == matchingKey }
        if (foundByKey != null) return foundByKey

        // Fallback to priority matching
        when {
            task.priority.equals("Urgent", ignoreCase = true) -> return themes.first { it.keyName == "red" }
            task.priority.equals("High", ignoreCase = true) || task.priority.equals("Important", ignoreCase = true) -> return themes.first { it.keyName == "peach" }
            task.priority.equals("Medium", ignoreCase = true) || task.priority.equals("Normal", ignoreCase = true) -> return themes.first { it.keyName == "blue" }
            task.priority.equals("Low", ignoreCase = true) -> return themes.first { it.keyName == "mint" }
            task.priority.equals("Routine", ignoreCase = true) || task.priority.equals("Habit", ignoreCase = true) -> return themes.first { it.keyName == "lavender" }
        }

        val index = (Math.abs(task.id * 31 + task.title.hashCode())) % themes.size
        return themes[index]
    }
}

/**
 * Modern Pastel Plan & Task Card matching the user's reference image:
 * - Pastel Card Canvas background (Blue, Peach, Lavender, Mint, Yellow, Pink)
 * - Top illustrated playful doodle banner
 * - White status pill with colored indicator dot
 * - Avatar cluster stack
 * - High-contrast title and description
 * - Darker pastel metadata chips (Tags, Date, Project)
 * - Response progress indicator
 * - Dark "Edit >" pill button
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
fun FriendPlansTaskCard(
    task: TaskEntity,
    onTaskClick: () -> Unit,
    onEditClick: () -> Unit,
    onToggleComplete: () -> Unit,
    modifier: Modifier = Modifier
) {
    val theme = PlanCardThemeCatalog.getThemeForTask(task)
    val hasVoteStyle = (task.id % 2 != 0) || task.priority.equals("High", ignoreCase = true)

    // Clean task time for top banner badge
    val displayTime = when {
        task.startTime.isNotBlank() && task.endTime.isNotBlank() && task.startTime != task.endTime ->
            "${task.startTime} - ${task.endTime}"
        task.startTime.isNotBlank() -> task.startTime
        task.endTime.isNotBlank() -> task.endTime
        else -> "All Day"
    }.trim()

    // Duration in parentheses from title e.g. "Coffee Break (30 min)" or "Study & Revision (1:30)"
    val durationRegex = Regex("\\s*\\(([^)]+)\\)")
    val durationMatch = durationRegex.find(task.title)
    val extractedDuration = durationMatch?.groupValues?.getOrNull(1)?.trim()
    val displayTitle = if (durationMatch != null) {
        task.title.replace(durationMatch.value, "").trim()
    } else {
        task.title
    }

    val durationValue = if (!extractedDuration.isNullOrBlank()) {
        extractedDuration
    } else if (task.startTime.isNotBlank() && task.endTime.isNotBlank() && task.startTime != task.endTime) {
        calculateDuration(task.startTime, task.endTime).ifBlank { "30 min" }
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
    val formattedDuration = cleanDuration

    Surface(
        modifier = modifier
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(26.dp),
                spotColor = Color(0x18000000),
                ambientColor = Color(0x0A000000)
            )
            .clip(RoundedCornerShape(26.dp))
            .clickable { onTaskClick() }
            .testTag("task_item_card_${task.id}"),
        shape = RoundedCornerShape(26.dp),
        color = theme.cardBg,
        border = androidx.compose.foundation.BorderStroke(1.2.dp, theme.cardBorder)
    ) {
        Column(
            modifier = Modifier.fillMaxWidth()
        ) {
            // 1. TOP ILLUSTRATED DOODLE BANNER
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(62.dp)
            ) {
                Canvas(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(62.dp)
                ) {
                    drawIllustratedBanner(theme = theme)
                }

                // Overlay Badges: Top Left = Duration (e.g. 30 min), Top Right = Status Badge
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Top Left: Duration Badge (e.g. 30 min, no parentheses, no colons)
                    Surface(
                        shape = CircleShape,
                        color = Color.White.copy(alpha = 0.95f),
                        shadowElevation = 2.dp,
                        modifier = Modifier.testTag("task_duration_badge_${task.id}")
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 11.dp, vertical = 5.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Outlined.Schedule,
                                contentDescription = "Duration",
                                tint = theme.accentColor,
                                modifier = Modifier.size(12.dp)
                            )
                            Spacer(modifier = Modifier.width(5.dp))
                            Text(
                                text = cleanDuration,
                                color = Color(0xFF0F172A),
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }

                    // Top Right: Status Pill
                    val statusLabel = when {
                        task.isFreeTime -> "☕ Free Time"
                        task.isCompleted -> "Completed"
                        task.status.isNotBlank() && task.status != "To Do" -> task.status
                        task.priority.equals("High", ignoreCase = true) -> "Locked In"
                        task.hasMeeting -> "Team Meet"
                        else -> theme.defaultStatusText
                    }

                    Surface(
                        shape = CircleShape,
                        color = Color.White.copy(alpha = 0.95f),
                        shadowElevation = 2.dp
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 11.dp, vertical = 5.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(7.dp)
                                    .clip(CircleShape)
                                    .background(if (task.isCompleted) Color(0xFF10B981) else theme.statusDotColor)
                            )
                            Spacer(modifier = Modifier.width(6.dp))
                            Text(
                                text = statusLabel,
                                color = if (task.isCompleted) Color(0xFF047857) else theme.statusPillText,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }
                }
            }

            // 2. MAIN CARD CONTENT
            Column(
                modifier = Modifier.padding(start = 18.dp, end = 18.dp, top = 10.dp, bottom = 18.dp)
            ) {
                // Title (clean without parentheses duration)
                Text(
                    text = displayTitle,
                    color = if (task.isCompleted) SubtitleGray else Color(0xFF0F172A),
                    fontSize = 21.sp,
                    fontWeight = FontWeight.ExtraBold,
                    lineHeight = 26.sp,
                    textDecoration = if (task.isCompleted) TextDecoration.LineThrough else TextDecoration.None
                )

                // Subtitle / Description
                if (task.description.isNotBlank()) {
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = task.description,
                        color = Color(0xFF334155),
                        fontSize = 13.sp,
                        lineHeight = 18.sp,
                        maxLines = 2,
                        overflow = TextOverflow.Ellipsis
                    )
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Tag Chips Row (Darker pastel chips matching the reference image)
                FlowRow(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    // Render tags from task (e.g. Landing Page, Website, One Page)
                    val tagList = task.getTagList()
                    if (tagList.isNotEmpty()) {
                        tagList.take(3).forEach { tag ->
                            Surface(
                                shape = RoundedCornerShape(12.dp),
                                color = theme.chipBg
                            ) {
                                Text(
                                    text = tag,
                                    color = Color(0xFF0F172A),
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.SemiBold,
                                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
                                )
                            }
                        }
                    }

                    // Date / Time Chip
                    Surface(
                        shape = RoundedCornerShape(12.dp),
                        color = theme.chipBg
                    ) {
                        Row(
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Outlined.CalendarToday,
                                contentDescription = null,
                                tint = Color(0xFF1E293B),
                                modifier = Modifier.size(12.dp)
                            )
                            Spacer(modifier = Modifier.width(5.dp))
                            Text(
                                text = task.dateString.ifBlank { "Today" },
                                color = Color(0xFF0F172A),
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }
                    }

                    // Project Chip
                    if (task.project.isNotBlank()) {
                        Surface(
                            shape = RoundedCornerShape(12.dp),
                            color = theme.chipBg
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp),
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Icon(
                                    imageVector = if (task.hasMeeting) Icons.Filled.LocationOn else Icons.Filled.Folder,
                                    contentDescription = null,
                                    tint = Color(0xFF1E293B),
                                    modifier = Modifier.size(12.dp)
                                )
                                Spacer(modifier = Modifier.width(5.dp))
                                Text(
                                    text = task.project,
                                    color = Color(0xFF0F172A),
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Medium,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                            }
                        }
                    }
                }

                // 3. CARD FOOTER: Dynamic Progress Line on every task
                Spacer(modifier = Modifier.height(14.dp))

                val (progressFraction, progressLabel) = calculateDynamicTaskProgress(task)
                val animatedProgress by animateFloatAsState(
                    targetValue = progressFraction,
                    animationSpec = tween(durationMillis = 600, easing = FastOutSlowInEasing),
                    label = "TaskProgressAnimation_${task.id}"
                )

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(6.dp)
                                .clip(CircleShape)
                                .background(if (task.isCompleted) Color(0xFF10B981) else theme.accentColor)
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = if (task.isCompleted) "TASK COMPLETED" else "TASK PROGRESS",
                            color = Color(0xFF475569),
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 0.5.sp
                        )
                    }
                    Text(
                        text = progressLabel,
                        color = if (task.isCompleted) Color(0xFF047857) else Color(0xFF0F172A),
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
                    color = if (task.isCompleted) Color(0xFF10B981) else theme.accentColor,
                    trackColor = theme.chipBg
                )

                Spacer(modifier = Modifier.height(14.dp))

                // Bottom Row: Task Time (without parentheses) + Duration
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            imageVector = if (task.isCompleted) Icons.Default.Check else Icons.Outlined.Schedule,
                            contentDescription = "Task Time",
                            tint = if (task.isCompleted) Color(0xFF10B981) else theme.accentColor,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = displayTime,
                            color = Color(0xFF1E293B),
                            fontSize = 12.5.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                    }

                    // Duration badge in footer (NO parentheses, NO colons)
                    Surface(
                        shape = CircleShape,
                        color = theme.chipBg,
                        modifier = Modifier
                            .clip(CircleShape)
                            .clickable { onEditClick() }
                            .testTag("task_edit_button_${task.id}")
                    ) {
                        Text(
                            text = cleanDuration,
                            color = Color(0xFF334155),
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp)
                        )
                    }
                }
            }
        }
    }
}

/**
 * Draws creative playful illustrated doodles on the top header canvas
 */
private fun DrawScope.drawIllustratedBanner(theme: PlanCardTheme) {
    val w = size.width
    val h = size.height

    // Background Gradient Header
    drawRect(
        brush = Brush.verticalGradient(
            colors = listOf(theme.bannerGradientEnd, theme.bannerGradientStart)
        ),
        size = Size(w, h)
    )

    when (theme.themeType) {
        PlanThemeType.CRIMSON_RED -> {
            // Urgent flame / exclamation energetic circles & pulse
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.5f),
                radius = 16.dp.toPx(),
                center = Offset(w * 0.48f, h * 0.45f)
            )
            drawCircle(
                color = theme.doodleAccent1.copy(alpha = 0.6f),
                radius = 10.dp.toPx(),
                center = Offset(w * 0.56f, h * 0.35f)
            )
            drawStar(
                center = Offset(w * 0.42f, h * 0.55f),
                radius = 8.dp.toPx(),
                color = theme.doodleAccent3.copy(alpha = 0.8f)
            )
        }
        PlanThemeType.ICE_BLUE -> {
            // Clouds, Starbursts, Browser windows & Sparkles
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.5f),
                radius = 16.dp.toPx(),
                center = Offset(w * 0.45f, h * 0.45f)
            )
            drawCircle(
                color = theme.doodleAccent1.copy(alpha = 0.6f),
                radius = 11.dp.toPx(),
                center = Offset(w * 0.52f, h * 0.35f)
            )
            // Little sparkle
            drawStar(
                center = Offset(w * 0.62f, h * 0.5f),
                radius = 8.dp.toPx(),
                color = theme.doodleAccent3.copy(alpha = 0.65f)
            )
            // Curved wave line
            val path = Path().apply {
                moveTo(w * 0.35f, h * 0.75f)
                quadraticTo(w * 0.5f, h * 0.5f, w * 0.65f, h * 0.75f)
            }
            drawPath(path, color = theme.doodleAccent3.copy(alpha = 0.4f), style = Stroke(width = 2.dp.toPx()))
        }
        PlanThemeType.WARM_PEACH -> {
            // Sunburst, geometric pill & warm flame
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.55f),
                radius = 15.dp.toPx(),
                center = Offset(w * 0.50f, h * 0.4f)
            )
            // Pill capsule
            drawRoundRect(
                color = theme.doodleAccent1.copy(alpha = 0.6f),
                topLeft = Offset(w * 0.55f, h * 0.3f),
                size = Size(24.dp.toPx(), 12.dp.toPx()),
                cornerRadius = CornerRadius(6.dp.toPx())
            )
            drawStar(
                center = Offset(w * 0.42f, h * 0.6f),
                radius = 7.dp.toPx(),
                color = theme.doodleAccent3.copy(alpha = 0.7f)
            )
        }
        PlanThemeType.LAVENDER -> {
            // Crescent moon, starry orbits & rings
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.5f),
                radius = 18.dp.toPx(),
                center = Offset(w * 0.52f, h * 0.5f)
            )
            drawCircle(
                color = theme.doodleAccent3.copy(alpha = 0.4f),
                radius = 12.dp.toPx(),
                center = Offset(w * 0.42f, h * 0.35f),
                style = Stroke(width = 2.dp.toPx())
            )
            drawStar(
                center = Offset(w * 0.60f, h * 0.35f),
                radius = 8.dp.toPx(),
                color = theme.doodleAccent3.copy(alpha = 0.75f)
            )
        }
        PlanThemeType.MINT_SAGE -> {
            // Botanical leaves, clover, circle dots
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.6f),
                radius = 14.dp.toPx(),
                center = Offset(w * 0.48f, h * 0.45f)
            )
            drawCircle(
                color = theme.doodleAccent1.copy(alpha = 0.6f),
                radius = 9.dp.toPx(),
                center = Offset(w * 0.56f, h * 0.35f)
            )
            val path = Path().apply {
                moveTo(w * 0.38f, h * 0.65f)
                quadraticTo(w * 0.45f, h * 0.3f, w * 0.52f, h * 0.65f)
            }
            drawPath(path, color = theme.doodleAccent3.copy(alpha = 0.5f), style = Stroke(width = 2.dp.toPx()))
        }
        PlanThemeType.HONEY_YELLOW -> {
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.6f),
                radius = 16.dp.toPx(),
                center = Offset(w * 0.50f, h * 0.45f)
            )
            drawStar(
                center = Offset(w * 0.58f, h * 0.4f),
                radius = 9.dp.toPx(),
                color = theme.doodleAccent3.copy(alpha = 0.7f)
            )
        }
        PlanThemeType.ROSE_PINK -> {
            drawCircle(
                color = theme.doodleAccent2.copy(alpha = 0.5f),
                radius = 15.dp.toPx(),
                center = Offset(w * 0.48f, h * 0.45f)
            )
            drawStar(
                center = Offset(w * 0.58f, h * 0.35f),
                radius = 8.dp.toPx(),
                color = theme.doodleAccent3.copy(alpha = 0.7f)
            )
        }
    }
}

/**
 * 4-pointed sparkle star helper
 */
private fun DrawScope.drawStar(center: Offset, radius: Float, color: Color) {
    val path = Path().apply {
        moveTo(center.x, center.y - radius)
        quadraticTo(center.x, center.y, center.x + radius, center.y)
        quadraticTo(center.x, center.y, center.x, center.y + radius)
        quadraticTo(center.x, center.y, center.x - radius, center.y)
        quadraticTo(center.x, center.y, center.x, center.y - radius)
        close()
    }
    drawPath(path, color = color, style = Fill)
}

/**
 * Calculates human readable duration between two formatted time strings like "03:30 PM" and "04:00 PM"
 */
private fun calculateDuration(startTime: String, endTime: String): String {
    return try {
        val format = SimpleDateFormat("hh:mm a", Locale.US)
        val start = format.parse(startTime) ?: return "30 min"
        val end = format.parse(endTime) ?: return "30 min"
        var diffMinutes = ((end.time - start.time) / (1000 * 60)).toInt()
        if (diffMinutes <= 0) diffMinutes += 24 * 60
        val hours = diffMinutes / 60
        val minutes = diffMinutes % 60
        when {
            hours > 0 && minutes > 0 -> "${hours}h ${minutes}m"
            hours > 0 -> "${hours}h"
            else -> "${minutes} min"
        }
    } catch (_: Exception) {
        "30 min"
    }
}

/**
 * Calculates dynamic progress percentage and status label based on real-time task state and schedule.
 */
fun calculateDynamicTaskProgress(task: TaskEntity): Pair<Float, String> {
    if (task.isCompleted || task.status.equals("Done", ignoreCase = true)) {
        return 1.0f to "100% DONE"
    }

    // 1. Multi-day date span calculation (e.g. "Oct 6 - Oct 10")
    if (task.dateString.contains(" - ")) {
        try {
            val parts = task.dateString.split(" - ").map { it.trim() }
            if (parts.size == 2) {
                val startPart = parts[0]
                val endPart = parts[1]
                val formats = listOf(
                    SimpleDateFormat("MMM d, yyyy", Locale.US),
                    SimpleDateFormat("MMM d", Locale.US),
                    SimpleDateFormat("yyyy-MM-dd", Locale.US),
                    SimpleDateFormat("EEE, MMM d", Locale.US)
                )
                var pStart: java.util.Date? = null
                var pEnd: java.util.Date? = null
                for (fmt in formats) {
                    if (pStart == null) try { pStart = fmt.parse(startPart) } catch (_: Exception) {}
                    if (pEnd == null) try { pEnd = fmt.parse(endPart) } catch (_: Exception) {}
                }
                if (pStart != null && pEnd != null) {
                    val now = java.util.Date()
                    if (now.after(pEnd)) {
                        return 0.85f to "85% OVERDUE"
                    } else if (now.before(pStart)) {
                        return 0.20f to "20% SCHEDULED"
                    } else {
                        val total = (pEnd.time - pStart.time).coerceAtLeast(1)
                        val elapsed = (now.time - pStart.time).coerceAtLeast(0)
                        val fraction = (elapsed.toFloat() / total.toFloat()).coerceIn(0.15f, 0.95f)
                        val pct = (fraction * 100).toInt()
                        return fraction to "$pct% IN PROGRESS"
                    }
                }
            }
        } catch (_: Exception) {
            // fallback to daily time
        }
    }

    // 2. Intra-day time calculation
    if (task.startTime.isNotBlank() && task.endTime.isNotBlank() && task.startTime != task.endTime) {
        try {
            val format = SimpleDateFormat("hh:mm a", Locale.US)
            val start = format.parse(task.startTime)
            val end = format.parse(task.endTime)
            if (start != null && end != null) {
                val cal = java.util.Calendar.getInstance()
                val nowMinutes = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + cal.get(java.util.Calendar.MINUTE)

                val startCal = java.util.Calendar.getInstance().apply { time = start }
                val startMinutes = startCal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + startCal.get(java.util.Calendar.MINUTE)

                val endCal = java.util.Calendar.getInstance().apply { time = end }
                var endMinutes = endCal.get(java.util.Calendar.HOUR_OF_DAY) * 60 + endCal.get(java.util.Calendar.MINUTE)
                if (endMinutes <= startMinutes) {
                    endMinutes += 24 * 60
                }

                if (nowMinutes in startMinutes..endMinutes) {
                    val total = (endMinutes - startMinutes).toFloat()
                    val elapsed = (nowMinutes - startMinutes).toFloat()
                    val fraction = (elapsed / total).coerceIn(0.15f, 0.95f)
                    val pct = (fraction * 100).toInt()
                    return fraction to "$pct% ACTIVE NOW"
                } else if (nowMinutes > endMinutes) {
                    return 0.85f to "85% OVERDUE"
                } else {
                    val initialFraction = when {
                        task.status.equals("In Progress", ignoreCase = true) -> 0.40f
                        task.priority.equals("High", ignoreCase = true) -> 0.30f
                        task.priority.equals("Urgent", ignoreCase = true) -> 0.40f
                        else -> 0.20f
                    }
                    val pct = (initialFraction * 100).toInt()
                    return initialFraction to "$pct% SCHEDULED"
                }
            }
        } catch (_: Exception) {
            // fallback
        }
    }

    // 3. Fallback based on status & priority
    val fraction = when {
        task.status.equals("In Progress", ignoreCase = true) -> 0.50f
        task.status.equals("In Review", ignoreCase = true) -> 0.85f
        task.priority.equals("High", ignoreCase = true) || task.priority.equals("Urgent", ignoreCase = true) -> 0.35f
        else -> 0.20f
    }
    val pct = (fraction * 100).toInt()
    return fraction to "$pct% IN PROGRESS"
}


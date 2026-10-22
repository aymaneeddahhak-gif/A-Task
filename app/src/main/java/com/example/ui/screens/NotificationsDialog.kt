package com.example.ui.screens

import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AccountBalanceWallet
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Alarm
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.BatteryFull
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Devices
import androidx.compose.material.icons.filled.DoneAll
import androidx.compose.material.icons.filled.Percent
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material.icons.filled.SignalCellularAlt
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.TaskAlt
import androidx.compose.material.icons.filled.Timer
import androidx.compose.material.icons.filled.TrendingUp
import androidx.compose.material.icons.filled.Wifi
import androidx.compose.material.icons.outlined.DeleteOutline
import androidx.compose.material.icons.rounded.AddCircle
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.example.R

data class AppNotificationItem(
    val id: String,
    val title: String,
    val description: String = "",
    val timeAgo: String,
    val isRead: Boolean = false,
    val type: NotificationType,
    val section: String = "Today",
    val avatarRes: Int? = null,
    val hasBadge: Boolean = true,
    val taskId: Int? = null,
    val actionRoute: String? = null
)

enum class NotificationType(
    val icon: ImageVector,
    val iconColor: Color,
    val iconBgColor: Color,
    val badgeIcon: ImageVector,
    val badgeColor: Color
) {
    TASK_ACHIEVED(
        icon = Icons.Default.TaskAlt,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Check,
        badgeColor = Color(0xFF10B981)
    ),
    UPCOMING_TASK(
        icon = Icons.AutoMirrored.Filled.Send,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.AutoMirrored.Filled.ArrowForward,
        badgeColor = Color(0xFF0284C7)
    ),
    ROUTINE_SUGGESTION(
        icon = Icons.Default.AutoAwesome,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Add,
        badgeColor = Color(0xFF0EA5E9)
    ),
    BEST_DAY_INSIGHT(
        icon = Icons.Default.Star,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Star,
        badgeColor = Color(0xFFF59E0B)
    ),
    PRODUCTIVITY_SUMMARY(
        icon = Icons.Default.TrendingUp,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Check,
        badgeColor = Color(0xFF64748B)
    ),
    SECURITY_LOGIN(
        icon = Icons.Default.Devices,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.ArrowDownward,
        badgeColor = Color(0xFF64748B)
    ),
    TASK_FINISHED(
        icon = Icons.Default.TaskAlt,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Check,
        badgeColor = Color(0xFF10B981)
    ),
    NEW_TASK_CREATED(
        icon = Icons.Rounded.AddCircle,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.AutoAwesome,
        badgeColor = Color(0xFF0284C7)
    ),
    DEADLINE_WARNING(
        icon = Icons.Default.Timer,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Alarm,
        badgeColor = Color(0xFFEF4444)
    ),
    REMINDER(
        icon = Icons.Default.Schedule,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Schedule,
        badgeColor = Color(0xFFF59E0B)
    ),
    PAYMENT_TRANSFER(
        icon = Icons.Default.Person,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.ArrowUpward,
        badgeColor = Color(0xFF10B981)
    ),
    WALLET_ALERT(
        icon = Icons.Default.AccountBalanceWallet,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Add,
        badgeColor = Color(0xFF0EA5E9)
    ),
    DISCOUNT_PROMO(
        icon = Icons.Default.Percent,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Check,
        badgeColor = Color(0xFF64748B)
    ),
    LOAN_DEADLINE(
        icon = Icons.AutoMirrored.Filled.Send,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.AutoMirrored.Filled.ArrowForward,
        badgeColor = Color(0xFF0284C7)
    ),
    FEATURE_STAR(
        icon = Icons.Default.Star,
        iconColor = Color(0xFF64748B),
        iconBgColor = Color(0xFFE2E8F0),
        badgeIcon = Icons.Default.Star,
        badgeColor = Color(0xFFF59E0B)
    )
}

/**
 * Modern Notifications View strictly designed from the Paytee Financial Management App case study reference image:
 * - Top soft warm blush/peach gradient header
 * - 9:41 Status Bar with cellular, wifi, and battery indicators
 * - Bold "Notifications" headline
 * - Centered floating white container card with 28.dp rounded corners
 * - Grouped sections: "Today", "Tommorrow" / "Yesterday", "Tuesday"
 * - Profile avatar / rounded icon with small bottom-right mini badge
 * - High-contrast titles and subtle timestamps
 * - Subtle thin dividers between sections
 */
@Composable
fun NotificationsDialog(
    isPushEnabled: Boolean,
    notifications: List<AppNotificationItem>,
    onDismiss: () -> Unit,
    onEnablePushNotifications: () -> Unit,
    onMarkAllAsRead: () -> Unit,
    onClearAll: () -> Unit,
    onItemClick: (AppNotificationItem) -> Unit,
    onRemoveItem: (String) -> Unit
) {
    val context = LocalContext.current

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(
            usePlatformDefaultWidth = false,
            decorFitsSystemWindows = false
        )
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.verticalGradient(
                        0.0f to Color(0xFFFBECE9),
                        0.22f to Color(0xFFFDF4F2),
                        0.50f to Color(0xFFFBFBFD),
                        1.0f to Color(0xFFF5F6F8)
                    )
                )
                .statusBarsPadding()
                .navigationBarsPadding()
        ) {
            Column(
                modifier = Modifier.fillMaxSize()
            ) {
                // 1. Status Bar Mock (9:41, Cellular, Wifi, Battery) matching reference image
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 26.dp, vertical = 10.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "9:41",
                        color = Color(0xFF0F172A),
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold
                    )

                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.SignalCellularAlt,
                            contentDescription = null,
                            tint = Color(0xFF0F172A),
                            modifier = Modifier.size(16.dp)
                        )
                        Icon(
                            imageVector = Icons.Default.Wifi,
                            contentDescription = null,
                            tint = Color(0xFF0F172A),
                            modifier = Modifier.size(16.dp)
                        )
                        Icon(
                            imageVector = Icons.Default.BatteryFull,
                            contentDescription = null,
                            tint = Color(0xFF0F172A),
                            modifier = Modifier.size(18.dp)
                        )
                    }
                }

                // 2. Headline: "Notifications" + Subtle Dismiss Icon
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 24.dp, end = 20.dp, top = 8.dp, bottom = 12.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Notifications",
                        color = Color(0xFF0F172A),
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold
                    )

                    // Close Button
                    Surface(
                        modifier = Modifier
                            .size(36.dp)
                            .clip(CircleShape)
                            .clickable { onDismiss() }
                            .testTag("notification_close_button"),
                        shape = CircleShape,
                        color = Color.White.copy(alpha = 0.85f),
                        shadowElevation = 2.dp
                    ) {
                        Box(contentAlignment = Alignment.Center) {
                            Icon(
                                imageVector = Icons.Default.Close,
                                contentDescription = "Close",
                                tint = Color(0xFF475569),
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }

                // 3. Main Floating Notification Card (White Container with 28.dp rounded corners)
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(horizontal = 18.dp, vertical = 6.dp)
                        .shadow(
                            elevation = 14.dp,
                            shape = RoundedCornerShape(28.dp),
                            spotColor = Color(0x18000000),
                            ambientColor = Color(0x0C000000)
                        )
                        .testTag("notifications_card"),
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    val groupedSections = remember(notifications) {
                        if (notifications.isEmpty()) {
                            emptyMap()
                        } else {
                            notifications
                                .filter { notif ->
                                    !notif.section.contains("Tomorrow", ignoreCase = true) &&
                                    !notif.section.contains("Tommorrow", ignoreCase = true) &&
                                    !notif.title.contains("Tomorrow", ignoreCase = true)
                                }
                                .groupBy { it.section.ifBlank { "Today" } }
                        }
                    }

                    if (notifications.isEmpty()) {
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .padding(32.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                Box(
                                    modifier = Modifier
                                        .size(64.dp)
                                        .clip(CircleShape)
                                        .background(Color(0xFFF1F5F9)),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.TaskAlt,
                                        contentDescription = null,
                                        tint = Color(0xFF94A3B8),
                                        modifier = Modifier.size(32.dp)
                                    )
                                }
                                Spacer(modifier = Modifier.height(16.dp))
                                Text(
                                    text = "All Caught Up!",
                                    color = Color(0xFF0F172A),
                                    fontSize = 17.sp,
                                    fontWeight = FontWeight.Bold
                                )
                                Spacer(modifier = Modifier.height(4.dp))
                                Text(
                                    text = "You have no unread notifications.",
                                    color = Color(0xFF64748B),
                                    fontSize = 13.sp
                                )
                            }
                        }
                    } else {
                        LazyColumn(
                            modifier = Modifier
                                .fillMaxSize()
                                .padding(horizontal = 20.dp, vertical = 22.dp)
                        ) {
                            val sectionList = groupedSections.entries.toList()
                            sectionList.forEachIndexed { sectionIndex, (sectionTitle, sectionItems) ->
                                item(key = "header_$sectionTitle") {
                                    Text(
                                        text = sectionTitle,
                                        color = Color(0xFF0F172A),
                                        fontSize = 13.5.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(bottom = 14.dp, top = if (sectionIndex > 0) 4.dp else 0.dp)
                                    )
                                }

                                items(
                                    count = sectionItems.size,
                                    key = { i -> sectionItems[i].id }
                                ) { index ->
                                    val item = sectionItems[index]
                                    NotificationRowItem(
                                        item = item,
                                        onClick = { onItemClick(item) },
                                        onRemove = { onRemoveItem(item.id) }
                                    )

                                    if (index < sectionItems.size - 1) {
                                        Spacer(modifier = Modifier.height(18.dp))
                                    }
                                }

                                if (sectionIndex < sectionList.size - 1) {
                                    item(key = "divider_$sectionTitle") {
                                        Spacer(modifier = Modifier.height(18.dp))
                                        HorizontalDivider(
                                            color = Color(0xFFF1F5F9),
                                            thickness = 1.dp
                                        )
                                        Spacer(modifier = Modifier.height(14.dp))
                                    }
                                }
                            }

                            // Bottom Controls: Mark All as Read / Clear All
                            item(key = "bottom_controls") {
                                Spacer(modifier = Modifier.height(24.dp))
                                HorizontalDivider(
                                    color = Color(0xFFF1F5F9),
                                    thickness = 1.dp
                                )
                                Spacer(modifier = Modifier.height(14.dp))

                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Surface(
                                        shape = RoundedCornerShape(12.dp),
                                        color = Color(0xFFF8FAFC),
                                        border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFE2E8F0)),
                                        modifier = Modifier
                                            .clip(RoundedCornerShape(12.dp))
                                            .clickable {
                                                onMarkAllAsRead()
                                                Toast.makeText(context, "All marked as read", Toast.LENGTH_SHORT).show()
                                            }
                                    ) {
                                        Row(
                                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 7.dp),
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Icon(
                                                imageVector = Icons.Default.DoneAll,
                                                contentDescription = null,
                                                tint = Color(0xFF475569),
                                                modifier = Modifier.size(14.dp)
                                            )
                                            Spacer(modifier = Modifier.width(6.dp))
                                            Text(
                                                text = "Mark all read",
                                                color = Color(0xFF475569),
                                                fontSize = 12.sp,
                                                fontWeight = FontWeight.SemiBold
                                            )
                                        }
                                    }

                                    Surface(
                                        shape = RoundedCornerShape(12.dp),
                                        color = Color(0xFFFEF2F2),
                                        border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFFEE2E2)),
                                        modifier = Modifier
                                            .clip(RoundedCornerShape(12.dp))
                                            .clickable {
                                                onClearAll()
                                                Toast.makeText(context, "All cleared", Toast.LENGTH_SHORT).show()
                                            }
                                    ) {
                                        Row(
                                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 7.dp),
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Icon(
                                                imageVector = Icons.Outlined.DeleteOutline,
                                                contentDescription = null,
                                                tint = Color(0xFFDC2626),
                                                modifier = Modifier.size(14.dp)
                                            )
                                            Spacer(modifier = Modifier.width(6.dp))
                                            Text(
                                                text = "Clear all",
                                                color = Color(0xFFDC2626),
                                                fontSize = 12.sp,
                                                fontWeight = FontWeight.SemiBold
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))
            }
        }
    }
}

/**
 * Single item row matching Paytee screenshot:
 * - 42.dp Round Avatar / Icon container with bottom-right mini circular badge
 * - High contrast title
 * - Subtitle / time ago text
 */
@Composable
private fun NotificationRowItem(
    item: AppNotificationItem,
    onClick: () -> Unit,
    onRemove: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .testTag("notification_item_${item.id}"),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Big Icon (Clean, centered, without any little badge icon)
        if (item.avatarRes != null) {
            Image(
                painter = painterResource(id = item.avatarRes),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
            )
        } else {
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(item.type.iconBgColor),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = item.type.icon,
                    contentDescription = null,
                    tint = item.type.iconColor,
                    modifier = Modifier.size(22.dp)
                )
            }
        }

        Spacer(modifier = Modifier.width(14.dp))

        // Title and Subtitle
        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = item.title,
                color = Color(0xFF0F172A),
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold,
                lineHeight = 19.sp
            )

            Spacer(modifier = Modifier.height(3.dp))

            Text(
                text = item.timeAgo,
                color = Color(0xFF94A3B8),
                fontSize = 12.sp,
                fontWeight = FontWeight.Normal
            )
        }
    }
}

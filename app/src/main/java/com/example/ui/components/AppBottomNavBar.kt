package com.example.ui.components

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.PersonOutline
import androidx.compose.material.icons.filled.ShowChart
import androidx.compose.material.icons.filled.SmartToy
import androidx.compose.material.icons.outlined.Checklist
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.PersonOutline
import androidx.compose.material.icons.outlined.SmartToy
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.theme.CharcoalDark

enum class NavigationTab(
    val title: String,
    val selectedIcon: ImageVector,
    val unselectedIcon: ImageVector,
    val testTag: String
) {
    HOME("Home", Icons.Filled.Home, Icons.Outlined.Home, "nav_tab_home"),
    CALENDAR("Tasks", Icons.Filled.ShowChart, Icons.Outlined.Checklist, "nav_tab_tasks"),
    CHATBOT("AI Bot", Icons.Filled.SmartToy, Icons.Outlined.SmartToy, "nav_tab_chatbot"),
    PROFILE("Profile", Icons.Filled.PersonOutline, Icons.Outlined.PersonOutline, "nav_tab_profile"),
    PROJECTS("Docs", Icons.Filled.SmartToy, Icons.Outlined.SmartToy, "nav_tab_projects") // Kept in enum for route navigation from top doc button
}

@Composable
fun AppBottomNavBar(
    selectedTab: NavigationTab,
    onTabSelected: (NavigationTab) -> Unit,
    onAddClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxWidth()
            .navigationBarsPadding()
            .padding(start = 16.dp, end = 16.dp, bottom = 14.dp, top = 4.dp),
        contentAlignment = Alignment.Center
    ) {
        // Unified Floating Pill Dock (Action-Driven Iconly Design)
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .shadow(
                    elevation = 20.dp,
                    shape = RoundedCornerShape(36.dp),
                    spotColor = Color(0x22000000),
                    ambientColor = Color(0x10000000)
                ),
            shape = RoundedCornerShape(36.dp),
            color = Color.White.copy(alpha = 0.98f),
            border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFF1F1ED))
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 8.dp, vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Left Navigation Icons Group (Doc icon removed from bottom bar)
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    val visibleTabs = listOf(
                        NavigationTab.HOME,
                        NavigationTab.CALENDAR,
                        NavigationTab.CHATBOT,
                        NavigationTab.PROFILE
                    )

                    visibleTabs.forEach { tab ->
                        val isSelected = tab == selectedTab
                        val interactionSource = remember { MutableInteractionSource() }

                        val iconColor by animateColorAsState(
                            targetValue = if (isSelected) Color.White else Color(0xFF9E9E9E),
                            animationSpec = tween(200),
                            label = "navIconColor"
                        )

                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .clip(RoundedCornerShape(14.dp))
                                .background(if (isSelected) CharcoalDark else Color.Transparent)
                                .clickable(
                                    interactionSource = interactionSource,
                                    indication = null
                                ) { onTabSelected(tab) }
                                .testTag(tab.testTag),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = if (isSelected) tab.selectedIcon else tab.unselectedIcon,
                                contentDescription = tab.title,
                                tint = iconColor,
                                modifier = Modifier.size(20.dp)
                            )
                        }
                    }
                }

                // Right Bold Action Button: Neon Lime/Yellow Capsule with "New" + "+" in Black Circle
                Surface(
                    modifier = Modifier
                        .clip(CircleShape)
                        .clickable { onAddClick() }
                        .shadow(8.dp, CircleShape, spotColor = Color(0x40D4FA37))
                        .testTag("nav_action_new_button"),
                    shape = CircleShape,
                    color = Color(0xFFE5FC48) // Neon energetic lime-yellow
                ) {
                    Row(
                        modifier = Modifier
                            .background(
                                Brush.horizontalGradient(
                                    listOf(
                                        Color(0xFFF1FF68),
                                        Color(0xFFE2FB3E)
                                    )
                                )
                            )
                            .padding(start = 16.dp, end = 4.dp, top = 4.dp, bottom = 4.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Text(
                            text = "New",
                            color = Color(0xFF161616),
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 0.2.sp
                        )

                        Spacer(modifier = Modifier.width(10.dp))

                        // Inner Black Circle with '+' Icon
                        Box(
                            modifier = Modifier
                                .size(34.dp)
                                .clip(CircleShape)
                                .background(Color(0xFF141414)),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.Add,
                                contentDescription = "New Task",
                                tint = Color.White,
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }
            }
        }
    }
}

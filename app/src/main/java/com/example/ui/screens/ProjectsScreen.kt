package com.example.ui.screens

import androidx.compose.foundation.background
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
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Code
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Storage
import androidx.compose.material.icons.outlined.Build
import androidx.compose.material.icons.outlined.SmartToy
import androidx.compose.material.icons.outlined.Speed
import androidx.compose.material.icons.outlined.TouchApp
import androidx.compose.material3.Divider
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.theme.CardBorder
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.viewmodel.TaskViewModel

data class TechSection(
    val category: String,
    val icon: ImageVector,
    val items: List<TechItem>
)

data class TechItem(
    val name: String,
    val description: String,
    val versionOrType: String
)

@Composable
fun ProjectsScreen(
    viewModel: TaskViewModel,
    modifier: Modifier = Modifier
) {
    val techSections = listOf(
        TechSection(
            category = "Core Language & Runtime",
            icon = Icons.Default.Code,
            items = listOf(
                TechItem("Kotlin", "Primary programming language for Android development", "Kotlin 2.0+"),
                TechItem("Kotlin Coroutines & Flow", "Asynchronous concurrency and reactive StateFlow streaming", "kotlinx.coroutines"),
                TechItem("Java 11 Target", "Java standard runtime compatibility", "JDK 11 / Android SDK 36")
            )
        ),
        TechSection(
            category = "UI Framework & Design",
            icon = Icons.Outlined.TouchApp,
            items = listOf(
                TechItem("Jetpack Compose", "Modern declarative UI toolkit for native Android interfaces", "Compose BOM"),
                TechItem("Material Design 3 (M3)", "Material 3 theming, color schemes, typography, and interactive components", "androidx.compose.material3"),
                TechItem("Material Icons Extended", "Comprehensive icon sets for task statuses, meetings, and categories", "Icons.Filled / Outlined"),
                TechItem("Edge-to-Edge Support", "Immersive status bar and navigation bar padding", "enableEdgeToEdge")
            )
        ),
        TechSection(
            category = "Architecture & State Management",
            icon = Icons.Outlined.Speed,
            items = listOf(
                TechItem("MVVM Architecture", "Model-View-ViewModel design pattern separating business logic from UI", "Architecture"),
                TechItem("AndroidX ViewModel", "Lifecycle-aware state holder preserving UI state", "lifecycle-viewmodel-compose"),
                TechItem("StateFlow & Lifecycle", "Lifecycle-safe UI state collection", "collectAsStateWithLifecycle")
            )
        ),
        TechSection(
            category = "Local Database & Storage",
            icon = Icons.Default.Storage,
            items = listOf(
                TechItem("Room Database", "SQLite object mapping layer for local offline task persistence", "androidx.room"),
                TechItem("Room KSP Compiler", "Kotlin Symbol Processing for compile-time DAO verification", "ksp compiler"),
                TechItem("Room DAO & Entities", "Reactive task queries returning Flow<List<TaskEntity>>", "SQLite DB")
            )
        ),
        TechSection(
            category = "Networking & AI Integration",
            icon = Icons.Outlined.SmartToy,
            items = listOf(
                TechItem("Google Gemini API", "Server-side and client AI models for task intelligence and assistance", "Firebase AI / Gemini"),
                TechItem("Retrofit 2 & OkHttp 3", "Type-safe HTTP client and logging interceptors for REST APIs", "Retrofit 2.x"),
                TechItem("Moshi JSON", "Fast JSON parsing and Kotlin code generation", "Moshi Kotlin")
            )
        ),
        TechSection(
            category = "Build System & Testing",
            icon = Icons.Outlined.Build,
            items = listOf(
                TechItem("Gradle (Kotlin DSL)", "Modular build configuration with Version Catalogs (libs.versions.toml)", "build.gradle.kts"),
                TechItem("KSP (Kotlin Symbol Processing)", "High-performance annotation processing for Room and Moshi", "devtools.ksp"),
                TechItem("Robolectric & Roborazzi", "Local JVM testing and screenshot verification", "JUnit4 / Roborazzi"),
                TechItem("Secrets Gradle Plugin", "Secure environment variable (.env) injection into BuildConfig", "secrets-gradle-plugin")
            )
        )
    )

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .statusBarsPadding()
            .padding(horizontal = 20.dp),
        contentPadding = PaddingValues(top = 16.dp, bottom = 110.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        // Page Title & Header
        item {
            Column {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(38.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(Color(0xFFEFF6FF)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Description,
                            contentDescription = "Documentation",
                            tint = Color(0xFF0284C7),
                            modifier = Modifier.size(22.dp)
                        )
                    }
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(
                        text = "App Documentation",
                        color = TextPrimary,
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold
                    )
                }

                Spacer(modifier = Modifier.height(6.dp))

                Text(
                    text = "Complete list of technologies, frameworks, and architectural components powering this application.",
                    color = SubtitleGray,
                    fontSize = 14.sp,
                    lineHeight = 20.sp
                )
            }
        }

        // Summary Quick Badges
        item {
            Surface(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                color = Color(0xFFF8FAFC),
                border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "Quick Summary",
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Bold,
                        color = CharcoalDark
                    )
                    Spacer(modifier = Modifier.height(10.dp))
                    val badges = listOf(
                        "Kotlin", "Jetpack Compose", "Material 3", "Room Database",
                        "Coroutines / Flow", "MVVM", "Gemini API", "Retrofit", "Gradle KTS"
                    )
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        // Wrap badges into rows or simple display
                        Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                badges.take(4).forEach { badge ->
                                    TechBadge(text = badge)
                                }
                            }
                            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                badges.drop(4).forEach { badge ->
                                    TechBadge(text = badge)
                                }
                            }
                        }
                    }
                }
            }
        }

        // Technology Sections
        items(techSections) { section ->
            Column(
                modifier = Modifier.fillMaxWidth()
            ) {
                // Section Title
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.padding(bottom = 10.dp)
                ) {
                    Icon(
                        imageVector = section.icon,
                        contentDescription = null,
                        tint = CharcoalDark,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = section.category,
                        color = TextPrimary,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                }

                // Section Items Card
                Surface(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(16.dp),
                    color = Color.White,
                    border = androidx.compose.foundation.BorderStroke(1.dp, CardBorder)
                ) {
                    Column(
                        modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)
                    ) {
                        section.items.forEachIndexed { index, item ->
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 10.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.Top
                            ) {
                                Column(modifier = Modifier.weight(1f)) {
                                    Text(
                                        text = item.name,
                                        color = TextPrimary,
                                        fontSize = 14.sp,
                                        fontWeight = FontWeight.SemiBold
                                    )
                                    Spacer(modifier = Modifier.height(2.dp))
                                    Text(
                                        text = item.description,
                                        color = SubtitleGray,
                                        fontSize = 12.sp,
                                        lineHeight = 16.sp
                                    )
                                }

                                Spacer(modifier = Modifier.width(12.dp))

                                Surface(
                                    shape = RoundedCornerShape(6.dp),
                                    color = Color(0xFFF1F5F9)
                                ) {
                                    Text(
                                        text = item.versionOrType,
                                        color = Color(0xFF475569),
                                        fontSize = 11.sp,
                                        fontFamily = FontFamily.Monospace,
                                        fontWeight = FontWeight.Medium,
                                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                                    )
                                }
                            }

                            if (index < section.items.size - 1) {
                                HorizontalDivider(
                                    color = Color(0xFFF1F5F9),
                                    thickness = 1.dp
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun TechBadge(text: String) {
    Surface(
        shape = RoundedCornerShape(8.dp),
        color = Color(0xFFE2E8F0)
    ) {
        Text(
            text = text,
            color = Color(0xFF1E293B),
            fontSize = 11.sp,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
        )
    }
}

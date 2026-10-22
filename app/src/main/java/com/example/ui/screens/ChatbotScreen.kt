package com.example.ui.screens

import android.speech.tts.TextToSpeech
import android.widget.Toast
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
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
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.ChatBubbleOutline
import androidx.compose.material.icons.filled.Checklist
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.FavoriteBorder
import androidx.compose.material.icons.filled.GraphicEq
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.RocketLaunch
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VolumeUp
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.Dashboard
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.R
import com.example.ui.theme.CharcoalDark
import com.example.ui.theme.SubtitleGray
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.viewmodel.TaskViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Locale

enum class ChatbotViewMode {
    MASCOT_SHOWCASE, // Left Screen: 3D Companion with Audio & Chat actions
    CREATE_PROMPT_SCREEN // Right Screen: Clean Task Planner with Auto-Writing & Speech
}

enum class ChatMode {
    CREATE,
    TEMPLATES
}

data class AiChatMessage(
    val id: String = java.util.UUID.randomUUID().toString(),
    val isFromUser: Boolean,
    val text: String,
    val suggestedTaskTitle: String? = null,
    val suggestedTime: String? = null,
    val suggestedPriority: String? = null,
    val suggestedProject: String? = null,
    val isAddedToSchedule: Boolean = false
)

@Composable
fun ChatbotScreen(
    viewModel: TaskViewModel,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()

    var viewMode by remember { mutableStateOf(ChatbotViewMode.MASCOT_SHOWCASE) }
    var selectedTabMode by remember { mutableStateOf(ChatMode.CREATE) }
    var promptInput by remember { mutableStateOf("") }
    var isLiked by remember { mutableStateOf(false) }
    var likeCount by remember { mutableIntStateOf(585) }

    var isSpeaking by remember { mutableStateOf(false) }
    var typingJob by remember { mutableStateOf<Job?>(null) }

    // Audio Text-to-Speech Engine
    val ttsInstance = remember { mutableStateOf<TextToSpeech?>(null) }

    DisposableEffect(context) {
        val tts = TextToSpeech(context) { status ->
            if (status == TextToSpeech.SUCCESS) {
                ttsInstance.value?.language = Locale.US
            }
        }
        ttsInstance.value = tts
        onDispose {
            tts.stop()
            tts.shutdown()
        }
    }

    val taskVoicePrompts = listOf(
        "Plan a high-priority UI design sprint for client demo and review.",
        "Schedule full-stack API optimization and database indexing tasks.",
        "Create a 4-step daily developer routine with code review and testing.",
        "Organize mobile app release launch checklist with QA verification."
    )
    var promptIndex by remember { mutableIntStateOf(0) }

    // Helper: Trigger Audio Talk + Auto-Writing
    fun startAudioTalkAndAutoTyping(customText: String? = null) {
        val speechText = customText ?: taskVoicePrompts[promptIndex % taskVoicePrompts.size]
        promptIndex++

        viewMode = ChatbotViewMode.CREATE_PROMPT_SCREEN
        isSpeaking = true
        promptInput = ""

        // Speak aloud
        ttsInstance.value?.speak(speechText, TextToSpeech.QUEUE_FLUSH, null, "AI_TASK_TALK")

        // Real-time animated auto-writing
        typingJob?.cancel()
        typingJob = coroutineScope.launch {
            for (i in 1..speechText.length) {
                promptInput = speechText.substring(0, i)
                delay(28)
            }
            delay(1200)
            isSpeaking = false
        }
    }

    // Helper: Open Write Mode (No auto-talk, ready for manual keyboard input)
    fun openManualWriteMode() {
        ttsInstance.value?.stop()
        typingJob?.cancel()
        isSpeaking = false
        promptInput = ""
        viewMode = ChatbotViewMode.CREATE_PROMPT_SCREEN
    }

    val messages = remember {
        mutableStateListOf(
            AiChatMessage(
                isFromUser = false,
                text = "Hey Aymane! I'm your AED Task Planning AI. Describe any sprint, task, or deadline and I'll generate a ready-to-use schedule for you!",
                suggestedTaskTitle = "UI Component Design System",
                suggestedTime = "11:00 AM - 12:30 PM",
                suggestedPriority = "High",
                suggestedProject = "Website Redesign"
            )
        )
    }

    AnimatedContent(
        targetState = viewMode,
        transitionSpec = {
            if (targetState == ChatbotViewMode.CREATE_PROMPT_SCREEN) {
                (slideInHorizontally { width -> width / 3 } + fadeIn())
                    .togetherWith(slideOutHorizontally { width -> -width / 3 } + fadeOut())
            } else {
                (slideInHorizontally { width -> -width / 3 } + fadeIn())
                    .togetherWith(slideOutHorizontally { width -> width / 3 } + fadeOut())
            }
        },
        label = "ChatbotViewTransition"
    ) { mode ->
        when (mode) {
            ChatbotViewMode.MASCOT_SHOWCASE -> {
                // SCREEN 1: Left Mascot Screen (Features Audio Button & Chat/Write Button)
                MascotShowcaseScreen(
                    onBackClick = onBackClick,
                    onPlayAudioClick = { startAudioTalkAndAutoTyping() },
                    onOpenChatClick = { openManualWriteMode() },
                    isLiked = isLiked,
                    likeCount = likeCount,
                    onLikeToggle = {
                        isLiked = !isLiked
                        likeCount += if (isLiked) 1 else -1
                    },
                    modifier = modifier
                )
            }

            ChatbotViewMode.CREATE_PROMPT_SCREEN -> {
                // SCREEN 2: Right Task Planner Screen (100% Task Management, No Media Tools)
                CreatePromptScreen(
                    viewModel = viewModel,
                    onBackClick = {
                        ttsInstance.value?.stop()
                        typingJob?.cancel()
                        isSpeaking = false
                        viewMode = ChatbotViewMode.MASCOT_SHOWCASE
                    },
                    promptInput = promptInput,
                    onPromptChange = { promptInput = it },
                    isSpeaking = isSpeaking,
                    onTriggerVoiceTalk = { startAudioTalkAndAutoTyping() },
                    onStopVoice = {
                        ttsInstance.value?.stop()
                        typingJob?.cancel()
                        isSpeaking = false
                    },
                    selectedMode = selectedTabMode,
                    onModeChange = { selectedTabMode = it },
                    messages = messages,
                    onSendMessage = { text ->
                        if (text.isNotBlank()) {
                            messages.add(AiChatMessage(isFromUser = true, text = text))
                            promptInput = ""

                            val generatedTitle = text.take(28).capitalizeWords()
                            messages.add(
                                AiChatMessage(
                                    isFromUser = false,
                                    text = "✨ Task scheduled! I've structured '$text' into an actionable sprint item. Tap below to commit it directly to your task database.",
                                    suggestedTaskTitle = if (generatedTitle.length > 5) generatedTitle else "Development Sprint Task",
                                    suggestedTime = "02:00 PM - 03:30 PM",
                                    suggestedPriority = "High",
                                    suggestedProject = "Project Delivery"
                                )
                            )
                        }
                    },
                    onSurpriseClick = { startAudioTalkAndAutoTyping() },
                    modifier = modifier
                )
            }
        }
    }
}

/**
 * SCREEN 1: 3D Mascot Showcase (Left Screen from Reference)
 */
@Composable
private fun MascotShowcaseScreen(
    onBackClick: () -> Unit,
    onPlayAudioClick: () -> Unit,
    onOpenChatClick: () -> Unit,
    isLiked: Boolean,
    likeCount: Int,
    onLikeToggle: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val infiniteTransition = rememberInfiniteTransition(label = "audioPulse")
    val pulseScale by infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = 1.14f,
        animationSpec = infiniteRepeatable(
            animation = tween(1200, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "pulseScale"
    )

    Box(
        modifier = modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF81B6FF),
                        Color(0xFF98C7FF),
                        Color(0xFFB5DCFF),
                        Color(0xFFD6ECFF),
                        Color(0xFFF1F8FF)
                    )
                )
            )
            .statusBarsPadding()
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(bottom = 90.dp)
        ) {
            // 1. Top Bar: Left Avatar, Right Notifications & Write Button
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Left User Avatar (Aymane)
                Box(
                    modifier = Modifier
                        .size(42.dp)
                        .clip(CircleShape)
                        .background(Color.White.copy(alpha = 0.9f))
                        .clickable { onBackClick() },
                    contentAlignment = Alignment.Center
                ) {
                    Image(
                        painter = painterResource(id = R.drawable.img_aymane_avatar),
                        contentDescription = "User Avatar",
                        modifier = Modifier
                            .size(38.dp)
                            .clip(CircleShape),
                        contentScale = ContentScale.Crop
                    )
                }

                // Right Actions: Notification Bell + Quick Write Button
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    Box(
                        modifier = Modifier
                            .size(40.dp)
                            .clip(CircleShape)
                            .background(Color.White.copy(alpha = 0.85f))
                            .clickable {
                                Toast.makeText(context, "Task Notifications Active", Toast.LENGTH_SHORT).show()
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Notifications,
                            contentDescription = "Notifications",
                            tint = Color(0xFF1E293B),
                            modifier = Modifier.size(18.dp)
                        )
                    }

                    Box(
                        modifier = Modifier
                            .size(40.dp)
                            .clip(CircleShape)
                            .background(Color.White.copy(alpha = 0.85f))
                            .clickable { onOpenChatClick() }
                            .testTag("mascot_top_write_button"),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Edit,
                            contentDescription = "Write Task",
                            tint = Color(0xFF1E293B),
                            modifier = Modifier.size(18.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(4.dp))

            // 2. Full 3D Companion Mascot Card (Matching Left Screen)
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .padding(horizontal = 18.dp, vertical = 6.dp)
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxSize()
                        .shadow(24.dp, RoundedCornerShape(36.dp), spotColor = Color(0x352563EB)),
                    shape = RoundedCornerShape(36.dp),
                    color = Color(0xFF4C9AFF)
                ) {
                    Box(modifier = Modifier.fillMaxSize()) {
                        // Fluffy Mascot Graphic
                        Image(
                            painter = painterResource(id = R.drawable.img_ai_mascot),
                            contentDescription = "3D AI Companion Mascot",
                            modifier = Modifier
                                .fillMaxSize()
                                .clip(RoundedCornerShape(36.dp)),
                            contentScale = ContentScale.Crop
                        )

                        // Top Card Header: Avatar + Creator Tag + Eye & Menu
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(18.dp),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier
                                    .clip(CircleShape)
                                    .background(Color.Black.copy(alpha = 0.2f))
                                    .padding(horizontal = 8.dp, vertical = 4.dp)
                            ) {
                                Image(
                                    painter = painterResource(id = R.drawable.img_aymane_avatar),
                                    contentDescription = null,
                                    modifier = Modifier
                                        .size(28.dp)
                                        .clip(CircleShape),
                                    contentScale = ContentScale.Crop
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Column {
                                    Text(
                                        text = "AED Task Assistant",
                                        color = Color.White,
                                        fontSize = 12.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                    Text(
                                        text = "@AED.Developer",
                                        color = Color.White.copy(alpha = 0.85f),
                                        fontSize = 10.sp
                                    )
                                }
                            }

                            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                Box(
                                    modifier = Modifier
                                        .size(34.dp)
                                        .clip(CircleShape)
                                        .background(Color.White.copy(alpha = 0.25f)),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.Visibility,
                                        contentDescription = "View",
                                        tint = Color.White,
                                        modifier = Modifier.size(16.dp)
                                    )
                                }
                                Box(
                                    modifier = Modifier
                                        .size(34.dp)
                                        .clip(CircleShape)
                                        .background(Color.White.copy(alpha = 0.25f)),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.MoreVert,
                                        contentDescription = "More",
                                        tint = Color.White,
                                        modifier = Modifier.size(16.dp)
                                    )
                                }
                            }
                        }

                        // Center Translucent Audio / Play Button (Option 1: Audio Talk)
                        Box(
                            modifier = Modifier
                                .align(Alignment.Center)
                                .size(64.dp)
                                .scale(pulseScale)
                                .clip(CircleShape)
                                .background(Color.White.copy(alpha = 0.45f))
                                .clickable { onPlayAudioClick() }
                                .testTag("mascot_audio_play_button"),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.PlayArrow,
                                contentDescription = "Play Voice AI & Auto-Write",
                                tint = Color.White,
                                modifier = Modifier.size(36.dp)
                            )
                        }

                        // Bottom Frosted Stats Bar: Tasks, Share, Likes, Chat
                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .align(Alignment.BottomCenter)
                                .padding(16.dp),
                            shape = CircleShape,
                            color = Color.Black.copy(alpha = 0.28f),
                            border = androidx.compose.foundation.BorderStroke(1.dp, Color.White.copy(alpha = 0.35f))
                        ) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(horizontal = 16.dp, vertical = 8.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                // Tasks Stat
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        imageVector = Icons.Default.Checklist,
                                        contentDescription = null,
                                        tint = Color.White,
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text("31K", color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }

                                // Share Stat
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        imageVector = Icons.Default.Share,
                                        contentDescription = null,
                                        tint = Color.White,
                                        modifier = Modifier.size(15.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text("143", color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }

                                // Likes Stat (Toggleable)
                                Row(
                                    verticalAlignment = Alignment.CenterVertically,
                                    modifier = Modifier.clickable { onLikeToggle() }
                                ) {
                                    Icon(
                                        imageVector = if (isLiked) Icons.Default.Favorite else Icons.Default.FavoriteBorder,
                                        contentDescription = "Like",
                                        tint = if (isLiked) Color(0xFFFF4848) else Color.White,
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text("$likeCount", color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }

                                // Chat / Write Option (Option 2: Direct Write)
                                Row(
                                    verticalAlignment = Alignment.CenterVertically,
                                    modifier = Modifier
                                        .clickable { onOpenChatClick() }
                                        .testTag("mascot_chat_write_button")
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.ChatBubbleOutline,
                                        contentDescription = "Write Task",
                                        tint = Color.White,
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text("141", color = Color.White, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                    }
                }
            }

            // Dual Action Selector Bar: [🎙️ Audio Talk] & [✍️ Write Task]
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 6.dp),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                // Audio Talk Button
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(CircleShape)
                        .clickable { onPlayAudioClick() }
                        .testTag("mascot_talk_card_button"),
                    shape = CircleShape,
                    color = Color.White.copy(alpha = 0.9f),
                    shadowElevation = 4.dp
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.VolumeUp,
                            contentDescription = null,
                            tint = Color(0xFF2563EB),
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "Audio Talk",
                            color = Color(0xFF1E293B),
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }

                // Write Task Button
                Surface(
                    modifier = Modifier
                        .weight(1f)
                        .clip(CircleShape)
                        .clickable { onOpenChatClick() }
                        .testTag("mascot_write_card_button"),
                    shape = CircleShape,
                    color = Color.White.copy(alpha = 0.9f),
                    shadowElevation = 4.dp
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Edit,
                            contentDescription = null,
                            tint = Color(0xFF2563EB),
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "Write Task",
                            color = Color(0xFF1E293B),
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }
    }
}

/**
 * SCREEN 2: Task Prompt Planner (Right Screen from Reference)
 */
@Composable
private fun CreatePromptScreen(
    viewModel: TaskViewModel,
    onBackClick: () -> Unit,
    promptInput: String,
    onPromptChange: (String) -> Unit,
    isSpeaking: Boolean,
    onTriggerVoiceTalk: () -> Unit,
    onStopVoice: () -> Unit,
    selectedMode: ChatMode,
    onModeChange: (ChatMode) -> Unit,
    messages: List<AiChatMessage>,
    onSendMessage: (String) -> Unit,
    onSurpriseClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val infiniteTransition = rememberInfiniteTransition(label = "sunrays")
    val rayRotation by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(40000, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "rayRotation"
    )
    val context = LocalContext.current

    Box(
        modifier = modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF5E9CFF),
                        Color(0xFF7CB2FF),
                        Color(0xFF9DC9FF),
                        Color(0xFFC0E0FF),
                        Color(0xFFE5F1FF)
                    )
                )
            )
            .drawBehind {
                // Sunburst rays effect matching right screen
                val center = Offset(size.width / 2f, size.height * 0.28f)
                rotate(rayRotation, pivot = center) {
                    val numRays = 16
                    for (i in 0 until numRays) {
                        val angle = (i * 360f / numRays) * (Math.PI / 180f)
                        val rayLength = size.width * 1.5f
                        val endX = center.x + (rayLength * Math.cos(angle)).toFloat()
                        val endY = center.y + (rayLength * Math.sin(angle)).toFloat()

                        drawLine(
                            color = Color.White.copy(alpha = 0.12f),
                            start = center,
                            end = Offset(endX, endY),
                            strokeWidth = 32.dp.toPx()
                        )
                    }
                }
            }
            .statusBarsPadding()
    ) {
        LazyColumn(
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(bottom = 110.dp)
        ) {
            // 1. Top Header: Back Arrow, Title "Plan your tasks", Mode Switcher [🚀 Plan | 📋 Templates]
            item {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 18.dp, vertical = 10.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        // Back Arrow Button
                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .clip(CircleShape)
                                .background(Color.White.copy(alpha = 0.85f))
                                .clickable { onBackClick() }
                                .testTag("create_prompt_back_button"),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                                contentDescription = "Back",
                                tint = Color(0xFF1E293B),
                                modifier = Modifier.size(20.dp)
                            )
                        }

                        // Title
                        Text(
                            text = "Plan your tasks",
                            color = Color.White,
                            fontSize = 17.sp,
                            fontWeight = FontWeight.Bold
                        )

                        // Voice Audio Speaking / Stop Button
                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .clip(CircleShape)
                                .background(if (isSpeaking) Color(0xFFFF5252) else Color.White.copy(alpha = 0.85f))
                                .clickable {
                                    if (isSpeaking) onStopVoice() else onTriggerVoiceTalk()
                                },
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                imageVector = if (isSpeaking) Icons.Default.GraphicEq else Icons.Default.VolumeUp,
                                contentDescription = "Voice Speech",
                                tint = if (isSpeaking) Color.White else Color(0xFF2563EB),
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    // Segmented Switcher Capsule: [🚀 Plan | 📋 Templates]
                    Surface(
                        shape = CircleShape,
                        color = Color.White.copy(alpha = 0.45f),
                        border = androidx.compose.foundation.BorderStroke(1.dp, Color.White.copy(alpha = 0.65f))
                    ) {
                        Row(
                            modifier = Modifier.padding(4.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            // Plan Pill
                            Box(
                                modifier = Modifier
                                    .clip(CircleShape)
                                    .background(if (selectedMode == ChatMode.CREATE) Color.White else Color.Transparent)
                                    .clickable { onModeChange(ChatMode.CREATE) }
                                    .padding(horizontal = 22.dp, vertical = 9.dp)
                                    .testTag("mode_plan_tab"),
                                contentAlignment = Alignment.Center
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        imageVector = Icons.Default.RocketLaunch,
                                        contentDescription = null,
                                        tint = if (selectedMode == ChatMode.CREATE) Color(0xFF2563EB) else Color(0xFF334155),
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text(
                                        text = "Plan",
                                        color = if (selectedMode == ChatMode.CREATE) Color(0xFF1E293B) else Color(0xFF334155),
                                        fontSize = 13.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }

                            // Templates Pill
                            Box(
                                modifier = Modifier
                                    .clip(CircleShape)
                                    .background(if (selectedMode == ChatMode.TEMPLATES) Color.White else Color.Transparent)
                                    .clickable { onModeChange(ChatMode.TEMPLATES) }
                                    .padding(horizontal = 20.dp, vertical = 9.dp)
                                    .testTag("mode_templates_tab"),
                                contentAlignment = Alignment.Center
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        imageVector = Icons.Outlined.Dashboard,
                                        contentDescription = null,
                                        tint = if (selectedMode == ChatMode.TEMPLATES) Color(0xFF2563EB) else Color(0xFF334155),
                                        modifier = Modifier.size(16.dp)
                                    )
                                    Spacer(modifier = Modifier.width(6.dp))
                                    Text(
                                        text = "Templates",
                                        color = if (selectedMode == ChatMode.TEMPLATES) Color(0xFF1E293B) else Color(0xFF334155),
                                        fontSize = 13.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                        }
                    }
                }
            }

            if (selectedMode == ChatMode.CREATE) {
                // 2. Large AI Task Prompt Card (Matching Right Screen in Image)
                item {
                    Surface(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 18.dp, vertical = 12.dp)
                            .shadow(16.dp, RoundedCornerShape(32.dp), spotColor = Color(0x202563EB)),
                        shape = RoundedCornerShape(32.dp),
                        color = Color.White
                    ) {
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(20.dp)
                        ) {
                            // Live Speech Voice Audio Wave Status Indicator
                            if (isSpeaking) {
                                Row(
                                    verticalAlignment = Alignment.CenterVertically,
                                    modifier = Modifier
                                        .clip(CircleShape)
                                        .background(Color(0xFFEFF6FF))
                                        .padding(horizontal = 10.dp, vertical = 4.dp)
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.GraphicEq,
                                        contentDescription = "Speaking",
                                        tint = Color(0xFF2563EB),
                                        modifier = Modifier.size(14.dp)
                                    )
                                    Spacer(modifier = Modifier.width(4.dp))
                                    Text(
                                        text = "AED Voice Audio Speaking & Auto-Writing...",
                                        color = Color(0xFF1D4ED8),
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                                Spacer(modifier = Modifier.height(10.dp))
                            }

                            // The Big Auto-Typing / Manual Input Field
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(200.dp)
                            ) {
                                BasicTextField(
                                    value = promptInput,
                                    onValueChange = onPromptChange,
                                    textStyle = TextStyle(
                                        color = TextPrimary,
                                        fontSize = 16.sp,
                                        lineHeight = 24.sp,
                                        fontWeight = FontWeight.Medium
                                    ),
                                    modifier = Modifier
                                        .fillMaxSize()
                                        .testTag("task_prompt_input_field"),
                                    decorationBox = { innerTextField ->
                                        if (promptInput.isEmpty()) {
                                            Text(
                                                text = "Describe what task or sprint you want to schedule...",
                                                color = Color(0xFF94A3B8),
                                                fontSize = 16.sp,
                                                lineHeight = 24.sp
                                            )
                                        }
                                        innerTextField()
                                    }
                                )

                                // Center Sparkle Star (Matching Right Screen)
                                if (promptInput.isEmpty()) {
                                    Box(
                                        modifier = Modifier
                                            .align(Alignment.Center)
                                            .size(54.dp),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Icon(
                                            imageVector = Icons.Default.AutoAwesome,
                                            contentDescription = null,
                                            tint = Color(0xFF60A5FA).copy(alpha = 0.7f),
                                            modifier = Modifier.size(36.dp)
                                        )
                                    }
                                }
                            }

                            Spacer(modifier = Modifier.height(14.dp))

                            // Bottom Controls: "✨ Surprise me" + Blue Round Send Button
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                // "✨ Surprise me" Pill
                                Surface(
                                    modifier = Modifier
                                        .clip(CircleShape)
                                        .clickable { onSurpriseClick() }
                                        .testTag("task_surprise_me_button"),
                                    shape = CircleShape,
                                    color = Color(0xFFF8FAFC),
                                    border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFE2E8F0))
                                ) {
                                    Row(
                                        modifier = Modifier.padding(horizontal = 16.dp, vertical = 10.dp),
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Icon(
                                            imageVector = Icons.Default.AutoAwesome,
                                            contentDescription = null,
                                            tint = Color(0xFF2563EB),
                                            modifier = Modifier.size(15.dp)
                                        )
                                        Spacer(modifier = Modifier.width(6.dp))
                                        Text(
                                            text = "Surprise me",
                                            color = Color(0xFF1E293B),
                                            fontSize = 13.sp,
                                            fontWeight = FontWeight.Bold
                                        )
                                    }
                                }

                                // Circular Send Button
                                Surface(
                                    modifier = Modifier
                                        .size(48.dp)
                                        .shadow(8.dp, CircleShape, spotColor = Color(0x352563EB))
                                        .clip(CircleShape)
                                        .clickable {
                                            if (promptInput.isNotBlank()) {
                                                onSendMessage(promptInput)
                                            }
                                        }
                                        .testTag("task_send_round_button"),
                                    shape = CircleShape,
                                    color = Color(0xFF3B82F6)
                                ) {
                                    Box(contentAlignment = Alignment.Center) {
                                        Icon(
                                            imageVector = Icons.AutoMirrored.Filled.Send,
                                            contentDescription = "Send Task",
                                            tint = Color.White,
                                            modifier = Modifier.size(20.dp)
                                        )
                                    }
                                }
                            }
                        }
                    }
                }

                // 3. Generated Scheduled Tasks (Database Connected)
                items(messages, key = { it.id }) { msg ->
                    ChatBubbleItem(
                        message = msg,
                        onAddToSchedule = {
                            if (msg.suggestedTaskTitle != null) {
                                viewModel.createTask(
                                    title = msg.suggestedTaskTitle,
                                    description = "Planned by AED AI Task Assistant for Aymane",
                                    date = "Today",
                                    startTime = msg.suggestedTime?.substringBefore(" - ") ?: "02:00 PM",
                                    endTime = msg.suggestedTime?.substringAfter(" - ") ?: "03:30 PM",
                                    priority = msg.suggestedPriority ?: "High",
                                    project = msg.suggestedProject ?: "Sprint Delivery",
                                    tags = "AI,Task,AED",
                                    hasMeeting = true
                                )
                                Toast.makeText(context, "Added '${msg.suggestedTaskTitle}' to Schedule!", Toast.LENGTH_SHORT).show()
                            }
                        }
                    )
                }
            } else {
                // TEMPLATES TAB
                item {
                    Column(modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp)) {
                        Text(
                            text = "Developer Task Templates",
                            color = Color.White,
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = "Ready-to-use sprint workflows you can import instantly",
                            color = Color.White.copy(alpha = 0.85f),
                            fontSize = 13.sp
                        )
                    }
                }

                val taskTemplates = listOf(
                    Triple("Full-Stack Sprint Planning", "Break down backend API, Compose UI, and database migrations", "3 Tasks • 4.5 hrs"),
                    Triple("Mobile UI/UX Design System", "Figma to Jetpack Compose tokens, micro-interactions, dark mode", "4 Tasks • 3 hrs"),
                    Triple("Client Milestone Delivery", "Automated UI tests, signed APK release, staging client review", "2 Tasks • 2 hrs"),
                    Triple("Developer Daily Focus Loop", "Morning standup, deep work coding sprint, peer PR reviews", "3 Tasks • 5 hrs")
                )

                items(taskTemplates) { (title, desc, duration) ->
                    Surface(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 20.dp, vertical = 6.dp)
                            .shadow(6.dp, RoundedCornerShape(20.dp), spotColor = Color(0x15000000))
                            .clip(RoundedCornerShape(20.dp))
                            .clickable {
                                viewModel.createTask(
                                    title = title,
                                    description = desc,
                                    date = "Today",
                                    startTime = "09:30 AM",
                                    endTime = "11:30 AM",
                                    priority = "High",
                                    project = "Mobile Development",
                                    tags = "Template,Dev,AED",
                                    hasMeeting = false
                                )
                                Toast.makeText(context, "Imported '$title' template to your Tasks!", Toast.LENGTH_SHORT).show()
                            }
                            .testTag("task_template_card_$title"),
                        shape = RoundedCornerShape(20.dp),
                        color = Color.White
                    ) {
                        Column(modifier = Modifier.padding(18.dp)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    text = title,
                                    color = TextPrimary,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold
                                )
                                Surface(
                                    shape = CircleShape,
                                    color = Color(0xFFEEF2FF)
                                ) {
                                    Text(
                                        text = duration,
                                        color = Color(0xFF4F46E5),
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.SemiBold,
                                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                                    )
                                }
                            }

                            Spacer(modifier = Modifier.height(6.dp))
                            Text(
                                text = desc,
                                color = TextSecondary,
                                fontSize = 13.sp,
                                lineHeight = 18.sp
                            )

                            Spacer(modifier = Modifier.height(12.dp))

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.End
                            ) {
                                Surface(
                                    shape = CircleShape,
                                    color = Color(0xFF0F172A)
                                ) {
                                    Text(
                                        text = "⚡ Apply Template",
                                        color = Color.White,
                                        fontSize = 12.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 6.dp)
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

@Composable
private fun ChatBubbleItem(
    message: AiChatMessage,
    onAddToSchedule: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp, vertical = 6.dp),
        horizontalAlignment = if (message.isFromUser) Alignment.End else Alignment.Start
    ) {
        Surface(
            shape = RoundedCornerShape(
                topStart = 20.dp,
                topEnd = 20.dp,
                bottomStart = if (message.isFromUser) 20.dp else 4.dp,
                bottomEnd = if (message.isFromUser) 4.dp else 20.dp
            ),
            color = if (message.isFromUser) CharcoalDark else Color.White,
            shadowElevation = 4.dp,
            modifier = Modifier.fillMaxWidth(if (message.suggestedTaskTitle != null) 0.95f else 0.85f)
        ) {
            Column(modifier = Modifier.padding(14.dp)) {
                Text(
                    text = message.text,
                    color = if (message.isFromUser) Color.White else TextPrimary,
                    fontSize = 14.sp,
                    lineHeight = 20.sp
                )

                if (message.suggestedTaskTitle != null) {
                    Spacer(modifier = Modifier.height(10.dp))
                    Surface(
                        shape = RoundedCornerShape(14.dp),
                        color = Color(0xFFF8FAFC),
                        border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFE2E8F0))
                    ) {
                        Column(modifier = Modifier.padding(12.dp)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    text = message.suggestedTaskTitle,
                                    color = TextPrimary,
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                                Surface(
                                    shape = CircleShape,
                                    color = Color(0xFFDCFCE7)
                                ) {
                                    Text(
                                        text = "${message.suggestedPriority} Priority",
                                        color = Color(0xFF15803D),
                                        fontSize = 10.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                                    )
                                }
                            }

                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = "⏰ ${message.suggestedTime} • 📂 ${message.suggestedProject}",
                                color = SubtitleGray,
                                fontSize = 11.sp
                            )

                            Spacer(modifier = Modifier.height(10.dp))

                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(CircleShape)
                                    .clickable { onAddToSchedule() }
                                    .testTag("add_task_to_schedule_button"),
                                shape = CircleShape,
                                color = Color(0xFF2563EB)
                            ) {
                                Box(
                                    modifier = Modifier.padding(vertical = 8.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Row(verticalAlignment = Alignment.CenterVertically) {
                                        Icon(
                                            imageVector = Icons.Outlined.CheckCircle,
                                            contentDescription = null,
                                            tint = Color.White,
                                            modifier = Modifier.size(14.dp)
                                        )
                                        Spacer(modifier = Modifier.width(6.dp))
                                        Text(
                                            text = "Add to My Schedule",
                                            color = Color.White,
                                            fontSize = 12.sp,
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
}

private fun String.capitalizeWords(): String = split(" ").joinToString(" ") { it.replaceFirstChar { char -> char.uppercase() } }

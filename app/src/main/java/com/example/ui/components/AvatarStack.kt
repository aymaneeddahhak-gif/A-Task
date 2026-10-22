package com.example.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.Image
import com.example.R

@Composable
fun UserAvatarHeader(
    modifier: Modifier = Modifier,
    size: Dp = 46.dp
) {
    Box(
        modifier = modifier
            .size(size)
            .clip(CircleShape)
            .border(2.dp, Color.White.copy(alpha = 0.85f), CircleShape),
        contentAlignment = Alignment.Center
    ) {
        // Render Aymane's profile avatar
        Image(
            painter = painterResource(id = R.drawable.img_aymane_avatar),
            contentDescription = "Aymane Profile Picture",
            modifier = Modifier.size(size),
            contentScale = ContentScale.Crop
        )
    }
}

@Composable
fun AvatarStack(
    count: Int = 4,
    modifier: Modifier = Modifier,
    avatarSize: Dp = 26.dp
) {
    val avatarGradients = listOf(
        Brush.linearGradient(listOf(Color(0xFFE57373), Color(0xFFF06292))),
        Brush.linearGradient(listOf(Color(0xFF64B5F6), Color(0xFF4FC3F7))),
        Brush.linearGradient(listOf(Color(0xFFFFB74D), Color(0xFFFF8A65))),
        Brush.linearGradient(listOf(Color(0xFF81C784), Color(0xFF4DB6AC)))
    )

    val avatarInitials = listOf("AL", "MK", "JD", "SP")

    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically
    ) {
        val displayCount = 2
        for (i in 0 until displayCount) {
            Box(
                modifier = Modifier
                    .offset(x = (-6 * i).dp)
                    .size(avatarSize)
                    .clip(CircleShape)
                    .background(avatarGradients[i % avatarGradients.size])
                    .border(1.5.dp, Color.White, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = avatarInitials[i],
                    color = Color.White,
                    fontSize = 9.sp,
                    fontWeight = FontWeight.Bold
                )
            }
        }

        // "+X" badge
        Box(
            modifier = Modifier
                .offset(x = (-6 * displayCount).dp)
                .size(avatarSize)
                .clip(CircleShape)
                .background(Color(0xFF1E1F24))
                .border(1.5.dp, Color.White, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = "+$count",
                color = Color.White,
                fontSize = 10.sp,
                fontWeight = FontWeight.SemiBold
            )
        }
    }
}

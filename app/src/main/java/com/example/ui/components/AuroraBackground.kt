package com.example.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import com.example.ui.theme.AuroraBgEnd
import com.example.ui.theme.AuroraBgStart
import com.example.ui.theme.AuroraCream
import com.example.ui.theme.AuroraLavender
import com.example.ui.theme.AuroraPeach
import com.example.ui.theme.AuroraPink

@Composable
fun AuroraBackground(
    modifier: Modifier = Modifier,
    content: @Composable () -> Unit
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(AuroraCream)
            .drawBehind {
                val width = size.width
                val height = size.height

                // Base smooth subtle vertical gradient
                drawRect(
                    brush = Brush.verticalGradient(
                        colors = listOf(
                            AuroraBgStart,
                            Color(0xFFFAF6F2),
                            AuroraBgEnd
                        )
                    )
                )

                // Top-Left Soft Peach/Coral Glow
                drawCircle(
                    brush = Brush.radialGradient(
                        colors = listOf(
                            AuroraPeach.copy(alpha = 0.65f),
                            AuroraPink.copy(alpha = 0.35f),
                            Color.Transparent
                        ),
                        center = Offset(width * 0.15f, height * 0.12f),
                        radius = width * 0.75f
                    )
                )

                // Top-Right Soft Lavender/Violet Glow
                drawCircle(
                    brush = Brush.radialGradient(
                        colors = listOf(
                            AuroraLavender.copy(alpha = 0.70f),
                            Color(0xFFE2D6FB).copy(alpha = 0.40f),
                            Color.Transparent
                        ),
                        center = Offset(width * 0.85f, height * 0.10f),
                        radius = width * 0.80f
                    )
                )

                // Center-Right subtle warm accent
                drawCircle(
                    brush = Brush.radialGradient(
                        colors = listOf(
                            AuroraPink.copy(alpha = 0.25f),
                            Color.Transparent
                        ),
                        center = Offset(width * 0.90f, height * 0.45f),
                        radius = width * 0.60f
                    )
                )
            }
    ) {
        content()
    }
}

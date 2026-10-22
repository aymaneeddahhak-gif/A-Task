package com.example.ui.components

import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlin.math.cos
import kotlin.math.sin

@Composable
fun CircularProgressRing(
    progress: Float, // 0.0f to 1.0f
    modifier: Modifier = Modifier,
    size: Dp = 102.dp,
    strokeWidth: Dp = 10.dp,
    trackColor: Color = Color(0xFFC7EC87),
    progressColor: Color = Color(0xFF75CE17),
    textColor: Color = Color(0xFF142410),
    centerCircleColor: Color = Color.White,
    centerSubtitle: String? = "done",
    centerSubtitleColor: Color = Color(0xFF4C6F3B),
    zeroProgressAccentColor: Color? = null
) {
    val animatedProgress by animateFloatAsState(
        targetValue = progress.coerceIn(0f, 1f),
        animationSpec = tween(durationMillis = 1000, easing = FastOutSlowInEasing),
        label = "ProgressAnimation"
    )

    Box(
        modifier = modifier.size(size),
        contentAlignment = Alignment.Center
    ) {
        Canvas(modifier = Modifier.size(size)) {
            val strokePx = strokeWidth.toPx()
            val diameter = size.toPx() - strokePx
            val topLeft = Offset(strokePx / 2, strokePx / 2)
            val arcSize = Size(diameter, diameter)

            // Draw center inner white disk
            if (centerCircleColor != Color.Transparent) {
                val innerRadius = (diameter - strokePx) / 2f
                drawCircle(
                    color = centerCircleColor,
                    radius = innerRadius,
                    center = Offset(size.toPx() / 2f, size.toPx() / 2f)
                )
            }

            // Draw background circular track
            drawArc(
                color = trackColor,
                startAngle = -90f,
                sweepAngle = 360f,
                useCenter = false,
                topLeft = topLeft,
                size = arcSize,
                style = Stroke(width = strokePx, cap = StrokeCap.Round)
            )

            // Draw active green progress arc
            val sweep = animatedProgress * 360f
            if (sweep > 0f) {
                drawArc(
                    color = progressColor,
                    startAngle = -90f,
                    sweepAngle = sweep,
                    useCenter = false,
                    topLeft = topLeft,
                    size = arcSize,
                    style = Stroke(width = strokePx, cap = StrokeCap.Round)
                )

                // Endpoint glow dot
                val angleRad = Math.toRadians((sweep - 90f).toDouble())
                val radius = diameter / 2f
                val centerX = size.toPx() / 2f
                val centerY = size.toPx() / 2f
                val dotX = (centerX + radius * cos(angleRad)).toFloat()
                val dotY = (centerY + radius * sin(angleRad)).toFloat()

                drawCircle(
                    color = Color.White,
                    radius = strokePx * 0.45f,
                    center = Offset(dotX, dotY)
                )
            } else if (zeroProgressAccentColor != null) {
                val littleSweep = 18f
                drawArc(
                    color = zeroProgressAccentColor,
                    startAngle = -90f,
                    sweepAngle = littleSweep,
                    useCenter = false,
                    topLeft = topLeft,
                    size = arcSize,
                    style = Stroke(width = strokePx, cap = StrokeCap.Round)
                )

                val angleRad = Math.toRadians((littleSweep - 90f).toDouble())
                val radius = diameter / 2f
                val centerX = size.toPx() / 2f
                val centerY = size.toPx() / 2f
                val dotX = (centerX + radius * cos(angleRad)).toFloat()
                val dotY = (centerY + radius * sin(angleRad)).toFloat()

                drawCircle(
                    color = Color.White,
                    radius = strokePx * 0.35f,
                    center = Offset(dotX, dotY)
                )
            }
        }

        // Center percentage & subtitle text
        val percentInt = (animatedProgress * 100).toInt()
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = "$percentInt%",
                color = textColor,
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold
            )
            if (centerSubtitle != null) {
                Text(
                    text = centerSubtitle,
                    color = centerSubtitleColor,
                    fontSize = 10.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}

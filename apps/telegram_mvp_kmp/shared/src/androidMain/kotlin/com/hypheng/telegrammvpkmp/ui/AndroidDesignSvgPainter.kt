package com.hypheng.telegrammvpkmp.ui

import android.graphics.Picture
import android.graphics.drawable.PictureDrawable
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.graphics.painter.Painter
import com.caverock.androidsvg.SVG
import kotlin.math.roundToInt

@Composable
actual fun designSvgPainter(assetPath: String): Painter {
    val context = LocalContext.current
    val drawable = remember(assetPath, context) {
        runCatching {
            context.assets.open(assetPath).use { inputStream ->
                val svg = SVG.getFromInputStream(inputStream)
                PictureDrawable(svg.renderToPicture())
            }
        }.getOrElse {
            PictureDrawable(Picture())
        }
    }

    return remember(drawable) {
        AndroidDrawablePainter(drawable)
    }
}

private class AndroidDrawablePainter(
    private val drawable: android.graphics.drawable.Drawable,
) : Painter() {
    override val intrinsicSize: Size
        get() {
            val width = drawable.intrinsicWidth
            val height = drawable.intrinsicHeight
            return if (width > 0 && height > 0) {
                Size(width.toFloat(), height.toFloat())
            } else {
                Size.Unspecified
            }
        }

    override fun DrawScope.onDraw() {
        val width = size.width.roundToInt().coerceAtLeast(1)
        val height = size.height.roundToInt().coerceAtLeast(1)
        drawable.setBounds(0, 0, width, height)
        drawIntoCanvas { canvas ->
            drawable.draw(canvas.nativeCanvas)
        }
    }
}

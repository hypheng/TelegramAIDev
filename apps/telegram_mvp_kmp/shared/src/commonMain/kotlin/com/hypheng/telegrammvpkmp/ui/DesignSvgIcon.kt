package com.hypheng.telegrammvpkmp.ui

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Composable
expect fun designSvgPainter(assetPath: String): Painter

@Composable
fun DesignSvgIcon(
    assetPath: String,
    modifier: Modifier = Modifier,
    size: Dp = 24.dp,
    tint: Color? = null,
    contentDescription: String? = null,
) {
    val painter = designSvgPainter(assetPath)
    Image(
        painter = painter,
        contentDescription = contentDescription,
        modifier = modifier.size(size),
        colorFilter = tint?.let { ColorFilter.tint(it) },
    )
}

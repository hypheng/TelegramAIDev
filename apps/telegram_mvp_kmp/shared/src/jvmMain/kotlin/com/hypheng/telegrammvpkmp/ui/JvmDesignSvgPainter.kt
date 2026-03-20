package com.hypheng.telegrammvpkmp.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.ColorPainter
import androidx.compose.ui.graphics.painter.Painter

@Composable
actual fun designSvgPainter(assetPath: String): Painter {
    return ColorPainter(Color.Transparent)
}

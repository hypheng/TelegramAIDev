package com.hypheng.telegrammvpkmp.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

import com.hypheng.telegrammvpkmp.design.DesignAssetPaths

@Composable
fun BootstrapScreen(brandTitle: String = "Telegram Demo") {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        DesignSvgIcon(
            assetPath = DesignAssetPaths.telegramBrandBadge,
            modifier = Modifier.size(80.dp),
            size = 80.dp,
        )
        Text(
            text = brandTitle,
            style = MaterialTheme.typography.headlineMedium,
        )
        CircularProgressIndicator()
        Text(text = "Checking local session…")
    }
}

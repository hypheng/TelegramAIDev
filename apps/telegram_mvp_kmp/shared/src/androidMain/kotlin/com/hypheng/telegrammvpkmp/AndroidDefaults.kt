package com.hypheng.telegrammvpkmp

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import com.hypheng.telegrammvpkmp.design.AndroidAssetDesignCatalogRepository
import com.hypheng.telegrammvpkmp.session.AndroidSharedPreferencesSessionStore

@Composable
fun TelegramMvpAppWithAndroidDefaults() {
    val context = LocalContext.current
    TelegramMvpApp(
        sessionStore = AndroidSharedPreferencesSessionStore(context),
        designCatalogRepository = AndroidAssetDesignCatalogRepository(context),
    )
}

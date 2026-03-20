package com.hypheng.telegrammvpkmp

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember

import com.hypheng.telegrammvpkmp.session.DesignCatalogRepository
import com.hypheng.telegrammvpkmp.session.SessionStore

@Composable
fun TelegramMvpApp(
    sessionStore: SessionStore,
    designCatalogRepository: DesignCatalogRepository,
) {
    val controller = remember(sessionStore, designCatalogRepository) {
        TelegramAppController(
            sessionStore = sessionStore,
            designCatalogRepository = designCatalogRepository,
        )
    }

    LaunchedEffect(controller) {
        controller.bootstrap()
    }

    MaterialTheme {
        TelegramMvpAppContent(controller = controller)
    }
}

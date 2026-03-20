package com.hypheng.telegrammvpkmp

import androidx.compose.runtime.Composable

import com.hypheng.telegrammvpkmp.ui.BootstrapScreen
import com.hypheng.telegrammvpkmp.ui.HomeShellScreen
import com.hypheng.telegrammvpkmp.ui.LoginScreen

@Composable
fun TelegramMvpAppContent(controller: TelegramAppController) {
    val state = controller.uiState

    when (val current = state) {
        TelegramUiState.Bootstrapping -> BootstrapScreen()
        is TelegramUiState.Login -> LoginScreen(
            state = current,
            onPhoneChange = controller::updateLoginPhoneNumber,
            onContinue = controller::signIn,
        )
        is TelegramUiState.Home -> HomeShellScreen(
            state = current,
            onSelectTab = controller::selectHomeTab,
            onLogout = controller::logOut,
        )
    }
}

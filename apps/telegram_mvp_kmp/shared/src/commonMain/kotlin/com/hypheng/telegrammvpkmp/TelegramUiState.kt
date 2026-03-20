package com.hypheng.telegrammvpkmp

import com.hypheng.telegrammvpkmp.design.DesignCatalog

sealed interface TelegramUiState {
    data object Bootstrapping : TelegramUiState

    data class Login(
        val catalog: DesignCatalog,
        val phoneNumber: String,
        val isSigningIn: Boolean = false,
        val errorMessage: String? = null,
    ) : TelegramUiState

    data class Home(
        val catalog: DesignCatalog,
        val phoneNumber: String?,
        val activeTab: HomeTab = HomeTab.Chats,
    ) : TelegramUiState
}

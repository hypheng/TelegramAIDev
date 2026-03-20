package com.hypheng.telegrammvpkmp

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue

import com.hypheng.telegrammvpkmp.design.DesignCatalog
import com.hypheng.telegrammvpkmp.session.DesignCatalogRepository
import com.hypheng.telegrammvpkmp.session.SessionSnapshot
import com.hypheng.telegrammvpkmp.session.SessionStore

class TelegramAppController(
    private val sessionStore: SessionStore,
    private val designCatalogRepository: DesignCatalogRepository,
) {
    var uiState by mutableStateOf<TelegramUiState>(TelegramUiState.Bootstrapping)
        private set

    suspend fun bootstrap() {
        val session = sessionStore.read()
        val catalog = designCatalogRepository.load()

        uiState = if (session.hasSession) {
            TelegramUiState.Home(
                catalog = catalog,
                phoneNumber = session.phoneNumber,
                activeTab = HomeTab.Chats,
            )
        } else {
            TelegramUiState.Login(
                catalog = catalog,
                phoneNumber = catalog.login.demoPhoneNumber,
            )
        }
    }

    suspend fun signIn(phoneNumber: String): Boolean {
        val current = uiState as? TelegramUiState.Login ?: return false
        val normalized = phoneNumber.trim()

        if (!isValidDemoPhoneNumber(normalized)) {
            uiState = current.copy(
                phoneNumber = normalized,
                errorMessage = current.catalog.login.validationMessage,
            )
            return false
        }

        uiState = current.copy(
            phoneNumber = normalized,
            isSigningIn = true,
            errorMessage = null,
        )

        sessionStore.saveDemoSession(normalized)

        uiState = TelegramUiState.Home(
            catalog = current.catalog,
            phoneNumber = normalized,
            activeTab = HomeTab.Chats,
        )
        return true
    }

    fun updateLoginPhoneNumber(value: String) {
        val current = uiState as? TelegramUiState.Login ?: return
        uiState = current.copy(
            phoneNumber = value,
            errorMessage = null,
        )
    }

    fun selectHomeTab(tab: HomeTab) {
        val current = uiState as? TelegramUiState.Home ?: return
        uiState = current.copy(activeTab = tab)
    }

    suspend fun logOut() {
        val currentCatalog = when (val state = uiState) {
            is TelegramUiState.Login -> state.catalog
            is TelegramUiState.Home -> state.catalog
            else -> null
        }

        sessionStore.clear()

        if (currentCatalog != null) {
            uiState = TelegramUiState.Login(
                catalog = currentCatalog,
                phoneNumber = currentCatalog.login.demoPhoneNumber,
            )
        } else {
            uiState = TelegramUiState.Bootstrapping
        }
    }

    private fun isValidDemoPhoneNumber(value: String): Boolean {
        val digitCount = value.count(Char::isDigit)
        return digitCount >= 10
    }
}

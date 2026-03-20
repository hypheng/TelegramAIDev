package com.hypheng.telegrammvpkmp

import com.hypheng.telegrammvpkmp.design.DesignCatalog
import com.hypheng.telegrammvpkmp.session.DesignCatalogRepository
import com.hypheng.telegrammvpkmp.session.SessionSnapshot
import com.hypheng.telegrammvpkmp.session.SessionStore
import kotlin.test.assertEquals
import kotlin.test.assertIs
import kotlin.test.assertFalse
import kotlin.test.assertTrue
import kotlinx.coroutines.test.runTest
import kotlin.test.Test

class TelegramAppControllerTest {
    @Test
    fun bootstrapWithoutSessionRoutesToLogin() = runTest {
        val sessionStore = InMemorySessionStore()
        val controller = TelegramAppController(sessionStore, InMemoryDesignCatalogRepository())

        controller.bootstrap()

        val state = assertIs<TelegramUiState.Login>(controller.uiState)
        assertEquals(DesignCatalog.sample().login.demoPhoneNumber, state.phoneNumber)
        assertEquals("Telegram Demo", state.catalog.login.brandTitle)
    }

    @Test
    fun bootstrapWithSessionRoutesToHomeChats() = runTest {
        val sessionStore = InMemorySessionStore(hasSession = true, phoneNumber = "+1 415 555 0199")
        val controller = TelegramAppController(sessionStore, InMemoryDesignCatalogRepository())

        controller.bootstrap()

        val state = assertIs<TelegramUiState.Home>(controller.uiState)
        assertEquals(HomeTab.Chats, state.activeTab)
        assertEquals("+1 415 555 0199", state.phoneNumber)
    }

    @Test
    fun validDemoPhoneSignsInAndPersistsSession() = runTest {
        val sessionStore = InMemorySessionStore()
        val controller = TelegramAppController(sessionStore, InMemoryDesignCatalogRepository())

        controller.bootstrap()
        val success = controller.signIn("+1 415 555 0199")

        assertTrue(success)
        val state = assertIs<TelegramUiState.Home>(controller.uiState)
        assertEquals(HomeTab.Chats, state.activeTab)
        assertEquals("+1 415 555 0199", state.phoneNumber)
        assertEquals("+1 415 555 0199", sessionStore.read().phoneNumber)
    }

    @Test
    fun invalidDemoPhoneStaysOnLoginAndShowsError() = runTest {
        val controller = TelegramAppController(
            InMemorySessionStore(),
            InMemoryDesignCatalogRepository(),
        )

        controller.bootstrap()
        val success = controller.signIn("+1 415 55")

        assertFalse(success)
        val state = assertIs<TelegramUiState.Login>(controller.uiState)
        assertEquals("+1 415 55", state.phoneNumber)
        assertEquals(DesignCatalog.sample().login.validationMessage, state.errorMessage)
    }
}

private class InMemoryDesignCatalogRepository : DesignCatalogRepository {
    override suspend fun load(): DesignCatalog = DesignCatalog.sample()
}

private class InMemorySessionStore(
    private var hasSession: Boolean = false,
    private var phoneNumber: String? = null,
) : SessionStore {
    override suspend fun read(): SessionSnapshot {
        return SessionSnapshot(hasSession = hasSession, phoneNumber = phoneNumber)
    }

    override suspend fun saveDemoSession(phoneNumber: String) {
        hasSession = true
        this.phoneNumber = phoneNumber
    }

    override suspend fun clear() {
        hasSession = false
        phoneNumber = null
    }
}

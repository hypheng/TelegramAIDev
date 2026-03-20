package com.hypheng.telegrammvpkmp.session

import android.content.Context

class AndroidSharedPreferencesSessionStore(
    context: Context,
) : SessionStore {
    private val preferences = context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)

    override suspend fun read(): SessionSnapshot {
        val phoneNumber = preferences.getString(KEY_PHONE_NUMBER, null)?.takeIf { it.isNotBlank() }
        return if (phoneNumber == null) {
            SessionSnapshot(hasSession = false)
        } else {
            SessionSnapshot(hasSession = true, phoneNumber = phoneNumber)
        }
    }

    override suspend fun saveDemoSession(phoneNumber: String) {
        preferences.edit()
            .putString(KEY_PHONE_NUMBER, phoneNumber)
            .apply()
    }

    override suspend fun clear() {
        preferences.edit()
            .remove(KEY_PHONE_NUMBER)
            .apply()
    }

    private companion object {
        private const val PREFERENCES_NAME = "telegram_mvp_session"
        private const val KEY_PHONE_NUMBER = "phone_number"
    }
}

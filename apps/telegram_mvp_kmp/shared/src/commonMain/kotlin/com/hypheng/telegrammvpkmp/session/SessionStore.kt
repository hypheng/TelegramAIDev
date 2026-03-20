package com.hypheng.telegrammvpkmp.session

data class SessionSnapshot(
    val hasSession: Boolean,
    val phoneNumber: String? = null,
)

interface SessionStore {
    suspend fun read(): SessionSnapshot
    suspend fun saveDemoSession(phoneNumber: String)
    suspend fun clear()
}

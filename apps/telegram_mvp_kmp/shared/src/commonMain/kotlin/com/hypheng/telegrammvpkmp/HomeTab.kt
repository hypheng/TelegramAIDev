package com.hypheng.telegrammvpkmp

enum class HomeTab(val id: String) {
    Chats("chats"),
    Contacts("contacts"),
    Settings("settings");

    companion object {
        fun fromId(id: String): HomeTab = entries.firstOrNull { it.id == id } ?: Chats
    }
}

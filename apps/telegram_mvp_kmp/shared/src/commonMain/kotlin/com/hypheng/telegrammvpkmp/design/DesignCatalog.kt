package com.hypheng.telegrammvpkmp.design

import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json

@Serializable
data class DesignCatalog(
    val login: LoginDesign,
    val homeShell: HomeShellDesign,
    val chatList: ChatListDesign,
    val contactsSurface: ContactsSurfaceDesign,
) {
    companion object {
        private val json = Json {
            ignoreUnknownKeys = true
        }

        fun fromJsonString(jsonString: String): DesignCatalog {
            return json.decodeFromString(jsonString)
        }

        fun sample(): DesignCatalog {
            return DesignCatalog(
                login = LoginDesign(
                    brandTitle = "Telegram Demo",
                    demoPhoneNumber = "+1 415 555 0199",
                    invalidPhoneNumber = "+1 415 55",
                    submitLabel = "Continue",
                    hint = "No real SMS or backend. Keep the flow credible, but lightweight.",
                    footer = "The first successful login routes into the home shell with the Chats tab active.",
                    validationMessage = "Please enter a complete demo phone number before continuing.",
                    validationHint = "Inline validation should be calm, visible, and intentional.",
                    validationFooter = "Use concise feedback and keep the rest of the form stable when validation fails.",
                ),
                homeShell = HomeShellDesign(
                    defaultTabId = "chats",
                    tabs = listOf(
                        HomeTabDesign(
                            id = "chats",
                            label = "Chats",
                            iconName = "tab-chats",
                            mvpDepth = "core",
                        ),
                        HomeTabDesign(
                            id = "contacts",
                            label = "Contacts",
                            iconName = "tab-contacts",
                            mvpDepth = "surface-only",
                        ),
                        HomeTabDesign(
                            id = "settings",
                            label = "Settings",
                            iconName = "tab-settings",
                            mvpDepth = "surface-only",
                        ),
                    ),
                    actions = HomeActions(
                        searchIconName = "search",
                        composeIconName = "compose",
                        addIconName = "add",
                    ),
                ),
                chatList = ChatListDesign(
                    conversations = listOf(
                        ChatConversation(
                            id = "alex-mercer",
                            title = "Alex Mercer",
                            avatarText = "A",
                            avatarVariant = "default",
                            timestampLabel = "09:42",
                            preview = "The design pass looks solid. Ship the home shell with tabs visible in MVP.",
                            unreadCount = 2,
                            isActive = true,
                            metaLabel = null,
                        ),
                        ChatConversation(
                            id = "team-sync",
                            title = "Team Sync",
                            avatarText = "T",
                            avatarVariant = "alt1",
                            timestampLabel = "08:15",
                            preview = "Need parity notes for CJMP, KMP, and flutter after the next round.",
                            unreadCount = 0,
                            isActive = false,
                            metaLabel = "PINNED",
                        ),
                        ChatConversation(
                            id = "mina-park",
                            title = "Mina Park",
                            avatarText = "M",
                            avatarVariant = "alt2",
                            timestampLabel = "Yesterday",
                            preview = "We can keep Contacts and Settings shallow for now, but they should be present.",
                            unreadCount = 1,
                            isActive = false,
                            metaLabel = null,
                        ),
                        ChatConversation(
                            id = "product-review",
                            title = "Product Review",
                            avatarText = "P",
                            avatarVariant = "alt3",
                            timestampLabel = "Tue",
                            preview = "Customer demo quality matters more than feature count for the benchmark.",
                            unreadCount = 0,
                            isActive = false,
                            metaLabel = "MUTED",
                        ),
                        ChatConversation(
                            id = "support-ops",
                            title = "Support Ops",
                            avatarText = "S",
                            avatarVariant = "alt4",
                            timestampLabel = "Mon",
                            preview = "The loading, empty, and send-pending states should feel production-credible.",
                            unreadCount = 0,
                            isActive = false,
                            metaLabel = null,
                        ),
                    ),
                    loadingState = LoadingState(
                        title = "Loading conversations",
                        body = "Use coherent, non-janky loading states instead of blank scaffolds.",
                        skeletonRowCount = 3,
                    ),
                    emptyState = EmptyState(
                        title = "No chats yet",
                        body = "The empty state should still feel like a product surface, not a broken screen.",
                    ),
                ),
                contactsSurface = ContactsSurfaceDesign(
                    title = "Contacts stays lightweight in MVP",
                    body = "The tab exists to keep the product surface close to Telegram. Detailed contacts management is intentionally deferred.",
                    skeletonLinePercents = listOf(88, 73, 81),
                ),
            )
        }
    }
}

@Serializable
data class LoginDesign(
    val brandTitle: String,
    val demoPhoneNumber: String,
    val invalidPhoneNumber: String,
    val submitLabel: String,
    val hint: String,
    val footer: String,
    val validationMessage: String,
    val validationHint: String,
    val validationFooter: String,
)

@Serializable
data class HomeShellDesign(
    val defaultTabId: String,
    val tabs: List<HomeTabDesign>,
    val actions: HomeActions,
)

@Serializable
data class HomeTabDesign(
    val id: String,
    val label: String,
    val iconName: String,
    val mvpDepth: String,
)

@Serializable
data class HomeActions(
    val searchIconName: String,
    val composeIconName: String,
    val addIconName: String,
)

@Serializable
data class ChatListDesign(
    val conversations: List<ChatConversation>,
    val loadingState: LoadingState,
    val emptyState: EmptyState,
)

@Serializable
data class LoadingState(
    val title: String,
    val body: String,
    val skeletonRowCount: Int,
)

@Serializable
data class EmptyState(
    val title: String,
    val body: String,
)

@Serializable
data class ChatConversation(
    val id: String,
    val title: String,
    val avatarText: String,
    val avatarVariant: String,
    val timestampLabel: String,
    val preview: String,
    val unreadCount: Int,
    val isActive: Boolean,
    val metaLabel: String? = null,
)

@Serializable
data class ContactsSurfaceDesign(
    val title: String,
    val body: String,
    val skeletonLinePercents: List<Int>,
)

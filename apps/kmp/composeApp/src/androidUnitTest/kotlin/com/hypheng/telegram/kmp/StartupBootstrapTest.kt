package com.hypheng.telegram.kmp

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertIs
import kotlinx.coroutines.runBlocking

class StartupBootstrapTest {
    @Test
    fun loadsAssetsByDefault() = runBlocking {
        val bootstrapCopy = sampleBootstrapCopy()
        val startupAssets = sampleStartupAssets()

        val result = loadBootstrapRouteResult(
            startupRuntimeHook = StartupRuntimeHook.None,
            loadBootstrapCopy = { bootstrapCopy },
            loadAll = { startupAssets },
        )

        assertEquals(bootstrapCopy, result.bootstrapCopy)
        assertEquals(startupAssets, assertIs<BootstrapLoadOutcome.Loaded>(result.outcome).assets)
    }

    @Test
    fun forcedFailureUsesFailureOutcomeWithoutLoadingAssets() = runBlocking {
        val bootstrapCopy = sampleBootstrapCopy()
        var loadAllCalls = 0

        val result = loadBootstrapRouteResult(
            startupRuntimeHook = StartupRuntimeHook.ForceFailure,
            loadBootstrapCopy = { bootstrapCopy },
            loadAll = {
                loadAllCalls += 1
                sampleStartupAssets()
            },
        )

        assertEquals(0, loadAllCalls)
        assertEquals(bootstrapCopy, result.bootstrapCopy)
        assertEquals(
            bootstrapCopy.failureNotice,
            assertIs<BootstrapLoadOutcome.Failure>(result.outcome).notice,
        )
    }

    private fun sampleBootstrapCopy() = BootstrapCopy(
        title = "Loading Telegram Demo...",
        body = "Preparing startup routing.",
        failureNotice = "Startup failed.",
    )

    private fun sampleStartupAssets() = StartupAssets(
        tokens = DesignTokens(
            meta = MetaTokens(name = "Telegram Demo", version = "1"),
            color = ColorTokens(
                surface = SurfaceColors(
                    appBackground = "#FFFFFF",
                    screen = "#FFFFFF",
                    subtle = "#F4F6F9",
                    elevated = "#FFFFFF",
                ),
                text = TextColors(
                    primary = "#17212B",
                    secondary = "#5B6B7B",
                    muted = "#92A0AD",
                    inverse = "#FFFFFF",
                ),
                accent = AccentColors(
                    brand = "#2AABEE",
                    brandStrong = "#229ED9",
                    brandSoft = "#E8F7FF",
                ),
                status = StatusColors(
                    success = "#4FC25B",
                    warning = "#FFB020",
                    error = "#E53935",
                ),
                border = BorderColors(
                    subtle = "#D8E1EB",
                    strong = "#91A3B0",
                ),
                badge = BadgeColors(
                    unreadBackground = "#2AABEE",
                    unreadText = "#FFFFFF",
                ),
                avatar = AvatarColors(
                    blue = "#2AABEE",
                    green = "#4FC25B",
                    orange = "#FFB020",
                    purple = "#7E57C2",
                ),
            ),
            typography = TypographyTokens(
                family = TypographyFamilies(primary = "Inter"),
                size = TypographySizes(caption = 12, body = 14, bodyStrong = 16, title = 20, headline = 28),
                lineHeight = TypographyLineHeights(caption = 16, body = 20, bodyStrong = 24, title = 24, headline = 32),
                weight = TypographyWeights(regular = 400, medium = 500, semibold = 600, bold = 700),
            ),
            spacing = SpacingTokens(xs = 4, sm = 8, md = 12, lg = 16, xl = 24, xxl = 32),
            radius = RadiusTokens(card = 28, field = 16, pill = 999, bubble = 18),
            borderWidth = BorderWidthTokens(hairline = 1, strong = 2),
            elevation = ElevationTokens(none = 0, card = 2, overlay = 8),
            iconSize = IconSizeTokens(sm = 16, md = 20, lg = 24, xl = 32),
            avatarSize = AvatarSizeTokens(list = 48, detail = 72),
        ),
        sharedCopy = SharedCopy(
            bootstrap = sampleBootstrapCopy(),
            login = LoginCopy(
                brandTitle = "Telegram Demo",
                headline = "Start with your phone number",
                body = "Demo login follows in the next slice.",
                phoneLabel = "Phone number",
                phoneHint = "+1 415 555 0199",
                continueLabel = "Continue",
                footer = "Local-only demo footer.",
                invalidInputNotice = "Invalid",
            ),
            homeShell = HomeShellCopy(
                tabs = HomeShellTabsCopy(
                    chats = "Chats",
                    contacts = "Contacts",
                    settings = "Settings",
                ),
                placeholderNotice = "Placeholder",
            ),
            chatList = ChatListCopy(
                title = "Telegram",
                loading = "Loading",
                emptyTitle = "Empty",
                emptyBody = "Body",
                errorTitle = "Error",
                errorBody = "Body",
            ),
            chatDetail = ChatDetailCopy(
                titleFallback = "Conversation",
                composerPlaceholder = "Message",
                sendLabel = "Send",
                sendFailureNotice = "Failed",
            ),
        ),
        sharedMockData = SharedMockData(
            startup = StartupMockData(defaultAuthenticatedDestination = "Placeholder"),
            homeShell = HomeShellMockData(
                defaultTab = "Chats",
                tabs = listOf(
                    HomeShellTabMock(
                        id = "chats",
                        labelKey = "chats",
                        iconId = "chat-bubble",
                        implementedInSlice = 4,
                    ),
                ),
            ),
            chatList = ChatListMockData(conversations = emptyList()),
            chatDetail = ChatDetailMockData(
                placeholderConversationId = "placeholder",
                messages = emptyList(),
                localSend = LocalSendMockData(
                    initialDeliveryState = "inactive",
                    settledDeliveryState = "inactive",
                    failureDeliveryState = "inactive",
                    clearComposerOnSuccess = false,
                ),
            ),
        ),
        resourceManifest = ResourceManifest(
            sourceRoot = "shared/design/telegram-commercial-mvp/resources",
            copyRule = CopyRule(
                copyIntoFrameworkApp = true,
                preserveFilenames = true,
                allowDirectRuntimeReadFromSharedSource = false,
            ),
            resources = listOf(
                ResourceEntry(
                    id = "app-mark",
                    source = "resources/app-mark.svg",
                    requiredBySlices = listOf(1),
                ),
            ),
        ),
        appMarkSvg = "<svg />".encodeToByteArray(),
    )
}

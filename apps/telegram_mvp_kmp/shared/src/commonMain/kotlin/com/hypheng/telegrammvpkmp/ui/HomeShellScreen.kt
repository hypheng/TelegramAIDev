package com.hypheng.telegrammvpkmp.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp

import com.hypheng.telegrammvpkmp.HomeTab
import com.hypheng.telegrammvpkmp.TelegramUiState
import com.hypheng.telegrammvpkmp.design.DesignAssetPaths

@Composable
fun HomeShellScreen(
    state: TelegramUiState.Home,
    onSelectTab: (HomeTab) -> Unit,
    onLogout: suspend () -> Unit,
) {
    val catalog = state.catalog
    val activeTab = state.activeTab

    Column(modifier = Modifier.fillMaxSize()) {
        TelegramSurfaceScaffold(
            title = catalog.homeShell.tabs.firstOrNull { it.id == activeTab.id }?.label ?: activeTab.name,
            actions = when (activeTab) {
                HomeTab.Chats -> listOf(
                    DesignAssetPaths.icon(catalog.homeShell.actions.searchIconName),
                    DesignAssetPaths.icon(catalog.homeShell.actions.composeIconName),
                )
                HomeTab.Contacts -> listOf(
                    DesignAssetPaths.icon(catalog.homeShell.actions.addIconName),
                )
                HomeTab.Settings -> emptyList()
            },
        ) { padding ->
            when (activeTab) {
                HomeTab.Chats -> ChatsTab(catalog = catalog, modifier = Modifier.padding(padding))
                HomeTab.Contacts -> ContactsTab(catalog = catalog, modifier = Modifier.padding(padding))
                HomeTab.Settings -> SettingsTab(modifier = Modifier.padding(padding))
            }
        }

        NavigationBar {
            catalog.homeShell.tabs.forEachIndexed { index, tab ->
                val homeTab = HomeTab.fromId(tab.id)
                val selected = homeTab == activeTab

                NavigationBarItem(
                    selected = selected,
                    onClick = { onSelectTab(homeTab) },
                    icon = {
                        DesignSvgIcon(
                            assetPath = DesignAssetPaths.icon(tab.iconName),
                            size = 20.dp,
                            tint = if (selected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    },
                    label = { Text(tab.label) },
                )
            }
        }
    }
}

@Composable
@OptIn(ExperimentalMaterial3Api::class)
private fun TelegramSurfaceScaffold(
    title: String,
    actions: List<String>,
    content: @Composable (PaddingValues) -> Unit,
) {
    androidx.compose.material3.Scaffold(
        topBar = {
            androidx.compose.material3.CenterAlignedTopAppBar(
                title = {
                    Text(
                        text = title,
                        style = MaterialTheme.typography.headlineSmall,
                    )
                },
                actions = {
                    actions.forEach { iconPath ->
                        DesignSvgIcon(
                            assetPath = iconPath,
                            modifier = Modifier.padding(horizontal = 6.dp),
                            size = 18.dp,
                            tint = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Spacer(modifier = Modifier.size(8.dp))
                },
            )
        },
        content = content,
    )
}

@Composable
private fun ChatsTab(
    catalog: com.hypheng.telegrammvpkmp.design.DesignCatalog,
    modifier: Modifier = Modifier,
) {
    LazyColumn(
        modifier = modifier.fillMaxSize(),
        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        items(catalog.chatList.conversations) { conversation ->
            Card(
                modifier = Modifier.fillMaxWidth(),
            ) {
                Row(
                    modifier = Modifier.padding(12.dp),
                    verticalAlignment = Alignment.Top,
                ) {
                    AvatarBubble(
                        text = conversation.avatarText,
                        variant = conversation.avatarVariant,
                    )
                    Spacer(modifier = Modifier.size(12.dp))
                    Column(modifier = Modifier.weight(1f)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                        ) {
                            Text(text = conversation.title, style = MaterialTheme.typography.titleMedium)
                            Text(text = conversation.timestampLabel, style = MaterialTheme.typography.labelSmall)
                        }
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = conversation.preview,
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                    Spacer(modifier = Modifier.size(10.dp))
                    ConversationMeta(conversation = conversation)
                }
            }
        }
    }
}

@Composable
private fun ConversationMeta(conversation: com.hypheng.telegrammvpkmp.design.ChatConversation) {
    if (conversation.unreadCount > 0) {
        FilledTonalButton(onClick = {}, contentPadding = PaddingValues(horizontal = 10.dp, vertical = 2.dp)) {
            Text(text = conversation.unreadCount.toString())
        }
    } else if (conversation.metaLabel != null) {
        Text(
            text = conversation.metaLabel,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

@Composable
private fun AvatarBubble(text: String, variant: String) {
    val colors = remember(variant) {
        when (variant) {
            "alt1" -> listOf(Color(0xFFFFA25F), Color(0xFFF06D3F))
            "alt2" -> listOf(Color(0xFF92CF7B), Color(0xFF4CA35F))
            "alt3" -> listOf(Color(0xFFC68CFF), Color(0xFF8E66FF))
            "alt4" -> listOf(Color(0xFF72D9D0), Color(0xFF2EA7A2))
            else -> listOf(Color(0xFF7EBDFF), Color(0xFF3D8FFF))
        }
    }

    Column(
        modifier = Modifier
            .size(54.dp)
            .clip(MaterialTheme.shapes.large)
            .background(Brush.verticalGradient(colors)),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(text = text, color = Color.White)
    }
}

@Composable
private fun ContactsTab(
    catalog: com.hypheng.telegrammvpkmp.design.DesignCatalog,
    modifier: Modifier = Modifier,
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Text(text = catalog.contactsSurface.title, style = MaterialTheme.typography.titleLarge)
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = catalog.contactsSurface.body,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Spacer(modifier = Modifier.height(18.dp))
            catalog.contactsSurface.skeletonLinePercents.forEach { percent ->
                Spacer(
                    modifier = Modifier
                        .fillMaxWidth(percent / 100f)
                        .height(16.dp)
                        .clip(MaterialTheme.shapes.extraLarge)
                        .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f))
                )
                Spacer(modifier = Modifier.height(12.dp))
            }
        }
    }
}

@Composable
private fun SettingsTab(modifier: Modifier = Modifier) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Text(text = "Settings stays lightweight in MVP", style = MaterialTheme.typography.titleLarge)
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "The tab exists to keep the shell close to Telegram. Detailed settings flows are intentionally deferred.",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Spacer(modifier = Modifier.height(18.dp))
            SettingsTile(label = "Notifications")
            SettingsTile(label = "Privacy and Security")
            SettingsTile(label = "Data and Storage")
        }
    }
}

@Composable
private fun SettingsTile(label: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
            .clip(MaterialTheme.shapes.large)
            .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.4f))
            .clickable { },
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            modifier = Modifier.weight(1f).padding(14.dp),
            text = label,
            style = MaterialTheme.typography.bodyLarge,
        )
        Text(
            modifier = Modifier.padding(end = 14.dp),
            text = "›",
            style = MaterialTheme.typography.titleLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}

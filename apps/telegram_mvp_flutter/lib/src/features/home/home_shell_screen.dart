import 'package:flutter/material.dart';

import '../../design/design_assets.dart';
import '../../design/design_catalog.dart';
import '../../widgets/design_svg_icon.dart';
import '../../widgets/telegram_surface_scaffold.dart';
import '../../app/app_controller.dart';
import 'home_tab.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({
    super.key,
    required this.controller,
    required this.activeTab,
  });

  final TelegramAppController controller;
  final HomeTab activeTab;

  @override
  Widget build(BuildContext context) {
    final catalog = controller.catalog ?? DesignCatalog.sample();
    final tab = activeTab;

    return TelegramSurfaceScaffold(
      activeTab: tab,
      title: catalog.homeShell.tabs[tab.index].label,
      actions: switch (tab) {
        HomeTab.chats => [
          _ActionIcon(iconName: catalog.homeShell.actions.searchIconName),
          _ActionIcon(iconName: catalog.homeShell.actions.composeIconName),
          const SizedBox(width: 8),
        ],
        HomeTab.contacts => [
          _ActionIcon(iconName: catalog.homeShell.actions.addIconName),
          const SizedBox(width: 8),
        ],
        HomeTab.settings => const [SizedBox(width: 8)],
      },
      body: switch (tab) {
        HomeTab.chats => _ChatsTab(catalog: catalog),
        HomeTab.contacts => _ContactsTab(catalog: catalog),
        HomeTab.settings => const _SettingsTab(),
      },
      tabs: catalog.homeShell.tabs,
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.iconName});

  final String iconName;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        shape: const CircleBorder(),
        child: InkResponse(
          radius: 22,
          onTap: () {},
          child: SizedBox.square(
            dimension: 36,
            child: Center(
              child: DesignSvgIcon(
                DesignAssetPaths.icon(iconName),
                size: 18,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatsTab extends StatelessWidget {
  const _ChatsTab({required this.catalog});

  final DesignCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final conversations = catalog.chatList.conversations;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return Container(
          decoration: BoxDecoration(
            color: conversation.isActive ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6) : null,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(
                  text: conversation.avatarText,
                  variant: conversation.avatarVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            conversation.timestampLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        conversation.preview,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _ConversationMeta(conversation: conversation),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 6),
      itemCount: conversations.length,
    );
  }
}

class _ConversationMeta extends StatelessWidget {
  const _ConversationMeta({required this.conversation});

  final ChatConversation conversation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (conversation.unreadCount > 0)
          Container(
            constraints: const BoxConstraints(minWidth: 22),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              conversation.unreadCount.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else if (conversation.metaLabel != null)
          Text(
            conversation.metaLabel!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.text, required this.variant});

  final String text;
  final String variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: switch (variant) {
            'alt1' => const [Color(0xFFFFA25F), Color(0xFFF06D3F)],
            'alt2' => const [Color(0xFF92CF7B), Color(0xFF4CA35F)],
            'alt3' => const [Color(0xFFC68CFF), Color(0xFF8E66FF)],
            'alt4' => const [Color(0xFF72D9D0), Color(0xFF2EA7A2)],
            _ => const [Color(0xFF7EBDFF), Color(0xFF3D8FFF)],
          },
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ContactsTab extends StatelessWidget {
  const _ContactsTab({required this.catalog});

  final DesignCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final surface = catalog.contactsSurface;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surface.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  surface.body,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                ...surface.skeletonLinePercents.map(
                  (percent) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GhostLine(widthFactor: percent / 100),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings stays lightweight in MVP',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  'The tab exists to keep the shell close to Telegram. Detailed settings flows are intentionally deferred.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                const _SettingsTile(label: 'Notifications'),
                const _SettingsTile(label: 'Privacy and Security'),
                const _SettingsTile(label: 'Data and Storage'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _GhostLine extends StatelessWidget {
  const _GhostLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFFEBF1F6), Color(0xFFF8FBFF), Color(0xFFEBF1F6)],
            ),
          ),
        ),
      ),
    );
  }
}

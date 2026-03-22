import 'package:flutter/material.dart';

import '../../shared/assets/shared_models.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({
    super.key,
    required this.tabs,
    required this.homeShellCopy,
    required this.currentTabId,
    required this.chatListTitle,
    required this.onSelectTab,
    required this.child,
  });

  final List<HomeShellTabData> tabs;
  final HomeShellCopy homeShellCopy;
  final String currentTabId;
  final String chatListTitle;
  final ValueChanged<String> onSelectTab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String title = currentTabId == 'chats'
        ? chatListTitle
        : homeShellCopy.labelForTabId(currentTabId);

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: false),
      body: SafeArea(child: child),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) => onSelectTab(tabs[index].id),
          destinations: tabs
              .map(
                (HomeShellTabData tab) => NavigationDestination(
                  icon: Icon(_iconForTab(tab.iconId)),
                  label: homeShellCopy.labelForTabId(tab.id),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  int get _selectedIndex {
    final int index = tabs.indexWhere(
      (HomeShellTabData tab) => tab.id == currentTabId,
    );
    return index < 0 ? 0 : index;
  }

  IconData _iconForTab(String iconId) {
    switch (iconId) {
      case 'contacts':
        return Icons.people_alt_outlined;
      case 'settings':
        return Icons.settings_outlined;
      case 'chat-bubble':
      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }
}

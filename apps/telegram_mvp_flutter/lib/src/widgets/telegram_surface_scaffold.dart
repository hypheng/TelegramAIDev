import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/design_assets.dart';
import '../design/design_catalog.dart';
import '../features/home/home_tab.dart';
import 'design_svg_icon.dart';

class TelegramSurfaceScaffold extends StatelessWidget {
  const TelegramSurfaceScaffold({
    super.key,
    required this.activeTab,
    required this.title,
    required this.actions,
    required this.body,
    required this.tabs,
  });

  final HomeTab activeTab;
  final String title;
  final List<Widget> actions;
  final Widget body;
  final List<HomeTabDesign> tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.04,
          ),
        ),
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: activeTab.index,
        onDestinationSelected: (index) {
          if (index == activeTab.index) {
            return;
          }

          final destinations = tabs
              .map(
                (tab) => tab.id == 'chats'
                    ? HomeTab.chats.routePath
                    : tab.id == 'contacts'
                    ? HomeTab.contacts.routePath
                    : HomeTab.settings.routePath,
              )
              .toList(growable: false);
          context.go(destinations[index]);
        },
        destinations: List<NavigationDestination>.generate(tabs.length, (
          index,
        ) {
          final tab = tabs[index];
          final isSelected = index == activeTab.index;
          final selectedColor = Theme.of(context).colorScheme.primary;
          final unselectedColor = Theme.of(
            context,
          ).colorScheme.onSurfaceVariant;
          final iconColor = isSelected ? selectedColor : unselectedColor;

          return NavigationDestination(
            icon: DesignSvgIcon(
              DesignAssetPaths.icon(tab.iconName),
              size: 20,
              color: iconColor,
            ),
            selectedIcon: DesignSvgIcon(
              DesignAssetPaths.icon(tab.iconName),
              size: 20,
              color: selectedColor,
            ),
            label: tab.label,
          );
        }),
      ),
    );
  }
}

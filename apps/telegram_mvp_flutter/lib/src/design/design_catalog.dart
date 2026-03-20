import 'dart:convert';

import 'package:flutter/services.dart';

import 'design_assets.dart';

class DesignCatalog {
  const DesignCatalog({
    required this.login,
    required this.homeShell,
    required this.chatList,
    required this.contactsSurface,
  });

  final LoginDesign login;
  final HomeShellDesign homeShell;
  final ChatListDesign chatList;
  final ContactsSurfaceDesign contactsSurface;

  factory DesignCatalog.fromJson(Map<String, Object?> json) {
    return DesignCatalog(
      login: LoginDesign.fromJson(_map(json['login'])),
      homeShell: HomeShellDesign.fromJson(_map(json['homeShell'])),
      chatList: ChatListDesign.fromJson(_map(json['chatList'])),
      contactsSurface: ContactsSurfaceDesign.fromJson(
        _map(json['contactsSurface']),
      ),
    );
  }

  static DesignCatalog sample() {
    return const DesignCatalog(
      login: LoginDesign(
        brandTitle: 'Telegram Demo',
        demoPhoneNumber: '+1 415 555 0199',
        invalidPhoneNumber: '+1 415 55',
        submitLabel: 'Continue',
        hint:
            'No real SMS or backend. Keep the flow credible, but lightweight.',
        footer:
            'The first successful login routes into the home shell with the Chats tab active.',
        validationMessage:
            'Please enter a complete demo phone number before continuing.',
        validationHint:
            'Inline validation should be calm, visible, and intentional.',
        validationFooter:
            'Use concise feedback and keep the rest of the form stable when validation fails.',
      ),
      homeShell: HomeShellDesign(
        defaultTabId: 'chats',
        tabs: [
          HomeTabDesign(
            id: 'chats',
            label: 'Chats',
            iconName: 'tab-chats',
            mvpDepth: 'core',
          ),
          HomeTabDesign(
            id: 'contacts',
            label: 'Contacts',
            iconName: 'tab-contacts',
            mvpDepth: 'surface-only',
          ),
          HomeTabDesign(
            id: 'settings',
            label: 'Settings',
            iconName: 'tab-settings',
            mvpDepth: 'surface-only',
          ),
        ],
        actions: HomeActions(
          searchIconName: 'search',
          composeIconName: 'compose',
          addIconName: 'add',
        ),
      ),
      chatList: ChatListDesign(
        conversations: [
          ChatConversation(
            id: 'alex-mercer',
            title: 'Alex Mercer',
            avatarText: 'A',
            avatarVariant: 'default',
            timestampLabel: '09:42',
            preview:
                'The design pass looks solid. Ship the home shell with tabs visible in MVP.',
            unreadCount: 2,
            isActive: true,
            metaLabel: null,
          ),
          ChatConversation(
            id: 'team-sync',
            title: 'Team Sync',
            avatarText: 'T',
            avatarVariant: 'alt1',
            timestampLabel: '08:15',
            preview:
                'Need parity notes for CJMP, KMP, and flutter after the next round.',
            unreadCount: 0,
            isActive: false,
            metaLabel: 'PINNED',
          ),
          ChatConversation(
            id: 'mina-park',
            title: 'Mina Park',
            avatarText: 'M',
            avatarVariant: 'alt2',
            timestampLabel: 'Yesterday',
            preview:
                'We can keep Contacts and Settings shallow for now, but they should be present.',
            unreadCount: 1,
            isActive: false,
            metaLabel: null,
          ),
          ChatConversation(
            id: 'product-review',
            title: 'Product Review',
            avatarText: 'P',
            avatarVariant: 'alt3',
            timestampLabel: 'Tue',
            preview:
                'Customer demo quality matters more than feature count for the benchmark.',
            unreadCount: 0,
            isActive: false,
            metaLabel: 'MUTED',
          ),
          ChatConversation(
            id: 'support-ops',
            title: 'Support Ops',
            avatarText: 'S',
            avatarVariant: 'alt4',
            timestampLabel: 'Mon',
            preview:
                'The loading, empty, and send-pending states should feel production-credible.',
            unreadCount: 0,
            isActive: false,
            metaLabel: null,
          ),
        ],
        loadingState: LoadingState(
          title: 'Loading conversations',
          body:
              'Use coherent, non-janky loading states instead of blank scaffolds.',
          skeletonRowCount: 3,
        ),
        emptyState: EmptyState(
          title: 'No chats yet',
          body:
              'The empty state should still feel like a product surface, not a broken screen.',
        ),
      ),
      contactsSurface: ContactsSurfaceDesign(
        title: 'Contacts stays lightweight in MVP',
        body:
            'The tab exists to keep the product surface close to Telegram. Detailed contacts management is intentionally deferred.',
        skeletonLinePercents: [88, 73, 81],
      ),
    );
  }
}

abstract class DesignCatalogRepository {
  Future<DesignCatalog> load();
}

class LoginDesign {
  const LoginDesign({
    required this.brandTitle,
    required this.demoPhoneNumber,
    required this.invalidPhoneNumber,
    required this.submitLabel,
    required this.hint,
    required this.footer,
    required this.validationMessage,
    required this.validationHint,
    required this.validationFooter,
  });

  final String brandTitle;
  final String demoPhoneNumber;
  final String invalidPhoneNumber;
  final String submitLabel;
  final String hint;
  final String footer;
  final String validationMessage;
  final String validationHint;
  final String validationFooter;

  factory LoginDesign.fromJson(Map<String, Object?> json) {
    return LoginDesign(
      brandTitle: _string(json['brandTitle'], 'Telegram Demo'),
      demoPhoneNumber: _string(json['demoPhoneNumber'], ''),
      invalidPhoneNumber: _string(json['invalidPhoneNumber'], ''),
      submitLabel: _string(json['submitLabel'], 'Continue'),
      hint: _string(json['hint'], ''),
      footer: _string(json['footer'], ''),
      validationMessage: _string(json['validationMessage'], ''),
      validationHint: _string(json['validationHint'], ''),
      validationFooter: _string(json['validationFooter'], ''),
    );
  }
}

class HomeShellDesign {
  const HomeShellDesign({
    required this.defaultTabId,
    required this.tabs,
    required this.actions,
  });

  final String defaultTabId;
  final List<HomeTabDesign> tabs;
  final HomeActions actions;

  factory HomeShellDesign.fromJson(Map<String, Object?> json) {
    return HomeShellDesign(
      defaultTabId: _string(json['defaultTab'], 'chats'),
      tabs: _list(json['tabs'])
          .map((value) => HomeTabDesign.fromJson(_map(value)))
          .toList(growable: false),
      actions: HomeActions.fromJson(_map(json['actions'])),
    );
  }
}

class HomeTabDesign {
  const HomeTabDesign({
    required this.id,
    required this.label,
    required this.iconName,
    required this.mvpDepth,
  });

  final String id;
  final String label;
  final String iconName;
  final String mvpDepth;

  factory HomeTabDesign.fromJson(Map<String, Object?> json) {
    return HomeTabDesign(
      id: _string(json['id'], ''),
      label: _string(json['label'], ''),
      iconName: _string(json['icon'], ''),
      mvpDepth: _string(json['mvpDepth'], ''),
    );
  }
}

class HomeActions {
  const HomeActions({
    required this.searchIconName,
    required this.composeIconName,
    required this.addIconName,
  });

  final String searchIconName;
  final String composeIconName;
  final String addIconName;

  factory HomeActions.fromJson(Map<String, Object?> json) {
    return HomeActions(
      searchIconName: _string(json['searchIcon'], 'search'),
      composeIconName: _string(json['composeIcon'], 'compose'),
      addIconName: _string(json['addIcon'], 'add'),
    );
  }
}

class ChatListDesign {
  const ChatListDesign({
    required this.conversations,
    required this.loadingState,
    required this.emptyState,
  });

  final List<ChatConversation> conversations;
  final LoadingState loadingState;
  final EmptyState emptyState;

  factory ChatListDesign.fromJson(Map<String, Object?> json) {
    return ChatListDesign(
      conversations: _list(json['conversations'])
          .map((value) => ChatConversation.fromJson(_map(value)))
          .toList(growable: false),
      loadingState: LoadingState.fromJson(_map(json['loadingState'])),
      emptyState: EmptyState.fromJson(_map(json['emptyState'])),
    );
  }
}

class LoadingState {
  const LoadingState({
    required this.title,
    required this.body,
    required this.skeletonRowCount,
  });

  final String title;
  final String body;
  final int skeletonRowCount;

  factory LoadingState.fromJson(Map<String, Object?> json) {
    return LoadingState(
      title: _string(json['title'], ''),
      body: _string(json['body'], ''),
      skeletonRowCount: _int(json['skeletonRowCount'], 0),
    );
  }
}

class EmptyState {
  const EmptyState({required this.title, required this.body});

  final String title;
  final String body;

  factory EmptyState.fromJson(Map<String, Object?> json) {
    return EmptyState(
      title: _string(json['title'], ''),
      body: _string(json['body'], ''),
    );
  }
}

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.title,
    required this.avatarText,
    required this.avatarVariant,
    required this.timestampLabel,
    required this.preview,
    required this.unreadCount,
    required this.isActive,
    required this.metaLabel,
  });

  final String id;
  final String title;
  final String avatarText;
  final String avatarVariant;
  final String timestampLabel;
  final String preview;
  final int unreadCount;
  final bool isActive;
  final String? metaLabel;

  factory ChatConversation.fromJson(Map<String, Object?> json) {
    return ChatConversation(
      id: _string(json['id'], ''),
      title: _string(json['title'], ''),
      avatarText: _string(json['avatarText'], ''),
      avatarVariant: _string(json['avatarVariant'], 'default'),
      timestampLabel: _string(json['timestampLabel'], ''),
      preview: _string(json['preview'], ''),
      unreadCount: _int(json['unreadCount'], 0),
      isActive: _bool(json['isActive'], false),
      metaLabel: _nullableString(json['metaLabel']),
    );
  }
}

class ContactsSurfaceDesign {
  const ContactsSurfaceDesign({
    required this.title,
    required this.body,
    required this.skeletonLinePercents,
  });

  final String title;
  final String body;
  final List<int> skeletonLinePercents;

  factory ContactsSurfaceDesign.fromJson(Map<String, Object?> json) {
    return ContactsSurfaceDesign(
      title: _string(json['title'], ''),
      body: _string(json['body'], ''),
      skeletonLinePercents: _list(json['skeletonLinePercents'])
          .map((value) => _int(value, 0))
          .toList(growable: false),
    );
  }
}

class AssetDesignCatalogRepository implements DesignCatalogRepository {
  const AssetDesignCatalogRepository();

  @override
  Future<DesignCatalog> load() async {
    final jsonString = await rootBundle.loadString(
      DesignAssetPaths.mockDataJson,
    );
    final decoded = jsonDecode(jsonString);
    final jsonMap = _map(decoded);
    return DesignCatalog.fromJson(jsonMap);
  }
}

class MemoryDesignCatalogRepository implements DesignCatalogRepository {
  const MemoryDesignCatalogRepository(this.catalog);

  final DesignCatalog catalog;

  @override
  Future<DesignCatalog> load() async => catalog;
}

Map<String, Object?> _map(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return value.cast<String, Object?>();
  }
  return <String, Object?>{};
}

List<Object?> _list(Object? value) {
  if (value is List<Object?>) {
    return value;
  }
  if (value is List) {
    return value.cast<Object?>();
  }
  return const <Object?>[];
}

String _string(Object? value, String fallback) {
  return value is String ? value : fallback;
}

String? _nullableString(Object? value) {
  return value is String ? value : null;
}

int _int(Object? value, int fallback) {
  return value is int ? value : fallback;
}

bool _bool(Object? value, bool fallback) {
  return value is bool ? value : fallback;
}

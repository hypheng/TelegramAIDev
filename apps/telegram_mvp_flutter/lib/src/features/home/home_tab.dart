enum HomeTab { chats, contacts, settings }

extension HomeTabIndex on HomeTab {
  int get index => switch (this) {
    HomeTab.chats => 0,
    HomeTab.contacts => 1,
    HomeTab.settings => 2,
  };

  String get routePath => switch (this) {
    HomeTab.chats => '/home/chats',
    HomeTab.contacts => '/home/contacts',
    HomeTab.settings => '/home/settings',
  };
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/design_catalog.dart';
import '../session/session_store.dart';
import '../features/bootstrap/bootstrap_screen.dart';
import '../features/home/home_shell_screen.dart';
import '../features/home/home_tab.dart';
import '../features/login/login_screen.dart';
import 'app_controller.dart';

class TelegramMvpApp extends StatefulWidget {
  const TelegramMvpApp({
    super.key,
    SessionStore? sessionStore,
    DesignCatalogRepository? designCatalogRepository,
  }) : sessionStore = sessionStore ?? const SharedPreferencesSessionStore(),
       designCatalogRepository =
           designCatalogRepository ?? const AssetDesignCatalogRepository();

  final SessionStore sessionStore;
  final DesignCatalogRepository designCatalogRepository;

  @override
  State<TelegramMvpApp> createState() => _TelegramMvpAppState();
}

class _TelegramMvpAppState extends State<TelegramMvpApp> {
  late final TelegramAppController _controller;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _controller = TelegramAppController(
      sessionStore: widget.sessionStore,
      designCatalogRepository: widget.designCatalogRepository,
    );
    _router = _createRouter();
    _controller.bootstrap();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: _controller,
      redirect: (context, state) {
        final path = state.uri.path;
        final controller = _controller;

        if (controller.isBootstrapping) {
          return path == '/' ? null : '/';
        }

        if (!controller.hasSession) {
          return path == '/login' ? null : '/login';
        }

        if (path == '/' || path == '/login') {
          return '/home/chats';
        }

        if (!path.startsWith('/home')) {
          return '/home/chats';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BootstrapScreen(controller: _controller),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(controller: _controller),
        ),
        GoRoute(
          path: '/home/chats',
          builder: (context, state) => HomeShellScreen(
            controller: _controller,
            activeTab: HomeTab.chats,
          ),
        ),
        GoRoute(
          path: '/home/contacts',
          builder: (context, state) => HomeShellScreen(
            controller: _controller,
            activeTab: HomeTab.contacts,
          ),
        ),
        GoRoute(
          path: '/home/settings',
          builder: (context, state) => HomeShellScreen(
            controller: _controller,
            activeTab: HomeTab.settings,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2D9CFF),
      brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );

    return MaterialApp.router(
      title: 'Telegram Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F8FC),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: colorScheme.surface.withValues(alpha: 0.98),
          indicatorColor: colorScheme.primaryContainer,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D9CFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0E1621),
      ),
      routerConfig: _router,
    );
  }
}

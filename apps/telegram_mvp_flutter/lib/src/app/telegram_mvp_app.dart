import 'package:flutter/material.dart';

import '../design/startup_catalog.dart';
import '../features/bootstrap/bootstrap_screen.dart';
import '../features/login/login_screen.dart';
import 'app_controller.dart';

class TelegramMvpApp extends StatefulWidget {
  const TelegramMvpApp({
    super.key,
    StartupCatalogRepository? startupCatalogRepository,
  }) : startupCatalogRepository =
           startupCatalogRepository ?? const AssetStartupCatalogRepository();

  final StartupCatalogRepository startupCatalogRepository;

  @override
  State<TelegramMvpApp> createState() => _TelegramMvpAppState();
}

class _TelegramMvpAppState extends State<TelegramMvpApp> {
  late final TelegramAppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TelegramAppController(
      startupCatalogRepository: widget.startupCatalogRepository,
    );
    _controller.bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2496FF),
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2496FF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Telegram Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: const Color(0xFFF5F8FC),
        cardTheme: CardThemeData(
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: const Color(0xFF0C1521),
      ),
      home: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isBootstrapping) {
            return BootstrapScreen(controller: _controller);
          }
          return LoginScreen(controller: _controller);
        },
      ),
    );
  }
}

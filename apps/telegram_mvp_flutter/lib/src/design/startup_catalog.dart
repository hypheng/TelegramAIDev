import 'dart:convert';

import 'package:flutter/services.dart';

class StartupCatalog {
  const StartupCatalog({required this.bootstrap, required this.login});

  final BootstrapCopy bootstrap;
  final LoginCopy login;

  factory StartupCatalog.fromJson(Map<String, Object?> json) {
    return StartupCatalog(
      bootstrap: BootstrapCopy.fromJson(_map(json['bootstrap'])),
      login: LoginCopy.fromJson(_map(json['login'])),
    );
  }

  factory StartupCatalog.fallback() {
    return const StartupCatalog(
      bootstrap: BootstrapCopy(
        title: 'Loading Telegram Demo…',
        body:
            'Preparing the app shell before the first-launch handoff into sign-in.',
      ),
      login: LoginCopy(
        brandTitle: 'Telegram Demo',
        headline: 'Start with your phone number',
        body:
            'Issue #1 only covers startup routing and a credible first-launch handoff into sign-in.',
        phoneLabel: 'Phone number',
        phoneHint: '+1 415 555 0199',
        continueLabel: 'Continue',
        footer: 'Demo verification ships in issue #2.',
      ),
    );
  }
}

class BootstrapCopy {
  const BootstrapCopy({required this.title, required this.body});

  final String title;
  final String body;

  factory BootstrapCopy.fromJson(Map<String, Object?> json) {
    return BootstrapCopy(
      title: _string(json['title'], 'Loading Telegram Demo…'),
      body: _string(json['body'], ''),
    );
  }
}

class LoginCopy {
  const LoginCopy({
    required this.brandTitle,
    required this.headline,
    required this.body,
    required this.phoneLabel,
    required this.phoneHint,
    required this.continueLabel,
    required this.footer,
  });

  final String brandTitle;
  final String headline;
  final String body;
  final String phoneLabel;
  final String phoneHint;
  final String continueLabel;
  final String footer;

  factory LoginCopy.fromJson(Map<String, Object?> json) {
    return LoginCopy(
      brandTitle: _string(json['brandTitle'], 'Telegram Demo'),
      headline: _string(json['headline'], ''),
      body: _string(json['body'], ''),
      phoneLabel: _string(json['phoneLabel'], 'Phone number'),
      phoneHint: _string(json['phoneHint'], ''),
      continueLabel: _string(json['continueLabel'], 'Continue'),
      footer: _string(json['footer'], ''),
    );
  }
}

abstract class StartupCatalogRepository {
  Future<StartupCatalog> load();
}

class AssetStartupCatalogRepository implements StartupCatalogRepository {
  const AssetStartupCatalogRepository({AssetBundle? assetBundle})
    : _assetBundle = assetBundle;

  static const String assetPath = 'assets/mock-data.json';

  final AssetBundle? _assetBundle;

  @override
  Future<StartupCatalog> load() async {
    final assetBundle = _assetBundle ?? rootBundle;
    final raw = await assetBundle.loadString(assetPath);
    final decoded = json.decode(raw);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Startup catalog must decode to a JSON map.');
    }
    return StartupCatalog.fromJson(decoded);
  }
}

class MemoryStartupCatalogRepository implements StartupCatalogRepository {
  const MemoryStartupCatalogRepository(this.catalog);

  final StartupCatalog catalog;

  @override
  Future<StartupCatalog> load() async => catalog;
}

class FailingStartupCatalogRepository implements StartupCatalogRepository {
  const FailingStartupCatalogRepository([this.error = const FormatException()]);

  final Object error;

  @override
  Future<StartupCatalog> load() async {
    throw error;
  }
}

Map<String, Object?> _map(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (key, entry) => MapEntry(key.toString(), entry as Object?),
    );
  }
  return const <String, Object?>{};
}

String _string(Object? value, String fallback) {
  return value is String && value.isNotEmpty ? value : fallback;
}

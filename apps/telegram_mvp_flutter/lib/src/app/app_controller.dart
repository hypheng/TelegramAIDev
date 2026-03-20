import 'package:flutter/foundation.dart';

import '../design/startup_catalog.dart';

class TelegramAppController extends ChangeNotifier {
  TelegramAppController({
    required StartupCatalogRepository startupCatalogRepository,
  }) : _startupCatalogRepository = startupCatalogRepository;

  final StartupCatalogRepository _startupCatalogRepository;

  bool _isBootstrapping = true;
  String? _bootstrapNotice;
  StartupCatalog _catalog = StartupCatalog.fallback();

  bool get isBootstrapping => _isBootstrapping;
  String? get bootstrapNotice => _bootstrapNotice;
  StartupCatalog get catalog => _catalog;

  Future<void> bootstrap() async {
    String? bootstrapNotice;
    StartupCatalog catalog = _catalog;

    try {
      catalog = await _startupCatalogRepository.load();
    } catch (_) {
      catalog = StartupCatalog.fallback();
      bootstrapNotice =
          'Design copy failed to load. The app is using embedded fallback content.';
    }

    _catalog = catalog;
    _bootstrapNotice = bootstrapNotice;
    _isBootstrapping = false;
    notifyListeners();
  }
}

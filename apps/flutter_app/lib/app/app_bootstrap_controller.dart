import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../shared/assets/shared_asset_repository.dart';
import '../shared/assets/shared_models.dart';

enum BootstrapPhase { loading, noSession, failure }

class AppBootstrapController extends ChangeNotifier {
  AppBootstrapController({required SharedAssetRepository repository})
    : _repository = repository {
    load();
  }

  final SharedAssetRepository _repository;

  BootstrapPhase _phase = BootstrapPhase.loading;
  BootstrapCopy _bootstrapCopy = BootstrapCopy.fallback();
  SharedStartupConfig? _startupConfig;
  String? _failureMessage;

  BootstrapPhase get phase => _phase;
  BootstrapCopy get bootstrapCopy => _bootstrapCopy;
  SharedStartupConfig? get startupConfig => _startupConfig;
  String? get failureMessage => _failureMessage;

  Future<void> load() async {
    _phase = BootstrapPhase.loading;
    _failureMessage = null;
    notifyListeners();

    try {
      final BootstrapCopy? loadedBootstrapCopy = await _repository
          .tryLoadBootstrapCopy();
      if (loadedBootstrapCopy != null) {
        _bootstrapCopy = loadedBootstrapCopy;
        notifyListeners();
      }

      final SharedStartupConfig startupConfig = await _repository
          .loadStartupConfig();
      _bootstrapCopy = startupConfig.bootstrapCopy;
      _startupConfig = startupConfig;
      _phase = BootstrapPhase.noSession;
      notifyListeners();
    } catch (error, stackTrace) {
      log(
        'Failed to load startup configuration.',
        name: 'flutter.telegram.bootstrap',
        error: error,
        stackTrace: stackTrace,
      );
      _failureMessage = _bootstrapCopy.failureNotice;
      _phase = BootstrapPhase.failure;
      notifyListeners();
    }
  }
}

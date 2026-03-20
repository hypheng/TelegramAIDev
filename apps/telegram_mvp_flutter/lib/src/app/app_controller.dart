import 'package:flutter/foundation.dart';

import '../design/design_catalog.dart';
import '../session/session_store.dart';

class TelegramAppController extends ChangeNotifier {
  TelegramAppController({
    required SessionStore sessionStore,
    required DesignCatalogRepository designCatalogRepository,
  }) : _sessionStore = sessionStore,
       _designCatalogRepository = designCatalogRepository;

  final SessionStore _sessionStore;
  final DesignCatalogRepository _designCatalogRepository;

  bool _isBootstrapping = true;
  bool _hasSession = false;
  bool _isSigningIn = false;
  String? _phoneNumber;
  String? _loginError;
  DesignCatalog? _catalog;

  bool get isBootstrapping => _isBootstrapping;
  bool get hasSession => _hasSession;
  bool get isSigningIn => _isSigningIn;
  String? get phoneNumber => _phoneNumber;
  String? get loginError => _loginError;
  DesignCatalog? get catalog => _catalog;

  Future<void> bootstrap() async {
    final sessionFuture = _sessionStore.read();
    final catalogFuture = _designCatalogRepository.load();

    final sessionSnapshot = await sessionFuture;
    final catalog = await catalogFuture;

    _hasSession = sessionSnapshot.hasSession;
    _phoneNumber = sessionSnapshot.phoneNumber;
    _catalog = catalog;
    _isBootstrapping = false;
    notifyListeners();
  }

  Future<bool> signIn(String phoneNumber) async {
    final normalized = phoneNumber.trim();
    if (!_isValidDemoPhoneNumber(normalized)) {
      _loginError =
          _catalog?.login.validationMessage ??
          'Please enter a complete demo phone number before continuing.';
      notifyListeners();
      return false;
    }

    _isSigningIn = true;
    _loginError = null;
    notifyListeners();

    await _sessionStore.saveDemoSession(normalized);

    _hasSession = true;
    _phoneNumber = normalized;
    _isSigningIn = false;
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    await _sessionStore.clear();
    _hasSession = false;
    _phoneNumber = null;
    notifyListeners();
  }

  void clearLoginError() {
    if (_loginError == null) {
      return;
    }
    _loginError = null;
    notifyListeners();
  }

  static bool _isValidDemoPhoneNumber(String value) {
    final digitCount = value.replaceAll(RegExp(r'[^0-9]'), '').length;
    return digitCount >= 10;
  }
}

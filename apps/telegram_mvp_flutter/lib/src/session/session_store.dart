import 'package:shared_preferences/shared_preferences.dart';

class SessionSnapshot {
  const SessionSnapshot({required this.hasSession, this.phoneNumber});

  final bool hasSession;
  final String? phoneNumber;
}

abstract class SessionStore {
  Future<SessionSnapshot> read();
  Future<void> saveDemoSession(String phoneNumber);
  Future<void> clear();
}

class SharedPreferencesSessionStore implements SessionStore {
  const SharedPreferencesSessionStore();

  static const String _hasSessionKey = 'telegram_mvp_has_session';
  static const String _phoneKey = 'telegram_mvp_phone';

  @override
  Future<SessionSnapshot> read() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionSnapshot(
      hasSession: prefs.getBool(_hasSessionKey) ?? false,
      phoneNumber: prefs.getString(_phoneKey),
    );
  }

  @override
  Future<void> saveDemoSession(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSessionKey, true);
    await prefs.setString(_phoneKey, phoneNumber);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasSessionKey);
    await prefs.remove(_phoneKey);
  }
}

class MemorySessionStore implements SessionStore {
  MemorySessionStore({bool hasSession = false, this.phoneNumber})
    : _hasSession = hasSession;

  bool _hasSession;
  String? phoneNumber;

  @override
  Future<SessionSnapshot> read() async {
    return SessionSnapshot(hasSession: _hasSession, phoneNumber: phoneNumber);
  }

  @override
  Future<void> saveDemoSession(String phoneNumber) async {
    _hasSession = true;
    this.phoneNumber = phoneNumber;
  }

  @override
  Future<void> clear() async {
    _hasSession = false;
    phoneNumber = null;
  }
}

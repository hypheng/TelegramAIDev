import 'package:flutter_test/flutter_test.dart';
import 'package:telegram_mvp_flutter/src/app/telegram_mvp_app.dart';
import 'package:telegram_mvp_flutter/src/design/design_catalog.dart';
import 'package:telegram_mvp_flutter/src/session/session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TelegramMvpApp buildApp({required SessionStore sessionStore}) {
    return TelegramMvpApp(
      sessionStore: sessionStore,
      designCatalogRepository: MemoryDesignCatalogRepository(
        DesignCatalog.sample(),
      ),
    );
  }

  testWidgets('first launch shows bootstrap then routes to login', (
    tester,
  ) async {
    final sessionStore = MemorySessionStore();

    await tester.pumpWidget(buildApp(sessionStore: sessionStore));

    expect(find.text('Checking local session…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Demo Sign In'), findsOneWidget);
    expect(find.text('Telegram Demo'), findsWidgets);
    expect(find.text('Chats'), findsNothing);
  });

  testWidgets('relaunch with session routes directly to chats', (tester) async {
    final sessionStore = MemorySessionStore(
      hasSession: true,
      phoneNumber: '+1 415 555 0199',
    );

    await tester.pumpWidget(buildApp(sessionStore: sessionStore));

    expect(find.text('Checking local session…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Alex Mercer'), findsOneWidget);
    expect(find.text('Demo Sign In'), findsNothing);
    expect(find.text('Contacts'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('login continues into the home shell and stores session', (
    tester,
  ) async {
    final sessionStore = MemorySessionStore();

    await tester.pumpWidget(buildApp(sessionStore: sessionStore));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    final snapshot = await sessionStore.read();
    expect(snapshot.hasSession, isTrue);
    expect(snapshot.phoneNumber, '+1 415 555 0199');
    expect(find.text('Alex Mercer'), findsOneWidget);
  });
}

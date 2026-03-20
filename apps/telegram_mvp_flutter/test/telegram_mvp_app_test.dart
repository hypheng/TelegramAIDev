import 'package:flutter_test/flutter_test.dart';
import 'package:telegram_mvp_flutter/src/app/telegram_mvp_app.dart';
import 'package:telegram_mvp_flutter/src/design/startup_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first launch shows bootstrap then routes to login', (
    tester,
  ) async {
    await tester.pumpWidget(
      TelegramMvpApp(
        startupCatalogRepository: MemoryStartupCatalogRepository(
          StartupCatalog.fallback(),
        ),
      ),
    );

    expect(find.text('Loading Telegram Demo…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Telegram Demo'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('catalog load failure falls back instead of stalling bootstrap', (
    tester,
  ) async {
    await tester.pumpWidget(
      const TelegramMvpApp(
        startupCatalogRepository: FailingStartupCatalogRepository(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Telegram Demo'), findsOneWidget);
    expect(find.textContaining('embedded fallback content'), findsOneWidget);
    expect(find.text('Loading Telegram Demo…'), findsNothing);
  });
}

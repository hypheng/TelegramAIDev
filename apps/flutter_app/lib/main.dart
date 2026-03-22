import 'package:flutter/widgets.dart';

import 'app/telegram_demo_app.dart';
import 'shared/assets/shared_asset_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(TelegramDemoApp(repository: RootBundleSharedAssetRepository()));
}

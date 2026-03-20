import 'package:flutter/material.dart';

import '../../design/design_assets.dart';
import '../../widgets/design_svg_icon.dart';
import '../../app/app_controller.dart';

class BootstrapScreen extends StatelessWidget {
  const BootstrapScreen({super.key, required this.controller});

  final TelegramAppController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DesignSvgIcon(DesignAssetPaths.telegramBrandBadge, size: 80),
            const SizedBox(height: 20),
            Text(
              controller.catalog?.login.brandTitle ?? 'Telegram Demo',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Checking local session…',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/assets/shared_models.dart';

class LoginHandoffScreen extends StatelessWidget {
  const LoginHandoffScreen({super.key, this.loginCopy, this.appMarkAssetPath});

  final LoginCopy? loginCopy;
  final String? appMarkAssetPath;

  @override
  Widget build(BuildContext context) {
    final LoginCopy copy = loginCopy ?? LoginCopy.fallback();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (appMarkAssetPath != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: SvgPicture.asset(
                              appMarkAssetPath!,
                              width: 72,
                              height: 72,
                            ),
                          ),
                        ),
                      Text(
                        copy.brandTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        copy.headline,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        copy.body,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            copy.footer,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

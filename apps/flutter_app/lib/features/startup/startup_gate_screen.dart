import 'package:flutter/material.dart';

import '../../app/app_bootstrap_controller.dart';
import '../../shared/assets/shared_models.dart';

class StartupGateScreen extends StatelessWidget {
  const StartupGateScreen({
    super.key,
    required this.phase,
    required this.bootstrapCopy,
    required this.failureMessage,
    required this.onRetry,
  });

  final BootstrapPhase phase;
  final BootstrapCopy bootstrapCopy;
  final String? failureMessage;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final bool isFailure = phase == BootstrapPhase.failure;

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
                    children: <Widget>[
                      Icon(
                        isFailure
                            ? Icons.warning_amber_rounded
                            : Icons.telegram,
                        size: 56,
                        color: isFailure
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        bootstrapCopy.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isFailure
                            ? failureMessage ?? bootstrapCopy.failureNotice
                            : bootstrapCopy.body,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      if (isFailure)
                        ElevatedButton(
                          onPressed: onRetry,
                          child: const Text('Retry startup'),
                        )
                      else
                        const CircularProgressIndicator(),
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

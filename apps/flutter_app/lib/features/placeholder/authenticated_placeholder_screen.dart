import 'package:flutter/material.dart';

class AuthenticatedPlaceholderScreen extends StatelessWidget {
  const AuthenticatedPlaceholderScreen({
    super.key,
    required this.placeholderNotice,
  });

  final String placeholderNotice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    placeholderNotice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
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

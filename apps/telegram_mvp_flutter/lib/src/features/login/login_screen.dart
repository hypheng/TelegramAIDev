import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/design_assets.dart';
import '../../widgets/design_svg_icon.dart';
import '../../app/app_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});

  final TelegramAppController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.controller.catalog?.login.demoPhoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await widget.controller.signIn(_phoneController.text);
    if (!mounted) {
      return;
    }
    if (success) {
      context.go('/home/chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final catalog = widget.controller.catalog;
        final login = catalog?.login;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: [
                        const DesignSvgIcon(
                          DesignAssetPaths.telegramBrandBadge,
                          size: 72,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          login?.brandTitle ?? 'Telegram Demo',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Demo Sign In',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) =>
                                widget.controller.clearLoginError(),
                            onSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              helperText: login?.hint,
                              errorText: widget.controller.loginError,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: widget.controller.isSigningIn
                                ? null
                                : _submit,
                            child: widget.controller.isSigningIn
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(login?.submitLabel ?? 'Continue'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            login?.validationHint ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.controller.loginError == null
                                ? login?.footer ?? ''
                                : login?.validationFooter ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

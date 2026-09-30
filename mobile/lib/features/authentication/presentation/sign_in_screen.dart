import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pantribox_mobile/app/theme/pantribox_spacing.dart';
import 'package:pantribox_mobile/shared/extensions/pantribox_theme_extension.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_card.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_primary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_page_app_bar.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_screen_header.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_secondary_button.dart';
import 'package:pantribox_mobile/shared/widgets/pantribox_status_chip.dart';
import 'package:pantribox_mobile/core/storage/secure_storage_service.dart';
import 'package:pantribox_mobile/features/authentication/application/authentication_repository.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      final token = await ref
          .read(authenticationRepositoryProvider)
          .signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
      await ref.read(secureStorageProvider).writeToken(token);
      if (mounted) context.go('/home');
    } on DioException catch (error) {
      setState(
        () => _errorMessage = error.response?.statusCode == 401
            ? 'Email or password is incorrect.'
            : 'Unable to sign in right now. Please try again.',
      );
    } on AuthenticationException catch (error) {
      setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.pantriBoxTheme;

    return Scaffold(
      appBar: const PantriBoxPageAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PantriBoxSpacing.lg),
          children: [
            const PantriBoxScreenHeader(
              eyebrow: 'Welcome back',
              title: 'Sign in',
              subtitle: 'Use your PantriBox development account to continue.',
            ),
            const SizedBox(height: PantriBoxSpacing.xl),
            const PantriBoxStatusChip(
              label: 'Secure session ready',
              tone: PantriBoxStatusTone.info,
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            PantriBoxCard(
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'name@example.com',
                    ),
                  ),
                  SizedBox(height: PantriBoxSpacing.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PantriBoxSpacing.lg),
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: palette.error),
              ),
              const SizedBox(height: PantriBoxSpacing.sm),
            ],
            PantriBoxPrimaryButton(
              label: _isSubmitting ? 'Signing in...' : 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: _isSubmitting ? null : _submit,
            ),
            const SizedBox(height: PantriBoxSpacing.sm),
            PantriBoxSecondaryButton(
              label: 'Forgot password',
              icon: Icons.lock_reset_outlined,
              onPressed: () {},
            ),
            TextButton(
              onPressed: () => context.push('/sign-up'),
              child: Text(
                'Need an account? Sign up',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: palette.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

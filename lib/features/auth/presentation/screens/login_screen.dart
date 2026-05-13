import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../auth_providers.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authProvider.notifier)
        .signIn(_emailCtrl.text, _passwordCtrl.text);
    final state = ref.read(authProvider);
    if (state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(state.error.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final state = ref.watch(authProvider);

    return AuthScaffold(
      title: t.loginTitle,
      subtitle: t.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: t.email,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
              ),
              validator: (v) => Validators.email(
                v,
                t.validationRequired,
                t.validationEmail,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: t.password,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ),
              validator: (v) => Validators.minLength(
                v,
                6,
                t.validationRequired,
                t.validationMinChars(6),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/forgot'),
                child: Text(t.forgotPassword),
              ),
            ),
            const SizedBox(height: 8),
            GradientButton(
              loading: state.isLoading,
              onPressed: _submit,
              label: t.signIn,
              icon: Icons.login_rounded,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.noAccount),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text(t.createAccount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

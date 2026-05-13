import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../auth_providers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authProvider.notifier)
        .changePassword(_currentCtrl.text, _newCtrl.text);
    final state = ref.read(authProvider);
    if (!mounted) return;
    final t = AppLocalizations.of(context);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(state.error.toString()),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.passwordChanged)),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.changePassword)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _currentCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t.currentPassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                  ),
                  validator: (v) =>
                      Validators.required(v, t.validationRequired),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t.newPassword,
                    prefixIcon: const Icon(Icons.lock_reset_rounded),
                  ),
                  validator: (v) => Validators.minLength(
                    v,
                    6,
                    t.validationRequired,
                    t.validationMinChars(6),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: t.confirmPassword,
                    prefixIcon: const Icon(Icons.check_rounded),
                  ),
                  validator: (v) {
                    if (v != _newCtrl.text) return t.validationMatch;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                GradientButton(
                  loading: state.isLoading,
                  onPressed: _submit,
                  label: t.changePassword,
                  icon: Icons.check_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

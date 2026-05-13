import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_currency.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          _Section(title: t.appearance, child: GlassCard(
            padding: EdgeInsets.zero,
            child: RadioGroup<ThemeMode>(
              groupValue: settings.themeMode,
              onChanged: (m) =>
                  ref.read(settingsProvider.notifier).setTheme(m!),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    title: Text(t.themeDark),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    title: Text(t.themeLight),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: Text(t.themeSystem),
                  ),
                ],
              ),
            ),
          )),
          _Section(title: t.language, child: GlassCard(
            padding: EdgeInsets.zero,
            child: RadioGroup<String>(
              groupValue: settings.locale.languageCode,
              onChanged: (v) {
                if (v == null) return;
                ref.read(settingsProvider.notifier).setLocale(Locale(v));
              },
              child: Column(
                children: [
                  for (final loc in const [
                    Locale('en'),
                    Locale('uk'),
                    Locale('pl'),
                  ])
                    RadioListTile<String>(
                      value: loc.languageCode,
                      title: Text(_languageLabel(loc.languageCode)),
                    ),
                ],
              ),
            ),
          )),
          _Section(title: t.currency, child: GlassCard(
            padding: EdgeInsets.zero,
            child: RadioGroup<AppCurrency>(
              groupValue: settings.currency,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setCurrency(v!),
              child: Column(
                children: [
                  for (final c in AppCurrency.values)
                    RadioListTile<AppCurrency>(
                      value: c,
                      title: Text('${c.symbol}  ${c.code}'),
                    ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'uk':
        return 'Українська';
      case 'pl':
        return 'Polski';
      case 'en':
      default:
        return 'English';
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
          ),
          child,
        ],
      ),
    );
  }
}

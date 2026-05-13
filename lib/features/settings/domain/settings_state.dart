import 'package:flutter/material.dart';

import '../../../core/constants/app_currency.dart';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.currency,
    required this.hideBalances,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final AppCurrency currency;
  final bool hideBalances;

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    AppCurrency? currency,
    bool? hideBalances,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
      hideBalances: hideBalances ?? this.hideBalances,
    );
  }

  static const SettingsState defaults = SettingsState(
    themeMode: ThemeMode.dark,
    locale: Locale('en'),
    currency: AppCurrency.usd,
    hideBalances: false,
  );
}

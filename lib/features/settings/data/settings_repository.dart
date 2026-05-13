import 'package:flutter/material.dart';

import '../../../core/constants/app_currency.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage.dart';
import '../domain/settings_state.dart';

class SettingsRepository {
  SettingsRepository(this._storage);

  final LocalStorage _storage;

  SettingsState load() {
    final themeStr = _storage.getString(StorageKeys.themeMode);
    final localeStr = _storage.getString(StorageKeys.locale);
    final currencyStr = _storage.getString(StorageKeys.currency);
    final hideBalances = _storage.getBool(StorageKeys.hideBalances) ?? false;

    return SettingsState(
      themeMode: _themeFromString(themeStr),
      locale: _localeFromString(localeStr),
      currency: AppCurrency.fromCode(currencyStr),
      hideBalances: hideBalances,
    );
  }

  Future<void> saveTheme(ThemeMode mode) =>
      _storage.setString(StorageKeys.themeMode, mode.name);

  Future<void> saveLocale(Locale locale) =>
      _storage.setString(StorageKeys.locale, locale.languageCode);

  Future<void> saveCurrency(AppCurrency currency) =>
      _storage.setString(StorageKeys.currency, currency.code);

  Future<void> saveHideBalances(bool value) =>
      _storage.setBool(StorageKeys.hideBalances, value);

  ThemeMode _themeFromString(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  Locale _localeFromString(String? raw) {
    const supported = {'en', 'uk', 'pl'};
    if (raw != null && supported.contains(raw)) return Locale(raw);
    return const Locale('en');
  }
}

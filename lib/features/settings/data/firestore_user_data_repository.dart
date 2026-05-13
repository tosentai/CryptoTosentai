import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_currency.dart';
import '../domain/settings_state.dart';

class UserProfileSnapshot {
  const UserProfileSnapshot({
    required this.settings,
    required this.displayName,
  });

  final SettingsState settings;
  final String? displayName;
}

class FirestoreUserDataRepository {
  FirestoreUserDataRepository(this._fs, this._uid);

  final FirebaseFirestore _fs;
  final String _uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _fs.collection('users').doc(_uid);

  Future<UserProfileSnapshot?> load() async {
    final snap = await _doc.get();
    if (!snap.exists) return null;
    final data = snap.data() ?? const <String, dynamic>{};

    return UserProfileSnapshot(
      settings: SettingsState(
        themeMode: _parseTheme(data['themeMode'] as String?),
        locale: _parseLocale(data['locale'] as String?),
        currency: AppCurrency.fromCode(data['currency'] as String?),
        hideBalances: data['hideBalances'] as bool? ?? false,
      ),
      displayName: data['displayName'] as String?,
    );
  }

  Future<void> saveSettings(SettingsState s) => _doc.set({
    'themeMode': s.themeMode.name,
    'locale': s.locale.languageCode,
    'currency': s.currency.code,
    'hideBalances': s.hideBalances,
  }, SetOptions(merge: true));

  Future<void> saveDisplayName(String name) =>
      _doc.set({'displayName': name}, SetOptions(merge: true));

  Future<void> wipe() async {
    final portfolio = await _doc.collection('portfolio').get();
    final batch = _fs.batch();
    for (final d in portfolio.docs) {
      batch.delete(d.reference);
    }
    batch.delete(_doc);
    await batch.commit();
  }

  ThemeMode _parseTheme(String? raw) {
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

  Locale _parseLocale(String? raw) {
    const supported = {'en', 'uk', 'pl'};
    if (raw != null && supported.contains(raw)) return Locale(raw);
    return const Locale('en');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_currency.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/local_storage.dart';
import '../../features/auth/presentation/auth_providers.dart';
import '../../features/settings/data/firestore_user_data_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../features/settings/domain/settings_state.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('Override in main()');
});

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(localStorageProvider));
});

final userDataRepositoryProvider = Provider<FirestoreUserDataRepository?>((
  ref,
) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  if (uid == null) return null;
  return FirestoreUserDataRepository(ref.watch(firestoreProvider), uid);
});

final settingsProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
      return SettingsController(
        localRepo: ref.watch(settingsRepositoryProvider),
        cloudRepo: ref.watch(userDataRepositoryProvider),
      );
    });

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController({
    required SettingsRepository localRepo,
    required FirestoreUserDataRepository? cloudRepo,
  }) : _local = localRepo,
       _cloud = cloudRepo,
       super(localRepo.load()) {
    _hydrateFromCloud();
  }

  final SettingsRepository _local;
  final FirestoreUserDataRepository? _cloud;

  Future<void> _hydrateFromCloud() async {
    final cloud = _cloud;
    if (cloud == null) return;
    try {
      final snap = await cloud.load();
      if (snap == null) {
        await cloud.saveSettings(state);
        return;
      }
      state = snap.settings;
      await _local.saveTheme(state.themeMode);
      await _local.saveLocale(state.locale);
      await _local.saveCurrency(state.currency);
    } catch (_) {}
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _local.saveTheme(mode);
    await _cloud?.saveSettings(state);
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _local.saveLocale(locale);
    await _cloud?.saveSettings(state);
  }

  Future<void> setCurrency(AppCurrency currency) async {
    state = state.copyWith(currency: currency);
    await _local.saveCurrency(currency);
    await _cloud?.saveSettings(state);
  }

  Future<void> setHideBalances(bool value) async {
    state = state.copyWith(hideBalances: value);
    await _local.saveHideBalances(value);
    await _cloud?.saveSettings(state);
  }
}

final currencyProvider = Provider<AppCurrency>((ref) {
  return ref.watch(settingsProvider.select((s) => s.currency));
});

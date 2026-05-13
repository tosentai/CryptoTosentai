import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/app_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../settings/data/firestore_user_data_repository.dart';
import '../data/profile_repository.dart';

class ProfileState {
  const ProfileState({this.avatarPath, this.displayName});
  final String? avatarPath;
  final String? displayName;

  ProfileState copyWith({
    String? avatarPath,
    String? displayName,
    bool clearAvatar = false,
  }) {
    return ProfileState(
      avatarPath: clearAvatar ? null : (avatarPath ?? this.avatarPath),
      displayName: displayName ?? this.displayName,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  return ProfileRepository(ref.watch(localStorageProvider), userId: uid);
});

final profileProvider = StateNotifierProvider<ProfileController, ProfileState>((
  ref,
) {
  return ProfileController(
    localRepo: ref.watch(profileRepositoryProvider),
    cloudRepo: ref.watch(userDataRepositoryProvider),
  );
});

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController({
    required ProfileRepository localRepo,
    required FirestoreUserDataRepository? cloudRepo,
  }) : _local = localRepo,
       _cloud = cloudRepo,
       super(
         ProfileState(
           avatarPath: localRepo.avatarPath,
           displayName: localRepo.displayName,
         ),
       ) {
    _hydrateFromCloud();
  }

  final ProfileRepository _local;
  final FirestoreUserDataRepository? _cloud;

  Future<void> _hydrateFromCloud() async {
    final cloud = _cloud;
    if (cloud == null) return;
    try {
      final snap = await cloud.load();
      final cloudName = snap?.displayName;
      if (cloudName != null && cloudName != state.displayName) {
        state = state.copyWith(displayName: cloudName);
        await _local.setDisplayName(cloudName);
      }
    } catch (_) {}
  }

  Future<void> setAvatar(String? path) async {
    state = state.copyWith(avatarPath: path, clearAvatar: path == null);
    await _local.setAvatarPath(path);
  }

  Future<void> setName(String name) async {
    state = state.copyWith(displayName: name);
    await _local.setDisplayName(name);
    try {
      await _cloud?.saveDisplayName(name);
    } catch (_) {}
  }
}

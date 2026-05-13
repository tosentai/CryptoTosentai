import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage.dart';

class ProfileRepository {
  ProfileRepository(this._storage, {this.userId});
  final LocalStorage _storage;
  final String? userId;

  String get _avatarKey =>
      '${StorageKeys.avatarPath}_${userId ?? 'guest'}';
  String get _nameKey =>
      '${StorageKeys.displayName}_${userId ?? 'guest'}';

  String? get avatarPath => _storage.getString(_avatarKey);
  String? get displayName => _storage.getString(_nameKey);

  Future<void> setAvatarPath(String? path) async {
    if (path == null) {
      await _storage.remove(_avatarKey);
    } else {
      await _storage.setString(_avatarKey, path);
    }
  }

  Future<void> setDisplayName(String name) =>
      _storage.setString(_nameKey, name);
}

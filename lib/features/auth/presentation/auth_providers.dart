import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firebase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(ref.watch(firebaseAuthProvider));
});

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final authProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repo) : super(const AsyncValue.data(null));

  final AuthRepository _repo;

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.signIn(
          email: email,
          password: password,
        ));
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.signUp(
          email: email,
          password: password,
        ));
  }

  Future<void> sendReset(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.sendPasswordResetEmail(email));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.signOut());
  }

  Future<void> changePassword(String current, String newPwd) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.changePassword(
          currentPassword: current,
          newPassword: newPwd,
        ));
  }

  Future<void> deleteAccount(String currentPassword) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _repo.deleteAccount(currentPassword: currentPassword));
  }
}

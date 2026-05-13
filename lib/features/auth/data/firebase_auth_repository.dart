import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  AuthUser? _map(User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  AuthUser? get currentUser => _map(_auth.currentUser);

  @override
  Stream<AuthUser?> authStateChanges() =>
      _auth.authStateChanges().map(_map);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _map(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw const AuthFailure(AuthFailureType.unknown);
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _map(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw const AuthFailure(AuthFailureType.unknown);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthFailure(AuthFailureType.userNotFound);
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  @override
  Future<void> deleteAccount({required String currentPassword}) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthFailure(AuthFailureType.userNotFound);
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw const AuthFailure(AuthFailureType.unknown);
    }
  }

  AuthFailure _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
      case 'wrong-password':
      case 'invalid-credential':
        return AuthFailure(AuthFailureType.invalidCredentials, e.message);
      case 'email-already-in-use':
        return AuthFailure(AuthFailureType.emailAlreadyInUse, e.message);
      case 'weak-password':
        return AuthFailure(AuthFailureType.weakPassword, e.message);
      case 'user-not-found':
        return AuthFailure(AuthFailureType.userNotFound, e.message);
      case 'network-request-failed':
        return AuthFailure(AuthFailureType.network, e.message);
      default:
        return AuthFailure(AuthFailureType.unknown, e.message);
    }
  }
}

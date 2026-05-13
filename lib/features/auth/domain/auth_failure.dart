enum AuthFailureType {
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  userNotFound,
  network,
  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.type, [this.message]);

  final AuthFailureType type;
  final String? message;

  @override
  String toString() => 'AuthFailure($type, $message)';
}

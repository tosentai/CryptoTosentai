class Validators {
  Validators._();

  static String? required(String? v, String required) {
    if (v == null || v.trim().isEmpty) return required;
    return null;
  }

  static String? email(String? v, String required, String invalid) {
    if (v == null || v.trim().isEmpty) return required;
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!r.hasMatch(v.trim())) return invalid;
    return null;
  }

  static String? minLength(
    String? v,
    int n,
    String required,
    String tooShort,
  ) {
    if (v == null || v.isEmpty) return required;
    if (v.length < n) return tooShort;
    return null;
  }
}

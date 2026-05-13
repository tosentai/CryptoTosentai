import 'package:crypto_tosentai/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty', () {
      expect(Validators.email('', 'req', 'inv'), 'req');
      expect(Validators.email(null, 'req', 'inv'), 'req');
    });

    test('rejects malformed', () {
      expect(Validators.email('foo', 'req', 'inv'), 'inv');
      expect(Validators.email('foo@', 'req', 'inv'), 'inv');
      expect(Validators.email('foo@bar', 'req', 'inv'), 'inv');
    });

    test('accepts valid email', () {
      expect(Validators.email('a@b.co', 'req', 'inv'), null);
    });
  });

  group('Validators.minLength', () {
    test('rejects too short', () {
      expect(Validators.minLength('abc', 6, 'req', 'short'), 'short');
    });

    test('accepts exact length', () {
      expect(Validators.minLength('abcdef', 6, 'req', 'short'), null);
    });
  });
}

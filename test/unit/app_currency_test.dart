import 'package:crypto_tosentai/core/constants/app_currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCurrency', () {
    test('fromCode returns matching enum case-insensitively', () {
      expect(AppCurrency.fromCode('USD'), AppCurrency.usd);
      expect(AppCurrency.fromCode('uah'), AppCurrency.uah);
      expect(AppCurrency.fromCode('Pln'), AppCurrency.pln);
    });

    test('fromCode falls back to USD for unknown', () {
      expect(AppCurrency.fromCode(null), AppCurrency.usd);
      expect(AppCurrency.fromCode('XYZ'), AppCurrency.usd);
    });

    test('apiCode is lowercase (CoinGecko expectation)', () {
      for (final c in AppCurrency.values) {
        expect(c.apiCode, c.apiCode.toLowerCase());
      }
    });
  });
}

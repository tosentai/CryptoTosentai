import 'package:crypto_tosentai/core/constants/app_currency.dart';
import 'package:crypto_tosentai/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Formatters', () {
    test('percent prefixes positive sign and 2 decimals', () {
      expect(Formatters.percent(3.456), '+3.46%');
      expect(Formatters.percent(-0.1), '-0.10%');
    });

    test('percent handles null', () {
      expect(Formatters.percent(null), '—');
    });

    test('price uses currency symbol', () {
      final out = Formatters.price(1234.56, AppCurrency.eur);
      expect(out.contains('€'), isTrue);
    });

    test('compact uses compact notation', () {
      final out = Formatters.compact(1500000, AppCurrency.usd);
      expect(out.contains('M') || out.contains('mln') || out.contains('млн'),
          isTrue);
    });
  });
}

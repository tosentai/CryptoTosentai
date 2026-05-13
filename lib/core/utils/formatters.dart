import 'package:intl/intl.dart';

import '../constants/app_currency.dart';

class Formatters {
  Formatters._();

  static String price(num? value, AppCurrency currency, {int? decimals}) {
    if (value == null) return '—';
    final v = value.toDouble();
    final d = decimals ?? _autoDecimals(v);
    final formatter = NumberFormat.currency(
      symbol: '${currency.symbol} ',
      decimalDigits: d,
    );
    return formatter.format(v);
  }

  static String compact(num? value, AppCurrency currency) {
    if (value == null) return '—';
    final formatter = NumberFormat.compactCurrency(
      symbol: '${currency.symbol} ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String percent(num? value) {
    if (value == null) return '—';
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  static String number(num? value, {int decimals = 4}) {
    if (value == null) return '—';
    final formatter = NumberFormat.decimalPattern();
    formatter.maximumFractionDigits = decimals;
    return formatter.format(value);
  }

  static String mask([String pattern = '••••••']) => pattern;

  static int _autoDecimals(double value) {
    final abs = value.abs();
    if (abs == 0) return 2;
    if (abs >= 1000) return 0;
    if (abs >= 1) return 2;
    if (abs >= 0.01) return 4;
    return 6;
  }
}

enum AppCurrency {
  usd('usd', 'USD', '\$'),
  eur('eur', 'EUR', '€'),
  uah('uah', 'UAH', '₴'),
  pln('pln', 'PLN', 'zł');

  const AppCurrency(this.apiCode, this.code, this.symbol);

  final String apiCode;
  final String code;
  final String symbol;

  static AppCurrency fromCode(String? code) {
    return AppCurrency.values.firstWhere(
      (c) => c.code == code?.toUpperCase(),
      orElse: () => AppCurrency.usd,
    );
  }
}

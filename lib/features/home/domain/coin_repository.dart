import '../../../core/constants/app_currency.dart';
import 'coin.dart';

abstract class CoinRepository {
  Future<List<Coin>> fetchTopCoins({
    required AppCurrency currency,
    int perPage = 100,
    int page = 1,
  });

  Future<List<double>> fetchSparkline({
    required String coinId,
    required AppCurrency currency,
    int days = 7,
  });
}

import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';

class CoinRemoteDataSource {
  CoinRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<dynamic>> getMarkets({
    required String vsCurrency,
    int perPage = 100,
    int page = 1,
  }) async {
    final res = await _dio.get(
      ApiConstants.coinsMarkets,
      queryParameters: {
        'vs_currency': vsCurrency,
        'order': 'market_cap_desc',
        'per_page': perPage,
        'page': page,
        'sparkline': true,
        'price_change_percentage': '24h',
      },
    );
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getMarketChart({
    required String coinId,
    required String vsCurrency,
    int days = 7,
  }) async {
    final res = await _dio.get(
      '${ApiConstants.coinDetails}/$coinId${ApiConstants.marketChart}',
      queryParameters: {
        'vs_currency': vsCurrency,
        'days': days,
      },
    );
    return res.data as Map<String, dynamic>;
  }
}

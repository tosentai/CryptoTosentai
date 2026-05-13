import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/constants/app_currency.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage.dart';
import '../domain/coin.dart';
import '../domain/coin_repository.dart';
import 'coin_remote_data_source.dart';

class CoinRepositoryImpl implements CoinRepository {
  CoinRepositoryImpl({
    required this.remote,
    required this.storage,
  });

  final CoinRemoteDataSource remote;
  final LocalStorage storage;

  static const _cacheTtl = Duration(minutes: 2);

  @override
  Future<List<Coin>> fetchTopCoins({
    required AppCurrency currency,
    int perPage = 100,
    int page = 1,
  }) async {
    try {
      final raw = await remote.getMarkets(
        vsCurrency: currency.apiCode,
        perPage: perPage,
        page: page,
      );
      final coins = raw
          .cast<Map<String, dynamic>>()
          .map(Coin.fromMarketJson)
          .toList(growable: false);
      await _writeCache(currency, coins);
      return coins;
    } on DioException {
      final cached = _readCache(currency, ignoreTtl: true);
      if (cached != null) return cached;
      rethrow;
    }
  }

  List<Coin>? _readCache(AppCurrency currency, {bool ignoreTtl = false}) {
    final raw = storage.getString('${StorageKeys.cachedCoins}_${currency.code}');
    final tsRaw =
        storage.getString('${StorageKeys.cachedCoinsTimestamp}_${currency.code}');
    if (raw == null) return null;
    if (!ignoreTtl && tsRaw != null) {
      final ts = DateTime.tryParse(tsRaw);
      if (ts != null && DateTime.now().difference(ts) > _cacheTtl) {
        return null;
      }
    }
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(Coin.fromMarketJson).toList(growable: false);
  }

  Future<void> _writeCache(AppCurrency currency, List<Coin> coins) async {
    await storage.setString(
      '${StorageKeys.cachedCoins}_${currency.code}',
      jsonEncode(coins.map((c) => c.toJson()).toList()),
    );
    await storage.setString(
      '${StorageKeys.cachedCoinsTimestamp}_${currency.code}',
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<double>> fetchSparkline({
    required String coinId,
    required AppCurrency currency,
    int days = 7,
  }) async {
    final data = await remote.getMarketChart(
      coinId: coinId,
      vsCurrency: currency.apiCode,
      days: days,
    );
    final prices = (data['prices'] as List?) ?? const [];
    return prices
        .map<double>((p) => ((p as List)[1] as num).toDouble())
        .toList(growable: false);
  }
}

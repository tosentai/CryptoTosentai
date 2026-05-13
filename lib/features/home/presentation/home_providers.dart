import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/app_providers.dart';
import '../data/coin_remote_data_source.dart';
import '../data/coin_repository_impl.dart';
import '../domain/coin.dart';
import '../domain/coin_repository.dart';

final coinRemoteDataSourceProvider = Provider<CoinRemoteDataSource>((ref) {
  return CoinRemoteDataSource(ref.watch(dioClientProvider).dio);
});

final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  return CoinRepositoryImpl(
    remote: ref.watch(coinRemoteDataSourceProvider),
    storage: ref.watch(localStorageProvider),
  );
});

enum CoinSort { marketCap, price, change24h }

final coinSortProvider = StateProvider<CoinSort>((_) => CoinSort.marketCap);
final coinSearchProvider = StateProvider<String>((_) => '');

final cryptoProvider = FutureProvider<List<Coin>>((ref) async {
  final currency = ref.watch(currencyProvider);
  final repo = ref.watch(coinRepositoryProvider);
  return repo.fetchTopCoins(currency: currency);
});

final filteredCoinsProvider = Provider<List<Coin>>((ref) {
  final coinsAsync = ref.watch(cryptoProvider);
  final query = ref.watch(coinSearchProvider).trim().toLowerCase();
  final sort = ref.watch(coinSortProvider);

  return coinsAsync.maybeWhen(
    data: (coins) {
      final list = query.isEmpty
          ? coins.toList()
          : coins
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(query) ||
                      c.symbol.toLowerCase().contains(query),
                )
                .toList();
      switch (sort) {
        case CoinSort.marketCap:
          list.sort((a, b) => b.marketCap.compareTo(a.marketCap));
          break;
        case CoinSort.price:
          list.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
          break;
        case CoinSort.change24h:
          list.sort(
            (a, b) => b.priceChangePercentage24h.compareTo(
              a.priceChangePercentage24h,
            ),
          );
          break;
      }
      return list;
    },
    orElse: () => const <Coin>[],
  );
});

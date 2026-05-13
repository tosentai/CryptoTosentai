import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/app_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../home/domain/coin.dart';
import '../../home/presentation/home_providers.dart';
import '../data/firestore_portfolio_repository.dart';
import '../domain/portfolio_asset.dart';
import '../domain/portfolio_repository.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.uid;
  if (uid == null) return const NoopPortfolioRepository();
  return FirestorePortfolioRepository(ref.watch(firestoreProvider), uid);
});

final portfolioProvider = StateNotifierProvider<PortfolioController,
    AsyncValue<List<PortfolioAsset>>>((ref) {
  return PortfolioController(ref.watch(portfolioRepositoryProvider));
});

class PortfolioController
    extends StateNotifier<AsyncValue<List<PortfolioAsset>>> {
  PortfolioController(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  final PortfolioRepository _repo;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.load());
  }

  Future<void> add(PortfolioAsset asset) async {
    await _repo.add(asset);
    await _load();
  }

  Future<void> update(PortfolioAsset asset) async {
    await _repo.update(asset);
    await _load();
  }

  Future<void> remove(String id) async {
    await _repo.remove(id);
    await _load();
  }

  Future<void> refresh() => _load();
}

class PortfolioSummary {
  const PortfolioSummary({
    required this.invested,
    required this.currentValue,
    required this.pnl,
    required this.pnlPercent,
  });

  final double invested;
  final double currentValue;
  final double pnl;
  final double pnlPercent;

  static const empty =
      PortfolioSummary(invested: 0, currentValue: 0, pnl: 0, pnlPercent: 0);
}

final portfolioSummaryProvider = Provider<PortfolioSummary>((ref) {
  final assetsAsync = ref.watch(portfolioProvider);
  final coinsAsync = ref.watch(cryptoProvider);

  if (!assetsAsync.hasValue || !coinsAsync.hasValue) {
    return PortfolioSummary.empty;
  }

  final coinsById = <String, Coin>{
    for (final c in coinsAsync.value!) c.id: c,
  };

  double invested = 0;
  double current = 0;
  for (final a in assetsAsync.value!) {
    invested += a.invested();
    final price = coinsById[a.coinId]?.currentPrice ?? a.buyPrice;
    current += a.amount * price;
  }
  final pnl = current - invested;
  final pnlPercent = invested == 0 ? 0.0 : (pnl / invested) * 100;
  return PortfolioSummary(
    invested: invested,
    currentValue: current,
    pnl: pnl,
    pnlPercent: pnlPercent,
  );
});

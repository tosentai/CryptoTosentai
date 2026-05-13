import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../home/domain/coin.dart';
import '../../../home/presentation/home_providers.dart';
import '../../../portfolio/presentation/widgets/asset_form_sheet.dart';
import '../details_providers.dart';
import '../widgets/price_chart.dart';

class CoinDetailsScreen extends ConsumerWidget {
  const CoinDetailsScreen({super.key, required this.coinId});

  final String coinId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    final coinsAsync = ref.watch(cryptoProvider);
    final sparkAsync = ref.watch(sparklineProvider(coinId));

    ref
        .read(localStorageProvider)
        .setString(StorageKeys.lastViewedCoin, coinId);

    final coin = coinsAsync.maybeWhen(
      data: (coins) =>
          coins.firstWhere((c) => c.id == coinId, orElse: () => coins.first),
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(),
      body: coin == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'coin-${coin.id}',
                        child: Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: coin.image.isEmpty
                              ? const Icon(Icons.currency_bitcoin)
                              : CachedNetworkImage(imageUrl: coin.image),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              coin.symbol,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.price(coin.currentPrice, currency),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                      ),
                      const SizedBox(width: 12),
                      _ChangeBadge(value: coin.priceChangePercentage24h),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.detailsChart7d,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        sparkAsync.when(
                          data: (points) => PriceChart(points: points),
                          loading: () =>
                              const ShimmerBox(height: 220, radius: 16),
                          error: (e, _) => SizedBox(
                            height: 220,
                            child: ErrorView(
                              message: t.errorNetwork,
                              onRetry: () =>
                                  ref.invalidate(sparklineProvider(coinId)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _StatsGrid(coin: coin),
                  const SizedBox(height: 24),
                  GradientButton(
                    onPressed: () => _openAddSheet(context, coin),
                    label: t.detailsAddToPortfolio,
                    icon: Icons.add_chart_rounded,
                  ),
                ],
              ),
            ),
    );
  }

  void _openAddSheet(BuildContext context, Coin coin) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AssetFormSheet(coin: coin),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (positive ? AppColors.positive : AppColors.negative).withValues(
          alpha: 0.16,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        Formatters.percent(value),
        style: TextStyle(
          color: positive ? AppColors.positive : AppColors.negative,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatsGrid extends ConsumerWidget {
  const _StatsGrid({required this.coin});
  final Coin coin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final currency = ref.watch(currencyProvider);
    final items = <(String, String)>[
      (t.detailsAth, Formatters.price(coin.ath, currency)),
      (t.detailsAtl, Formatters.price(coin.atl, currency)),
      (t.detailsVolume, Formatters.compact(coin.totalVolume, currency)),
      (t.marketCap, Formatters.compact(coin.marketCap, currency)),
      (
        t.detailsCircSupply,
        '${Formatters.number(coin.circulatingSupply, decimals: 0)} ${coin.symbol}',
      ),
    ];
    return GlassCard(
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  items[i].$1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  items[i].$2,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            if (i != items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
          ],
        ],
      ),
    );
  }
}

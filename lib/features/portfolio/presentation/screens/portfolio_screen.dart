import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../home/domain/coin.dart';
import '../../../home/presentation/home_providers.dart';
import '../../domain/portfolio_asset.dart';
import '../portfolio_providers.dart';
import '../widgets/asset_form_sheet.dart';
import '../widgets/summary_card.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final assetsAsync = ref.watch(portfolioProvider);
    final coinsAsync = ref.watch(cryptoProvider);
    final summary = ref.watch(portfolioSummaryProvider);
    final currency = ref.watch(currencyProvider);
    final hideBalances =
        ref.watch(settingsProvider.select((s) => s.hideBalances));

    final coinsById = <String, Coin>{
      for (final c in coinsAsync.valueOrNull ?? const <Coin>[]) c.id: c,
    };

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(portfolioProvider.notifier).refresh();
            ref.invalidate(cryptoProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Text(t.portfolioTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      )),
              const SizedBox(height: 16),
              SummaryCard(
                summary: summary,
                currency: currency,
                hideBalances: hideBalances,
              ),
              const SizedBox(height: 24),
              assetsAsync.when(
                data: (assets) {
                  if (assets.isEmpty) {
                    return _Empty(t: t);
                  }
                  return Column(
                    children: [
                      for (final a in assets)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AssetTile(
                            asset: a,
                            coin: coinsById[a.coinId],
                            hideBalances: hideBalances,
                            onTap: () =>
                                _openEdit(context, a, coinsById[a.coinId]),
                            onLongPress: () =>
                                _confirmDelete(context, ref, a),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Text('$e'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: assetsAsync.maybeWhen(
        data: (a) => a.isEmpty
            ? null
            : FloatingActionButton.extended(
                backgroundColor: AppColors.emerald,
                foregroundColor: Colors.white,
                onPressed: () => context.push('/'),
                label: Text(t.addAsset),
                icon: const Icon(Icons.add_rounded),
              ),
        orElse: () => null,
      ),
    );
  }

  void _openEdit(BuildContext context, PortfolioAsset asset, Coin? coin) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AssetFormSheet(coin: coin, existing: asset),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PortfolioAsset asset,
  ) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(asset.name),
        content: Text('${t.delete}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(portfolioProvider.notifier).remove(asset.id);
    }
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.t});
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 56),
          const SizedBox(height: 12),
          Text(t.portfolioEmpty,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(t.portfolioEmptyHint,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _AssetTile extends ConsumerWidget {
  const _AssetTile({
    required this.asset,
    required this.coin,
    required this.onTap,
    required this.onLongPress,
    this.hideBalances = false,
  });

  final PortfolioAsset asset;
  final Coin? coin;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool hideBalances;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final price = coin?.currentPrice ?? asset.buyPrice;
    final pnl = asset.pnl(price);
    final positive = pnl >= 0;
    String fmt(double v) =>
        hideBalances ? '••••••' : Formatters.price(v, currency);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: asset.image.isEmpty
                  ? const Icon(Icons.currency_bitcoin)
                  : CachedNetworkImage(imageUrl: asset.image),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${asset.name} (${asset.symbol})',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    hideBalances
                        ? '••• • ${fmt(asset.buyPrice)}'
                        : '${Formatters.number(asset.amount)} • ${fmt(asset.buyPrice)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(fmt(asset.currentValue(price)),
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  hideBalances
                      ? '••••••'
                      : '${positive ? '+' : ''}${Formatters.price(pnl, currency)}',
                  style: TextStyle(
                    color:
                        positive ? AppColors.positive : AppColors.negative,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

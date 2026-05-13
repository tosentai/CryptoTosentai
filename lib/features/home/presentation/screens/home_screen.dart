import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../home_providers.dart';
import '../widgets/coin_tile.dart';
import '../widgets/coin_tile_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final coinsAsync = ref.watch(cryptoProvider);
    final filtered = ref.watch(filteredCoinsProvider);
    final currency = ref.watch(currencyProvider);
    final searchCtrl = TextEditingController(
      text: ref.read(coinSearchProvider),
    );
    searchCtrl.selection = TextSelection.collapsed(
      offset: searchCtrl.text.length,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      t.homeTitle,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showSortSheet(context, ref),
                    icon: const Icon(Icons.sort_rounded),
                    tooltip: t.sortBy,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                controller: searchCtrl,
                onChanged: (v) =>
                    ref.read(coinSearchProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: t.search,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.invalidate(cryptoProvider),
                child: coinsAsync.when(
                  data: (_) => ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final coin = filtered[index];
                      return CoinTile(
                        key: ValueKey(coin.id),
                        coin: coin,
                        currency: currency,
                        onTap: () => context.push('/coin/${coin.id}'),
                      );
                    },
                  ),
                  loading: () => ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (_, _) => const CoinTileSkeleton(),
                  ),
                  error: (e, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ErrorView(
                          message: t.errorNetwork,
                          onRetry: () => ref.invalidate(cryptoProvider),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                t.sortBy,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final s in CoinSort.values)
              Consumer(
                builder: (context, ref, _) {
                  final selected = ref.watch(coinSortProvider) == s;
                  return ListTile(
                    title: Text(_sortLabel(s, t)),
                    trailing: selected ? const Icon(Icons.check_rounded) : null,
                    onTap: () {
                      ref.read(coinSortProvider.notifier).state = s;
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _sortLabel(CoinSort s, AppLocalizations t) {
    switch (s) {
      case CoinSort.marketCap:
        return t.sortMarketCap;
      case CoinSort.price:
        return t.sortPrice;
      case CoinSort.change24h:
        return t.sortChange;
    }
  }
}

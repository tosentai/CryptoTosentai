import 'package:crypto_tosentai/core/constants/app_currency.dart';
import 'package:crypto_tosentai/features/home/domain/coin.dart';
import 'package:crypto_tosentai/features/home/presentation/widgets/coin_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CoinTile shows name, symbol and triggers onTap', (tester) async {
    var taps = 0;
    final coin = Coin.fromMarketJson({
      'id': 'bitcoin',
      'symbol': 'btc',
      'name': 'Bitcoin',
      'image': '',
      'current_price': 64000.0,
      'market_cap': 1.2e12,
      'price_change_percentage_24h': 2.5,
    });

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoinTile(
          coin: coin,
          currency: AppCurrency.usd,
          onTap: () => taps++,
        ),
      ),
    ));

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.textContaining('BTC'), findsOneWidget);
    expect(find.textContaining('+2.50%'), findsOneWidget);

    await tester.tap(find.byType(CoinTile));
    await tester.pump();
    expect(taps, 1);
  });
}

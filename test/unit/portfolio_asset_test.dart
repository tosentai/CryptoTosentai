import 'package:crypto_tosentai/features/portfolio/domain/portfolio_asset.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PortfolioAsset', () {
    final asset = PortfolioAsset(
      id: '1',
      coinId: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      image: '',
      amount: 2,
      buyPrice: 30000,
    );

    test('invested = amount * buyPrice', () {
      expect(asset.invested(), 60000);
    });

    test('currentValue tracks current price', () {
      expect(asset.currentValue(35000), 70000);
    });

    test('positive PnL with current price > buy price', () {
      expect(asset.pnl(35000), 10000);
      expect(asset.pnlPercent(35000), closeTo(16.6667, 0.01));
    });

    test('negative PnL with current price < buy price', () {
      expect(asset.pnl(25000), -10000);
      expect(asset.pnlPercent(25000), closeTo(-16.6667, 0.01));
    });

    test('serialises and parses round-trip', () {
      final restored = PortfolioAsset.fromJson(asset.toJson());
      expect(restored.id, asset.id);
      expect(restored.coinId, asset.coinId);
      expect(restored.amount, asset.amount);
      expect(restored.buyPrice, asset.buyPrice);
    });
  });
}

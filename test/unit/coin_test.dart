import 'package:crypto_tosentai/features/home/domain/coin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coin.fromMarketJson', () {
    test('parses required fields and uppercases symbol', () {
      final coin = Coin.fromMarketJson({
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'image': 'https://x/btc.png',
        'current_price': 64000.5,
        'market_cap': 1.2e12,
        'price_change_percentage_24h': 1.23,
        'total_volume': 3.4e10,
        'circulating_supply': 19500000,
        'ath': 73000,
        'atl': 67.81,
      });
      expect(coin.id, 'bitcoin');
      expect(coin.symbol, 'BTC');
      expect(coin.currentPrice, 64000.5);
      expect(coin.priceChangePercentage24h, 1.23);
      expect(coin.ath, 73000);
    });

    test('handles null numeric fields gracefully', () {
      final coin = Coin.fromMarketJson({
        'id': 'x',
        'symbol': 'x',
        'name': 'X',
        'current_price': null,
        'market_cap': null,
        'price_change_percentage_24h': null,
      });
      expect(coin.currentPrice, 0);
      expect(coin.marketCap, 0);
      expect(coin.priceChangePercentage24h, 0);
      expect(coin.ath, isNull);
    });

    test('round-trips via toJson', () {
      final coin = Coin.fromMarketJson({
        'id': 'eth',
        'symbol': 'eth',
        'name': 'Ethereum',
        'image': '',
        'current_price': 3000.0,
        'market_cap': 4e11,
        'price_change_percentage_24h': -0.5,
      });
      final restored = Coin.fromMarketJson(coin.toJson());
      expect(restored.id, coin.id);
      expect(restored.symbol, coin.symbol);
      expect(restored.currentPrice, coin.currentPrice);
    });
  });
}

class Coin {
  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.priceChangePercentage24h,
    this.totalVolume,
    this.circulatingSupply,
    this.ath,
    this.atl,
    this.sparkline7d,
  });

  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final double priceChangePercentage24h;
  final double? totalVolume;
  final double? circulatingSupply;
  final double? ath;
  final double? atl;
  final List<double>? sparkline7d;

  factory Coin.fromMarketJson(Map<String, dynamic> json) {
    double? toD(dynamic v) => v == null ? null : (v as num).toDouble();
    List<double>? sparkline;
    final raw = json['sparkline_in_7d'];
    if (raw is Map && raw['price'] is List) {
      sparkline = (raw['price'] as List)
          .map<double>((p) => (p as num).toDouble())
          .toList(growable: false);
    } else if (json['sparkline_in_7d'] is List) {
      sparkline = (json['sparkline_in_7d'] as List)
          .map<double>((p) => (p as num).toDouble())
          .toList(growable: false);
    }
    return Coin(
      id: json['id'] as String,
      symbol: (json['symbol'] as String).toUpperCase(),
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      currentPrice: toD(json['current_price']) ?? 0,
      marketCap: toD(json['market_cap']) ?? 0,
      priceChangePercentage24h:
          toD(json['price_change_percentage_24h']) ?? 0,
      totalVolume: toD(json['total_volume']),
      circulatingSupply: toD(json['circulating_supply']),
      ath: toD(json['ath']),
      atl: toD(json['atl']),
      sparkline7d: sparkline,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'image': image,
        'current_price': currentPrice,
        'market_cap': marketCap,
        'price_change_percentage_24h': priceChangePercentage24h,
        'total_volume': totalVolume,
        'circulating_supply': circulatingSupply,
        'ath': ath,
        'atl': atl,
        'sparkline_in_7d': sparkline7d,
      };
}

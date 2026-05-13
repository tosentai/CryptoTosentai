class PortfolioAsset {
  const PortfolioAsset({
    required this.id,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.image,
    required this.amount,
    required this.buyPrice,
    this.notes,
  });

  final String id;
  final String coinId;
  final String symbol;
  final String name;
  final String image;
  final double amount;
  final double buyPrice;
  final String? notes;

  double invested() => amount * buyPrice;
  double currentValue(double currentPrice) => amount * currentPrice;
  double pnl(double currentPrice) =>
      currentValue(currentPrice) - invested();
  double pnlPercent(double currentPrice) {
    final i = invested();
    if (i == 0) return 0;
    return ((currentValue(currentPrice) - i) / i) * 100;
  }

  PortfolioAsset copyWith({
    String? id,
    String? coinId,
    String? symbol,
    String? name,
    String? image,
    double? amount,
    double? buyPrice,
    String? notes,
  }) {
    return PortfolioAsset(
      id: id ?? this.id,
      coinId: coinId ?? this.coinId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      amount: amount ?? this.amount,
      buyPrice: buyPrice ?? this.buyPrice,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coinId': coinId,
        'symbol': symbol,
        'name': name,
        'image': image,
        'amount': amount,
        'buyPrice': buyPrice,
        'notes': notes,
      };

  factory PortfolioAsset.fromJson(Map<String, dynamic> json) {
    return PortfolioAsset(
      id: json['id'] as String,
      coinId: json['coinId'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      buyPrice: (json['buyPrice'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

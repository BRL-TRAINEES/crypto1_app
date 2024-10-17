class Crypto {
  final String id; 
  final String name;
  final String symbol;
  final double price;
  final double marketCap;
  final double volume;
  final double changePercentage;
  final String imageUrl;

  Crypto({
    required this.id, 
    required this.name,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.volume,
    required this.changePercentage,
    required this.imageUrl,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'], 
      name: json['name'] ?? 'Unknown', 
      symbol: json['symbol'] ?? 'N/A', 
      price: json['current_price']?.toDouble() ?? 0.0, 
      marketCap: json['market_cap']?.toDouble() ?? 0.0, 
      volume: json['total_volume']?.toDouble() ?? 0.0, 
      changePercentage: json['price_change_percentage_24h']?.toDouble() ?? 0.0, 
      imageUrl: json['image'] ?? '', 
    );
  }
}

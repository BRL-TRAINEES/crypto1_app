class Crypto {
  final String name;
  final String symbol;
  final double price;
  final double changePercentage;
  final double marketCap; // Add this line
  final double volume; // Add this line
  final String imageUrl;

  Crypto({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercentage,
    required this.marketCap,
    required this.volume,
    required this.imageUrl,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'],
      symbol: json['symbol'],
      price: json['current_price'].toDouble(),
      changePercentage: json['price_change_percentage_24h'].toDouble(),
      marketCap: json['market_cap'].toDouble(), // Ensure this is included
      volume: json['total_volume'].toDouble(), // Ensure this is included
      imageUrl: json['image'],
    );
  }
}

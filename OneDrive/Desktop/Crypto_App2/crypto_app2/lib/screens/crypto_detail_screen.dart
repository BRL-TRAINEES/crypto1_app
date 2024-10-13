import 'package:flutter/material.dart';
import 'package:crypto_app2/crypto_model.dart';

class CryptoDetailScreen extends StatelessWidget {
  final Crypto crypto;

  CryptoDetailScreen({required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff494F55),
      appBar: AppBar(
        title: Text(crypto.name),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              "${crypto.name} (${crypto.symbol.toUpperCase()})",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: \$${crypto.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              "Market Cap: \$${crypto.marketCap.toString()}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              "24h Volume: \$${crypto.volume.toString()}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              "Change (24h): ${crypto.changePercentage.toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),

            const SizedBox(height: 20),

            //  for Chart
            Text(
              "Price Chart", 
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            
          ],
        ),
      ),
    );
  }
}

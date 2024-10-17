import 'package:flutter/material.dart';
import 'package:crypto_app2/crypto_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:crypto_app2/api_service.dart';
import 'package:intl/intl.dart';

class CryptoDetailScreen extends StatefulWidget {
  final Crypto crypto;

  const CryptoDetailScreen({super.key, required this.crypto});

  @override
  _CryptoDetailScreenState createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  late Future<List<dynamic>> futureChartData;

  @override
  void initState() {
    super.initState();
    futureChartData = ApiService().fetchChartData(widget.crypto.id);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0.00');

    return Scaffold(
      backgroundColor: const Color(0xff494F55),
      appBar: AppBar(
        title: Text(widget.crypto.name),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: Text(
                "${widget.crypto.name} (${widget.crypto.symbol.toUpperCase()})",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: Text(
                "Price: \$${widget.crypto.price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Market Cap: \$${numberFormat.format(widget.crypto.marketCap)}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Volume (24h): \$${numberFormat.format(widget.crypto.volume)}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Change (24h): ${widget.crypto.changePercentage.toStringAsFixed(2)}%",
              style: TextStyle(
                fontSize: 18,
                color: widget.crypto.changePercentage >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Price Chart",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Price Chart
            FutureBuilder<List<dynamic>>(
              future: futureChartData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No chart data found'));
                }

                List<dynamic> prices = snapshot.data!;
                List<FlSpot> spots = prices.map((data) {
                  return FlSpot(
                    (data[0] as num).toDouble(), // Timestamp
                    (data[1] as num).toDouble(), // Price
                  );
                }).toList();

                return SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40, 
                            getTitlesWidget: (value, meta) {
                              DateTime time = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  DateFormat('dd/MM').format(time), 
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40, 
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(0), 
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      minX: spots.first.x,
                      maxX: spots.last.x,
                      minY: 0,
                      maxY: spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1, 
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:crypto_app2/utlis.dart'; 
import 'package:flutter/material.dart';
import 'package:crypto_app2/api_service.dart';
import 'package:crypto_app2/crypto_model.dart';
import 'crypto_detail_screen.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<List<Crypto>> futureCryptos;
  List<Crypto> allCryptos = [];
  List<Crypto> filteredCryptos = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCryptos = ApiService().fetchCryptos().then((cryptos) {
      allCryptos = cryptos;
      filteredCryptos = cryptos; 
      return cryptos;
    });
  }

  void filterCryptos(String query) {
    final filtered = allCryptos.where((crypto) {
      return crypto.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCryptos = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff494F55),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Text(
                'Crypto Prices App',
                style: textStyle(25, Colors.white, FontWeight.bold),
              ),
              TextField(
                controller: searchController,
                onChanged: filterCryptos,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                style: TextStyle(color: Colors.white),
              ),
              FutureBuilder<List<Crypto>>(
                future: futureCryptos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data found'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredCryptos.length,
                    itemBuilder: (context, index) {
                      final crypto = filteredCryptos[index];
                      return GestureDetector( 
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CryptoDetailScreen(crypto: crypto),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[700]!,
                                                offset: const Offset(4, 4),
                                                blurRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Image.network(crypto.imageUrl),
                                          ),
                                        ),
                                        const SizedBox(width: 20.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5),
                                            Text(
                                              crypto.name,
                                              style: textStyle(18, Colors.white, FontWeight.w600),
                                            ),
                                            Text(
                                              "${crypto.changePercentage.toStringAsFixed(2)}%",
                                              style: textStyle(18, Colors.white, FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      "\$${crypto.price.toStringAsFixed(2)}",
                                      style: textStyle(18, Colors.white, FontWeight.w600),
                                    ),
                                    Text(
                                      crypto.symbol.toUpperCase(),
                                      style: textStyle(18, Colors.white, FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:crypto_app2/screens/HomeScreen.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class  MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
       return MaterialApp(
        debugShowCheckedModeBanner: false,
        
        home: Homescreen(),
       );
  }
}


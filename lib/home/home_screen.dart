import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home_screen";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Native Splash Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

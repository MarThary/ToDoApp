import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/app_config_provider.dart';

import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "splash_screen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: provider.isDarkMode()
            ? Image.asset(
                'assets/images/splash_dark.png',
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

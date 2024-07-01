import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/screen/home_screen.dart';
import 'package:task_management/screen/start_screen.dart';

import '../components/shared_key/shared_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLogged = prefs.getBool(SharedKey.isLogin.toString());
    Future.delayed(const Duration(seconds: 1), () {
      if (isLogged == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StartPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png"),
      ),
    );
  }
}

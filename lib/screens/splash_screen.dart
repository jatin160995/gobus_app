import 'package:flutter/material.dart';
import 'package:gobus_app/core/constants.dart';
import 'package:gobus_app/core/storage/local_storage.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/screens/Auth/intro.dart';
import 'package:gobus_app/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    final token = await LocalStorage.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // ✅ User already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // ❌ Not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.width - 25,
            width: MediaQuery.of(context).size.width - 25,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Image.asset(AppConstants.imagePath + "splash.png"),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 160,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Image.asset(
                      AppConstants.imagePath + "logo-white-transparent.png",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

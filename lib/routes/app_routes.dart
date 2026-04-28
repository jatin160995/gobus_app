import 'package:flutter/material.dart';
import 'package:gobus_app/screens/Auth/login.dart';
import 'package:gobus_app/screens/splash_screen.dart';
import '../screens/home/home_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const login = '/login';
  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
  };
}

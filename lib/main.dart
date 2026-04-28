import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:shared_preferences/shared_preferences.dart';

//  Global
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: GoBusApp(),
    ),
  );
}

class LanguageProvider extends ChangeNotifier {
  static const _kPrefKey = 'app_locale';
  Locale? _locale;

  Locale? get locale => _locale;

  /// Call this at startup to load saved locale
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kPrefKey);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  /// Change language and persist selection
  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefKey, languageCode);
  }

  /// Reset to system locale and remove preference
  Future<void> clearLanguage() async {
    _locale = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPrefKey);
  }
}

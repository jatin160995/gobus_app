import 'package:flutter/material.dart';
import 'package:gobus_app/main.dart';
import 'package:gobus_app/providers/booking_draft_provider.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'routes/app_routes.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';

class GoBusApp extends StatelessWidget {
  GoBusApp({super.key});
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    // In main.dart, add this at the top level:

    //final languageProvider = LanguageProvider();
    languageProvider.loadLocale();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingDraft()),
        // add other ChangeNotifiers here when needed
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        locale: languageProvider.locale,
        title: 'GoBus',
        theme: appTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,

        // ADD THESE LINES:
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('fr'), // French
        ],
      ),
    );
  }
}

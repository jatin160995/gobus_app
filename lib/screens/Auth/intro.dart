import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gobus_app/core/decoration.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/main.dart';
import 'package:gobus_app/screens/Auth/login.dart';
// Import the generated localizations file
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Widget> items = [];
  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: CarouselSlider(
                    items: getItems(l10n), // Pass l10n object
                    options: CarouselOptions(
                      height: 500,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        // setState(() {
                        //   _current = index;
                        // });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Switch to French
                //     Provider.of<LanguageProvider>(
                //       context,
                //       listen: false,
                //     ).changeLanguage('fr');
                //   },
                //   child: const Text("Français"),
                // ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              width: 200,
              height: 45,
              decoration: DecorationUtils.buildBoxDecoration(
                radius: 22,
                color: AppColors.primary,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  l10n.skipBtn, // Localized skip button
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List images = ["assets/images/onboard1.png", "assets/images/onboard2.png"];

  // Modified to accept the localization object
  getItems(AppLocalizations l10n) {
    // Localized text and description lists
    List<String> text = [l10n.introTitle1, l10n.introTitle2];
    List<String> desc = [l10n.introDesc1, l10n.introDesc2];

    List<Widget> items = [];
    for (int i = 0; i < text.length; i++) {
      items.add(
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Center(child: Image.asset(images[i], height: 250)),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  desc[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.mediumText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return items;
  }
}

import 'package:flutter/material.dart';
import 'package:gobus_app/core/constants.dart';

class TaxigoIntroScreen extends StatelessWidget {
  const TaxigoIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text(
          "TAXIGO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Top Image
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppConstants.imagePath + "taxigo_car.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  /// Title
                  Text(
                    "🚀 La Révolution est en marche aux Aéroports du Cameroun !",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 16),

                  /// Description
                  Text(
                    "Découvrez TAXIGO, votre nouveau service de transport premium, bientôt disponible exclusivement sur l'application GO. 🇨🇲✈️",
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),

                  SizedBox(height: 20),

                  /// Bullet Points
                  Text(
                    "✅ 100% Connecté : Wi-Fi haut débit gratuit à bord avec Orange Business pour rester productif jusqu'à destination.\n\n"
                    "✅ 100% Assuré : Voyagez l'esprit tranquille, chaque trajet est couvert par notre partenaire ACTIVA.\n\n"
                    "✅ 100% Neuf : Profitez du confort exceptionnel de nos SUV BAIC X35 pour vos transferts aéroportuaires.",
                    style: TextStyle(fontSize: 15, height: 1.6),
                  ),

                  SizedBox(height: 20),

                  /// Closing
                  Text(
                    "Fini le stress des tarifs aléatoires et du confort incertain. Avec TAXIGO, hissons ensemble nos aéroports aux standards internationaux.",
                    style: TextStyle(fontSize: 15, height: 1.6),
                  ),

                  SizedBox(height: 24),

                  /// CTA
                  Text(
                    "👉 Préparez-vous ! Téléchargez l'application GO dès maintenant.\n\nSmart Travel Simplified.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

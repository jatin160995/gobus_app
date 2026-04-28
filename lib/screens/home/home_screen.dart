import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/design_utils.dart';
import 'package:gobus_app/core/constants.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/providers/profile_provider.dart';
import 'package:gobus_app/screens/Profile/profile_screen.dart';
import 'package:gobus_app/screens/Search/rentCar/rent_car_search_screen.dart';
import 'package:gobus_app/screens/Search/search_screen.dart';
import 'package:gobus_app/screens/TaxiGo/taxigo_intro_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_draft_provider.dart';
import '../../core/theme.dart'; // or import where AppColors lives

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // click 0 = bus, 1= car, 2=taxigo
  void _onModeTap(BuildContext context, String mode, int click) {
    if (click == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TaxigoIntroScreen()),
      );
    } else if (click == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RentCarSearchScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    }
  }

  // click 0 = bus, 1= car, 2=taxigo
  Widget _modeCard(
    BuildContext context,
    String asset,
    String label,
    int click,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onModeTap(context, label, click),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // replace this with Image.asset if you have svg/png
                SizedBox(
                  height: 88,
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickAccessTile(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.white,
            child: Icon(icon, color: AppColors.secondary),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.darkText,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: AppColors.lightText),
          onTap: onTap,
        ),
        const Divider(height: 1, color: AppColors.dividerColor),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userName = "John"; // replace with actual provider/user state
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // small logo square
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(AppConstants.imagePath + "logo-small.png"),
            ),
            const SizedBox(width: 10),
            Text(
              'Go',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppColors.dividerColor,
              child: Icon(Icons.person, color: AppColors.darkText),
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider(
                          create: (_) => ProfileProvider()..fetchProfile(),
                          child: ProfileScreen(),
                        ),
                  ),
                ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                l10n.hiUser(userName),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.howWouldYouLike,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homeGreeting,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumText,
                ),
              ),
              const SizedBox(height: 20),

              // Mode cards
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerColor),
                ),
                child: Row(
                  children: [
                    _modeCard(
                      context,
                      AppConstants.imagePath + "home-bus.png",
                      l10n.busIntercity,
                      0,
                    ),
                    Container(
                      width: 1,
                      height: 100,
                      color: AppColors.dividerColor,
                    ),
                    _modeCard(
                      context,
                      AppConstants.imagePath + "home-car.png",
                      l10n.carRental,
                      1,
                    ),
                    Container(
                      width: 1,
                      height: 140,
                      color: AppColors.dividerColor,
                    ),
                    _modeCard(
                      context,
                      AppConstants.imagePath + "taxigo.png",
                      'Taxigo',
                      2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Quick Access header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  heading(l10n.quickAccess),

                  // TextButton(
                  //   onPressed: () => Navigator.pushNamed(context, '/trips'),
                  //   child: Text(
                  //     l10n.viewAll,
                  //     style: const TextStyle(color: AppColors.secondary),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              // Quick access items
              _quickAccessTile(
                context,
                Icons.calendar_today,
                l10n.upcomingTrips,
                () {
                  Navigator.pushNamed(context, '/upcoming');
                },
              ),
              _quickAccessTile(context, Icons.loyalty, l10n.loyaltyPoints, () {
                Navigator.pushNamed(context, '/loyalty');
              }),
              _quickAccessTile(
                context,
                Icons.support_agent,
                l10n.supportHelp,
                () {
                  Navigator.pushNamed(context, '/support');
                },
              ),
              _quickAccessTile(context, Icons.history, l10n.tripHistory, () {
                Navigator.pushNamed(context, '/history');
              }),

              const SizedBox(height: 80), // space for bottom nav
            ],
          ),
        ),
      ),

      // Bottom pill navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(36),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomNavItem(context, Icons.home, l10n.navHome, true, () {
                // already on home
              }),
              _bottomNavItem(
                context,
                Icons.confirmation_num,
                l10n.navTickets,
                false,
                () {
                  Navigator.pushNamed(context, '/tickets');
                },
              ),
              _bottomNavItem(context, Icons.person, l10n.navProfile, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider(
                          create: (_) => ProfileProvider()..fetchProfile(),
                          child: ProfileScreen(),
                        ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    final color = active ? AppColors.accent : AppColors.white;
    final bg = active ? AppColors.secondaryLight : Colors.transparent;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundColor: bg, child: Icon(icon, color: color)),
          //const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontFamily: "medium",
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

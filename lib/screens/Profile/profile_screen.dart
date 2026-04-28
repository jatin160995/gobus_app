import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/language_selector.dart';
import 'package:gobus_app/core/decoration.dart';
import 'package:gobus_app/core/utils.dart';
import 'package:gobus_app/features/auth/models/user_model.dart';
import 'package:gobus_app/features/auth/services/auth_api.dart';
import 'package:gobus_app/features/passenger/providers/passenger_provider.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/main.dart';
import 'package:gobus_app/providers/profile_provider.dart';
import 'package:gobus_app/screens/Auth/login.dart';
import 'package:gobus_app/screens/Passenger/saved_passengers_screen.dart';
import 'package:gobus_app/screens/Profile/change_password_screen.dart';
import 'package:gobus_app/screens/Profile/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart'; // import where AppColors is defined

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Replace these with your real user model/provider
  Map<String, String> _mockUser() => {
    'name': 'John Smith',
    'email': 'exampleemail@gmail.com',
    'phone': '+23-836-178381',
  };

  bool _isLoggingOut = false;

  Widget _header(BuildContext context, AppLocalizations l10n, UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left: user details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? '',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email ?? '',
                  style: const TextStyle(color: AppColors.white, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  user.phone ?? '',
                  style: const TextStyle(color: AppColors.white, fontSize: 13),
                ),
              ],
            ),
          ),

          // Right: edit icon
          InkWell(
            onTap: () {
              // navigate to edit profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Container(
          decoration: DecorationUtils.buildBoxDecoration(
            borderColor: AppColors.dividerColor,
            color: AppColors.primaryBackground,
          ),
          child: ListTile(
            onTap: onTap,
            leading: CircleAvatar(
              backgroundColor: AppColors.lightPrimary,
              radius: 26,
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: AppColors.mediumText),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.lightText,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = _mockUser(); // replace this with your provider call

    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.profileTitle,
          style: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // optional: logout or share profile
        //     },
        //     icon: const Icon(Icons.login_outlined, color: AppColors.primary),
        //   ),
        // ],
      ),
      body:
          provider.isLoading
              ? loader()
              : SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _header(context, l10n, provider.profile!),
                      const SizedBox(height: 18),

                      _optionTile(
                        context,
                        Icons.lock_outline,
                        l10n.changePassword,
                        l10n.changePasswordSubtitle,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),

                      _optionTile(
                        context,
                        Icons.receipt_long,
                        l10n.transactions,
                        l10n.transactionsSubtitle,
                        () {
                          Navigator.pushNamed(context, '/profile/transactions');
                        },
                      ),

                      _optionTile(
                        context,
                        Icons.person_add_alt_1,
                        l10n.passengers,
                        l10n.passengersSubtitle,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChangeNotifierProvider(
                                    create: (_) => PassengerProvider(),
                                    child: const SavedPassengersScreen(),
                                  ),
                            ),
                          );
                        },
                      ),

                      _optionTile(
                        context,
                        Icons.notifications_none,
                        l10n.notifications,
                        l10n.notificationsSubtitle,
                        () {
                          Navigator.pushNamed(
                            context,
                            '/profile/notifications',
                          );
                        },
                      ),

                      const SizedBox(height: 18),
                      const LanguageSelector(),
                      const SizedBox(height: 18),

                      // Logout button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          // implement logout
                          _showLogoutDialog(context);
                        },
                        child: Text(
                          l10n.logout,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
    );
  }

  void _showLogoutDialog(BuildContext screenContext) {
    final l10n = AppLocalizations.of(screenContext)!;

    showDialog(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutConfirmMessage),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(color: AppColors.mediumText),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext); // close confirm dialog
                _handleLogout(screenContext); // ✅ use SCREEN context
              },
              child: Text(
                l10n.logout,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext screenContext) async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    showLoader(screenContext);

    final success = await AuthApi.logout();

    if (!screenContext.mounted) return;

    Navigator.of(screenContext, rootNavigator: true).pop(); // 🔥 close loader

    setState(() {
      _isLoggingOut = false;
    });

    if (success) {
      Navigator.pushAndRemoveUntil(
        screenContext,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(screenContext).showSnackBar(
        const SnackBar(
          content: Text("Logout failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

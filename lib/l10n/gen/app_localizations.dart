import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to Access Your Travel Tickets'**
  String get loginTitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginBtn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginBtn;

  /// No description provided for @signupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get signupPrompt;

  /// No description provided for @signupAction.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get signupAction;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Code Verification'**
  String get otpTitle;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'We have sent an OTP code on your email'**
  String get otpSentMessage;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get nameHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up to Explore and Book Tickets'**
  String get signupTitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get orLoginWith;

  /// No description provided for @orSignupWith.
  ///
  /// In en, this message translates to:
  /// **'Or Sign Up with'**
  String get orSignupWith;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// No description provided for @didNotReceiveEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t received Email ?'**
  String get didNotReceiveEmail;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'You can resend code in'**
  String get resendCodeIn;

  /// No description provided for @resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend Now'**
  String get resendNow;

  /// No description provided for @submitBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitBtn;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @forgotPasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordScreenTitle;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'Book your tickets in Advance.'**
  String get introTitle1;

  /// No description provided for @introDesc1.
  ///
  /// In en, this message translates to:
  /// **'Search and book budget-friendly buses or premium car rentals in just a few taps. Fast, reliable, and made for your travel comfort.'**
  String get introDesc1;

  /// No description provided for @introTitle2.
  ///
  /// In en, this message translates to:
  /// **'Safe and Secure payments.'**
  String get introTitle2;

  /// No description provided for @introDesc2.
  ///
  /// In en, this message translates to:
  /// **'Enjoy secure payments, instant e-tickets, and real-time updates — so your journey stays as smooth as your destination.'**
  String get introDesc2;

  /// No description provided for @skipBtn.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipBtn;

  /// No description provided for @otpHeading.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpHeading;

  /// No description provided for @otpSubHeading.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get otpSubHeading;

  /// No description provided for @resetPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordHeading;

  /// No description provided for @resetPasswordSubHeading.
  ///
  /// In en, this message translates to:
  /// **'Create new Password'**
  String get resetPasswordSubHeading;

  /// No description provided for @forgotHeading.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotHeading;

  /// No description provided for @forgotSubHeading.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Access Here'**
  String get forgotSubHeading;

  /// No description provided for @signUpHeading.
  ///
  /// In en, this message translates to:
  /// **'Sign Up to Explore and'**
  String get signUpHeading;

  /// No description provided for @signUpSubHeading.
  ///
  /// In en, this message translates to:
  /// **'Book Tickets'**
  String get signUpSubHeading;

  /// No description provided for @loginHeading.
  ///
  /// In en, this message translates to:
  /// **'Login to Access Your'**
  String get loginHeading;

  /// No description provided for @loginSubHeading.
  ///
  /// In en, this message translates to:
  /// **'Travel Tickets'**
  String get loginSubHeading;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get navTickets;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get navTrips;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get homePageTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Find your next journey with ease.'**
  String get homeGreeting;

  /// Greeting with user's name
  ///
  /// In en, this message translates to:
  /// **'Hi {name} 👋,'**
  String hiUser(Object name);

  /// No description provided for @howWouldYouLike.
  ///
  /// In en, this message translates to:
  /// **'How would you like to travel today?'**
  String get howWouldYouLike;

  /// No description provided for @pickMode.
  ///
  /// In en, this message translates to:
  /// **'Pick a mode to continue your booking.'**
  String get pickMode;

  /// No description provided for @busIntercity.
  ///
  /// In en, this message translates to:
  /// **'Bus Intercity'**
  String get busIntercity;

  /// No description provided for @carRental.
  ///
  /// In en, this message translates to:
  /// **'Car Rental'**
  String get carRental;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @upcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Trips'**
  String get upcomingTrips;

  /// No description provided for @loyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// No description provided for @supportHelp.
  ///
  /// In en, this message translates to:
  /// **'Support / Help'**
  String get supportHelp;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get tripHistory;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEditButton;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get changePasswordSubtitle;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all your transactions'**
  String get transactionsSubtitle;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @child.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get child;

  /// No description provided for @passengersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all saved passengers'**
  String get passengersSubtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change notification settings'**
  String get notificationsSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editProfileAria.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileAria;

  /// No description provided for @languageHeadeing.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageHeadeing;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @findYourBus.
  ///
  /// In en, this message translates to:
  /// **'Find your'**
  String get findYourBus;

  /// No description provided for @bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @passengerLabel.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get passengerLabel;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @recentlySearched.
  ///
  /// In en, this message translates to:
  /// **'Recently Searched'**
  String get recentlySearched;

  /// No description provided for @noRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'No recent searches yet'**
  String get noRecentSearches;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectPassengers.
  ///
  /// In en, this message translates to:
  /// **'Select passengers'**
  String get selectPassengers;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get editProfileNameHint;

  /// No description provided for @editProfileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get editProfileEmailHint;

  /// No description provided for @editProfilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone'**
  String get editProfilePhoneHint;

  /// No description provided for @editProfileUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get editProfileUpdateButton;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrent;

  /// No description provided for @changePasswordNew.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNew;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordUpdateButton;

  /// No description provided for @savedPassengersTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Passengers'**
  String get savedPassengersTitle;

  /// No description provided for @passengerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Passenger Name'**
  String get passengerNameLabel;

  /// No description provided for @passengerAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get passengerAgeLabel;

  /// No description provided for @editPassengerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Passengers'**
  String get editPassengerTitle;

  /// No description provided for @passengerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Passenger Name'**
  String get passengerNameHint;

  /// No description provided for @passengerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get passengerPhoneLabel;

  /// No description provided for @passengerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get passengerPhoneHint;

  /// No description provided for @passengerGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get passengerGenderLabel;

  /// No description provided for @passengerGenderHint.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get passengerGenderHint;

  /// No description provided for @passengerIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get passengerIdLabel;

  /// No description provided for @passengerIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter ID Number'**
  String get passengerIdHint;

  /// No description provided for @passengerUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get passengerUpdateButton;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectSeats.
  ///
  /// In en, this message translates to:
  /// **'Select Seats'**
  String get selectSeats;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @confirmSeats.
  ///
  /// In en, this message translates to:
  /// **'Confirm Seats'**
  String get confirmSeats;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// No description provided for @rentCarTitle.
  ///
  /// In en, this message translates to:
  /// **'Rent a Car'**
  String get rentCarTitle;

  /// No description provided for @findYour.
  ///
  /// In en, this message translates to:
  /// **'Find your'**
  String get findYour;

  /// No description provided for @chauffeur.
  ///
  /// In en, this message translates to:
  /// **'Chauffeur'**
  String get chauffeur;

  /// No description provided for @pickupDate.
  ///
  /// In en, this message translates to:
  /// **'Pickup Date'**
  String get pickupDate;

  /// No description provided for @pickupTime.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickupTime;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return Date'**
  String get returnDate;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @trip_details.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get trip_details;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @available_vehicles.
  ///
  /// In en, this message translates to:
  /// **'Available Vehicles'**
  String get available_vehicles;

  /// No description provided for @trip_type.
  ///
  /// In en, this message translates to:
  /// **'Trip Type'**
  String get trip_type;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get seats;

  /// No description provided for @price_breakdown.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get price_breakdown;

  /// No description provided for @base_price.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get base_price;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vat;

  /// No description provided for @grand_total.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grand_total;

  /// No description provided for @vehicle_category.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Category'**
  String get vehicle_category;

  /// No description provided for @vehicle_assigned_before_pickup.
  ///
  /// In en, this message translates to:
  /// **'Vehicle will be assigned before pickup'**
  String get vehicle_assigned_before_pickup;

  /// No description provided for @platform_commission.
  ///
  /// In en, this message translates to:
  /// **'Platform Commission'**
  String get platform_commission;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

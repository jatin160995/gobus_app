import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/city_picker_sheet.dart';
import 'package:gobus_app/Widgets/design_utils.dart';
import 'package:gobus_app/core/constants.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/features/search/models/city.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/providers/city_search_provider.dart';
import 'package:gobus_app/screens/Search/models/recent_search.dart';
import 'package:gobus_app/screens/Search/recent_search_card.dart';
import 'package:gobus_app/screens/Search/rentCar/car_result_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RentCarSearchScreen extends StatefulWidget {
  const RentCarSearchScreen({super.key});

  @override
  State<RentCarSearchScreen> createState() => _RentCarSearchScreenState();
}

class _RentCarSearchScreenState extends State<RentCarSearchScreen> {
  City? fromCity;
  City? toCity;

  bool isRoundTrip = false;

  DateTime pickupDate = DateTime.now().add(const Duration(days: 1));
  DateTime? returnDate;

  TimeOfDay pickupTime = const TimeOfDay(hour: 10, minute: 00);

  int passengers = 1;

  List<RecentSearch> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  /* -------------------- RECENT SEARCH -------------------- */

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('recent_rent_searches');

    if (raw != null) {
      final list = jsonDecode(raw) as List;
      setState(() {
        recentSearches = list.map((e) => RecentSearch.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveRecentSearch(RecentSearch search) async {
    final prefs = await SharedPreferences.getInstance();

    recentSearches.removeWhere(
      (e) =>
          e.fromCode == search.fromCode &&
          e.toCode == search.toCode &&
          e.date == search.date,
    );

    recentSearches.insert(0, search);

    if (recentSearches.length > 10) {
      recentSearches = recentSearches.take(10).toList();
    }

    await prefs.setString(
      'recent_rent_searches',
      jsonEncode(recentSearches.map((e) => e.toJson()).toList()),
    );

    setState(() {});
  }

  /* -------------------- DATE PICKER -------------------- */

  Future<void> _pickDate({required bool isPickup}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isPickup
              ? pickupDate
              : returnDate ?? pickupDate.add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: Localizations.localeOf(context),
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          pickupDate = picked;
        } else {
          returnDate = picked;
        }
      });
    }
  }

  /* -------------------- TIME PICKER -------------------- */

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: pickupTime,
    );

    if (picked != null) {
      setState(() => pickupTime = picked);
    }
  }

  /* -------------------- CITY PICKER -------------------- */

  Future<void> _pickCity({required bool isFrom}) async {
    final city = await showModalBottomSheet<City>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ChangeNotifierProvider(
          create: (_) => CitySearchProvider(),
          child: const CityPickerSheet(),
        );
      },
    );

    if (city != null) {
      setState(() {
        if (isFrom) {
          fromCity = city;
        } else {
          toCity = city;
        }
      });
    }
  }

  /* -------------------- PASSENGER PICKER -------------------- */

  Future<void> _pickPassengers() async {
    int count = passengers;

    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder:
              (_, setState) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Passengers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed:
                              count > 1 ? () => setState(() => count--) : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text("$count", style: const TextStyle(fontSize: 20)),
                        IconButton(
                          onPressed: () => setState(() => count++),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, count),
                        child: const Text("Confirm"),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );

    if (result != null) {
      setState(() => passengers = result);
    }
  }

  /* -------------------- SEARCH -------------------- */

  void _onSearch() {
    // final l10n = AppLocalizations.of(context)!;

    // if (fromCity == null || toCity == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(l10n.fromLabel + " / " + l10n.toLabel)),
    //   );
    //   return;
    // }

    // final recent = RecentSearch(
    //   fromCode: fromCity!.code,
    //   fromName: fromCity!.name,
    //   toCode: toCity!.code,
    //   toName: toCity!.name,
    //   date: pickupDate,
    //   transport: "car",
    // );

    // _saveRecentSearch(recent);

    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("Search clicked (UI only)")));

    final l10n = AppLocalizations.of(context)!;

    if (fromCity == null || toCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fromLabel + " / " + l10n.toLabel)),
      );
      return;
    }

    final recent = RecentSearch(
      fromId: fromCity!.id,
      toId: toCity!.id,
      fromCode: fromCity!.code,
      fromName: fromCity!.name,
      toCode: toCity!.code,
      toName: toCity!.name,
      date: pickupDate,
      transport: "car",

      // 👇 NEW FIELDS (add these in your model)
      isRoundTrip: isRoundTrip,
      returnDate: returnDate,
      pickupHour: pickupTime.hour,
      pickupMinute: pickupTime.minute,
      passengers: passengers,
    );
    print(recent.toString());
    _saveRecentSearch(recent);

    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("Search clicked")));
    final pickupDateStr = DateFormat("yyyy-MM-dd").format(pickupDate);
    final pickupTimeStr =
        "${pickupTime.hour.toString().padLeft(2, '0')}:${pickupTime.minute.toString().padLeft(2, '0')}";

    final returnDateStr =
        returnDate != null
            ? DateFormat("yyyy-MM-dd").format(returnDate!)
            : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CarResultsScreen(
              fromCity: fromCity!,
              toCity: toCity!,
              tripType: isRoundTrip ? "round_trip" : "one_way",
              pickupDate: pickupDateStr,
              pickupTime: pickupTimeStr,
              returnDate: returnDateStr,
              passengers: passengers,
            ),
      ),
    );
  }

  /* -------------------- FIELD TILE -------------------- */

  Widget _fieldTile({
    required String heading,
    required Widget leading,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        smallHeading(heading),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.dividerColor),
              color: Colors.white,
            ),
            child: Row(
              children: [
                SizedBox(width: 36, child: leading),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.lightText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pickupDateLabel = DateFormat(
      'EEE, d MMM',
      Localizations.localeOf(context).toString(),
    ).format(pickupDate);

    final timeLabel = pickupTime.format(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.darkText),
        title: const Text(
          "Rent a Car",
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Hero
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.findYour,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          l10n.car,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: Image.asset(
                      AppConstants.imagePath + "home-car.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Form Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerColor),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    /// One Way / Round Trip
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.oneWay ?? "One Way"),
                            selected: !isRoundTrip,
                            onSelected:
                                (_) => setState(() => isRoundTrip = false),
                            selectedColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.roundTrip ?? "Round Trip"),
                            selected: isRoundTrip,
                            onSelected:
                                (_) => setState(() => isRoundTrip = true),
                            selectedColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _fieldTile(
                      heading: l10n.fromLabel,
                      leading: const Icon(
                        Icons.location_on,
                        color: AppColors.secondary,
                      ),
                      title: fromCity?.label ?? l10n.selectCity,
                      onTap: () => _pickCity(isFrom: true),
                    ),

                    const SizedBox(height: 12),

                    _fieldTile(
                      heading: l10n.toLabel,
                      leading: const Icon(
                        Icons.flag,
                        color: AppColors.secondary,
                      ),
                      title: toCity?.label ?? l10n.selectCity,
                      onTap: () => _pickCity(isFrom: false),
                    ),

                    const SizedBox(height: 12),

                    _fieldTile(
                      heading: l10n.pickupDate,
                      leading: const Icon(
                        Icons.calendar_today,
                        color: AppColors.secondary,
                      ),
                      title: pickupDateLabel,
                      onTap: () => _pickDate(isPickup: true),
                    ),

                    const SizedBox(height: 12),

                    _fieldTile(
                      heading: l10n.pickupTime,
                      leading: const Icon(
                        Icons.access_time,
                        color: AppColors.secondary,
                      ),
                      title: timeLabel,
                      onTap: _pickTime,
                    ),

                    if (isRoundTrip) ...[
                      const SizedBox(height: 12),
                      _fieldTile(
                        heading: l10n.returnDate,
                        leading: const Icon(
                          Icons.event_repeat,
                          color: AppColors.secondary,
                        ),
                        title:
                            returnDate != null
                                ? DateFormat(
                                  'EEE, d MMM',
                                  Localizations.localeOf(context).toString(),
                                ).format(returnDate!)
                                : l10n.selectDate,
                        onTap: () => _pickDate(isPickup: false),
                      ),
                    ],

                    const SizedBox(height: 12),

                    _fieldTile(
                      heading: l10n.passengerLabel,
                      leading: const Icon(
                        Icons.person,
                        color: AppColors.secondary,
                      ),
                      title: "$passengers " + l10n.passengers,
                      onTap: _pickPassengers,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          l10n.searchButton,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              if (recentSearches.isNotEmpty) ...[
                heading(l10n.recentlySearched),
                const SizedBox(height: 10),
                Column(
                  children:
                      recentSearches
                          .map(
                            (r) => RecentSearchCard(
                              item: r,
                              onTap: () {
                                setState(() {
                                  // restore cities
                                  fromCity = City(
                                    id: r.fromId,
                                    name: r.fromName,
                                    code: r.fromCode,
                                    country: '',
                                    label: "${r.fromName} (${r.fromCode})",
                                  );

                                  toCity = City(
                                    id: r.toId,
                                    name: r.toName,
                                    code: r.toCode,
                                    country: '',
                                    label: "${r.toName} (${r.toCode})",
                                  );

                                  // restore pickup date
                                  pickupDate = r.date;

                                  // restore round trip
                                  isRoundTrip = r.isRoundTrip ?? false;

                                  // restore return date
                                  returnDate = r.returnDate;

                                  // restore time
                                  if (r.pickupHour != null &&
                                      r.pickupMinute != null) {
                                    pickupTime = TimeOfDay(
                                      hour: r.pickupHour!,
                                      minute: r.pickupMinute!,
                                    );
                                  }

                                  // restore passengers
                                  passengers = r.passengers ?? 1;
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

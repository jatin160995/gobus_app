// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:gobus_app/Widgets/city_picker_sheet.dart';
// import 'package:gobus_app/Widgets/design_utils.dart';
// import 'package:gobus_app/core/constants.dart';
// import 'package:gobus_app/features/search/models/city.dart';
// import 'package:gobus_app/l10n/gen/app_localizations.dart';
// import 'package:gobus_app/providers/city_search_provider.dart';
// import 'package:gobus_app/screens/Search/models/recent_search.dart';
// import 'package:gobus_app/screens/Search/recent_search_card.dart';
// import 'package:gobus_app/screens/Search/search_results_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/theme.dart';
// import 'package:intl/intl.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   City? fromCity;
//   City? toCity;

//   DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
//   int passengers = 1;

//   List<RecentSearch> recentSearches = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadRecentSearches();
//   }

//   /* -------------------- RECENT SEARCH -------------------- */

//   Future<void> _loadRecentSearches() async {
//     final prefs = await SharedPreferences.getInstance();
//     final raw = prefs.getString('recent_searches');

//     if (raw != null) {
//       final list = jsonDecode(raw) as List;
//       setState(() {
//         recentSearches = list.map((e) => RecentSearch.fromJson(e)).toList();
//       });
//     }
//   }

//   Future<void> _saveRecentSearch(RecentSearch search) async {
//     final prefs = await SharedPreferences.getInstance();

//     recentSearches.removeWhere(
//       (e) =>
//           e.fromCode == search.fromCode &&
//           e.toCode == search.toCode &&
//           e.date == search.date,
//     );

//     recentSearches.insert(0, search);

//     if (recentSearches.length > 10) {
//       recentSearches = recentSearches.take(10).toList();
//     }

//     await prefs.setString(
//       'recent_searches',
//       jsonEncode(recentSearches.map((e) => e.toJson()).toList()),
//     );

//     setState(() {});
//   }

//   /* -------------------- DATE -------------------- */

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       locale: Localizations.localeOf(context),
//     );
//     if (picked != null) {
//       setState(() => selectedDate = picked);
//     }
//   }

//   /* -------------------- CITY PICKER -------------------- */

//   Future<void> _pickCity({required bool isFrom}) async {
//     final city = await showModalBottomSheet<City>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) {
//         return ChangeNotifierProvider(
//           create: (_) => CitySearchProvider(),
//           child: const CityPickerSheet(),
//         );
//       },
//     );

//     if (city != null) {
//       setState(() {
//         if (isFrom) {
//           fromCity = city;
//         } else {
//           toCity = city;
//         }
//       });
//     }
//   }

//   /* -------------------- PASSENGER PICKER -------------------- */

//   Future<void> _pickPassengers() async {
//     int count = passengers;

//     final result = await showModalBottomSheet<int>(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(
//           builder:
//               (_, setState) => Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Passengers",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed:
//                               count > 1 ? () => setState(() => count--) : null,
//                           icon: const Icon(Icons.remove),
//                         ),
//                         Text("$count", style: const TextStyle(fontSize: 20)),
//                         IconButton(
//                           onPressed: () => setState(() => count++),
//                           icon: const Icon(Icons.add),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.pop(context, count),
//                         child: const Text("Confirm"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//         );
//       },
//     );

//     if (result != null) {
//       setState(() => passengers = result);
//     }
//   }

//   /* -------------------- SEARCH -------------------- */

//   void _onSearch() {
//     if (fromCity == null || toCity == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select From & To cities")),
//       );
//       return;
//     }

//     final recent = RecentSearch(
//       fromId: fromCity!.id,
//       toId: toCity!.id,
//       fromCode: fromCity!.code,
//       fromName: fromCity!.name,
//       toCode: toCity!.code,
//       toName: toCity!.name,
//       date: selectedDate,
//       transport: "bus",
//     );

//     _saveRecentSearch(recent);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (_) => SearchResultsScreen(
//               from: fromCity!.code,
//               to: toCity!.code,
//               date: DateFormat('yyyy-MM-dd').format(selectedDate),
//               passengers: passengers,
//             ),
//       ),
//     );
//   }

//   /* -------------------- UI HELPERS -------------------- */

//   Widget _fieldTile({
//     required String heading,
//     required Widget leading,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         smallHeading(heading),
//         const SizedBox(height: 5),
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(25),
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(color: AppColors.dividerColor),
//               color: Colors.white,
//             ),
//             child: Row(
//               children: [
//                 SizedBox(width: 36, child: leading),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       color: AppColors.darkText,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right, color: AppColors.lightText),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final dateLabel = DateFormat(
//       'EEE, d MMM',
//       Localizations.localeOf(context).toString(),
//     ).format(selectedDate);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: AppColors.darkText),
//         title: Text(
//           l10n.searchTitle,
//           style: const TextStyle(
//             color: AppColors.darkText,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         minimum: const EdgeInsets.symmetric(horizontal: 18),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               /// Hero
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           l10n.findYourBus,
//                           style: const TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.secondary,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           l10n.bus,
//                           style: const TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.accent,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 90,
//                     child: Image.asset(
//                       AppConstants.imagePath + "home-bus.png",
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               /// Form
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.dividerColor),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     _fieldTile(
//                       heading: l10n.fromLabel,
//                       leading: Image.asset(
//                         AppConstants.imagePath + "from.png",
//                         height: 28,
//                       ),
//                       title: fromCity != null ? fromCity!.label : "Select city",
//                       onTap: () => _pickCity(isFrom: true),
//                     ),
//                     const SizedBox(height: 12),
//                     _fieldTile(
//                       heading: l10n.toLabel,
//                       leading: Image.asset(
//                         AppConstants.imagePath + "to.png",
//                         height: 28,
//                       ),
//                       title: toCity != null ? toCity!.label : "Select city",
//                       onTap: () => _pickCity(isFrom: false),
//                     ),
//                     const SizedBox(height: 12),
//                     _fieldTile(
//                       heading: l10n.dateLabel,
//                       leading: const Icon(
//                         Icons.calendar_today,
//                         color: AppColors.secondary,
//                       ),
//                       title: dateLabel,
//                       onTap: _pickDate,
//                     ),
//                     const SizedBox(height: 12),
//                     _fieldTile(
//                       heading: l10n.passengerLabel,
//                       leading: const Icon(
//                         Icons.person_outlined,
//                         color: AppColors.secondary,
//                       ),
//                       title: "$passengers Passenger(s)",
//                       onTap: _pickPassengers,
//                     ),
//                     const SizedBox(height: 20),

//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: _onSearch,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           l10n.searchButton,
//                           style: const TextStyle(
//                             color: AppColors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 22),

//               if (recentSearches.isNotEmpty) ...[
//                 heading(l10n.recentlySearched),
//                 const SizedBox(height: 10),
//                 Column(
//                   children:
//                       recentSearches
//                           .map(
//                             (r) => RecentSearchCard(
//                               item: r,
//                               onTap: () {
//                                 setState(() {
//                                   fromCity = City(
//                                     id: 0,
//                                     name: r.fromName,
//                                     code: r.fromCode,
//                                     country: '',
//                                     label: "${r.fromName} (${r.fromCode})",
//                                   );
//                                   toCity = City(
//                                     id: 0,
//                                     name: r.toName,
//                                     code: r.toCode,
//                                     country: '',
//                                     label: "${r.toName} (${r.toCode})",
//                                   );
//                                   selectedDate = r.date;
//                                 });
//                               },
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ],

//               const SizedBox(height: 80),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /* ---------------- CITY PICKER SHEET ---------------- */

// // class _CityPickerSheet extends StatelessWidget {
// //   const _CityPickerSheet();

// //   @override
// //   Widget build(BuildContext context) {
// //     final provider = context.watch<CitySearchProvider>();

// //     return Padding(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           TextField(
// //             decoration: const InputDecoration(
// //               hintText: "Search city",
// //               prefixIcon: Icon(Icons.search),
// //             ),
// //             onChanged: provider.search,
// //           ),
// //           const SizedBox(height: 10),
// //           if (provider.isLoading) const CircularProgressIndicator(),
// //           ...provider.results.map(
// //             (city) => ListTile(
// //               title: Text(city.label),
// //               onTap: () => Navigator.pop(context, city),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/city_picker_sheet.dart';
import 'package:gobus_app/Widgets/design_utils.dart';
import 'package:gobus_app/core/constants.dart';
import 'package:gobus_app/features/search/models/city.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/providers/city_search_provider.dart';
import 'package:gobus_app/screens/Search/models/recent_search.dart';
import 'package:gobus_app/screens/Search/recent_search_card.dart';
import 'package:gobus_app/screens/Search/search_results_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  City? fromCity;
  City? toCity;

  bool isRoundTrip = false;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime? returnDate;
  int adults = 1;
  int children = 0;

  List<RecentSearch> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  /* -------------------- RECENT SEARCH -------------------- */

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('recent_searches');

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
      'recent_searches',
      jsonEncode(recentSearches.map((e) => e.toJson()).toList()),
    );

    setState(() {});
  }

  /* -------------------- DATE -------------------- */

  Future<void> _pickDate({required bool isReturn}) async {
    final initialDate =
        isReturn
            ? (returnDate ?? selectedDate.add(const Duration(days: 1)))
            : selectedDate;

    final firstDate =
        isReturn ? selectedDate.add(const Duration(days: 1)) : DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: Localizations.localeOf(context),
    );

    if (picked != null) {
      setState(() {
        if (isReturn) {
          returnDate = picked;
        } else {
          selectedDate = picked;
          // Reset return date if it's before new outbound date
          if (returnDate != null && returnDate!.isBefore(picked)) {
            returnDate = null;
          }
        }
      });
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
    int adultCount = adults;
    int childCount = children;

    final result = await showModalBottomSheet<Map<String, int>>(
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
                    const SizedBox(height: 16),
                    _counterRow(
                      "Adults",
                      adultCount,
                      onDec:
                          adultCount > 1
                              ? () => setState(() => adultCount--)
                              : null,
                      onInc: () => setState(() => adultCount++),
                    ),
                    const SizedBox(height: 12),
                    _counterRow(
                      "Children (under 12)",
                      childCount,
                      onDec:
                          childCount > 0
                              ? () => setState(() => childCount--)
                              : null,
                      onInc: () => setState(() => childCount++),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            () => Navigator.pop(context, {
                              'adults': adultCount,
                              'children': childCount,
                            }),
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
      setState(() {
        adults = result['adults']!;
        children = result['children']!;
      });
    }
  }

  Widget _counterRow(
    String label,
    int count, {
    VoidCallback? onDec,
    VoidCallback? onInc,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(onPressed: onDec, icon: const Icon(Icons.remove)),
        Text("$count", style: const TextStyle(fontSize: 18)),
        IconButton(onPressed: onInc, icon: const Icon(Icons.add)),
      ],
    );
  }

  /* -------------------- SEARCH -------------------- */

  void _onSearch() {
    final l10n = AppLocalizations.of(context)!;

    if (fromCity == null || toCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${l10n.fromLabel} / ${l10n.toLabel} required")),
      );
      return;
    }

    if (isRoundTrip && returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a return date")),
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
      date: selectedDate,
      transport: "bus",
      isRoundTrip: isRoundTrip,
      returnDate: returnDate,
    );

    _saveRecentSearch(recent);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SearchResultsScreen(
              from: fromCity!.code,
              to: toCity!.code,
              date: DateFormat('yyyy-MM-dd').format(selectedDate),
              passengers: adults,
              children: children,
              tripType: isRoundTrip ? 'round_trip' : 'one_way',
              returnDate:
                  isRoundTrip && returnDate != null
                      ? DateFormat('yyyy-MM-dd').format(returnDate!)
                      : null,
            ),
      ),
    );
  }

  /* -------------------- UI HELPERS -------------------- */

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

  /* -------------------- TRIP TYPE TOGGLE -------------------- */

  Widget _tripTypeToggle(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap:
                () => setState(() {
                  isRoundTrip = false;
                  returnDate = null;
                }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: !isRoundTrip ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                      !isRoundTrip ? AppColors.primary : AppColors.dividerColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_right_alt,
                    color: !isRoundTrip ? Colors.white : AppColors.mediumText,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.oneWay,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: !isRoundTrip ? Colors.white : AppColors.mediumText,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isRoundTrip = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isRoundTrip ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color:
                      isRoundTrip ? AppColors.primary : AppColors.dividerColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sync_alt,
                    color: isRoundTrip ? Colors.white : AppColors.mediumText,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.roundTrip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isRoundTrip ? Colors.white : AppColors.mediumText,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateLabel = DateFormat(
      'EEE, d MMM',
      Localizations.localeOf(context).toString(),
    ).format(selectedDate);

    final returnDateLabel =
        returnDate != null
            ? DateFormat(
              'EEE, d MMM',
              Localizations.localeOf(context).toString(),
            ).format(returnDate!)
            : l10n.selectDate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.darkText),
        title: Text(
          l10n.searchTitle,
          style: const TextStyle(
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
                          l10n.findYourBus,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.bus,
                          style: const TextStyle(
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
                      AppConstants.imagePath + "home-bus.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Form
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.dividerColor),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    /// One Way / Round Trip Toggle
                    _tripTypeToggle(l10n),

                    const SizedBox(height: 16),

                    _fieldTile(
                      heading: l10n.fromLabel,
                      leading: Image.asset(
                        AppConstants.imagePath + "from.png",
                        height: 28,
                      ),
                      title:
                          fromCity != null ? fromCity!.label : l10n.selectCity,
                      onTap: () => _pickCity(isFrom: true),
                    ),
                    const SizedBox(height: 12),
                    _fieldTile(
                      heading: l10n.toLabel,
                      leading: Image.asset(
                        AppConstants.imagePath + "to.png",
                        height: 28,
                      ),
                      title: toCity != null ? toCity!.label : l10n.selectCity,
                      onTap: () => _pickCity(isFrom: false),
                    ),
                    const SizedBox(height: 12),
                    _fieldTile(
                      heading: l10n.dateLabel,
                      leading: const Icon(
                        Icons.calendar_today,
                        color: AppColors.secondary,
                      ),
                      title: dateLabel,
                      onTap: () => _pickDate(isReturn: false),
                    ),

                    /// Return date — only shown for round trip
                    if (isRoundTrip) ...[
                      const SizedBox(height: 12),
                      _fieldTile(
                        heading: l10n.returnDate,
                        leading: const Icon(
                          Icons.event_repeat,
                          color: AppColors.secondary,
                        ),
                        title: returnDateLabel,
                        onTap: () => _pickDate(isReturn: true),
                      ),
                    ],

                    const SizedBox(height: 12),
                    _fieldTile(
                      heading: l10n.passengerLabel,
                      leading: const Icon(
                        Icons.person_outlined,
                        color: AppColors.secondary,
                      ),
                      title:
                          "$adults Adult(s)${children > 0 ? ', $children Child(ren)' : ''}",
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
                                  selectedDate = r.date;
                                  isRoundTrip = r.isRoundTrip ?? false;
                                  returnDate = r.returnDate;
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

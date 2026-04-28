// import 'package:flutter/material.dart';
// import 'package:gobus_app/core/theme.dart';
// import 'package:gobus_app/core/utils.dart';
// import 'package:gobus_app/features/search/models/trip.dart';
// import 'package:gobus_app/l10n/gen/app_localizations.dart';
// import 'package:gobus_app/providers/search_result_provider.dart';
// import 'package:gobus_app/screens/Search/trip_details_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class SearchResultsScreen extends StatelessWidget {
//   final String from;
//   final String to;
//   final int passengers;
//   final String date;

//   const SearchResultsScreen({
//     super.key,
//     required this.from,
//     required this.to,
//     required this.passengers,
//     required this.date,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create:
//           (_) =>
//               SearchResultProvider()
//                 ..load(from: from, to: to, date: date, passengers: passengers),
//       child: _SearchResultsView(from: from, to: to, passengers: passengers),
//     );
//   }
// }

// class _SearchResultsView extends StatelessWidget {
//   final String from;
//   final String to;
//   final int passengers;

//   const _SearchResultsView({
//     required this.from,
//     required this.to,
//     required this.passengers,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<SearchResultProvider>();
//     final l10n = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: AppColors.darkText),
//         title: const Text(
//           "Results",
//           style: TextStyle(
//             color: AppColors.darkText,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body:
//           provider.isLoading
//               ? loader()
//               : Column(
//                 children: [
//                   _header(context),
//                   const Divider(height: 1),
//                   Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount: provider.trips.length,
//                       itemBuilder: (_, i) {
//                         return _TripCard(
//                           trip: provider.trips[i],
//                           totalPassengers: passengers,
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//     );
//   }

//   /// ---------- TOP SUMMARY ----------
//   Widget _header(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               _locationBlock(from),
//               const Spacer(),
//               Column(
//                 children: [
//                   const Icon(Icons.directions_bus, color: AppColors.primary),
//                   const SizedBox(height: 4),
//                   Text(
//                     "$passengers " + l10n.passengers,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.mediumText,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               _locationBlock(to),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               _actionChip(Icons.filter_alt_outlined, "Filters"),
//               const SizedBox(width: 12),
//               _actionChip(Icons.sort, "Sort"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _locationBlock(String code) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           code,
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _actionChip(IconData icon, String label) {
//     return Expanded(
//       child: OutlinedButton.icon(
//         onPressed: () {},
//         icon: Icon(icon, size: 18, color: AppColors.primary),
//         label: Text(label),
//         style: OutlinedButton.styleFrom(
//           side: const BorderSide(color: AppColors.dividerColor),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ---------- TRIP CARD ----------
// class _TripCard extends StatelessWidget {
//   final Trip trip;
//   final int totalPassengers;

//   _TripCard({required this.trip, required this.totalPassengers});

//   @override
//   Widget build(BuildContext context) {
//     final departureTime = DateFormat.Hm().format(trip.departure);
//     final arrivalTime = DateFormat.Hm().format(
//       trip.departure.add(Duration(minutes: trip.durationMinutes)),
//     );

//     final dateLabel = DateFormat("dd MMM, EEE").format(trip.departure);

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (_) => TripDetailsScreen(
//                   trip.scheduleId,
//                   trip.providerName,
//                   trip.providerLogo,
//                   trip,
//                   totalPassengers,
//                 ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColors.dividerColor),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           children: [
//             /// PROVIDER
//             Row(
//               children: [
//                 Container(
//                   height: 50,
//                   width: 50,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),

//                   child: Image.network(trip.providerLogo),
//                 ),

//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     trip.providerName, // API can add later
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 _comfortChip(trip.comfort),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// TIMES
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _timeBlock(departureTime, dateLabel),
//                 Column(
//                   children: [
//                     Text(
//                       "${trip.durationMinutes ~/ 60} hr ${trip.durationMinutes % 60} min",
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.mediumText,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       trip.totalStops, // static
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.lightText,
//                       ),
//                     ),
//                   ],
//                 ),
//                 _timeBlock(arrivalTime, dateLabel),
//               ],
//             ),

//             const SizedBox(height: 14),
//             const Divider(),

//             /// FOOTER
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${trip.seats} seats left",
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: AppColors.mediumText,
//                   ),
//                 ),
//                 Text(
//                   "XAF ${trip.price}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: AppColors.secondary,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 6),

//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "View Detail >",
//                 style: TextStyle(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _timeBlock(String time, String date) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           time,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           date,
//           style: const TextStyle(fontSize: 12, color: AppColors.mediumText),
//         ),
//       ],
//     );
//   }

//   Widget _comfortChip(String comfort) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         comfort.toUpperCase(),
//         style: const TextStyle(
//           fontSize: 11,
//           color: AppColors.primary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/core/utils.dart';
import 'package:gobus_app/features/search/models/trip.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/providers/search_result_provider.dart';
import 'package:gobus_app/screens/Search/trip_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatelessWidget {
  final String from;
  final String to;
  final int passengers;
  final String date;
  final String tripType;
  final String? returnDate;
  final int children;

  const SearchResultsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.passengers,
    required this.date,
    required this.children,
    this.tripType = 'one_way',
    this.returnDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) =>
              SearchResultProvider()..load(
                from: from,
                to: to,
                date: date,
                passengers: passengers,
                children: children,
                tripType: tripType,
                returnDate: returnDate,
              ),
      child: _SearchResultsView(
        from: from,
        to: to,
        passengers: passengers,
        children: children,
        tripType: tripType,
      ),
    );
  }
}

class _SearchResultsView extends StatelessWidget {
  final String from;
  final String to;
  final int passengers;
  final int children;
  final String tripType;

  const _SearchResultsView({
    required this.from,
    required this.to,
    required this.passengers,
    required this.children,
    required this.tripType,
  });

  bool get isRoundTrip => tripType == 'round_trip';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchResultProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.darkText),
        title: Text(
          isRoundTrip ? l10n.roundTrip : l10n.oneWay,
          style: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body:
          provider.isLoading
              ? loader()
              : Column(
                children: [
                  _header(context),
                  const Divider(height: 1),
                  Expanded(
                    child:
                        provider.trips.isEmpty
                            ? _emptyState(l10n)
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.trips.length,
                              itemBuilder: (_, i) {
                                if (isRoundTrip) {
                                  return _RoundTripCard(
                                    trip: provider.trips[i],
                                    totalPassengers: passengers,
                                    children: children,
                                  );
                                }
                                return _TripCard(
                                  trip: provider.trips[i],
                                  totalPassengers: passengers,
                                  children: children,
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _emptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_bus_outlined,
            size: 60,
            color: AppColors.dividerColor,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.no_data,
            style: const TextStyle(color: AppColors.mediumText, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              _locationBlock(from),
              const Spacer(),
              Column(
                children: [
                  Icon(
                    isRoundTrip ? Icons.sync_alt : Icons.arrow_right_alt,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$passengers ${l10n.passengers} + $children ${l10n.children}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumText,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _locationBlock(to),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _actionChip(Icons.filter_alt_outlined, "Filters"),
              const SizedBox(width: 12),
              _actionChip(Icons.sort, "Sort"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationBlock(String code) {
    return Text(
      code,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _actionChip(IconData icon, String label) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18, color: AppColors.primary),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ONE WAY TRIP CARD (unchanged logic)
// ─────────────────────────────────────────────
class _TripCard extends StatelessWidget {
  final Trip trip;
  final int totalPassengers;
  final int children;

  const _TripCard({
    required this.trip,
    required this.totalPassengers,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final departureTime = DateFormat.Hm().format(trip.departure);
    final arrivalTime = DateFormat.Hm().format(
      trip.departure.add(Duration(minutes: trip.durationMinutes)),
    );
    final dateLabel = DateFormat("dd MMM, EEE").format(trip.departure);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => TripDetailsScreen(
                  trip.scheduleId,
                  trip.providerName,
                  trip.providerLogo,
                  trip,
                  totalPassengers,
                  tripType: 'one_way',
                  children: children,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            /// Provider
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(trip.providerLogo),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    trip.providerName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                _comfortChip(trip.comfort),
              ],
            ),

            const SizedBox(height: 16),

            /// Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _timeBlock(departureTime, dateLabel),
                Column(
                  children: [
                    Text(
                      "${trip.durationMinutes ~/ 60}h ${trip.durationMinutes % 60}m",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.totalStops,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightText,
                      ),
                    ),
                  ],
                ),
                _timeBlock(arrivalTime, dateLabel),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(),

            /// Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${trip.seats} seats left",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mediumText,
                  ),
                ),
                Text(
                  "XAF ${trip.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "View Detail >",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeBlock(String time, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          date,
          style: const TextStyle(fontSize: 12, color: AppColors.mediumText),
        ),
      ],
    );
  }

  Widget _comfortChip(String comfort) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        comfort.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROUND TRIP CARD
// ─────────────────────────────────────────────
class _RoundTripCard extends StatelessWidget {
  final Trip trip;
  final int totalPassengers;
  final int children;

  const _RoundTripCard({
    required this.trip,
    required this.totalPassengers,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final outbound = trip.outbound!;
    final returnLeg = trip.returnLeg!;

    final outDeparture = DateFormat.Hm().format(outbound.departure);
    final outArrival = DateFormat.Hm().format(
      outbound.departure.add(Duration(minutes: outbound.durationMinutes)),
    );
    final outDate = DateFormat("dd MMM, EEE").format(outbound.departure);

    final retDeparture = DateFormat.Hm().format(returnLeg.departure);
    final retArrival = DateFormat.Hm().format(
      returnLeg.departure.add(Duration(minutes: returnLeg.durationMinutes)),
    );
    final retDate = DateFormat("dd MMM, EEE").format(returnLeg.departure);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => TripDetailsScreen(
                  outbound.scheduleId,
                  outbound.providerName,
                  outbound.providerLogo,
                  outbound,
                  totalPassengers,
                  tripType: 'round_trip',
                  children: children,
                  returnScheduleId: returnLeg.scheduleId,
                  roundTripTotalPrice: trip.roundTripTotalPrice,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            /// Provider + round trip badge
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(outbound.providerLogo),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      outbound.providerName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "ROUND TRIP",
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.dividerColor),

            /// Outbound leg
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_right_alt,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Outbound",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        outbound.comfort.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _legRow(
                    departureTime: outDeparture,
                    arrivalTime: outArrival,
                    date: outDate,
                    duration:
                        "${outbound.durationMinutes ~/ 60}h ${outbound.durationMinutes % 60}m",
                    stops: outbound.totalStops,
                    seats: outbound.seats,
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.dividerColor),

            /// Return leg
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.sync_alt,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Return",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        returnLeg.comfort.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _legRow(
                    departureTime: retDeparture,
                    arrivalTime: retArrival,
                    date: retDate,
                    duration:
                        "${returnLeg.durationMinutes ~/ 60}h ${returnLeg.durationMinutes % 60}m",
                    stops: returnLeg.totalStops,
                    seats: returnLeg.seats,
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.dividerColor),

            /// Price footer
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total round trip",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumText,
                        ),
                      ),
                      Text(
                        "XAF ${trip.roundTripTotalPrice?.toStringAsFixed(0) ?? '-'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        "XAF ${trip.roundTripPricePerPassenger?.toStringAsFixed(0) ?? '-'} per person",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.lightText,
                        ),
                      ),
                      trip.roundTripChildPrice! > 0
                          ? Text(
                            "XAF ${trip.roundTripChildPrice?.toStringAsFixed(0) ?? '-'} per ${l10n.child}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.lightText,
                            ),
                          )
                          : Container(),
                    ],
                  ),
                  const Text(
                    "View Detail >",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legRow({
    required String departureTime,
    required String arrivalTime,
    required String date,
    required String duration,
    required String stops,
    required int seats,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Departure
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              departureTime,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: AppColors.mediumText),
            ),
          ],
        ),

        /// Duration + stops
        Column(
          children: [
            Text(
              duration,
              style: const TextStyle(fontSize: 11, color: AppColors.mediumText),
            ),
            const SizedBox(height: 2),
            Text(
              stops,
              style: const TextStyle(fontSize: 11, color: AppColors.lightText),
            ),
            const SizedBox(height: 2),
            Text(
              "$seats seats",
              style: const TextStyle(fontSize: 11, color: AppColors.lightText),
            ),
          ],
        ),

        /// Arrival
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              arrivalTime,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: AppColors.mediumText),
            ),
          ],
        ),
      ],
    );
  }
}

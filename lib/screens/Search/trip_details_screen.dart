// import 'dart:convert';
// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:gobus_app/Widgets/design_utils.dart';
// import 'package:gobus_app/core/api/api_constants.dart';
// import 'package:gobus_app/core/api/api_logger.dart';
// import 'package:gobus_app/core/theme.dart';
// import 'package:gobus_app/core/utils.dart';
// import 'package:gobus_app/features/search/models/trip.dart';
// import 'package:gobus_app/features/tripSearchDetail/models/trip_details_model.dart';
// import 'package:gobus_app/features/tripSearchDetail/models/trip_info.dart';
// import 'package:gobus_app/l10n/gen/app_localizations.dart';
// import 'package:gobus_app/screens/Search/seat_selection_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class TripDetailsScreen extends StatefulWidget {
//   final int scheduleId;
//   final String providerName;
//   final String providerLogo;
//   final Trip trip;
//   final int totalPassengers;
//   final int children;
//   final String tripType;
//   final int? returnScheduleId;
//   final double? roundTripTotalPrice;

//   const TripDetailsScreen(
//     this.scheduleId,
//     this.providerName,
//     this.providerLogo,
//     this.trip,
//     this.totalPassengers, {
//     super.key,
//     this.children = 0,
//     this.tripType = 'one_way',
//     this.returnScheduleId,
//     this.roundTripTotalPrice,
//   });

//   @override
//   State<TripDetailsScreen> createState() => _TripDetailsScreenState();
// }

// class _TripDetailsScreenState extends State<TripDetailsScreen> {
//   bool loading = true;
//   String? error;
//   TripDetails? details;

//   // Selected seats
//   List<String> selectedOutboundSeats = [];
//   List<String> selectedReturnSeats = [];

//   bool get isRoundTrip => widget.tripType == 'round_trip';
//   int get adults => widget.totalPassengers;
//   int get children => widget.children;
//   int get totalSeatsNeeded => adults + children;

//   @override
//   void initState() {
//     super.initState();
//     _loadDetails();
//   }

//   Future<void> _loadDetails() async {
//     try {
//       final queryParams =
//           'trip_type=${widget.tripType}'
//           '${widget.returnScheduleId != null ? '&return_schedule_id=${widget.returnScheduleId}'
//                   '&adult=${widget.totalPassengers}'
//                   '&children=${widget.children}' : '&adult=${widget.totalPassengers}'
//                   '&children=${widget.children}'}';

//       final uri = Uri.parse(
//         '${ApiConstants.baseUrl}trips/${widget.scheduleId}/details?$queryParams',
//       );

//       final res = await http.get(
//         uri,
//         headers: {
//           HttpHeaders.acceptHeader: 'application/json',
//           HttpHeaders.contentTypeHeader: 'application/json',
//         },
//       );
//       ApiLogger.logRequest(uri.toString(), res.body);
//       final decoded = jsonDecode(res.body);

//       if (decoded['status']) {
//         setState(() {
//           details = TripDetails.fromJson(decoded['data']);

//           loading = false;
//         });
//       } else {
//         setState(() {
//           error = decoded['error'] ?? 'Failed to load trip';
//           loading = false;
//         });
//       }
//     } catch (e, stackTrace) {
//       setState(() {
//         error = e.toString();
//         print('❌ ERROR: $e');
//         print('📍 STACKTRACE: $stackTrace');
//         loading = false;
//       });
//     }
//   }

//   Future<void> _openSeatSelection() async {
//     final result = await Navigator.push<Map<String, List<String>>>(
//       context,
//       MaterialPageRoute(
//         builder:
//             (_) => SeatSelectionScreen(
//               isRoundTrip: isRoundTrip,
//               totalPassengers: totalSeatsNeeded,
//               outboundSeatMap:
//                   details!.seatMap
//                       .map(
//                         (s) => {
//                           'seat_number': s.seatNumber,
//                           'status': s.status,
//                         },
//                       )
//                       .toList(),
//               returnSeatMap:
//                   isRoundTrip
//                       ? details!.returnSeatMap
//                           .map(
//                             (s) => {
//                               'seat_number': s.seatNumber,
//                               'status': s.status,
//                             },
//                           )
//                           .toList()
//                       : [],
//               preselectedOutbound: selectedOutboundSeats,
//               preselectedReturn: selectedReturnSeats,
//               outboundLayoutImage: details!.vehicle.layout,
//               returnLayoutImage: isRoundTrip ? details!.vehicle.layout : '',
//               outboundLabel:
//                   '${details!.trip.from.name} → ${details!.trip.to.name}',
//               returnLabel:
//                   isRoundTrip
//                       ? '${details!.returnTrip!.from.name} → ${details!.returnTrip!.to.name}'
//                       : '',
//             ),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         selectedOutboundSeats = result['outbound'] ?? [];
//         selectedReturnSeats = result['return'] ?? [];
//       });
//     }
//   }

//   bool get seatsFullySelected {
//     if (isRoundTrip) {
//       return selectedOutboundSeats.length == totalSeatsNeeded &&
//           selectedReturnSeats.length == totalSeatsNeeded;
//     }
//     return selectedOutboundSeats.length == totalSeatsNeeded;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     if (loading) return Scaffold(body: loader());
//     if (error != null) {
//       return Scaffold(appBar: AppBar(), body: Center(child: Text(error!)));
//     }

//     final d = details!;
//     final trip = d.trip;
//     final departure = DateTime.parse(trip.departure.toIso8601String());

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: const BackButton(color: Colors.black),
//         title: Text(
//           isRoundTrip ? 'Round Trip Details' : 'Trip Details',
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Vehicle images
//             _vehicleImages(d),

//             const SizedBox(height: 16),

//             // Provider
//             _providerRow(),

//             const Divider(height: 32, color: AppColors.dividerColor),

//             // Outbound leg info
//             _legSection(
//               label: isRoundTrip ? 'Outbound' : null,
//               labelColor: AppColors.primary,
//               scheduleInfo: d.trip,
//               durationMinutes: widget.trip.durationMinutes,
//               stops: d.stops,
//               isOutbound: true,
//             ),

//             // Return leg info (round trip only)
//             if (isRoundTrip && d.returnTrip != null) ...[
//               const Divider(height: 32, color: AppColors.dividerColor),
//               _legSection(
//                 label: 'Return',
//                 labelColor: AppColors.secondary,
//                 scheduleInfo: d.returnTrip!,
//                 durationMinutes: widget.trip.durationMinutes,
//                 stops: d.returnStops,
//                 isOutbound: false,
//               ),
//             ],

//             const Divider(height: 32, color: AppColors.dividerColor),

//             // Seat selection row
//             _seatSelectionTile(),

//             const Divider(height: 32, color: AppColors.dividerColor),

//             // Pricing breakdown
//             //_pricingBreakdown(d),
//             _pricingCard(l10n, d),
//             const Divider(height: 32, color: AppColors.dividerColor),

//             // Route stops
//             if (d.stops.isNotEmpty) ...[
//               _routeSection('Bus Route', d.stops, d.trip),
//               const Divider(height: 32, color: AppColors.dividerColor),
//             ],

//             // Legal
//             ..._legalSections(d),

//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _bookButton(),
//     );
//   }

//   Widget _vehicleImages(TripDetails d) {
//     final images = d.vehicle.images;
//     if (images.isEmpty) {
//       return Container(
//         height: 200,
//         color: AppColors.primaryBackground,
//         child: const Center(
//           child: Icon(
//             Icons.directions_bus,
//             size: 80,
//             color: AppColors.dividerColor,
//           ),
//         ),
//       );
//     }

//     return CarouselSlider(
//       items:
//           images.map<Widget>((img) {
//             return Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: DecorationImage(
//                   image: NetworkImage(img),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           }).toList(),
//       options: CarouselOptions(
//         height: 200,
//         viewportFraction: 1,
//         enableInfiniteScroll: false,
//         autoPlay: images.length > 1,
//       ),
//     );
//   }

//   Widget _providerRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Container(
//             height: 50,
//             width: 50,
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(color: AppColors.dividerColor),
//             ),
//             child: Image.network(widget.providerLogo),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               widget.providerName,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//                 color: AppColors.darkText,
//               ),
//             ),
//           ),
//           //const Spacer(),
//           if (isRoundTrip)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: AppColors.secondary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 'ROUND TRIP',
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: AppColors.secondary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _legSection({
//     String? label,
//     Color labelColor = AppColors.primary,
//     required TripInfo scheduleInfo,
//     required int durationMinutes,
//     required List stops,
//     required bool isOutbound,
//   }) {
//     final departure = scheduleInfo.departure;
//     final departureTime = DateFormat('HH:mm').format(departure);
//     final arrivalTime = DateFormat(
//       'HH:mm',
//     ).format(departure.add(Duration(minutes: durationMinutes)));
//     final dateLabel = DateFormat('dd MMM, EEE').format(departure);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (label != null) ...[
//             Row(
//               children: [
//                 Icon(
//                   isOutbound ? Icons.arrow_right_alt : Icons.sync_alt,
//                   color: labelColor,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: labelColor,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//           ],
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _timeBlock(departureTime, dateLabel, scheduleInfo.from.name),
//               Column(
//                 children: [
//                   Text(
//                     '${durationMinutes ~/ 60}h ${durationMinutes % 60}m',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.mediumText,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     height: 1,
//                     width: 80,
//                     color: AppColors.dividerColor,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     stops.isEmpty ? 'Non-stop' : '${stops.length} Stop(s)',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.lightText,
//                     ),
//                   ),
//                 ],
//               ),
//               _timeBlock(arrivalTime, dateLabel, scheduleInfo.to.name),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _timeBlock(String time, String date, String city) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(time, style: const TextStyle(fontSize: 22, fontFamily: 'medium')),
//         Text(
//           date,
//           style: const TextStyle(fontSize: 12, color: AppColors.lightText),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           city,
//           style: const TextStyle(
//             fontFamily: 'medium',
//             color: AppColors.secondary,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _seatSelectionTile() {
//     final outboundText =
//         selectedOutboundSeats.isEmpty
//             ? 'Tap to select'
//             : selectedOutboundSeats.join(', ');
//     final returnText =
//         selectedReturnSeats.isEmpty
//             ? 'Tap to select'
//             : selectedReturnSeats.join(', ');

//     return InkWell(
//       onTap: _openSeatSelection,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(
//                   Icons.event_seat,
//                   color: AppColors.primary,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Selected Seats',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.darkText,
//                   ),
//                 ),
//                 const Spacer(),
//                 const Icon(Icons.chevron_right, color: AppColors.lightText),
//               ],
//             ),
//             const SizedBox(height: 8),
//             _seatChipRow(
//               label: isRoundTrip ? 'Outbound' : null,
//               seats: selectedOutboundSeats,
//               placeholder: outboundText,
//               color: AppColors.primary,
//             ),
//             if (isRoundTrip) ...[
//               const SizedBox(height: 6),
//               _seatChipRow(
//                 label: 'Return',
//                 seats: selectedReturnSeats,
//                 placeholder: returnText,
//                 color: AppColors.secondary,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _seatChipRow({
//     String? label,
//     required List<String> seats,
//     required String placeholder,
//     required Color color,
//   }) {
//     return Row(
//       children: [
//         if (label != null) ...[
//           Text(
//             '$label: ',
//             style: TextStyle(
//               fontSize: 12,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//         if (seats.isEmpty)
//           Text(
//             placeholder,
//             style: const TextStyle(color: AppColors.mediumText, fontSize: 13),
//           )
//         else
//           Expanded(
//             child: Wrap(
//               spacing: 6,
//               children:
//                   seats
//                       .map(
//                         (s) => Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: color.withOpacity(0.4)),
//                           ),
//                           child: Text(
//                             s,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: color,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       )
//                       .toList(),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _pricingBreakdown(TripDetails d) {
//     final pricing = d.pricing;

//     // Calculate totals
//     double adultPrice =
//         isRoundTrip
//             ? (pricing?.roundTripPricePerPassenger ??
//                 widget.trip.price.toDouble())
//             : (pricing?.oneWayPricePerPassenger ??
//                 widget.trip.price.toDouble());

//     double childPrice =
//         isRoundTrip
//             ? (pricing?.roundTripChildPricePerPassenger ?? adultPrice) * 2
//             : (pricing?.oneWayChildPricePerPassenger ?? adultPrice);

//     double adultTotal = adultPrice * adults;
//     double childTotal = childPrice * children;
//     double grandTotal = adultTotal + childTotal;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Price Breakdown',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.darkText,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // Adults row
//           _priceRow(
//             label: '$adults Adult${adults > 1 ? 's' : ''}',
//             unitPrice: adultPrice,
//             total: adultTotal,
//           ),

//           // Children row (only if children > 0)
//           if (children > 0) ...[
//             const SizedBox(height: 8),
//             _priceRow(
//               label: '$children Child${children > 1 ? 'ren' : ''}',
//               unitPrice: childPrice,
//               total: childTotal,
//               note: isRoundTrip ? '(×2 for round trip)' : null,
//             ),
//           ],

//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Divider(color: AppColors.dividerColor),
//           ),

//           // // Grand total
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Text(
//           //       isRoundTrip ? 'Total (Round Trip)' : 'Total',
//           //       style: const TextStyle(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.w600,
//           //         color: AppColors.darkText,
//           //       ),
//           //     ),
//           //     Text(
//           //       'XAF ${grandTotal.toStringAsFixed(0)}',
//           //       style: const TextStyle(
//           //         fontSize: 20,
//           //         fontWeight: FontWeight.bold,
//           //         color: AppColors.primary,
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _priceRow({
//     required String label,
//     required double unitPrice,
//     required double total,
//     String? note,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(fontSize: 14, color: AppColors.darkText),
//               ),
//               if (note != null)
//                 Text(
//                   note,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: AppColors.lightText,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         Text(
//           'XAF ${unitPrice.toStringAsFixed(0)} × ${label.split(' ')[0]}',
//           style: const TextStyle(fontSize: 13, color: AppColors.mediumText),
//         ),
//         const SizedBox(width: 16),
//         Text(
//           '${total.toStringAsFixed(0)} XAF',
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppColors.darkText,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _routeSection(String title, List stops, TripInfo tripInfo) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//           ),
//           const SizedBox(height: 16),
//           _routePoint(tripInfo.from.name, isStart: true),
//           ...stops.map((s) => _routePoint(s.cityName)).toList(),
//           _routePoint(tripInfo.to.name, isEnd: true),
//         ],
//       ),
//     );
//   }

//   Widget _routePoint(String city, {bool isStart = false, bool isEnd = false}) {
//     return Row(
//       children: [
//         Column(
//           children: [
//             if (!isStart)
//               Container(width: 1, height: 20, color: AppColors.dividerColor),
//             Container(
//               padding: const EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color:
//                     isStart
//                         ? AppColors.primary
//                         : isEnd
//                         ? AppColors.secondary
//                         : AppColors.white,
//                 border:
//                     (!isStart && !isEnd)
//                         ? Border.all(color: AppColors.dividerColor)
//                         : null,
//               ),
//               child: Icon(
//                 isStart
//                     ? Icons.location_searching_sharp
//                     : isEnd
//                     ? Icons.location_pin
//                     : Icons.circle,
//                 color: isStart || isEnd ? Colors.white : AppColors.lightText,
//                 size: isStart || isEnd ? 16 : 8,
//               ),
//             ),
//             if (!isEnd)
//               Container(width: 1, height: 20, color: AppColors.dividerColor),
//           ],
//         ),
//         const SizedBox(width: 12),
//         Text(city, style: const TextStyle(color: AppColors.darkText)),
//       ],
//     );
//   }

//   List<Widget> _legalSections(TripDetails d) {
//     // legal_values is returned as raw Setting records from DB
//     // We render them the same as the original screen
//     List<Widget> widgetList =
//         d.legalValues
//             .map(
//               (item) => Container(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     heading(item['label']),
//                     SizedBox(height: 16),
//                     ...(item['value']
//                         .toString()
//                         .split("\r\n")
//                         .map((bullet) => _bullet(bullet))),

//                     // Text(
//                     //   "- " +
//                     //       item['value'].toString().replaceAll("\r\n", "\n- "),
//                     // ),
//                   ],
//                 ),
//               ),
//             )
//             .toList();
//     return widgetList;
//   }

//   Widget _bookButton() {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
//         ),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor:
//                 seatsFullySelected ? AppColors.primary : AppColors.dividerColor,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//           onPressed:
//               seatsFullySelected
//                   ? () {
//                     // Booking flow — next step
//                   }
//                   : null,
//           child: Text(
//             seatsFullySelected
//                 ? 'Book Now'
//                 : 'Select ${totalSeatsNeeded - selectedOutboundSeats.length} more seat(s)',
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _pricingCard(AppLocalizations l10n, TripDetails d) {
//     final pricing = d?.pricing;
//     // Calculate totals
//     double adultPrice =
//         isRoundTrip
//             ? (pricing?.roundTripPricePerPassenger ??
//                 widget.trip.price.toDouble())
//             : (pricing?.oneWayPricePerPassenger ??
//                 widget.trip.price.toDouble());

//     double childPrice =
//         isRoundTrip
//             ? (pricing?.roundTripChildPricePerPassenger ?? adultPrice) * 2
//             : (pricing?.oneWayChildPricePerPassenger ?? adultPrice);

//     double adultTotal = adultPrice * adults;
//     double childTotal = childPrice * children;
//     double grandTotal = adultTotal + childTotal;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         //borderRadius: BorderRadius.circular(14),
//         color: Colors.white,
//         //boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             l10n.price_breakdown,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),

//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 14),
//             child: Divider(color: AppColors.dividerColor),
//           ),

//           // Adults row
//           _priceRow(
//             label: '$adults Adult${adults > 1 ? 's' : ''}',
//             unitPrice: adultPrice,
//             total: adultTotal,
//           ),

//           // Children row (only if children > 0)
//           if (children > 0) ...[
//             const SizedBox(height: 8),
//             _priceRow(
//               label: '$children Child${children > 1 ? 'ren' : ''}',
//               unitPrice: childPrice,
//               total: childTotal,
//               note: isRoundTrip ? '(×2 for round trip)' : null,
//             ),
//           ],

//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 14),
//             child: Divider(color: AppColors.dividerColor),
//           ),
//           _pricingRow(
//             l10n.base_price,
//             "${pricing?.basePrice?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
//           ),
//           const SizedBox(height: 8),
//           _pricingRow(
//             l10n.platform_commission,
//             "${pricing?.commission?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
//           ),

//           // const SizedBox(height: 8),
//           // _pricingRow(
//           //   l10n.insurance,
//           //   "${pricing?.insurance?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
//           // ),
//           const SizedBox(height: 8),

//           _pricingRow(
//             "VAT (${pricing?.vatPercent ?? 0}%)",
//             "${pricing?.vatAmount?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
//           ),

//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 14),
//             child: Divider(color: AppColors.dividerColor),
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 l10n.total_price,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "${pricing?.grandTotal?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pricingRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [Text(label), Text(value)],
//     );
//   }

//   Widget _bullet(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("• "),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(color: AppColors.lightText, fontSize: 13),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/design_utils.dart';
import 'package:gobus_app/core/api/api_constants.dart';
import 'package:gobus_app/core/api/api_logger.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/core/utils.dart';
import 'package:gobus_app/features/passenger/providers/passenger_provider.dart';
import 'package:gobus_app/features/search/models/trip.dart';
import 'package:gobus_app/features/tripSearchDetail/models/trip_details_model.dart';
import 'package:gobus_app/features/tripSearchDetail/models/trip_info.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/screens/Search/seat_selection_screen.dart';
import 'package:gobus_app/screens/Search/widgets/passenger_selection_section.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TripDetailsScreen extends StatefulWidget {
  final int scheduleId;
  final String providerName;
  final String providerLogo;
  final Trip trip;
  final int totalPassengers;
  final int children;
  final String tripType;
  final int? returnScheduleId;
  final double? roundTripTotalPrice;

  const TripDetailsScreen(
    this.scheduleId,
    this.providerName,
    this.providerLogo,
    this.trip,
    this.totalPassengers, {
    super.key,
    this.children = 0,
    this.tripType = 'one_way',
    this.returnScheduleId,
    this.roundTripTotalPrice,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  bool loading = true;
  String? error;
  TripDetails? details;

  // Seats
  List<String> selectedOutboundSeats = [];
  List<String> selectedReturnSeats = [];

  // Passengers
  List<PassengerSlot> _passengerSlots = [];

  bool get isRoundTrip => widget.tripType == 'round_trip';
  int get adults => widget.totalPassengers;
  int get children => widget.children;
  int get totalSeatsNeeded => adults + children;

  bool get seatsFullySelected {
    if (isRoundTrip) {
      return selectedOutboundSeats.length == totalSeatsNeeded &&
          selectedReturnSeats.length == totalSeatsNeeded;
    }
    return selectedOutboundSeats.length == totalSeatsNeeded;
  }

  bool get passengersFullyAssigned =>
      _passengerSlots.isNotEmpty && _passengerSlots.every((s) => s.isFilled);

  /// Book button is enabled only when both seats AND passengers are done
  bool get canBook => seatsFullySelected && passengersFullyAssigned;

  // ─── Load trip details ────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final queryParams =
          'trip_type=${widget.tripType}'
          '${widget.returnScheduleId != null ? '&return_schedule_id=${widget.returnScheduleId}' : ''}'
          '&adult=${widget.totalPassengers}'
          '&children=${widget.children}';

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}trips/${widget.scheduleId}/details?$queryParams',
      );

      final res = await http.get(
        uri,
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      ApiLogger.logRequest(uri.toString(), res.body);
      final decoded = jsonDecode(res.body);

      if (decoded['status'] == true) {
        setState(() {
          details = TripDetails.fromJson(decoded['data']);
          loading = false;
        });
      } else {
        setState(() {
          error = decoded['error'] ?? 'Failed to load trip';
          loading = false;
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        error = e.toString();
        print('❌ ERROR: $e');
        print('📍 STACKTRACE: $stackTrace');
        loading = false;
      });
    }
  }

  // ─── Seat selection ───────────────────────────────────────────────────────

  Future<void> _openSeatSelection() async {
    final result = await Navigator.push<Map<String, List<String>>>(
      context,
      MaterialPageRoute(
        builder:
            (_) => SeatSelectionScreen(
              isRoundTrip: isRoundTrip,
              totalPassengers: totalSeatsNeeded,
              outboundSeatMap:
                  details!.seatMap
                      .map(
                        (s) => {
                          'seat_number': s.seatNumber,
                          'status': s.status,
                        },
                      )
                      .toList(),
              returnSeatMap:
                  isRoundTrip
                      ? details!.returnSeatMap
                          .map(
                            (s) => {
                              'seat_number': s.seatNumber,
                              'status': s.status,
                            },
                          )
                          .toList()
                      : [],
              preselectedOutbound: selectedOutboundSeats,
              preselectedReturn: selectedReturnSeats,
              outboundLayoutImage: details!.vehicle.layout,
              returnLayoutImage: isRoundTrip ? details!.vehicle.layout : '',
              outboundLabel:
                  '${details!.trip.from.name} → ${details!.trip.to.name}',
              returnLabel:
                  isRoundTrip
                      ? '${details!.returnTrip!.from.name} → ${details!.returnTrip!.to.name}'
                      : '',
            ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedOutboundSeats = result['outbound'] ?? [];
        selectedReturnSeats = result['return'] ?? [];
      });
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) return Scaffold(body: loader());
    if (error != null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(error!)));
    }

    final d = details!;

    return ChangeNotifierProvider(
      create: (_) => PassengerProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(color: Colors.black),
          title: Text(
            isRoundTrip ? 'Round Trip Details' : 'Trip Details',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Vehicle images
              _vehicleImages(d),
              const SizedBox(height: 16),

              // 2. Provider row
              _providerRow(),
              const Divider(height: 32, color: AppColors.dividerColor),

              // 3. Outbound leg
              _legSection(
                label: isRoundTrip ? 'Outbound' : null,
                labelColor: AppColors.primary,
                scheduleInfo: d.trip,
                durationMinutes: widget.trip.durationMinutes,
                stops: d.stops,
                isOutbound: true,
              ),

              // 4. Return leg (round trip only)
              if (isRoundTrip && d.returnTrip != null) ...[
                const Divider(height: 32, color: AppColors.dividerColor),
                _legSection(
                  label: 'Return',
                  labelColor: AppColors.secondary,
                  scheduleInfo: d.returnTrip!,
                  durationMinutes: widget.trip.durationMinutes,
                  stops: d.returnStops,
                  isOutbound: false,
                ),
              ],

              const Divider(height: 32, color: AppColors.dividerColor),

              // 5. Seat selection
              _seatSelectionTile(),
              const Divider(height: 32, color: AppColors.dividerColor),

              // 6. ── PASSENGER SELECTION ─────────────────────────────────────
              PassengerSelectionSection(
                adults: adults,
                children: children,
                onSlotsChanged: (slots) {
                  setState(() => _passengerSlots = slots);
                },
              ),
              const Divider(height: 32, color: AppColors.dividerColor),

              // 7. Pricing card
              _pricingCard(l10n, d),
              const Divider(height: 32, color: AppColors.dividerColor),

              // 8. Route stops
              if (d.stops.isNotEmpty) ...[
                _routeSection('Bus Route', d.stops, d.trip),
                const Divider(height: 32, color: AppColors.dividerColor),
              ],

              // 9. Legal sections
              ..._legalSections(d),

              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: _bookButton(),
      ),
    );
  }

  // ─── Vehicle images ───────────────────────────────────────────────────────

  Widget _vehicleImages(TripDetails d) {
    final images = d.vehicle.images;
    if (images.isEmpty) {
      return Container(
        height: 200,
        color: AppColors.primaryBackground,
        child: const Center(
          child: Icon(
            Icons.directions_bus,
            size: 80,
            color: AppColors.dividerColor,
          ),
        ),
      );
    }
    return CarouselSlider(
      items:
          images
              .map<Widget>(
                (img) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(img),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              .toList(),
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1,
        enableInfiniteScroll: false,
        autoPlay: images.length > 1,
      ),
    );
  }

  // ─── Provider row ─────────────────────────────────────────────────────────

  Widget _providerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: Image.network(widget.providerLogo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.providerName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkText,
              ),
            ),
          ),
          if (isRoundTrip)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'ROUND TRIP',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Leg section ─────────────────────────────────────────────────────────

  Widget _legSection({
    String? label,
    Color labelColor = AppColors.primary,
    required TripInfo scheduleInfo,
    required int durationMinutes,
    required List stops,
    required bool isOutbound,
  }) {
    final departure = scheduleInfo.departure;
    final departureTime = DateFormat('HH:mm').format(departure);
    final arrivalTime = DateFormat(
      'HH:mm',
    ).format(departure.add(Duration(minutes: durationMinutes)));
    final dateLabel = DateFormat('dd MMM, EEE').format(departure);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Row(
              children: [
                Icon(
                  isOutbound ? Icons.arrow_right_alt : Icons.sync_alt,
                  color: labelColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _timeBlock(departureTime, dateLabel, scheduleInfo.from.name),
              Column(
                children: [
                  Text(
                    '${durationMinutes ~/ 60}h ${durationMinutes % 60}m',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 1,
                    width: 80,
                    color: AppColors.dividerColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stops.isEmpty ? 'Non-stop' : '${stops.length} Stop(s)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
              _timeBlock(arrivalTime, dateLabel, scheduleInfo.to.name),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBlock(String time, String date, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time, style: const TextStyle(fontSize: 22, fontFamily: 'medium')),
        Text(
          date,
          style: const TextStyle(fontSize: 12, color: AppColors.lightText),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: const TextStyle(
            fontFamily: 'medium',
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  // ─── Seat selection tile ──────────────────────────────────────────────────

  Widget _seatSelectionTile() {
    final outboundText =
        selectedOutboundSeats.isEmpty
            ? 'Tap to select'
            : selectedOutboundSeats.join(', ');
    final returnText =
        selectedReturnSeats.isEmpty
            ? 'Tap to select'
            : selectedReturnSeats.join(', ');

    return InkWell(
      onTap: _openSeatSelection,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.event_seat,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Selected Seats',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const Spacer(),
                // Seats status badge
                _statusBadge(
                  filled:
                      seatsFullySelected
                          ? totalSeatsNeeded
                          : selectedOutboundSeats.length,
                  total: totalSeatsNeeded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.lightText),
              ],
            ),
            const SizedBox(height: 8),
            _seatChipRow(
              label: isRoundTrip ? 'Outbound' : null,
              seats: selectedOutboundSeats,
              placeholder: outboundText,
              color: AppColors.primary,
            ),
            if (isRoundTrip) ...[
              const SizedBox(height: 6),
              _seatChipRow(
                label: 'Return',
                seats: selectedReturnSeats,
                placeholder: returnText,
                color: AppColors.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusBadge({
    required int filled,
    required int total,
    required Color color,
  }) {
    final done = filled == total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:
            done ? Colors.green.withOpacity(0.1) : AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: done ? Colors.green.withOpacity(0.4) : color.withOpacity(0.3),
        ),
      ),
      child: Text(
        '$filled / $total',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: done ? Colors.green : color,
        ),
      ),
    );
  }

  Widget _seatChipRow({
    String? label,
    required List<String> seats,
    required String placeholder,
    required Color color,
  }) {
    return Row(
      children: [
        if (label != null) ...[
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (seats.isEmpty)
          Text(
            placeholder,
            style: const TextStyle(color: AppColors.mediumText, fontSize: 13),
          )
        else
          Expanded(
            child: Wrap(
              spacing: 6,
              children:
                  seats
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withOpacity(0.4)),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }

  // ─── Pricing card ─────────────────────────────────────────────────────────

  Widget _pricingCard(AppLocalizations l10n, TripDetails d) {
    final pricing = d.pricing;

    double adultPrice =
        isRoundTrip
            ? (pricing?.roundTripPricePerPassenger ??
                widget.trip.price.toDouble())
            : (pricing?.oneWayPricePerPassenger ??
                widget.trip.price.toDouble());

    double childPrice =
        isRoundTrip
            ? (pricing?.roundTripChildPricePerPassenger ?? adultPrice) * 2
            : (pricing?.oneWayChildPricePerPassenger ?? adultPrice);

    double adultTotal = adultPrice * adults;
    double childTotal = childPrice * children;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.price_breakdown,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            //child: Divider(color: AppColors.dividerColor),
          ),
          _priceRow(
            label: '$adults Adult${adults > 1 ? 's' : ''}',
            unitPrice: adultPrice,
            total: adultTotal,
          ),
          if (children > 0) ...[
            const SizedBox(height: 8),
            _priceRow(
              label: '$children Child${children > 1 ? 'ren' : ''}',
              unitPrice: childPrice,
              total: childTotal,
              note: isRoundTrip ? '(×2 for round trip)' : null,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.dividerColor),
          ),
          _pricingRow(
            l10n.base_price,
            '${pricing?.basePrice?.toStringAsFixed(0) ?? '0'} ${pricing?.currency ?? ''}',
          ),
          const SizedBox(height: 8),
          _pricingRow(
            l10n.platform_commission,
            '${pricing?.commission?.toStringAsFixed(0) ?? '0'} ${pricing?.currency ?? ''}',
          ),
          const SizedBox(height: 8),
          _pricingRow(
            'VAT (${pricing?.vatPercent ?? 0}%)',
            '${pricing?.vatAmount?.toStringAsFixed(0) ?? '0'} ${pricing?.currency ?? ''}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.dividerColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total_price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${pricing?.grandTotal?.toStringAsFixed(0) ?? '0'} ${pricing?.currency ?? ''}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow({
    required String label,
    required double unitPrice,
    required double total,
    String? note,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: AppColors.darkText),
              ),
              if (note != null)
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightText,
                  ),
                ),
            ],
          ),
        ),
        Text(
          'XAF ${unitPrice.toStringAsFixed(0)} × ${label.split(' ')[0]}',
          style: const TextStyle(fontSize: 13, color: AppColors.mediumText),
        ),
        const SizedBox(width: 16),
        Text(
          '${total.toStringAsFixed(0)} XAF',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }

  Widget _pricingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    );
  }

  // ─── Route section ────────────────────────────────────────────────────────

  Widget _routeSection(String title, List stops, TripInfo tripInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          _routePoint(tripInfo.from.name, isStart: true),
          ...stops.map((s) => _routePoint(s.cityName)).toList(),
          _routePoint(tripInfo.to.name, isEnd: true),
        ],
      ),
    );
  }

  Widget _routePoint(String city, {bool isStart = false, bool isEnd = false}) {
    return Row(
      children: [
        Column(
          children: [
            if (!isStart)
              Container(width: 1, height: 20, color: AppColors.dividerColor),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:
                    isStart
                        ? AppColors.primary
                        : isEnd
                        ? AppColors.secondary
                        : AppColors.white,
                border:
                    (!isStart && !isEnd)
                        ? Border.all(color: AppColors.dividerColor)
                        : null,
              ),
              child: Icon(
                isStart
                    ? Icons.location_searching_sharp
                    : isEnd
                    ? Icons.location_pin
                    : Icons.circle,
                color: isStart || isEnd ? Colors.white : AppColors.lightText,
                size: isStart || isEnd ? 16 : 8,
              ),
            ),
            if (!isEnd)
              Container(width: 1, height: 20, color: AppColors.dividerColor),
          ],
        ),
        const SizedBox(width: 12),
        Text(city, style: const TextStyle(color: AppColors.darkText)),
      ],
    );
  }

  // ─── Legal sections ───────────────────────────────────────────────────────

  List<Widget> _legalSections(TripDetails d) {
    return d.legalValues
        .map(
          (item) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading(item['label']),
                const SizedBox(height: 16),
                ...(item['value']
                    .toString()
                    .split('\r\n')
                    .map((bullet) => _bullet(bullet))),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.lightText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Book button ──────────────────────────────────────────────────────────

  Widget _bookButton() {
    // Determine what's still missing
    final String buttonLabel;
    if (!seatsFullySelected) {
      final remaining = totalSeatsNeeded - selectedOutboundSeats.length;
      buttonLabel = 'Select $remaining more seat(s)';
    } else if (!passengersFullyAssigned) {
      final remaining = _passengerSlots.where((s) => !s.isFilled).length;
      buttonLabel = 'Assign $remaining more passenger(s)';
    } else {
      buttonLabel = 'Book Now';
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress indicators
            if (!canBook) _progressHints(),
            if (!canBook) const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canBook ? AppColors.primary : AppColors.dividerColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed:
                  canBook
                      ? () {
                        // TODO: navigate to booking confirmation
                        // Pass: selectedOutboundSeats, selectedReturnSeats, _passengerSlots
                      }
                      : null,
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressHints() {
    return Row(
      children: [
        _progressChip(
          icon: Icons.event_seat,
          label: 'Seats',
          done: seatsFullySelected,
        ),
        const SizedBox(width: 8),
        _progressChip(
          icon: Icons.people_outline,
          label: 'Passengers',
          done: passengersFullyAssigned,
        ),
      ],
    );
  }

  Widget _progressChip({
    required IconData icon,
    required String label,
    required bool done,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color:
              done
                  ? Colors.green.withOpacity(0.08)
                  : AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                done ? Colors.green.withOpacity(0.3) : AppColors.dividerColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              done ? Icons.check_circle : icon,
              size: 16,
              color: done ? Colors.green : AppColors.mediumText,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: done ? Colors.green : AppColors.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

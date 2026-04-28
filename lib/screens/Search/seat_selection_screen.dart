// import 'package:flutter/material.dart';
// import 'package:gobus_app/Widgets/design_utils.dart';
// import 'package:gobus_app/core/theme.dart';

// class SeatSelectionScreen extends StatefulWidget {
//   final List seatMap;
//   final String layoutImage;
//   final int totalPassengers;
//   final List<String> preselectedSeats;

//   const SeatSelectionScreen({
//     super.key,
//     required this.seatMap,
//     required this.layoutImage,
//     required this.totalPassengers,
//     required this.preselectedSeats,
//   });

//   @override
//   State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
// }

// class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
//   late List<String> selectedSeats;

//   @override
//   void initState() {
//     super.initState();
//     selectedSeats = List.from(widget.preselectedSeats);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryBackground,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         title: headingBig("Select Seats"),
//       ),
//       body: Column(
//         children: [
//           /// 🔥 Layout Image
//           Container(
//             margin: const EdgeInsets.all(16),
//             height: 160,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               image: DecorationImage(
//                 image: NetworkImage(widget.layoutImage),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           /// Legend
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _legendBox(Colors.green, "Available"),
//                 _legendBox(Colors.red, "Booked"),
//                 _legendBox(AppColors.primary, "Selected"),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           /// Seat Grid
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: GridView.builder(
//                 itemCount: widget.seatMap.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemBuilder: (context, index) {
//                   final seat = widget.seatMap[index];
//                   final seatNumber = seat["seat_number"];
//                   final status = seat["status"];

//                   final isSelected = selectedSeats.contains(seatNumber);

//                   Color seatColor;

//                   if (status != "available") {
//                     seatColor = Colors.red;
//                   } else if (isSelected) {
//                     seatColor = AppColors.primary;
//                   } else {
//                     seatColor = Colors.green;
//                   }

//                   return GestureDetector(
//                     onTap:
//                         status != "available"
//                             ? null
//                             : () {
//                               setState(() {
//                                 if (isSelected) {
//                                   selectedSeats.remove(seatNumber);
//                                 } else {
//                                   if (selectedSeats.length <
//                                       widget.totalPassengers) {
//                                     selectedSeats.add(seatNumber);
//                                   }
//                                 }
//                               });
//                             },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: seatColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         seatNumber,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           /// Bottom CTA
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   "Selected: ${selectedSeats.length}/${widget.totalPassengers}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkText,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                     onPressed:
//                         selectedSeats.length == widget.totalPassengers
//                             ? () {
//                               Navigator.pop(context, selectedSeats);
//                             }
//                             : null,
//                     child: const Text(
//                       "Confirm Seats",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _legendBox(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//           width: 18,
//           height: 18,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(label),
//       ],
//     );
//   }
// }
// V2-------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:gobus_app/l10n/gen/app_localizations.dart';

// class SeatSelectionScreen extends StatefulWidget {
//   final List seatMap;
//   final String layoutImage;
//   final int totalPassengers;
//   final List<String> preselectedSeats;

//   const SeatSelectionScreen({
//     super.key,
//     required this.seatMap,
//     required this.layoutImage,
//     required this.totalPassengers,
//     required this.preselectedSeats,
//   });

//   @override
//   State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
// }

// class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
//   late List<String> selectedSeats;

//   @override
//   void initState() {
//     super.initState();
//     selectedSeats = List.from(widget.preselectedSeats);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     return Scaffold(
//       backgroundColor: const Color(0xfff5f6fa),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Text(
//           l10n.selectSeats,
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           /// Layout Image
//           if (widget.layoutImage.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.all(16),
//               height: 160,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: DecorationImage(
//                   image: NetworkImage(widget.layoutImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),

//           /// Legend
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _legendBox(Colors.green, l10n.available),
//                 _legendBox(Colors.red, l10n.booked),
//                 _legendBox(const Color(0xffFF7A00), l10n.selected),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           /// Seat Grid
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: GridView.builder(
//                 itemCount: widget.seatMap.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemBuilder: (context, index) {
//                   final seat = widget.seatMap[index];
//                   final seatNumber = seat["seat_number"].toString();
//                   final status = seat["status"].toString();

//                   final isSelected = selectedSeats.contains(seatNumber);

//                   Color seatColor;

//                   if (status != "available") {
//                     seatColor = Colors.red;
//                   } else if (isSelected) {
//                     seatColor = const Color(0xffFF7A00);
//                   } else {
//                     seatColor = Colors.green;
//                   }

//                   return GestureDetector(
//                     onTap:
//                         status != "available"
//                             ? null
//                             : () {
//                               setState(() {
//                                 if (isSelected) {
//                                   selectedSeats.remove(seatNumber);
//                                 } else {
//                                   if (selectedSeats.length <
//                                       widget.totalPassengers) {
//                                     selectedSeats.add(seatNumber);
//                                   }
//                                 }
//                               });
//                             },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: seatColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         seatNumber,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           /// Bottom Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   "${l10n.selected}: ${selectedSeats.length}/${widget.totalPassengers}",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xffFF7A00),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                     onPressed:
//                         selectedSeats.length == widget.totalPassengers
//                             ? () {
//                               Navigator.pop(context, selectedSeats);
//                             }
//                             : null,
//                     child: Text(
//                       l10n.confirmSeats,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _legendBox(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//           width: 18,
//           height: 18,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(label),
//       ],
//     );
//   }
// }
//V3-------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';

class SeatSelectionScreen extends StatefulWidget {
  final bool isRoundTrip;
  final int totalPassengers;
  final List<Map<String, dynamic>> outboundSeatMap;
  final List<Map<String, dynamic>> returnSeatMap;
  final List<String> preselectedOutbound;
  final List<String> preselectedReturn;
  final String outboundLayoutImage;
  final String returnLayoutImage;
  final String outboundLabel;
  final String returnLabel;

  const SeatSelectionScreen({
    super.key,
    required this.isRoundTrip,
    required this.totalPassengers,
    required this.outboundSeatMap,
    this.returnSeatMap = const [],
    this.preselectedOutbound = const [],
    this.preselectedReturn = const [],
    this.outboundLayoutImage = '',
    this.returnLayoutImage = '',
    this.outboundLabel = '',
    this.returnLabel = '',
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> selectedOutbound;
  late List<String> selectedReturn;

  @override
  void initState() {
    super.initState();
    selectedOutbound = List.from(widget.preselectedOutbound);
    selectedReturn = List.from(widget.preselectedReturn);
    _tabController = TabController(
      length: widget.isRoundTrip ? 2 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get outboundComplete =>
      selectedOutbound.length == widget.totalPassengers;
  bool get returnComplete =>
      !widget.isRoundTrip || selectedReturn.length == widget.totalPassengers;
  bool get allComplete => outboundComplete && returnComplete;

  void _toggleSeat(String seatNumber, bool isOutbound) {
    setState(() {
      if (isOutbound) {
        if (selectedOutbound.contains(seatNumber)) {
          selectedOutbound.remove(seatNumber);
        } else if (selectedOutbound.length < widget.totalPassengers) {
          selectedOutbound.add(seatNumber);
          // Auto-switch to return tab when outbound is complete
          if (outboundComplete && widget.isRoundTrip) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) _tabController.animateTo(1);
            });
          }
        }
      } else {
        if (selectedReturn.contains(seatNumber)) {
          selectedReturn.remove(seatNumber);
        } else if (selectedReturn.length < widget.totalPassengers) {
          selectedReturn.add(seatNumber);
        }
      }
    });
  }

  void _confirm() {
    Navigator.pop(context, {
      'outbound': selectedOutbound,
      'return': selectedReturn,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          l10n.selectSeats,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom:
            widget.isRoundTrip
                ? TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.mediumText,
                  indicatorColor: AppColors.primary,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_right_alt, size: 16),
                          const SizedBox(width: 4),
                          const Text('Outbound'),
                          const SizedBox(width: 4),
                          _tabBadge(
                            selectedOutbound.length,
                            widget.totalPassengers,
                            AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.sync_alt, size: 16),
                          const SizedBox(width: 4),
                          const Text('Return'),
                          const SizedBox(width: 4),
                          _tabBadge(
                            selectedReturn.length,
                            widget.totalPassengers,
                            AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : null,
      ),
      body:
          widget.isRoundTrip
              ? TabBarView(
                controller: _tabController,
                children: [
                  _seatGrid(
                    seatMap: widget.outboundSeatMap,
                    selected: selectedOutbound,
                    layoutImage: widget.outboundLayoutImage,
                    isOutbound: true,
                    routeLabel: widget.outboundLabel,
                  ),
                  _seatGrid(
                    seatMap: widget.returnSeatMap,
                    selected: selectedReturn,
                    layoutImage: widget.returnLayoutImage,
                    isOutbound: false,
                    routeLabel: widget.returnLabel,
                  ),
                ],
              )
              : _seatGrid(
                seatMap: widget.outboundSeatMap,
                selected: selectedOutbound,
                layoutImage: widget.outboundLayoutImage,
                isOutbound: true,
                routeLabel: widget.outboundLabel,
              ),
      bottomNavigationBar: _bottomBar(l10n),
    );
  }

  Widget _tabBadge(int selected, int total, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:
            selected == total
                ? color.withOpacity(0.15)
                : AppColors.dividerColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$selected/$total',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: selected == total ? color : AppColors.mediumText,
        ),
      ),
    );
  }

  Widget _seatGrid({
    required List<Map<String, dynamic>> seatMap,
    required List<String> selected,
    required String layoutImage,
    required bool isOutbound,
    required String routeLabel,
  }) {
    return Column(
      children: [
        // Route label
        if (routeLabel.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Text(
              routeLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
                fontSize: 14,
              ),
            ),
          ),

        // Layout image
        if (layoutImage.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(12),
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(layoutImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(Colors.green, 'Available'),
              const SizedBox(width: 20),
              _legendItem(Colors.red.shade300, 'Booked'),
              const SizedBox(width: 20),
              _legendItem(
                isOutbound ? AppColors.primary : AppColors.secondary,
                'Selected',
              ),
            ],
          ),
        ),

        // Seat grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: seatMap.length,
            itemBuilder: (context, index) {
              final seat = seatMap[index];
              final seatNumber = seat['seat_number'].toString();
              final status = seat['status'].toString();
              final isSelected = selected.contains(seatNumber);
              final isBooked = status != 'available';

              Color bgColor;
              Color textColor;

              if (isBooked) {
                bgColor = Colors.red.shade100;
                textColor = Colors.red.shade700;
              } else if (isSelected) {
                bgColor = isOutbound ? AppColors.primary : AppColors.secondary;
                textColor = Colors.white;
              } else {
                bgColor = Colors.green.shade50;
                textColor = Colors.green.shade800;
              }

              return GestureDetector(
                onTap:
                    isBooked ? null : () => _toggleSeat(seatNumber, isOutbound),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected
                              ? (isOutbound
                                  ? AppColors.primary
                                  : AppColors.secondary)
                              : isBooked
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_seat, size: 18, color: textColor),
                      const SizedBox(height: 2),
                      Text(
                        seatNumber,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.event_seat, size: 11, color: Colors.white),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.mediumText),
        ),
      ],
    );
  }

  Widget _bottomBar(AppLocalizations l10n) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection status
            Row(
              children: [
                _statusChip(
                  label: widget.isRoundTrip ? 'Outbound' : 'Seats',
                  selected: selectedOutbound.length,
                  total: widget.totalPassengers,
                  color: AppColors.primary,
                ),
                if (widget.isRoundTrip) ...[
                  const SizedBox(width: 10),
                  _statusChip(
                    label: 'Return',
                    selected: selectedReturn.length,
                    total: widget.totalPassengers,
                    color: AppColors.secondary,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      allComplete ? AppColors.primary : AppColors.dividerColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: allComplete ? _confirm : null,
                child: Text(
                  allComplete
                      ? l10n.confirmSeats
                      : !outboundComplete
                      ? 'Select ${widget.totalPassengers - selectedOutbound.length} outbound seat(s)'
                      : 'Select ${widget.totalPassengers - selectedReturn.length} return seat(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip({
    required String label,
    required int selected,
    required int total,
    required Color color,
  }) {
    final complete = selected == total;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              complete ? color.withOpacity(0.1) : AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: complete ? color.withOpacity(0.3) : AppColors.dividerColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              complete ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: complete ? color : AppColors.lightText,
            ),
            const SizedBox(width: 6),
            Text(
              '$label: $selected/$total',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: complete ? color : AppColors.mediumText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

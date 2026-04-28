import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/vehicle_image_slider.dart';
import 'package:gobus_app/core/api/api_response.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/data/car_route_detail_api.dart';
import 'package:gobus_app/features/rent_car/model/car_route_detail.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class CarRouteDetailScreen extends StatefulWidget {
  final int routeId;
  final String vehicleCategory;
  final String tripType;
  final String pickupDate;
  final String pickupTime;
  final String? returnDate;

  const CarRouteDetailScreen({
    super.key,
    required this.routeId,
    required this.vehicleCategory,
    required this.tripType,
    required this.pickupDate,
    required this.pickupTime,
    this.returnDate,
  });

  @override
  State<CarRouteDetailScreen> createState() => _CarRouteDetailScreenState();
}

class _CarRouteDetailScreenState extends State<CarRouteDetailScreen> {
  bool loading = true;
  CarRouteDetail? detail;

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    final response = await CarRouteDetailService.getRouteDetails(
      routeId: widget.routeId,
      vehicleCategory: widget.vehicleCategory,
      tripType: widget.tripType,
      pickupDate: widget.pickupDate,
      pickupTime: widget.pickupTime,
      returnDate: widget.returnDate,
    );

    if (response.status && response.data != null) {
      detail = response.data;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (detail == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.details)),
        body: Center(child: Text(l10n.no_data)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trip_details)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _routeCard(l10n),
            const SizedBox(height: 16),
            _providerCard(),
            const SizedBox(height: 16),
            _vehicleCategoryCard(l10n),
            const SizedBox(height: 16),
            _pricingCard(l10n),
            const SizedBox(height: 20),
            _vehicleSection(l10n),
          ],
        ),
      ),
      bottomNavigationBar: _bookButton(l10n),
    );
  }

  Widget _routeCard(AppLocalizations l10n) {
    final route = detail?.route;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.route, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${route?.fromCity ?? ""} → ${route?.toCity ?? ""}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _providerCard() {
    final provider = detail?.provider;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          provider?.logo != null
              ? Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(25),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(provider!.logo!),
              )
              : const CircleAvatar(radius: 26),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider?.name ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (provider?.phone != null)
                  Text(
                    provider!.phone!,
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () async {
              if (provider?.phone != null) {
                final Uri phoneUri = Uri(scheme: 'tel', path: provider!.phone!);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _vehicleCategoryCard(AppLocalizations l10n) {
    final category = detail?.vehicleCategory ?? "";

    String formattedCategory =
        category.isNotEmpty
            ? "${category[0].toUpperCase()}${category.substring(1)}"
            : "";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.directions_car),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.vehicle_category,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                Text(
                  formattedCategory,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  l10n.vehicle_assigned_before_pickup,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pricingCard(AppLocalizations l10n) {
    final pricing = detail?.pricing;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.price_breakdown,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          _pricingRow(
            l10n.trip_type,
            pricing?.tripType.toString().replaceAll("_", " ").toUpperCase() ??
                "",
          ),

          const SizedBox(height: 8),

          _pricingRow(l10n.days, pricing?.days?.toString() ?? "1"),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: AppColors.dividerColor),
          ),

          _pricingRow(
            l10n.base_price,
            "${pricing?.basePrice?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
          ),
          const SizedBox(height: 8),
          _pricingRow(
            l10n.platform_commission,
            "${pricing?.commission?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
          ),

          // const SizedBox(height: 8),
          // _pricingRow(
          //   l10n.insurance,
          //   "${pricing?.insurance?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
          // ),
          const SizedBox(height: 8),

          _pricingRow(
            "VAT (${pricing?.vatPercent ?? 0}%)",
            "${pricing?.vatAmount?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
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
                "${pricing?.grandTotal?.toStringAsFixed(0) ?? "0"} ${pricing?.currency ?? ""}",
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

  Widget _pricingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    );
  }

  Widget _vehicleSection(AppLocalizations l10n) {
    final vehicles = detail?.vehicles ?? [];

    if (vehicles.isEmpty) {
      return Center(child: Text(l10n.no_data));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.available_vehicles,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          "Vehicle shown is representative of the category. Exact vehicle may vary based on availability.",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: AppColors.lightText,
          ),
        ),
        const SizedBox(height: 20),
        ...vehicles.map((vehicle) => _vehicleCard(vehicle, l10n)).toList(),
      ],
    );
  }

  Widget _vehicleCard(Vehicle vehicle, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vehicle.images.isNotEmpty)
            VehicleImageSlider(images: vehicle.images),

          // SizedBox(
          //   height: 180,
          //   child: PageView(

          //     children:
          //         vehicle.images.map((img) {
          //           return ClipRRect(
          //             borderRadius: const BorderRadius.vertical(
          //               top: Radius.circular(14),
          //             ),
          //             child: Image.network(
          //               img.image ?? "",
          //               fit: BoxFit.cover,
          //             ),
          //           );
          //         }).toList(),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${vehicle.brand ?? ""} ${vehicle.model ?? ""}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${vehicle.year ?? ""} • ${vehicle.seats ?? ""} ${l10n.seats}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookButton(AppLocalizations l10n) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppColors.primary,
          ),
          onPressed: () {},
          child: Text(
            l10n.book_now,
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.white,
              fontFamily: "medium",
            ),
          ),
        ),
      ),
    );
  }
}

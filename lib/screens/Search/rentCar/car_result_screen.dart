import 'package:flutter/material.dart';
import 'package:gobus_app/data/search_car_api.dart';
import 'package:gobus_app/features/rent_car/model/car_route.dart';
import 'package:gobus_app/features/search/models/city.dart';
import 'package:gobus_app/screens/Search/rentCar/car_route_detail_screen.dart';
import '../../../core/theme.dart';

class CarResultsScreen extends StatefulWidget {
  final City fromCity;
  final City toCity;
  final String tripType;
  final String pickupDate;
  final String pickupTime;
  final String? returnDate;
  final int passengers;

  const CarResultsScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.tripType,
    required this.pickupDate,
    required this.pickupTime,
    this.returnDate,
    required this.passengers,
  });

  @override
  State<CarResultsScreen> createState() => _CarResultsScreenState();
}

class _CarResultsScreenState extends State<CarResultsScreen> {
  bool loading = true;
  List<CarRoute> routes = [];

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    final response = await CarSearchService.searchCars(
      fromCityId: widget.fromCity.id,
      toCityId: widget.toCity.id,
      tripType: widget.tripType,
      pickupDate: widget.pickupDate,
      pickupTime: widget.pickupTime,
      returnDate: widget.returnDate,
      passengers: widget.passengers,
    );

    if (response.status) {
      routes = response.data ?? [];
      print(response.toString());
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }

    setState(() {
      loading = false;
    });
  }

  Widget routeCard(CarRoute route) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => CarRouteDetailScreen(
                  routeId: route.routeId,
                  vehicleCategory: route.vehicleCategory,
                  tripType: widget.tripType,
                  pickupDate: widget.pickupDate,
                  pickupTime: widget.pickupTime,
                  returnDate: widget.returnDate,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.dividerColor),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (route.providerLogo != null)
                  Image.network(route.providerLogo!, height: 32),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    route.providerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "CAR",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fromCity.code,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.pickupDate),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.toCity.code,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(route.vehicleCategory),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "View Detail",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  "${route.currency} ${route.price}",
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),

      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: routes.length,
                itemBuilder: (_, i) => routeCard(routes[i]),
              ),
    );
  }
}

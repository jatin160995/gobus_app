import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/providers/city_search_provider.dart';
import 'package:provider/provider.dart';

class CityPickerSheet extends StatefulWidget {
  const CityPickerSheet();

  @override
  State<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<CityPickerSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Load ALL cities initially
    Future.microtask(() {
      context.read<CitySearchProvider>().search("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CitySearchProvider>();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            /// Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            /// Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select City",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Search field (optional filter)
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search city",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.primaryBackground,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                provider.search(value);
              },
            ),

            const SizedBox(height: 16),

            /// City List
            Expanded(
              child:
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.results.isEmpty
                      ? const Center(
                        child: Text(
                          "No cities found",
                          style: TextStyle(color: AppColors.lightText),
                        ),
                      )
                      : ListView.separated(
                        itemCount: provider.results.length,
                        separatorBuilder:
                            (_, __) => const Divider(
                              height: 1,
                              color: AppColors.dividerColor,
                            ),
                        itemBuilder: (_, index) {
                          final city = provider.results[index];

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            title: Text(
                              city.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                            subtitle: Text(
                              "${city.code} • ${city.country}",
                              style: const TextStyle(
                                color: AppColors.mediumText,
                              ),
                            ),
                            onTap: () => Navigator.pop(context, city),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

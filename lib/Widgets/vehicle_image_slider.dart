import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gobus_app/features/rent_car/model/car_route_detail.dart';

class VehicleImageSlider extends StatefulWidget {
  final List<VehicleImage> images;

  const VehicleImageSlider({super.key, required this.images});

  @override
  State<VehicleImageSlider> createState() => _VehicleImageSliderState();
}

class _VehicleImageSliderState extends State<VehicleImageSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        _currentPage++;

        if (_currentPage >= widget.images.length) {
          _currentPage = 0;
        }

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < widget.images.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    _controller.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prev() {
    if (_currentPage > 0) {
      _currentPage--;
    } else {
      _currentPage = widget.images.length - 1;
    }

    _controller.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          PageView(
            controller: _controller,
            children:
                widget.images.map((img) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Image.network(
                      img.image ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
          ),

          /// Previous Button
          Positioned(
            left: 10,
            top: 70,
            child: _navButton(Icons.arrow_back_ios, _prev),
          ),

          /// Next Button
          Positioned(
            right: 10,
            top: 70,
            child: _navButton(Icons.arrow_forward_ios, _next),
          ),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

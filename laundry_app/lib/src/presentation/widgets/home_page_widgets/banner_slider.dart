import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class BannerSlider extends StatelessWidget {
  final bool isLoading;
  final List<String>? imageBanner;
  final int currentPage;
  final Function(int index) onPageChanged;

  const BannerSlider({
    super.key,
    required this.isLoading,
    this.imageBanner,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    final bannerHeight = size.height * 0.25;

    if (isLoading) {
      return SizedBox(
        height: bannerHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final images = imageBanner ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: images.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                url,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: bannerHeight,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.88,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            final isActive = entry.key == currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.text : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

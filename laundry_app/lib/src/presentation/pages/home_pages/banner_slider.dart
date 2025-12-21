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
    final bannerHeight = size.height * 0.22;

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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.asset(
                      url,
                      width: double.infinity,
                      height: bannerHeight,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: bannerHeight,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.90,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) {
              onPageChanged(index);
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            final isActive = entry.key == currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
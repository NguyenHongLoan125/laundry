import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import '../../../features/auth/data/models/service_model.dart';

class TypesOfService extends StatelessWidget {
  final bool isLoading;
  final List<ServiceModel>? services;

  const TypesOfService({
    super.key,
    required this.isLoading,
    this.services,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardHeight = size.height * 0.25;
    final cardWidth = size.width * 0.42;
    final iconSize = size.width * 0.18;
    final spacingTop = size.height * 0.015;
    final titleFont = size.width * 0.05;
    final itemFont = size.width * 0.048;
    final avatarLetterFont = size.width * 0.09;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Loại dịch vụ',
            style: TextStyle(
              fontSize: titleFont,
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: size.height * 0.02),

          if (isLoading)
            SizedBox(
              height: size.height * 0.08,
              child: const Center(child: CircularProgressIndicator()),
            ),

          if (!isLoading && (services == null || services!.isEmpty))
            const Center(
              child: Text(
                'Không có dịch vụ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (!isLoading && services != null && services!.isNotEmpty)
            SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services!.length,
                itemBuilder: (context, index) {
                  final service = services![index];

                  return Container(
                    width: cardWidth,
                    margin: EdgeInsets.only(right: size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                      border: Border.all(
                        color: AppColors.textPrimary,
                        width: size.width * 0.006,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildServiceIcon(
                          service.iconUrl,
                          service.name,
                          iconSize,
                          avatarLetterFont,
                        ),
                        SizedBox(height: spacingTop),
                        Text(
                          service.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pacifico',
                            color: AppColors.textPrimary,
                            fontSize: itemFont,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _buildServiceIcon(String? iconUrl, String? name, double size, double letterFont) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      return Image.network(
        iconUrl,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackLetter(name, size, letterFont),
      );
    } else {
      return _fallbackLetter(name, size, letterFont);
    }
  }

  Widget _fallbackLetter(String? name, double size, double fontSize) {
    final letter = (name?.isNotEmpty ?? false)
        ? name!.substring(0, 1).toUpperCase()
        : "?";

    return SizedBox(
      height: size,
      width: size,
      child: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(
          letter,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

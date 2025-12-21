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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại dịch vụ',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            SizedBox(
              height: size.height * 0.15,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (!isLoading && (services == null || services!.isEmpty))
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Không có dịch vụ',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (!isLoading && services != null && services!.isNotEmpty)
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final service = services![index];
                  return _ServiceCard(service: service, size: size);
                },
              ),
            )
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final Size size;

  const _ServiceCard({required this.service, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildServiceIcon(
                  service.iconUrl,
                  service.name,
                  60,
                ),
                const SizedBox(height: 12),
                Text(
                  service.name ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(String? iconUrl, String? name, double size) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(12),
        child: Image.network(
          iconUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _fallbackIcon(name, size),
        ),
      );
    } else {
      return _fallbackIcon(name, size);
    }
  }

  Widget _fallbackIcon(String? name, double size) {
    final letter = (name?.isNotEmpty ?? false)
        ? name!.substring(0, 1).toUpperCase()
        : "?";

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary,
          ],
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: size * 0.45,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
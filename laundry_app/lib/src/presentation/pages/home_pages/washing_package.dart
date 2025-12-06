import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/auth/data/models/home_model.dart';
import '../../../core/constants/app_colors.dart';

class WashingPackage extends StatelessWidget {
  final List<WashingPackageModel> washingPackage;
  const WashingPackage({super.key, required this.washingPackage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final washingPackageCardHeight = size.height * 0.3;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gói giặt',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  fontSize: size.width * 0.06,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: size.width * 0.05,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: size.height * 0.02),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: (size.width * 0.04).clamp(12.0, 18.0),
              vertical: (size.width * 0.03).clamp(10.0, 16.0),
            ),
            clipBehavior: Clip.none,
            itemCount: washingPackage.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: (size.width * 0.03).clamp(10.0, 16.0)),
            itemBuilder: (context, index) {
              final package = washingPackage[index];
              return PackageCard(
                height: washingPackageCardHeight,
                size: size,
                onBuy: () {},
                washingPackage: package,
              );
            },
          ),
        ],
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  final Size size;
  final double height;
  final WashingPackageModel washingPackage;
  final VoidCallback? onBuy;

  const PackageCard({
    super.key,
    required this.size,
    required this.washingPackage,
    required this.onBuy,
    required this.height,
  });

  String formatVnd(double? value) {
    final v = (value ?? 0).round();
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write('.');
    }
    return '${buf.toString()}đ';
  }

  @override
  Widget build(BuildContext context) {
    final price = formatVnd(washingPackage.price);

    return Container(
      height: height,
      padding: EdgeInsets.all((size.width * 0.04).clamp(12.0, 16.0)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.5, color: AppColors.textPrimary),
      ),
      child: Stack(
        children: [

          Padding(
            padding: EdgeInsets.only(bottom: (size.width * 0.14).clamp(44.0, 60.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  washingPackage.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: (size.width * 0.042).clamp(14.0, 18.0),
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: (size.width * 0.02).clamp(6.0, 10.0)),
                Text(
                  'Mô tả: ${washingPackage.description ?? ""}',
                  style: TextStyle(
                    fontSize: (size.width * 0.032).clamp(11.0, 14.0),
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: (size.width * 0.02).clamp(6.0, 10.0)),
                Text(
                  washingPackage.note ?? "",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: (size.width * 0.030).clamp(10.5, 13.0),
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          //price + button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: (size.width * 0.038).clamp(12.0, 16.0),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onBuy,
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (size.width * 0.05).clamp(14.0, 18.0),
                      vertical: (size.width * 0.02).clamp(8.0, 11.0),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF5FE),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      'Mua gói',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: (size.width * 0.032).clamp(11.0, 14.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

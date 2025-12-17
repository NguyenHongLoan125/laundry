import 'package:flutter/material.dart';
import 'package:laundry_app/src/features/auth/data/models/cloths_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/auth/data/models/service_model.dart';

class TypeOfClothes extends StatelessWidget {
  final bool isLoading;
  final List<ClothsModel>? clothes;

  const TypeOfClothes({
    super.key,
    required this.isLoading,
    this.clothes,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final itemSize = size.width * 0.26;
    final circleSize = size.width * 0.20;
    final iconSize = size.width * 0.10;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Loại đồ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  fontSize: size.width*0.05,
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),
          if (isLoading)
            const Center(
              child: SizedBox(
                height: 60,
                child: CircularProgressIndicator(),
              ),
            ),
          if (!isLoading && (clothes == null || clothes!.isEmpty))
            const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (!isLoading && clothes != null && clothes!.isNotEmpty)
            SizedBox(
              height: itemSize + 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: clothes!.length,
                itemBuilder: (context, index) {
                  final cloth = clothes![index];

                  return SizedBox(
                    width: itemSize,
                    child: Column(
                      children: [
                        Container(
                          height: circleSize,
                          width: circleSize,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _buildClothesIcon(
                            cloth.iconUrl,
                            cloth.name,
                            iconSize,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          cloth.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pacifico',
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClothesIcon(String? iconUrl, String? name, double size) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          iconUrl,
          height: size,
          width: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackLetter(name, size),
        ),
      );
    } else {
      return _fallbackLetter(name, size);
    }
  }

  Widget _fallbackLetter(String? name, double size) {
    final letter = (name?.isNotEmpty ?? false)
        ? name!.substring(0, 1).toUpperCase()
        : "?";

    return Container(
      margin: const EdgeInsets.all(16),
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.blue.shade100,
        child: Text(
          letter,
          style: TextStyle(
            fontSize: size * 0.75,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}

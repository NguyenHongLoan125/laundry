import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import '../../features/laundry/domain/entities/clothing_item.dart';
import '../../features/laundry/domain/entities/clothing_sub_item.dart';

class ClothingItemsWidget extends StatelessWidget {
  final List<ClothingItem> items;
  final Function(String) onToggleItem;
  final Function(String, String, int) onUpdateQuantity;
  final Function(String)? onToggleItemExpansion;

  const ClothingItemsWidget({
    Key? key,
    required this.items,
    required this.onToggleItem,
    required this.onUpdateQuantity,
    required this.onToggleItemExpansion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _ClothingItemWrapper(
            item: item,
            onToggle: () => onToggleItem(item.id),
            onUpdateQuantity: (subItemId, delta) =>
                onUpdateQuantity(item.id, subItemId, delta),
          ),
        );
      }).toList(),
    );
  }
}

class _ClothingItemWrapper extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onToggle;
  final Function(String, int) onUpdateQuantity;

  const _ClothingItemWrapper({
    required this.item,
    required this.onToggle,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ClothingItemCard(
          item: item,
          onToggle: onToggle,
        ),

        if (item.isSelected && item.subItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: item.subItems.map((subItem) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 20, right:20),
                  child: _SubItemRow(
                    subItem: subItem,
                    onUpdateQuantity: (delta) =>
                        onUpdateQuantity(subItem.id, delta),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _ClothingItemCard extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onToggle;

  const _ClothingItemCard({
    required this.item,
    required this.onToggle,
  });

  bool _isImageUrl(String icon) {
    return icon.startsWith('http://') || icon.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            // Icon circle - FIXED VERSION
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF9F6),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(7), // Thay padding bằng margin
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                ),
                clipBehavior: Clip.antiAlias,
                child: _isImageUrl(item.icon)
                    ? ClipOval( // Thêm ClipOval để đảm bảo hình tròn
                  child: Image.network(
                    item.icon,
                    fit: BoxFit.cover, // Giữ nguyên tỷ lệ và cover
                    width: 40, // Fixed width
                    height: 40, // Fixed height
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                  child: Text(
                    item.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Name
            Expanded(
              child: Text(
                item.name,
                style: GoogleFonts.petrona(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Radio
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textPrimary,
                  width: 2,
                ),
              ),
              child: item.isSelected
                  ? const Center(
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: AppColors.textPrimary,
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
class _SubItemRow extends StatelessWidget {
  final ClothingSubItem subItem;
  final Function(int) onUpdateQuantity;

  const _SubItemRow({
    required this.subItem,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1.5,
          color:   AppColors.textPrimary,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subItem.name,
              style:  GoogleFonts.petrona(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          _QtyButton(
            icon: Icons.remove,
            enabled: subItem.quantity > 0,
            onTap: () => onUpdateQuantity(-1),
          ),

          SizedBox(
            width: 28,
            child: Text(
              subItem.quantity.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.petrona(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          _QtyButton(
            icon: Icons.add,
            enabled: true,
            onTap: () => onUpdateQuantity(1),
          ),
        ],
      ),
    );
  }
}
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.5,
            color: enabled
                ?AppColors.textPrimary
                : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled
              ? AppColors.textPrimary
              : Colors.grey,
        ),
      ),
    );
  }
}
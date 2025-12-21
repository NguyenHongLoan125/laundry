import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import '../../features/laundry/domain/entities/laundry_package.dart';

class PackageSelectorWidget extends StatelessWidget {
  final List<LaundryPackage> packages;
  final LaundryPackage? selectedPackage;
  final bool usePackage;
  final VoidCallback onTogglePackage;
  final Function(LaundryPackage)? onSelectPackage;

  const PackageSelectorWidget({
    super.key,
    required this.packages,
    required this.selectedPackage,
    required this.usePackage,
    required this.onTogglePackage,
    required this.onSelectPackage,
  });

  @override
  Widget build(BuildContext context) {
    final package = selectedPackage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [



        /// OPTION 1: GÓI GIẶT
        if (package != null)
          SelectableOptionCard(
            selected: usePackage,
            onTap: () {
              if (!usePackage) onTogglePackage();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: usePackage
                        ? const Color(0xFF00BFA5)
                        : const Color(0xFF616161),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  package.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF616161),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Vui lòng sử dụng trước ngày ${_formatDate(package.expiryDate)}.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        /// OPTION 2: KHÔNG SỬ DỤNG GÓI
        SelectableOptionCard(
          selected: !usePackage,
          onTap: () {
            if (usePackage) onTogglePackage();
          },
          child: const Center(
            child: Text(
              'Không sử dụng gói giặt',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00BFA5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
class SelectableOptionCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const SelectableOptionCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          /// CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? AppColors.backgroundSecondary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                selected ? AppColors.textPrimary : const Color(0xFFE0E0E0),
                width: selected ? 2 : 1,
              ),
            ),
            child: child,
          ),

          /// CHECK GÓC PHẢI
          if (selected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 35,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

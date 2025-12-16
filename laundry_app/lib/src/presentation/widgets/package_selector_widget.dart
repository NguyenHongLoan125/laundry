import 'package:flutter/material.dart';
import '../../features/laundry/domain/entities/laundry_package.dart';

class PackageSelectorWidget extends StatelessWidget {
  final List<LaundryPackage> packages;
  final LaundryPackage? selectedPackage;
  final bool usePackage;
  final VoidCallback onTogglePackage;

  const PackageSelectorWidget({
    Key? key,
    required this.packages,
    required this.selectedPackage,
    required this.usePackage,
    required this.onTogglePackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final package = selectedPackage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gói giặt',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00BFA5),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00BFA5),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (package != null && usePackage)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00BFA5), width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(package.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 4),
                      Text(package.description,
                          style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        'Vui lòng sử dụng trước ngày ${_formatDate(package.expiryDate)}.',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00BFA5),
                  size: 28,
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: onTogglePackage,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: !usePackage
                    ? const Color(0xFF00BFA5)
                    : const Color(0xFFE0E0E0),
                width: !usePackage ? 2 : 1,
              ),
            ),
            child: const Center(
              child: Text(
                'Không sử dụng gói giặt',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00BFA5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

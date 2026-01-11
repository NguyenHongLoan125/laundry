import 'package:flutter/material.dart';

import '../../features/laundry/data/models/delivery_method_model.dart';


class DeliveryMethodWidget extends StatelessWidget {
  final List<DeliveryMethod> methods; // Thay dynamic bằng DeliveryMethod sau khi import
  final Function(String) onMethodSelected;
  final String myFont;

  const DeliveryMethodWidget({
    Key? key,
    required this.methods,
    required this.onMethodSelected,
    this.myFont = 'Pacifico',
  }) : super(key: key);

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'delivery_dining':
        return Icons.delivery_dining;
      case 'store':
        return Icons.store;
      case 'directions_bike':
        return Icons.directions_bike;
      default:
        return Icons.local_shipping;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: methods.map((method) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onMethodSelected(method.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: method.isSelected
                      ? const Color(0xFF00BFA5)
                      : Colors.grey[300]!,
                  width: method.isSelected ? 2 : 1,
                ),
                boxShadow: method.isSelected
                    ? [
                  BoxShadow(
                    color: const Color(0xFF00BFA5).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
                    : [],
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: method.isSelected
                          ? const Color(0xFF00BFA5).withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getIconData(method.icon),
                      color: method.isSelected
                          ? const Color(0xFF00BFA5)
                          : Colors.grey[600],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Thông tin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                method.name,
                                style: TextStyle(
                                  fontFamily: myFont,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: method.isSelected
                                      ? const Color(0xFF00BFA5)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (method.price > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: method.isSelected
                                      ? const Color(0xFF00BFA5)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+${method.price.toStringAsFixed(0)}đ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: method.isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                            if (method.price == 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Miễn phí',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          method.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Radio button
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: method.isSelected
                            ? const Color(0xFF00BFA5)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: method.isSelected
                        ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00BFA5),
                        ),
                      ),
                    )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:laundry_app/src/presentation/widgets/selectacle_item.dart';
import '../../features/laundry/domain/entities/detergent_item.dart';

class DetergentSelectorWidget extends StatelessWidget {
  final List<DetergentItem> detergents;
  final Function(String) onToggle;

  const DetergentSelectorWidget({
    Key? key,
    required this.detergents,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nước giặt',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00BFA5),
          ),
        ),
        const SizedBox(height: 12),

        Column(
          children: detergents.asMap().entries.map((entry) {
            final index = entry.key;
            final detergent = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < detergents.length - 1 ? 8 : 0,
              ),
              child: SelectableItem(
                text: detergent.name,
                isSelected: detergent.isSelected,
                onTap: () => onToggle(detergent.id),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
